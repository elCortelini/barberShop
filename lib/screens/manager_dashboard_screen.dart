import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/barbershop_provider.dart';
import '../models/appointment.dart';
import '../theme/app_theme.dart';
import 'branch_selection_dialog.dart';

class ManagerDashboardScreen extends StatelessWidget {
  final Function(int)? onNavigateSubTab;

  const ManagerDashboardScreen({super.key, this.onNavigateSubTab});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BarbershopProvider>(context);
    final activeBranch = provider.selectedBranch;
    final currentUser = provider.currentUser;

    // Filter store appointments
    final branchAppointments = provider.appointments
        .where((a) => a.branchId == activeBranch.id)
        .toList();
    final completedCount = branchAppointments
        .where((a) => a.status == AppointmentStatus.completed)
        .length;
    final scheduledCount = branchAppointments
        .where((a) => a.status == AppointmentStatus.scheduled)
        .length;
    final totalRevenue = branchAppointments.fold<double>(
        0.0, (sum, a) => sum + (a.status != AppointmentStatus.cancelled ? a.price : 0.0));

    // Low stock products on current branch
    final lowStockProducts = provider.products.where((p) {
      final stock = p.stockByBranch[activeBranch.id] ?? 0;
      return stock <= 15;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard do Gerente'),
        actions: [
          IconButton(
            icon: const Icon(Icons.store, color: AppTheme.primaryGold),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const BranchSelectionDialog(),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Manager Store Header Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.darkCard,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.primaryGold, width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryGold,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'GERENTE DE UNIDADE',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Text(
                        currentUser.email,
                        style: const TextStyle(
                            fontSize: 11, color: Colors.white54),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    activeBranch.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 14, color: AppTheme.primaryGold),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          activeBranch.address,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.white70),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Metrics Grid (Faturamento & Atendimentos)
            Row(
              children: [
                Expanded(
                  child: _DashboardStatCard(
                    title: 'Faturamento Movimentado',
                    value: 'R\$ ${totalRevenue.toStringAsFixed(2)}',
                    subtitle: 'Agendamentos da loja',
                    icon: Icons.monetization_on,
                    color: AppTheme.successGreen,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _DashboardStatCard(
                    title: 'Atendimentos',
                    value: '${branchAppointments.length}',
                    subtitle: '$completedCount concluídos • $scheduledCount ativos',
                    icon: Icons.calendar_month,
                    color: AppTheme.infoBlue,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Low Stock Alert Section
            const Text(
              'ALERTAS DE ESTOQUE DE PRODUTOS',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 10),

            if (lowStockProducts.isEmpty)
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.darkCard,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.check_circle,
                        color: AppTheme.successGreen, size: 20),
                    SizedBox(width: 10),
                    Text(
                      'Estoque de todos os produtos está regular nesta filial.',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              )
            else
              Column(
                children: lowStockProducts.map((product) {
                  final stock = product.stockByBranch[activeBranch.id] ?? 0;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppTheme.darkCard,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: AppTheme.warningOrange.withValues(alpha: 0.6)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.warning_amber_rounded,
                            color: AppTheme.warningOrange, size: 24),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                'Estoque atual na loja: $stock unidades',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppTheme.warningOrange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Estorno / Reposição de Estoque de Compra Não Confirmada
                            provider.releaseProductStock(
                                product.id, activeBranch.id, 10);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Estoque do produto "${product.name}" liberado/reposto (+10 un)!',
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.warningOrange,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            minimumSize: Size.zero,
                          ),
                          child: const Text('REPOR +10',
                              style: TextStyle(fontSize: 10)),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),

            const SizedBox(height: 24),

            // Barbers Productivity Section
            const Text(
              'EQUIPE DE BARBEIROS DA UNIDADE',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 10),

            ...provider.currentBranchProfessionals.map((barber) {
              final barberApts = branchAppointments
                  .where((a) => a.professionalId == barber.id)
                  .toList();

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
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
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            barber.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'Horário: ${barber.workingHours}',
                            style: const TextStyle(
                                fontSize: 11, color: Colors.white54),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryGold.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${barberApts.length} atendimentos',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryGold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 30),

            // Footer Version Info
            const Center(
              child: Text(
                'Estação Elite Barbearia • Versão: barberShopV004',
                style: TextStyle(fontSize: 11, color: Colors.white38),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _DashboardStatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _DashboardStatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.darkCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 11, color: Colors.white54),
              ),
              Icon(icon, color: color, size: 20),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 10, color: Colors.white38),
          ),
        ],
      ),
    );
  }
}
