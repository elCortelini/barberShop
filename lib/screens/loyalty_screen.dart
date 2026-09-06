import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../state/barbershop_provider.dart';
import '../theme/app_theme.dart';

class LoyaltyScreen extends StatelessWidget {
  const LoyaltyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BarbershopProvider>(context);
    final userPoints = provider.userLoyaltyPoints;
    final rewards = provider.loyaltyRewards;
    final history = provider.loyaltyTransactions;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Clube de Fidelidade Elite'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gold Header Badge
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF3D3012),
                    Color(0xFF261D09),
                    Color(0xFF14120D),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(color: AppTheme.primaryGold, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryGold.withValues(alpha: 0.2),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Icon(Icons.workspace_premium,
                      color: AppTheme.primaryGold, size: 48),
                  const SizedBox(height: 10),
                  const Text(
                    'SEU SALDO DE FIDELIDADE',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryGold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '$userPoints',
                    style: const TextStyle(
                      fontSize: 44,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    'Pontos Acumulados',
                    style: TextStyle(fontSize: 13, color: Colors.white70),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGold.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.primaryGold),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star, color: AppTheme.primaryGold, size: 16),
                        SizedBox(width: 6),
                        Text(
                          'STATUS: CLIENTE VIP ELITE',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // How to earn points hint
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.darkCard,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.darkCardBorder),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: AppTheme.primaryGold, size: 20),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Ganhe pontos automaticamente a cada agendamento de serviço ou compra de produtos na Estação Elite!',
                      style: TextStyle(fontSize: 12, color: Colors.white70),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Recompensas Disponíveis
            const Text(
              'RECOMPENSAS DISPONÍVEIS PARA RESGATE',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 12),

            ...rewards.map((reward) {
              final canRedeem = userPoints >= reward.pointsRequired;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.darkCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: canRedeem
                        ? AppTheme.primaryGold.withValues(alpha: 0.5)
                        : AppTheme.darkCardBorder,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: canRedeem
                            ? AppTheme.primaryGold.withValues(alpha: 0.2)
                            : Colors.white10,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.card_giftcard,
                        color: canRedeem
                            ? AppTheme.primaryGold
                            : Colors.white38,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            reward.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            reward.description,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.white54),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${reward.pointsRequired} PONTOS',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: canRedeem
                                  ? AppTheme.accentAmber
                                  : Colors.white38,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: canRedeem
                          ? () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  backgroundColor: AppTheme.darkSurface,
                                  title: const Text('Confirmar Resgate',
                                      style: TextStyle(color: Colors.white)),
                                  content: Text(
                                    'Deseja resgatar "${reward.title}" por ${reward.pointsRequired} pontos?',
                                    style:
                                        const TextStyle(color: Colors.white70),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancelar'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        final success =
                                            provider.redeemReward(reward);
                                        Navigator.pop(context);
                                        if (success) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Recompensa "${reward.title}" resgatada com sucesso!',
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      child: const Text('Confirmar'),
                                    ),
                                  ],
                                ),
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        minimumSize: Size.zero,
                      ),
                      child: const Text('RESGATAR',
                          style: TextStyle(fontSize: 11)),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 24),

            // Extrato de Pontos (Histórico)
            const Text(
              'EXTRATO DE PONTOS',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 12),

            if (history.isEmpty)
              const Text('Nenhum extrato disponível.',
                  style: TextStyle(color: Colors.white54))
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: history.length,
                itemBuilder: (context, index) {
                  final tx = history[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppTheme.darkCard,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.darkCardBorder),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              tx.isEarned
                                  ? Icons.add_circle_outline
                                  : Icons.remove_circle_outline,
                              color: tx.isEarned
                                  ? AppTheme.successGreen
                                  : AppTheme.dangerRed,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tx.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  DateFormat('dd/MM/yyyy HH:mm')
                                      .format(tx.date),
                                  style: const TextStyle(
                                      fontSize: 11, color: Colors.white38),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Text(
                          '${tx.isEarned ? "+" : ""}${tx.points} pts',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: tx.isEarned
                                ? AppTheme.successGreen
                                : AppTheme.dangerRed,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
