import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../state/barbershop_provider.dart';
import '../models/professional.dart';
import '../widgets/time_slot_picker.dart';
import '../theme/app_theme.dart';
import 'branch_selection_dialog.dart';

class BookingScreen extends StatefulWidget {
  final VoidCallback onBookingComplete;

  const BookingScreen({super.key, required this.onBookingComplete});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  // State for step selection
  String? _selectedServiceOrPackageTitle;
  double _selectedPrice = 0.0;
  int _selectedBonusPoints = 30;

  Professional? _selectedProfessional;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  String? _selectedTimeSlot;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BarbershopProvider>(context);
    final activeBranch = provider.selectedBranch;
    final availableServices = provider.currentBranchServices;
    final availablePackages = provider.packages;
    final availableProfessionals = provider.currentBranchProfessionals;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Agendamento de Serviço'),
        actions: [
          IconButton(
            icon: const Icon(Icons.store, color: AppTheme.primaryGold),
            tooltip: 'Trocar Unidade',
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
            // Active Branch Info Card
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primaryGold.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: AppTheme.primaryGold.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on,
                      color: AppTheme.primaryGold, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Unidade Selecionada:',
                          style: TextStyle(fontSize: 11, color: Colors.white54),
                        ),
                        Text(
                          activeBranch.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => const BranchSelectionDialog(),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      minimumSize: Size.zero,
                    ),
                    child: const Text('Alterar', style: TextStyle(fontSize: 11)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Step 1: Select Service or Package
            const Text(
              '1. ESCOLHA O SERVIÇO OU PACOTE',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryGold,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 10),

            // Services Selector Expansion / List
            const Text('Serviços Individuais:',
                style: TextStyle(fontSize: 13, color: Colors.white70)),
            const SizedBox(height: 8),
            ...availableServices.map((service) {
              final isSelected =
                  _selectedServiceOrPackageTitle == service.title;
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.primaryGold.withValues(alpha: 0.15)
                      : AppTheme.darkCard,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.primaryGold
                        : AppTheme.darkCardBorder,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: ListTile(
                  leading: const Icon(Icons.content_cut,
                      color: AppTheme.primaryGold),
                  title: Text(
                    service.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  subtitle: Text(
                    '${service.durationMinutes} min • ${service.description}',
                    style:
                        const TextStyle(fontSize: 12, color: Colors.white54),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Text(
                    'R\$ ${service.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryGold,
                      fontSize: 15,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _selectedServiceOrPackageTitle = service.title;
                      _selectedPrice = service.price;
                      _selectedBonusPoints = 30;
                    });
                  },
                ),
              );
            }),

            const SizedBox(height: 12),
            const Text('Pacotes Promocionais (Combos):',
                style: TextStyle(fontSize: 13, color: Colors.white70)),
            const SizedBox(height: 8),
            ...availablePackages.map((pkg) {
              final isSelected = _selectedServiceOrPackageTitle == pkg.title;
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.primaryGold.withValues(alpha: 0.15)
                      : AppTheme.darkCard,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.primaryGold
                        : AppTheme.darkCardBorder,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: ListTile(
                  leading: const Icon(Icons.stars, color: AppTheme.accentAmber),
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          pkg.title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryGold,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          pkg.badgeText,
                          style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  subtitle: Text(
                    pkg.description,
                    style:
                        const TextStyle(fontSize: 12, color: Colors.white54),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'R\$ ${pkg.originalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          fontSize: 10,
                          color: Colors.white38,
                        ),
                      ),
                      Text(
                        'R\$ ${pkg.packagePrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryGold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      _selectedServiceOrPackageTitle = pkg.title;
                      _selectedPrice = pkg.packagePrice;
                      _selectedBonusPoints = pkg.bonusPoints;
                    });
                  },
                ),
              );
            }),

            const SizedBox(height: 24),

            // Step 2: Select Professional
            const Text(
              '2. ESCOLHA O PROFISSIONAL',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryGold,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 10),

            if (availableProfessionals.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                    'Nenhum barbeiro disponível nesta filial no momento.',
                    style: TextStyle(color: Colors.white54)),
              )
            else
              Column(
                children: availableProfessionals.map((barber) {
                  final isSelected = _selectedProfessional?.id == barber.id;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.primaryGold.withValues(alpha: 0.15)
                          : AppTheme.darkCard,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.primaryGold
                            : AppTheme.darkCardBorder,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppTheme.primaryGold,
                        child: Text(
                          barber.name.substring(0, 1),
                          style: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(
                        barber.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      subtitle: Text(
                        '${barber.role} • ${barber.bio}',
                        style: const TextStyle(
                            fontSize: 12, color: Colors.white54),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star,
                              color: AppTheme.accentAmber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            barber.rating.toString(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      onTap: () {
                        setState(() {
                          _selectedProfessional = barber;
                          _selectedTimeSlot = null;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),

            const SizedBox(height: 24),

            // Step 3: Date & Time
            const Text(
              '3. SELECIONE A DATA E O HORÁRIO',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryGold,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 10),

            // Date picker button bar
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppTheme.darkCard,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.darkCardBorder),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today,
                            color: AppTheme.primaryGold, size: 18),
                        const SizedBox(width: 10),
                        Text(
                          DateFormat('EEEE, dd/MM/yyyy', 'pt_BR')
                              .format(_selectedDate),
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 30)),
                    );
                    if (picked != null) {
                      setState(() {
                        _selectedDate = picked;
                      });
                    }
                  },
                  icon: const Icon(Icons.edit_calendar, size: 18),
                  label: const Text('Mudar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.darkCardBorder,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            const Text('Horários Disponíveis:',
                style: TextStyle(fontSize: 13, color: Colors.white70)),
            const SizedBox(height: 10),

            TimeSlotPicker(
              availableSlots: _selectedProfessional?.availableTimeSlots ??
                  ['09:00', '10:00', '11:00', '14:00', '15:30', '17:00'],
              selectedSlot: _selectedTimeSlot,
              onSelected: (slot) {
                setState(() {
                  _selectedTimeSlot = slot;
                });
              },
            ),

            const SizedBox(height: 30),

            // Step 4: Summary Card & Confirm Button
            if (_selectedServiceOrPackageTitle != null &&
                _selectedProfessional != null &&
                _selectedTimeSlot != null) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.darkSurface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.primaryGold),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.check_circle,
                            color: AppTheme.primaryGold, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'RESUMO DO AGENDAMENTO',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    _SummaryRow(
                        label: 'Unidade', value: activeBranch.name),
                    _SummaryRow(
                        label: 'Serviço',
                        value: _selectedServiceOrPackageTitle!),
                    _SummaryRow(
                        label: 'Barbeiro',
                        value: _selectedProfessional!.name),
                    _SummaryRow(
                      label: 'Data & Hora',
                      value:
                          '${DateFormat('dd/MM/yyyy').format(_selectedDate)} às $_selectedTimeSlot',
                    ),
                    _SummaryRow(
                      label: 'Pontos a Ganhar',
                      value: '+$_selectedBonusPoints pontos',
                      valueColor: AppTheme.accentAmber,
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Valor Total:',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Text(
                          'R\$ ${_selectedPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: AppTheme.primaryGold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    provider.addAppointment(
                      professionalId: _selectedProfessional!.id,
                      professionalName: _selectedProfessional!.name,
                      serviceOrPackageTitle: _selectedServiceOrPackageTitle!,
                      price: _selectedPrice,
                      date: _selectedDate,
                      timeSlot: _selectedTimeSlot!,
                      pointsEarned: _selectedBonusPoints,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: AppTheme.primaryGold,
                        content: Text(
                          'Agendamento confirmado com sucesso na unidade ${activeBranch.name}! +$_selectedBonusPoints pontos creditados.',
                          style: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                    );

                    widget.onBookingComplete();
                  },
                  icon: const Icon(Icons.check, size: 22),
                  label: const Text('CONFIRMAR AGENDAMENTO'),
                ),
              ),
            ] else ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.darkCard,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Selecione o serviço, o profissional e o horário acima para concluir seu agendamento.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white54, fontSize: 13),
                ),
              ),
            ],

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(color: Colors.white54, fontSize: 13)),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                color: valueColor ?? Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
              textAlign: TextAlign.right,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
