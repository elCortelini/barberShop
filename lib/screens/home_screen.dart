import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../state/barbershop_provider.dart';
import '../widgets/custom_banner_carousel.dart';
import '../widgets/loyalty_card_widget.dart';
import '../widgets/status_badge.dart';
import '../theme/app_theme.dart';
import 'branch_selection_dialog.dart';

class HomeScreen extends StatelessWidget {
  final Function(int) onNavigateTab;
  final VoidCallback onStartBooking;

  const HomeScreen({
    super.key,
    required this.onNavigateTab,
    required this.onStartBooking,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BarbershopProvider>(context);
    final activeBranch = provider.selectedBranch;
    final activeAppointments = provider.activeAppointments;
    final services = provider.currentBranchServices;
    final packages = provider.packages;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => const BranchSelectionDialog(),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.darkCard,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.primaryGold, width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.store, color: AppTheme.primaryGold, size: 20),
                const SizedBox(width: 8),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            activeBranch.name,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.keyboard_arrow_down,
                              color: AppTheme.primaryGold, size: 16),
                        ],
                      ),
                      Text(
                        activeBranch.address,
                        style: const TextStyle(
                            fontSize: 10, color: Colors.white54),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined,
                color: AppTheme.primaryGold),
            onPressed: () {
              onNavigateTab(3); // Go to My Appointments
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Active User Profile Banner
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppTheme.darkCard,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: provider.isSuperAdmin
                      ? AppTheme.primaryGold
                      : (provider.isStoreOwner
                          ? AppTheme.accentAmber
                          : AppTheme.darkCardBorder),
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: AppTheme.primaryGold,
                    child: Icon(
                      provider.isSuperAdmin
                          ? Icons.shield
                          : (provider.isStoreOwner ? Icons.store : Icons.person),
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              provider.currentUser.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: provider.isSuperAdmin
                                    ? AppTheme.primaryGold
                                    : (provider.isStoreOwner
                                        ? AppTheme.accentAmber
                                        : Colors.white24),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                provider.currentUser.roleDisplayName,
                                style: TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                  color: provider.isClient
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          provider.currentUser.email,
                          style: const TextStyle(
                              fontSize: 11, color: Colors.white54),
                        ),
                      ],
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => onNavigateTab(5), // Go to Profile / Login
                    icon: const Icon(Icons.swap_horiz,
                        size: 16, color: AppTheme.primaryGold),
                    label: const Text('Trocar',
                        style: TextStyle(
                            fontSize: 11, color: AppTheme.primaryGold)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Banner Carousel (Publicity)
            CustomBannerCarousel(
              banners: provider.promoBanners,
              onBannerTap: (banner) {
                if (banner.actionRoute == '/booking') {
                  onStartBooking();
                } else if (banner.actionRoute == '/loyalty') {
                  onNavigateTab(4); // Loyalty tab
                } else {
                  onNavigateTab(1); // Catalog tab
                }
              },
            ),

            const SizedBox(height: 16),

            // Loyalty Summary Card
            LoyaltyCardWidget(
              currentPoints: provider.userLoyaltyPoints,
              onTap: () {
                onNavigateTab(4); // Go to Loyalty tab
              },
            ),

            const SizedBox(height: 16),

            // Upcoming Appointment Reminder Card (if available)
            if (activeAppointments.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.alarm_on,
                            color: AppTheme.primaryGold, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'PRÓXIMO AGENDAMENTO',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () => onNavigateTab(3),
                      child: const Text('Ver todos',
                          style: TextStyle(
                              color: AppTheme.primaryGold, fontSize: 12)),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.darkCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: AppTheme.primaryGold.withValues(alpha: 0.5)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        StatusBadge(status: activeAppointments.first.status),
                        Row(
                          children: [
                            const Icon(Icons.notifications_active,
                                size: 16, color: AppTheme.primaryGold),
                            const SizedBox(width: 4),
                            Text(
                              activeAppointments.first.reminderEnabled
                                  ? 'Lembrete Ativo'
                                  : 'Lembrete Desativado',
                              style: const TextStyle(
                                  fontSize: 11, color: Colors.white70),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      activeAppointments.first.serviceOrPackageTitle,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.person,
                            size: 14, color: Colors.white54),
                        const SizedBox(width: 4),
                        Text(
                          'Profissional: ${activeAppointments.first.professionalName}',
                          style: const TextStyle(
                              fontSize: 13, color: Colors.white70),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today,
                            size: 14, color: Colors.white54),
                        const SizedBox(width: 4),
                        Text(
                          '${DateFormat('dd/MM/yyyy').format(activeAppointments.first.dateTime)} às ${activeAppointments.first.timeSlot}',
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
                        const Icon(Icons.location_on,
                            size: 14, color: Colors.white54),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            activeAppointments.first.branchName,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.white54),
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
            ],

            // Quick Actions Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ACESSO RÁPIDO',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _QuickActionButton(
                          icon: Icons.calendar_month,
                          label: 'Novo Agendamento',
                          color: AppTheme.primaryGold,
                          onTap: onStartBooking,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _QuickActionButton(
                          icon: Icons.content_cut,
                          label: 'Serviços & Pacotes',
                          color: Colors.white,
                          onTap: () => onNavigateTab(1),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _QuickActionButton(
                          icon: Icons.shopping_bag_outlined,
                          label: 'Produtos Exclusivos',
                          color: Colors.white,
                          onTap: () => onNavigateTab(1),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _QuickActionButton(
                          icon: Icons.admin_panel_settings_outlined,
                          label: 'Painel de Gestão',
                          color: AppTheme.accentAmber,
                          onTap: () => onNavigateTab(5), // Admin tab
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Featured Services Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'SERVIÇOS DESTAQUE',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                  TextButton(
                    onPressed: () => onNavigateTab(1),
                    child: const Text('Ver todos',
                        style: TextStyle(
                            color: AppTheme.primaryGold, fontSize: 12)),
                  ),
                ],
              ),
            ),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: services.take(3).length,
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
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryGold.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.content_cut,
                          color: AppTheme.primaryGold,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              service.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${service.durationMinutes} min • R\$ ${service.price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: AppTheme.primaryGold,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: onStartBooking,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text('AGENDAR',
                            style: TextStyle(fontSize: 11)),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            // Packages publicity banner card
            if (packages.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: const Text(
                  'PACOTES E COMBOS ESPECIAIS',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: packages.length,
                  itemBuilder: (context, index) {
                    final pkg = packages[index];
                    return Container(
                      width: 280,
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.darkCard,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: AppTheme.primaryGold.withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryGold,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    pkg.badgeText,
                                    style: const TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '+${pkg.bonusPoints} pts',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppTheme.accentAmber,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            pkg.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 14,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'R\$ ${pkg.originalPrice.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        decoration: TextDecoration.lineThrough,
                                        color: Colors.white38,
                                        fontSize: 11,
                                      ),
                                    ),
                                    Text(
                                      'R\$ ${pkg.packagePrice.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        color: AppTheme.primaryGold,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              OutlinedButton(
                                onPressed: onStartBooking,
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 6),
                                  minimumSize: Size.zero,
                                ),
                                child: const Text('Reservar',
                                    style: TextStyle(fontSize: 11)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Barbearia Footer Brand Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.darkSurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.darkCardBorder),
              ),
              child: Column(
                children: [
                  const Icon(Icons.content_cut,
                      color: AppTheme.primaryGold, size: 36),
                  const SizedBox(height: 8),
                  const Text(
                    'ESTAÇÃO ELITE BARBEARIA',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Tradição em cortes, barboterapia e ambiente exclusivo.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.white54),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.phone, size: 14, color: AppTheme.primaryGold),
                      const SizedBox(width: 6),
                      Text(
                        activeBranch.phone,
                        style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white70,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const Divider(height: 20),
                  const Text(
                    'Versão Oficial: ${BarbershopProvider.currentVersion}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryGold,
                    ),
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
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: AppTheme.darkCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
