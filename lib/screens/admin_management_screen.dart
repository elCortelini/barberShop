import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/barbershop_provider.dart';
import '../models/service_item.dart';
import '../models/professional.dart';
import '../models/product.dart';
import '../models/combo_package.dart';
import '../models/branch.dart';
import '../theme/app_theme.dart';

class AdminManagementScreen extends StatefulWidget {
  const AdminManagementScreen({super.key});

  @override
  State<AdminManagementScreen> createState() => _AdminManagementScreenState();
}

class _AdminManagementScreenState extends State<AdminManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BarbershopProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Painel de Gestão Estação Elite'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: AppTheme.primaryGold,
          labelColor: AppTheme.primaryGold,
          unselectedLabelColor: Colors.white54,
          tabs: const [
            Tab(text: 'Serviços'),
            Tab(text: 'Profissionais'),
            Tab(text: 'Produtos'),
            Tab(text: 'Pacotes'),
            Tab(text: 'Unidades/Lojas'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // 1. Gestão de Serviços
          _buildServicesTab(provider),

          // 2. Gestão de Profissionais & Horários
          _buildProfessionalsTab(provider),

          // 3. Gestão de Produtos & Valores
          _buildProductsTab(provider),

          // 4. Gestão de Pacotes & Combos
          _buildPackagesTab(provider),

          // 5. Gestão de Lojas (Matriz & Filiais)
          _buildBranchesTab(provider),
        ],
      ),
    );
  }

  // --- TAB 1: SERVIÇOS ---
  Widget _buildServicesTab(BarbershopProvider provider) {
    final services = provider.services;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddServiceDialog(provider),
        backgroundColor: AppTheme.primaryGold,
        foregroundColor: Colors.black,
        icon: const Icon(Icons.add),
        label: const Text('Novo Serviço'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: services.length,
        itemBuilder: (context, index) {
          final service = services[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.darkCard,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.darkCardBorder),
            ),
            child: Row(
              children: [
                const Icon(Icons.content_cut, color: AppTheme.primaryGold),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(service.title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      Text('${service.durationMinutes} min • R\$ ${service.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                              color: AppTheme.primaryGold, fontSize: 13)),
                      Text(service.description,
                          style: const TextStyle(
                              color: Colors.white54, fontSize: 11)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline,
                      color: AppTheme.dangerRed),
                  onPressed: () {
                    provider.removeService(service.id);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showAddServiceDialog(BarbershopProvider provider) {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    final priceController = TextEditingController();
    final durationController = TextEditingController();
    String category = 'Cabelo';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkSurface,
        title: const Text('Cadastrar Novo Serviço',
            style: TextStyle(color: Colors.white)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration:
                    const InputDecoration(labelText: 'Nome do Serviço'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: descController,
                decoration: const InputDecoration(labelText: 'Descrição'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration:
                    const InputDecoration(labelText: 'Preço (R\$)'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: durationController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    labelText: 'Duração em minutos'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty &&
                  priceController.text.isNotEmpty) {
                provider.addService(
                  ServiceItem(
                    id: 's_${DateTime.now().millisecondsSinceEpoch}',
                    title: titleController.text,
                    description: descController.text,
                    price: double.tryParse(priceController.text) ?? 50.0,
                    durationMinutes:
                        int.tryParse(durationController.text) ?? 30,
                    category: category,
                  ),
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  // --- TAB 2: PROFISSIONAIS ---
  Widget _buildProfessionalsTab(BarbershopProvider provider) {
    final professionals = provider.professionals;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddProfessionalDialog(provider),
        backgroundColor: AppTheme.primaryGold,
        foregroundColor: Colors.black,
        icon: const Icon(Icons.person_add),
        label: const Text('Novo Barbeiro'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: professionals.length,
        itemBuilder: (context, index) {
          final barber = professionals[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.darkCard,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.darkCardBorder),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppTheme.primaryGold,
                  child: Text(
                    barber.name.substring(0, 1),
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(barber.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      Text(barber.role,
                          style: const TextStyle(
                              color: AppTheme.primaryGold, fontSize: 13)),
                      Text(
                          'Horários: ${barber.availableTimeSlots.join(', ')}',
                          style: const TextStyle(
                              color: Colors.white54, fontSize: 11)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline,
                      color: AppTheme.dangerRed),
                  onPressed: () {
                    provider.removeProfessional(barber.id);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showAddProfessionalDialog(BarbershopProvider provider) {
    final nameController = TextEditingController();
    final roleController = TextEditingController();
    final bioController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkSurface,
        title: const Text('Cadastrar Barbeiro/Profissional',
            style: TextStyle(color: Colors.white)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nome do Barbeiro'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: roleController,
                decoration: const InputDecoration(labelText: 'Especialidade / Cargo'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: bioController,
                decoration: const InputDecoration(labelText: 'Biografia / Resumo'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                provider.addProfessional(
                  Professional(
                    id: 'p_${DateTime.now().millisecondsSinceEpoch}',
                    name: nameController.text,
                    role: roleController.text.isNotEmpty
                        ? roleController.text
                        : 'Barbeiro Elite',
                    avatarUrl: '',
                    rating: 5.0,
                    branchIds: ['b1', 'b2', 'b3'],
                    workingDays: [1, 2, 3, 4, 5, 6],
                    availableTimeSlots: [
                      '09:00',
                      '10:00',
                      '11:00',
                      '14:00',
                      '15:00',
                      '16:00',
                      '17:00'
                    ],
                    bio: bioController.text,
                  ),
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  // --- TAB 3: PRODUTOS ---
  Widget _buildProductsTab(BarbershopProvider provider) {
    final products = provider.products;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddProductDialog(provider),
        backgroundColor: AppTheme.primaryGold,
        foregroundColor: Colors.black,
        icon: const Icon(Icons.add_shopping_cart),
        label: const Text('Novo Produto'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.darkCard,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.darkCardBorder),
            ),
            child: Row(
              children: [
                const Icon(Icons.shopping_bag, color: AppTheme.accentAmber),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      Text('R\$ ${product.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                              color: AppTheme.primaryGold, fontSize: 13)),
                      Text(product.description,
                          style: const TextStyle(
                              color: Colors.white54, fontSize: 11)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline,
                      color: AppTheme.dangerRed),
                  onPressed: () {
                    provider.removeProduct(product.id);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showAddProductDialog(BarbershopProvider provider) {
    final nameController = TextEditingController();
    final descController = TextEditingController();
    final priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkSurface,
        title: const Text('Cadastrar Produto',
            style: TextStyle(color: Colors.white)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nome do Produto'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: descController,
                decoration: const InputDecoration(labelText: 'Descrição'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Preço (R\$)'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  priceController.text.isNotEmpty) {
                provider.addProduct(
                  Product(
                    id: 'pr_${DateTime.now().millisecondsSinceEpoch}',
                    name: nameController.text,
                    description: descController.text,
                    price: double.tryParse(priceController.text) ?? 39.90,
                    category: 'Cosméticos',
                    imageUrl: '',
                    stockByBranch: {'b1': 20, 'b2': 20, 'b3': 20},
                    loyaltyPointsBonus: 15,
                  ),
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  // --- TAB 4: PACOTES ---
  Widget _buildPackagesTab(BarbershopProvider provider) {
    final packages = provider.packages;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddPackageDialog(provider),
        backgroundColor: AppTheme.primaryGold,
        foregroundColor: Colors.black,
        icon: const Icon(Icons.stars),
        label: const Text('Novo Pacote/Combo'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: packages.length,
        itemBuilder: (context, index) {
          final pkg = packages[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.darkCard,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.darkCardBorder),
            ),
            child: Row(
              children: [
                const Icon(Icons.stars, color: AppTheme.primaryGold),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(pkg.title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      Text(
                          'De R\$ ${pkg.originalPrice.toStringAsFixed(2)} por R\$ ${pkg.packagePrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                              color: AppTheme.primaryGold, fontSize: 13)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline,
                      color: AppTheme.dangerRed),
                  onPressed: () {
                    provider.removeComboPackage(pkg.id);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showAddPackageDialog(BarbershopProvider provider) {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    final origPriceController = TextEditingController();
    final pkgPriceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkSurface,
        title: const Text('Cadastrar Pacote Promo',
            style: TextStyle(color: Colors.white)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Título do Pacote'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: descController,
                decoration: const InputDecoration(labelText: 'Descrição'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: origPriceController,
                keyboardType: TextInputType.number,
                decoration:
                    const InputDecoration(labelText: 'Preço Original (R\$)'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: pkgPriceController,
                keyboardType: TextInputType.number,
                decoration:
                    const InputDecoration(labelText: 'Preço do Pacote (R\$)'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty &&
                  pkgPriceController.text.isNotEmpty) {
                provider.addComboPackage(
                  ComboPackage(
                    id: 'pkg_${DateTime.now().millisecondsSinceEpoch}',
                    title: titleController.text,
                    description: descController.text,
                    originalPrice:
                        double.tryParse(origPriceController.text) ?? 150.0,
                    packagePrice:
                        double.tryParse(pkgPriceController.text) ?? 120.0,
                    serviceNames: ['Corte', 'Barba'],
                    productNames: ['Pomada Matte'],
                    bonusPoints: 50,
                  ),
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  // --- TAB 5: LOJAS / UNIDADES ---
  Widget _buildBranchesTab(BarbershopProvider provider) {
    final branches = provider.branches;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddBranchDialog(provider),
        backgroundColor: AppTheme.primaryGold,
        foregroundColor: Colors.black,
        icon: const Icon(Icons.store),
        label: const Text('Nova Filial/Loja'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: branches.length,
        itemBuilder: (context, index) {
          final branch = branches[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.darkCard,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.darkCardBorder),
            ),
            child: Row(
              children: [
                Icon(
                  branch.isMain ? Icons.star : Icons.store,
                  color: AppTheme.primaryGold,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(branch.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                          if (branch.isMain) ...[
                            const SizedBox(width: 6),
                            const Text('(MATRIZ)',
                                style: TextStyle(
                                    color: AppTheme.primaryGold,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ],
                      ),
                      Text(branch.address,
                          style: const TextStyle(
                              color: Colors.white54, fontSize: 11)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showAddBranchDialog(BarbershopProvider provider) {
    final nameController = TextEditingController();
    final addressController = TextEditingController();
    final phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkSurface,
        title: const Text('Cadastrar Nova Loja / Filial',
            style: TextStyle(color: Colors.white)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nome da Filial'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(labelText: 'Endereço Completo'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Telefone de Contato'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                provider.addBranch(
                  Branch(
                    id: 'b_${DateTime.now().millisecondsSinceEpoch}',
                    name: nameController.text,
                    address: addressController.text,
                    phone: phoneController.text,
                    isMain: false,
                    openingHours: 'Seg - Sáb: 09:00 - 20:00',
                    imageUrl: '',
                  ),
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }
}
