import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../state/barbershop_provider.dart';
import '../models/appointment.dart';
import '../widgets/status_badge.dart';
import '../theme/app_theme.dart';

class BarberPanelScreen extends StatelessWidget {
  const BarberPanelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BarbershopProvider>(context);
    final currentUser = provider.currentUser;
    final barberAppointments = provider.barberAppointments;

    // Metrics calculation
    final completedAppointments = barberAppointments
        .where((a) => a.status == AppointmentStatus.completed)
        .toList();
    final totalRevenue = barberAppointments.fold<double>(
        0.0, (sum, apt) => sum + (apt.status != AppointmentStatus.cancelled ? apt.price : 0.0));
    final estimatedCommission = totalRevenue * 0.50; // 50% commission

    return Scaffold(
      appBar: AppBar(
        title: const Text('Agenda do Barbeiro'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Barber Header Profile Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.darkCard,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.primaryGold, width: 1.5),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: AppTheme.primaryGold,
                    child: Icon(Icons.content_cut, color: Colors.black, size: 30),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.accentAmber,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'PAINEL DO PROFISSIONAL',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          currentUser.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          currentUser.email,
                          style: const TextStyle(
                              fontSize: 12, color: AppTheme.primaryGold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Financial & Metrics Row
            Row(
              children: [
                Expanded(
                  child: _MetricCard(
                    title: 'Atendimentos',
                    value: '${barberAppointments.length}',
                    subtitle: '${completedAppointments.length} concluídos',
                    icon: Icons.event_available,
                    color: AppTheme.infoBlue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _MetricCard(
                    title: 'Sua Comissão (50%)',
                    value: 'R\$ ${estimatedCommission.toStringAsFixed(2)}',
                    subtitle: 'Faturamento: R\$ ${totalRevenue.toStringAsFixed(2)}',
                    icon: Icons.attach_money,
                    color: AppTheme.successGreen,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Today's Clients List
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'SEUS ATENDIMENTOS AGENDADOS',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),
                Text(
                  '${barberAppointments.length} clientes',
                  style: const TextStyle(fontSize: 12, color: Colors.white54),
                ),
              ],
            ),
            const SizedBox(height: 12),

            if (barberAppointments.isEmpty)
              Container(
                padding: const EdgeInsets.all(24),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppTheme.darkCard,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.event_busy, size: 48, color: Colors.white24),
                    SizedBox(height: 10),
                    Text(
                      'Nenhum cliente agendado para o seu horário no momento.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white54, fontSize: 13),
                    ),
                  ],
                ),
              )
            else
              ...barberAppointments.map((apt) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.darkCard,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: apt.status == AppointmentStatus.scheduled
                          ? AppTheme.primaryGold.withValues(alpha: 0.5)
                          : AppTheme.darkCardBorder,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          StatusBadge(status: apt.status),
                          Text(
                            'R\$ ${apt.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryGold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        apt.serviceOrPackageTitle,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.access_time,
                              size: 14, color: AppTheme.primaryGold),
                          const SizedBox(width: 4),
                          Text(
                            '${DateFormat('dd/MM/yyyy').format(apt.dateTime)} às ${apt.timeSlot}',
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppTheme.primaryGold,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.store,
                              size: 14, color: Colors.white54),
                          const SizedBox(width: 4),
                          Text(
                            apt.branchName,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.white54),
                          ),
                        ],
                      ),
                      const Divider(height: 20),

                      if (apt.status == AppointmentStatus.scheduled) ...[
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  provider.completeAppointment(apt.id);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      backgroundColor: AppTheme.successGreen,
                                      content: Text(
                                        'Atendimento concluído com sucesso! Comissão contabilizada.',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.check, size: 18),
                                label: const Text('CONCLUIR SERVIÇO',
                                    style: TextStyle(fontSize: 11)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.successGreen,
                                  foregroundColor: Colors.black,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            OutlinedButton(
                              onPressed: () {
                                provider.cancelAppointment(apt.id);
                              },
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                    color: AppTheme.dangerRed),
                                foregroundColor: AppTheme.dangerRed,
                              ),
                              child: const Text('Cancelar',
                                  style: TextStyle(fontSize: 11)),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                );
              }),

            const SizedBox(height: 30),

            // Footer Version Info
            const Center(
              child: Text(
                'Estação Elite Barbearia • Versão: barberShopV003',
                style: TextStyle(fontSize: 11, color: Colors.white38),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.darkCard,
        borderRadius: BorderRadius.circular(14),
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
              Icon(icon, color: color, size: 18),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
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
