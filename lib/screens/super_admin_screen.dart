import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/barbershop_provider.dart';
import '../models/branch.dart';
import '../theme/app_theme.dart';

class SuperAdminScreen extends StatelessWidget {
  const SuperAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BarbershopProvider>(context);
    final branches = provider.branches;
    final currentUser = provider.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Painel do Super Administrador'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Super Admin Master Badge
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF382C10),
                    Color(0xFF241B08),
                    Color(0xFF16130B),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(color: AppTheme.primaryGold, width: 1.5),
              ),
              child: Column(
                children: [
                  const Icon(Icons.shield, color: AppTheme.primaryGold, size: 40),
                  const SizedBox(height: 8),
                  const Text(
                    'PORTAL MASTER - SUPER ADMINISTRADOR',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryGold,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    currentUser.email,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Você possui controle total do sistema e atribuição de Gerentes.',
                    style: TextStyle(fontSize: 11, color: Colors.white70),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Section: Assign Managers to Branches
            const Text(
              'ATRIBUIÇÃO DE GERENTES POR UNIDADE',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Insira o e-mail do gerente da loja para conceder permissão de Dono/Gerente:',
              style: TextStyle(fontSize: 12, color: Colors.white54),
            ),

            const SizedBox(height: 14),

            ...branches.map((branch) {
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.darkCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: branch.isMain
                        ? AppTheme.primaryGold
                        : AppTheme.darkCardBorder,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              branch.isMain ? Icons.star : Icons.store,
                              color: AppTheme.primaryGold,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              branch.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton.icon(
                          onPressed: () => _showAddManagerDialog(
                              context, provider, branch),
                          icon: const Icon(Icons.person_add, size: 16),
                          label: const Text('Add Gerente',
                              style: TextStyle(fontSize: 11)),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            minimumSize: Size.zero,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      branch.address,
                      style:
                          const TextStyle(fontSize: 11, color: Colors.white54),
                    ),
                    const Divider(height: 20),

                    const Text(
                      'Gerentes Autorizados nesta Unidade:',
                      style: TextStyle(
                          fontSize: 11,
                          color: Colors.white70,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),

                    if (branch.managerEmails.isEmpty)
                      const Text(
                        'Nenhum gerente atribuído (somente o Super Admin gerencia esta unidade).',
                        style: TextStyle(
                            fontSize: 11,
                            color: Colors.white38,
                            fontStyle: FontStyle.italic),
                      )
                    else
                      Column(
                        children: branch.managerEmails.map((managerEmail) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 6),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppTheme.darkSurface,
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(color: AppTheme.darkCardBorder),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.mail_outline,
                                        size: 16, color: AppTheme.accentAmber),
                                    const SizedBox(width: 8),
                                    Text(
                                      managerEmail,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline,
                                      color: AppTheme.dangerRed, size: 18),
                                  onPressed: () {
                                    provider.removeManagerFromBranch(
                                        branch.id, managerEmail);
                                  },
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 20),

            // General System Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.darkSurface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.darkCardBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'RESUMO GLOBAL DO SISTEMA',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white54,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _StatBadge(
                        label: 'Unidades',
                        value: '${branches.length}',
                        icon: Icons.store,
                      ),
                      _StatBadge(
                        label: 'Serviços',
                        value: '${provider.services.length}',
                        icon: Icons.content_cut,
                      ),
                      _StatBadge(
                        label: 'Barbeiros',
                        value: '${provider.professionals.length}',
                        icon: Icons.people,
                      ),
                      _StatBadge(
                        label: 'Produtos',
                        value: '${provider.products.length}',
                        icon: Icons.shopping_bag,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  void _showAddManagerDialog(
      BuildContext context, BarbershopProvider provider, Branch branch) {
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkSurface,
        title: Text('Vincular Gerente em ${branch.name}',
            style: const TextStyle(color: Colors.white, fontSize: 16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Digite o e-mail Google do Gerente. Ao realizar login com este e-mail, ele terá acesso total de gerenciamento para esta loja:',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'E-mail do Gerente',
                hintText: 'ex: gerente.centro@estacaoelite.com',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (emailController.text.isNotEmpty) {
                provider.assignManagerToBranch(branch.id, emailController.text);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'E-mail "${emailController.text}" configurado como Gerente de ${branch.name}!',
                    ),
                  ),
                );
              }
            },
            child: const Text('Vincular'),
          ),
        ],
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatBadge({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.primaryGold, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: Colors.white54),
        ),
      ],
    );
  }
}
