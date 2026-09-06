import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../state/barbershop_provider.dart';
import '../models/appointment.dart';
import '../widgets/status_badge.dart';
import '../theme/app_theme.dart';

class MyAppointmentsScreen extends StatefulWidget {
  final VoidCallback onNewBooking;

  const MyAppointmentsScreen({super.key, required this.onNewBooking});

  @override
  State<MyAppointmentsScreen> createState() => _MyAppointmentsScreenState();
}

class _MyAppointmentsScreenState extends State<MyAppointmentsScreen> {
  AppointmentStatus _selectedFilter = AppointmentStatus.scheduled;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BarbershopProvider>(context);
    final appointments = provider.appointments
        .where((a) => a.status == _selectedFilter)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Agenda de Serviços'),
      ),
      body: Column(
        children: [
          // Filter Segmented Buttons
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppTheme.darkSurface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.darkCardBorder),
            ),
            child: Row(
              children: [
                _FilterTab(
                  label: 'Agendados',
                  isSelected: _selectedFilter == AppointmentStatus.scheduled,
                  onTap: () {
                    setState(() {
                      _selectedFilter = AppointmentStatus.scheduled;
                    });
                  },
                ),
                _FilterTab(
                  label: 'Concluídos',
                  isSelected: _selectedFilter == AppointmentStatus.completed,
                  onTap: () {
                    setState(() {
                      _selectedFilter = AppointmentStatus.completed;
                    });
                  },
                ),
                _FilterTab(
                  label: 'Cancelados',
                  isSelected: _selectedFilter == AppointmentStatus.cancelled,
                  onTap: () {
                    setState(() {
                      _selectedFilter = AppointmentStatus.cancelled;
                    });
                  },
                ),
              ],
            ),
          ),

          // List of appointments
          Expanded(
            child: appointments.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.event_busy,
                            size: 64, color: Colors.white24),
                        const SizedBox(height: 16),
                        Text(
                          _selectedFilter == AppointmentStatus.scheduled
                              ? 'Você não possui agendamentos ativos.'
                              : 'Nenhum agendamento neste status.',
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 15),
                        ),
                        const SizedBox(height: 16),
                        if (_selectedFilter == AppointmentStatus.scheduled)
                          ElevatedButton.icon(
                            onPressed: widget.onNewBooking,
                            icon: const Icon(Icons.add),
                            label: const Text('AGENDAR AGORA'),
                          ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: appointments.length,
                    itemBuilder: (context, index) {
                      final apt = appointments[index];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
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
                                    fontWeight: FontWeight.w900,
                                    fontSize: 16,
                                    color: AppTheme.primaryGold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              apt.serviceOrPackageTitle,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.person,
                                    size: 16, color: Colors.white54),
                                const SizedBox(width: 6),
                                Text(
                                  'Barbeiro: ${apt.professionalName}',
                                  style: const TextStyle(
                                      fontSize: 13, color: Colors.white70),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.access_time,
                                    size: 16, color: AppTheme.primaryGold),
                                const SizedBox(width: 6),
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
                                    size: 16, color: Colors.white54),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    apt.branchName,
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.white54),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 20),

                            // Reminder & Loyalty section
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.stars,
                                        size: 16, color: AppTheme.accentAmber),
                                    const SizedBox(width: 4),
                                    Text(
                                      '+${apt.loyaltyPointsEarned} pts de fidelidade',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppTheme.accentAmber,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                if (apt.status ==
                                    AppointmentStatus.scheduled) ...[
                                  Row(
                                    children: [
                                      const Icon(Icons.notifications_active,
                                          size: 16, color: Colors.white70),
                                      const SizedBox(width: 4),
                                      const Text(
                                        'Lembrete',
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.white70),
                                      ),
                                      Switch(
                                        value: apt.reminderEnabled,
                                        activeThumbColor: AppTheme.primaryGold,
                                        onChanged: (val) {
                                          provider.toggleReminder(apt.id);
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),

                            if (apt.status == AppointmentStatus.scheduled) ...[
                              const SizedBox(height: 8),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        backgroundColor: AppTheme.darkSurface,
                                        title: const Text('Cancelar Agendamento',
                                            style:
                                                TextStyle(color: Colors.white)),
                                        content: const Text(
                                          'Tem certeza que deseja cancelar este agendamento?',
                                          style: TextStyle(color: Colors.white70),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text('Voltar'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              provider.cancelAppointment(apt.id);
                                              Navigator.pop(context);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      'Agendamento cancelado com sucesso.'),
                                                ),
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: AppTheme.dangerRed,
                                            ),
                                            child: const Text('Sim, Cancelar'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.close,
                                      size: 16, color: AppTheme.dangerRed),
                                  label: const Text('Cancelar Agendamento',
                                      style: TextStyle(
                                          color: AppTheme.dangerRed,
                                          fontSize: 12)),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                        color: AppTheme.dangerRed),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _FilterTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primaryGold : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.white70,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}
