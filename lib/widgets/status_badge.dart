import 'package:flutter/material.dart';
import '../models/appointment.dart';
import '../theme/app_theme.dart';

class StatusBadge extends StatelessWidget {
  final AppointmentStatus status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    String label;
    IconData icon;

    switch (status) {
      case AppointmentStatus.scheduled:
        bg = AppTheme.primaryGold.withValues(alpha: 0.15);
        fg = AppTheme.primaryGold;
        label = 'AGENDADO';
        icon = Icons.event_available;
        break;
      case AppointmentStatus.completed:
        bg = AppTheme.successGreen.withValues(alpha: 0.15);
        fg = AppTheme.successGreen;
        label = 'CONCLUÍDO';
        icon = Icons.check_circle_outline;
        break;
      case AppointmentStatus.cancelled:
        bg = AppTheme.dangerRed.withValues(alpha: 0.15);
        fg = AppTheme.dangerRed;
        label = 'CANCELADO';
        icon = Icons.cancel_outlined;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: fg.withValues(alpha: 0.4), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: fg),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: fg,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
