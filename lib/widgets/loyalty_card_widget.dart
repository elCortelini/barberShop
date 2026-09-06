import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class LoyaltyCardWidget extends StatelessWidget {
  final int currentPoints;
  final VoidCallback onTap;

  const LoyaltyCardWidget({
    super.key,
    required this.currentPoints,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const nextTierGoal = 500;
    final progress = (currentPoints / nextTierGoal).clamp(0.0, 1.0);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF382C10),
            Color(0xFF241B08),
            Color(0xFF16130B),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: AppTheme.primaryGold,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryGold.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.workspace_premium,
                      color: AppTheme.primaryGold, size: 24),
                  SizedBox(width: 8),
                  Text(
                    'CLUBE DE FIDELIDADE',
                    style: TextStyle(
                      color: AppTheme.primaryGold,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGold.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.primaryGold, width: 1),
                ),
                child: const Text(
                  'CLIENTE ELITE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '$currentPoints',
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                'pontos acumulados',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.white12,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppTheme.primaryGold),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Faltam ${nextTierGoal - currentPoints} pts para o selo VIP',
                style: const TextStyle(fontSize: 11, color: Colors.white54),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: const TextStyle(
                    fontSize: 11,
                    color: AppTheme.primaryGold,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onTap,
              icon: const Icon(Icons.card_giftcard, size: 18),
              label: const Text('VER RECOMPENSAS DISPONÍVEIS'),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppTheme.primaryGold),
                foregroundColor: AppTheme.primaryGold,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
