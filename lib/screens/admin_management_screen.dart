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
        title: const Text('Gestão de Lojas & Cadastros'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: AppTheme.primaryGold,
          labelColor: AppTheme.primaryGold,
          unselectedLabelColor: Colors.white54,
          tabs: const [
            Tab(text: 'Serviços'),
            Tab(text: 'Profissionais'),
            Tab(text: 'Produtos & Estoque'),
            Tab(text: 'Pacotes'),
            Tab(text: 'Unidades/Lojas'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildServicesTab(provider),
          _buildProfessionalsTab(provider),
          _buildProductsTab(provider),
          _buildPackagesTab(provider),
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
        onPressed: () => _showServiceFormDialog(provider, null),
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
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGold.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.content_cut, color: AppTheme.primaryGold),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(service.title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      Text(
                          '${service.durationMinutes} min • R\$ ${service.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                              color: AppTheme.primaryGold, fontSize: 13)),
                      Text(service.description,
                          style: const TextStyle(
                              color: Colors.white54, fontSize: 11)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: AppTheme.primaryGold),
                  onPressed: () => _showServiceFormDialog(provider, service),
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

  void _showServiceFormDialog(
      BarbershopProvider provider, ServiceItem? existing) {
    final titleController = TextEditingController(text: existing?.title ?? '');
    final descController = TextEditingController(text: existing?.description ?? '');
    final priceController =
        TextEditingController(text: existing?.price.toString() ?? '');
    final durationController =
        TextEditingController(text: existing?.durationMinutes.toString() ?? '');
    final imageController =
        TextEditingController(text: existing?.imageUrl ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkSurface,
        title: Text(existing == null ? 'Cadastrar Serviço' : 'Editar Serviço',
            style: const TextStyle(color: Colors.white)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Nome do Serviço'),
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
              const SizedBox(height: 10),
              TextField(
                controller: durationController,
                keyboardType: TextInputType.number,
                decoration:
                    const InputDecoration(labelText: 'Duração em minutos'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: imageController,
                decoration:
                    const InputDecoration(labelText: 'URL da Foto do Serviço'),
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
                final item = ServiceItem(
                  id: existing?.id ?? 's_${DateTime.now().millisecondsSinceEpoch}',
                  title: titleController.text,
                  description: descController.text,
                  price: double.tryParse(priceController.text) ?? 50.0,
                  durationMinutes:
                      int.tryParse(durationController.text) ?? 30,
                  category: 'Geral',
                  imageUrl: imageController.text,
                );

                if (existing == null) {
                  provider.addService(item);
                } else {
                  provider.updateService(item);
                }

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
        onPressed: () => _showProfessionalFormDialog(provider, null),
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
                      Text('${barber.role} • E-mail: ${barber.email}',
                          style: const TextStyle(
                              color: AppTheme.primaryGold, fontSize: 12)),
                      Text('Horário: ${barber.workingHours}',
                          style: const TextStyle(
                              color: Colors.white54, fontSize: 11)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: AppTheme.primaryGold),
                  onPressed: () =>
                      _showProfessionalFormDialog(provider, barber),
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

  void _showProfessionalFormDialog(
      BarbershopProvider provider, Professional? existing) {
    final nameController = TextEditingController(text: existing?.name ?? '');
    final emailController = TextEditingController(text: existing?.email ?? '');
    final roleController = TextEditingController(text: existing?.role ?? '');
    final hoursController =
        TextEditingController(text: existing?.workingHours ?? '08:00 - 19:00');
    final avatarController =
        TextEditingController(text: existing?.avatarUrl ?? '');
    final bioController = TextEditingController(text: existing?.bio ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkSurface,
        title: Text(existing == null ? 'Cadastrar Barbeiro' : 'Editar Barbeiro',
            style: const TextStyle(color: Colors.white)),
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
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'E-mail Google do Barbeiro',
                  hintText: 'ex: carlos.barba@estacaoelite.com',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: roleController,
                decoration:
                    const InputDecoration(labelText: 'Especialidade / Cargo'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: hoursController,
                decoration:
                    const InputDecoration(labelText: 'Horário de Atendimento'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: avatarController,
                decoration:
                    const InputDecoration(labelText: 'URL da Foto / Avatar'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: bioController,
                decoration: const InputDecoration(labelText: 'Biografia'),
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
                final item = Professional(
                  id: existing?.id ??
                      'p_${DateTime.now().millisecondsSinceEpoch}',
                  name: nameController.text,
                  email: emailController.text,
                  role: roleController.text.isNotEmpty
                      ? roleController.text
                      : 'Barbeiro Elite',
                  avatarUrl: avatarController.text,
                  rating: existing?.rating ?? 5.0,
                  branchIds: existing?.branchIds ?? ['b1', 'b2', 'b3'],
                  workingHours: hoursController.text,
                  workingDays: existing?.workingDays ?? [1, 2, 3, 4, 5, 6],
                  availableTimeSlots: existing?.availableTimeSlots ??
                      ['09:00', '10:00', '11:00', '14:00', '15:30', '17:00'],
                  bio: bioController.text,
                );

                if (existing == null) {
                  provider.addProfessional(item);
                } else {
                  provider.updateProfessional(item);
                }

                Navigator.pop(context);
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  // --- TAB 3: PRODUTOS & ESTOQUE ---
  Widget _buildProductsTab(BarbershopProvider provider) {
    final products = provider.products;
    final activeBranch = provider.selectedBranch;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showProductFormDialog(provider, null),
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
          final stock = product.stockByBranch[activeBranch.id] ?? 0;

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
                      Text(
                        'R\$ ${product.price.toStringAsFixed(2)} • Estoque na loja: $stock un.',
                        style: const TextStyle(
                            color: AppTheme.primaryGold, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                // Botão de Estorno de Compra Não Confirmada
                IconButton(
                  tooltip: 'Estornar/Liberar Estoque (+5)',
                  icon: const Icon(Icons.restore, color: AppTheme.warningOrange),
                  onPressed: () {
                    provider.releaseProductStock(
                        product.id, activeBranch.id, 5);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Estoque do produto "${product.name}" estornado (+5 un).'),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: AppTheme.primaryGold),
                  onPressed: () => _showProductFormDialog(provider, product),
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

  void _showProductFormDialog(BarbershopProvider provider, Product? existing) {
    final nameController = TextEditingController(text: existing?.name ?? '');
    final descController = TextEditingController(text: existing?.description ?? '');
    final priceController =
        TextEditingController(text: existing?.price.toString() ?? '');
    final imageController =
        TextEditingController(text: existing?.imageUrl ?? '');
    final stockController = TextEditingController(
        text: (existing?.stockByBranch[provider.selectedBranch.id] ?? 20)
            .toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkSurface,
        title: Text(existing == null ? 'Cadastrar Produto' : 'Editar Produto',
            style: const TextStyle(color: Colors.white)),
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
              const SizedBox(height: 10),
              TextField(
                controller: stockController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Estoque para ${provider.selectedBranch.name}',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: imageController,
                decoration:
                    const InputDecoration(labelText: 'URL da Foto do Produto'),
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
                final activeBranchId = provider.selectedBranch.id;
                final updatedStock = Map<String, int>.from(
                    existing?.stockByBranch ?? {'b1': 20, 'b2': 20, 'b3': 20});
                updatedStock[activeBranchId] =
                    int.tryParse(stockController.text) ?? 20;

                final item = Product(
                  id: existing?.id ??
                      'pr_${DateTime.now().millisecondsSinceEpoch}',
                  name: nameController.text,
                  description: descController.text,
                  price: double.tryParse(priceController.text) ?? 39.90,
                  category: 'Cosméticos',
                  imageUrl: imageController.text,
                  stockByBranch: updatedStock,
                  loyaltyPointsBonus: 15,
                );

                if (existing == null) {
                  provider.addProduct(item);
                } else {
                  provider.updateProduct(item);
                }

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
        onPressed: () => _showPackageFormDialog(provider, null),
        backgroundColor: AppTheme.primaryGold,
        foregroundColor: Colors.black,
        icon: const Icon(Icons.stars),
        label: const Text('Novo Pacote'),
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
                          'Por R\$ ${pkg.packagePrice.toStringAsFixed(2)} (De R\$ ${pkg.originalPrice.toStringAsFixed(2)})',
                          style: const TextStyle(
                              color: AppTheme.primaryGold, fontSize: 12)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: AppTheme.primaryGold),
                  onPressed: () => _showPackageFormDialog(provider, pkg),
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

  void _showPackageFormDialog(
      BarbershopProvider provider, ComboPackage? existing) {
    final titleController = TextEditingController(text: existing?.title ?? '');
    final descController = TextEditingController(text: existing?.description ?? '');
    final origPriceController =
        TextEditingController(text: existing?.originalPrice.toString() ?? '');
    final pkgPriceController =
        TextEditingController(text: existing?.packagePrice.toString() ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkSurface,
        title: Text(existing == null ? 'Cadastrar Pacote' : 'Editar Pacote',
            style: const TextStyle(color: Colors.white)),
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
                final item = ComboPackage(
                  id: existing?.id ??
                      'pkg_${DateTime.now().millisecondsSinceEpoch}',
                  title: titleController.text,
                  description: descController.text,
                  originalPrice:
                      double.tryParse(origPriceController.text) ?? 150.0,
                  packagePrice:
                      double.tryParse(pkgPriceController.text) ?? 120.0,
                  serviceNames: existing?.serviceNames ?? ['Corte', 'Barba'],
                  productNames:
                      existing?.productNames ?? ['Pomada Matte'],
                  bonusPoints: 50,
                );

                if (existing == null) {
                  provider.addComboPackage(item);
                } else {
                  provider.updateComboPackage(item);
                }

                Navigator.pop(context);
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  // --- TAB 5: UNIDADES / LOJAS ---
  Widget _buildBranchesTab(BarbershopProvider provider) {
    final branches = provider.branches;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showBranchFormDialog(provider, null),
        backgroundColor: AppTheme.primaryGold,
        foregroundColor: Colors.black,
        icon: const Icon(Icons.store),
        label: const Text('Nova Loja'),
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
                      Text(branch.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      Text(branch.address,
                          style: const TextStyle(
                              color: Colors.white54, fontSize: 11)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: AppTheme.primaryGold),
                  onPressed: () => _showBranchFormDialog(provider, branch),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showBranchFormDialog(BarbershopProvider provider, Branch? existing) {
    final nameController = TextEditingController(text: existing?.name ?? '');
    final addressController = TextEditingController(text: existing?.address ?? '');
    final phoneController = TextEditingController(text: existing?.phone ?? '');
    final hoursController =
        TextEditingController(text: existing?.openingHours ?? 'Seg - Sáb: 08:00 - 20:00');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkSurface,
        title: Text(existing == null ? 'Cadastrar Loja' : 'Editar Loja',
            style: const TextStyle(color: Colors.white)),
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
                decoration: const InputDecoration(labelText: 'Telefone'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: hoursController,
                decoration:
                    const InputDecoration(labelText: 'Horário de Atendimento'),
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
                final item = Branch(
                  id: existing?.id ??
                      'b_${DateTime.now().millisecondsSinceEpoch}',
                  name: nameController.text,
                  address: addressController.text,
                  phone: phoneController.text,
                  isMain: existing?.isMain ?? false,
                  openingHours: hoursController.text,
                  imageUrl: existing?.imageUrl ?? '',
                  managerEmails: existing?.managerEmails ?? [],
                );

                if (existing == null) {
                  provider.addBranch(item);
                } else {
                  provider.updateBranch(item);
                }

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
