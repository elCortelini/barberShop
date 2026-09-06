import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/barbershop_provider.dart';
import '../theme/app_theme.dart';

class CatalogScreen extends StatefulWidget {
  final VoidCallback onStartBooking;

  const CatalogScreen({super.key, required this.onStartBooking});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BarbershopProvider>(context);
    final activeBranch = provider.selectedBranch;
    final services = provider.currentBranchServices
        .where((s) => s.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            s.category.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
    final packages = provider.packages
        .where((p) => p.title.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
    final products = provider.products
        .where((p) => p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            p.category.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo Estação Elite'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.primaryGold,
          labelColor: AppTheme.primaryGold,
          unselectedLabelColor: Colors.white60,
          tabs: const [
            Tab(icon: Icon(Icons.content_cut, size: 20), text: 'Serviços'),
            Tab(icon: Icon(Icons.stars, size: 20), text: 'Pacotes'),
            Tab(icon: Icon(Icons.shopping_bag, size: 20), text: 'Produtos'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search Input
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (val) {
                setState(() {
                  _searchQuery = val;
                });
              },
              decoration: InputDecoration(
                hintText: 'Buscar por nome ou categoria...',
                prefixIcon: const Icon(Icons.search, color: AppTheme.primaryGold),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white54),
                        onPressed: () {
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
              ),
            ),
          ),

          // Tab views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Services List
                services.isEmpty
                    ? const Center(
                        child: Text('Nenhum serviço encontrado.',
                            style: TextStyle(color: Colors.white54)),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: services.length,
                        itemBuilder: (context, index) {
                          final service = services[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppTheme.darkCard,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppTheme.darkCardBorder),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: AppTheme.primaryGold
                                            .withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        service.category.toUpperCase(),
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.primaryGold,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '${service.durationMinutes} min',
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.white54),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  service.title,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  service.description,
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.white70),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'R\$ ${service.price.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w900,
                                        color: AppTheme.primaryGold,
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: widget.onStartBooking,
                                      child: const Text('AGENDAR'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                // Packages List
                packages.isEmpty
                    ? const Center(
                        child: Text('Nenhum pacote encontrado.',
                            style: TextStyle(color: Colors.white54)),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: packages.length,
                        itemBuilder: (context, index) {
                          final pkg = packages[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 14),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppTheme.darkCard,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  color: AppTheme.primaryGold
                                      .withValues(alpha: 0.5)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: AppTheme.primaryGold,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        pkg.badgeText,
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '+${pkg.bonusPoints} pts no Clube',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppTheme.accentAmber,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  pkg.title,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  pkg.description,
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.white70),
                                ),
                                const SizedBox(height: 10),
                                const Text('Itens inclusos neste combo:',
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.white54,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                ...pkg.serviceNames.map((s) => Row(
                                      children: [
                                        const Icon(Icons.check,
                                            size: 14, color: AppTheme.primaryGold),
                                        const SizedBox(width: 6),
                                        Text(s,
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white.withValues(alpha: 0.87))),
                                      ],
                                    )),
                                ...pkg.productNames.map((p) => Row(
                                      children: [
                                        const Icon(Icons.card_giftcard,
                                            size: 14, color: AppTheme.accentAmber),
                                        const SizedBox(width: 6),
                                        Text('$p (Produto para levar)',
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: AppTheme.accentAmber)),
                                      ],
                                    )),
                                const Divider(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'De: R\$ ${pkg.originalPrice.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            decoration: TextDecoration.lineThrough,
                                            fontSize: 12,
                                            color: Colors.white38,
                                          ),
                                        ),
                                        Text(
                                          'Por: R\$ ${pkg.packagePrice.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w900,
                                            color: AppTheme.primaryGold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    ElevatedButton(
                                      onPressed: widget.onStartBooking,
                                      child: const Text('RESERVAR COMBO'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                // Products List
                products.isEmpty
                    ? const Center(
                        child: Text('Nenhum produto encontrado.',
                            style: TextStyle(color: Colors.white54)),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          final stock =
                              product.stockByBranch[activeBranch.id] ?? 0;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppTheme.darkCard,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppTheme.darkCardBorder),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppTheme.accentAmber
                                        .withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: const Icon(
                                    Icons.shopping_bag_outlined,
                                    color: AppTheme.accentAmber,
                                    size: 30,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        product.description,
                                        style: const TextStyle(
                                            fontSize: 11,
                                            color: Colors.white54),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          Icon(
                                            stock > 0
                                                ? Icons.inventory_2
                                                : Icons.production_quantity_limits,
                                            size: 14,
                                            color: stock > 0
                                                ? AppTheme.successGreen
                                                : AppTheme.dangerRed,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            stock > 0
                                                ? 'Estoque na unidade: $stock un.'
                                                : 'Esgotado nesta filial',
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: stock > 0
                                                  ? AppTheme.successGreen
                                                  : AppTheme.dangerRed,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'R\$ ${product.price.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.primaryGold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: stock > 0
                                      ? () {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Reserva do produto "${product.name}" enviada para retirada na unidade ${activeBranch.name}!',
                                              ),
                                            ),
                                          );
                                        }
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                    minimumSize: Size.zero,
                                  ),
                                  child: const Text('COMPRAR',
                                      style: TextStyle(fontSize: 11)),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
