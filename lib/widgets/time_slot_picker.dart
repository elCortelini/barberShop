import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class TimeSlotPicker extends StatelessWidget {
  final List<String> availableSlots;
  final String? selectedSlot;
  final ValueChanged<String> onSelected;

  const TimeSlotPicker({
    super.key,
    required this.availableSlots,
    required this.selectedSlot,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (availableSlots.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.darkCard,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          'Nenhum horário disponível para a data ou profissional selecionado.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white54, fontSize: 13),
        ),
      );
    }

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: availableSlots.map((slot) {
        final isSelected = slot == selectedSlot;

        return ChoiceChip(
          label: Text(slot),
          selected: isSelected,
          selectedColor: AppTheme.primaryGold,
          backgroundColor: AppTheme.darkCard,
          side: BorderSide(
            color: isSelected ? AppTheme.primaryGold : AppTheme.darkCardBorder,
            width: 1.5,
          ),
          labelStyle: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          onSelected: (selected) {
            if (selected) {
              onSelected(slot);
            }
          },
        );
      }).toList(),
    );
  }
}
