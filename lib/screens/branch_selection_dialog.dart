import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/barbershop_provider.dart';
import '../theme/app_theme.dart';

class BranchSelectionDialog extends StatelessWidget {
  const BranchSelectionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BarbershopProvider>(context);
    final branches = provider.branches;
    final activeBranch = provider.selectedBranch;

    return Dialog(
      backgroundColor: AppTheme.darkSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.storefront, color: AppTheme.primaryGold, size: 28),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Selecione a Unidade',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.white54),
                ),
              ],
            ),
            const Text(
              'Escolha a barbearia Estação Elite mais próxima de você:',
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: branches.map((branch) {
                    final isSelected = branch.id == activeBranch.id;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.primaryGold.withValues(alpha: 0.15)
                            : AppTheme.darkCard,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected
                              ? AppTheme.primaryGold
                              : AppTheme.darkCardBorder,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        leading: CircleAvatar(
                          backgroundColor: branch.isMain
                              ? AppTheme.primaryGold
                              : AppTheme.darkCardBorder,
                          foregroundColor:
                              branch.isMain ? Colors.black : Colors.white,
                          child: Icon(
                            branch.isMain ? Icons.star : Icons.store,
                            size: 20,
                          ),
                        ),
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                branch.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            if (branch.isMain)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryGold,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  'MATRIZ',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.location_on,
                                    size: 14, color: Colors.white54),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    branch.address,
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.white70),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                const Icon(Icons.access_time,
                                    size: 14, color: Colors.white54),
                                const SizedBox(width: 4),
                                Text(
                                  branch.openingHours,
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.white54),
                                ),
                              ],
                            ),
                          ],
                        ),
                        onTap: () {
                          provider.setSelectedBranch(branch);
                          Navigator.pop(context);
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
