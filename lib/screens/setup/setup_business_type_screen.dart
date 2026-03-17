import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../widgets/buttons/bh_button.dart';
import '../../widgets/navigation/bh_navigation.dart';
import 'setup_pan_screen.dart' show SetupStepHeader;

class SetupBusinessTypeScreen extends StatefulWidget {
  const SetupBusinessTypeScreen({super.key});
  @override
  State<SetupBusinessTypeScreen> createState() => _SetupBusinessTypeScreenState();
}

class _SetupBusinessTypeScreenState extends State<SetupBusinessTypeScreen> {
  String? _selected;

  final List<_BusinessType> _types = [
    _BusinessType('Manufacturing', Icons.factory_rounded, AppColors.primaryBlue),
    _BusinessType('Retail / Trading', Icons.store_rounded, AppColors.verifiedTeal),
    _BusinessType('Food & Beverage', Icons.restaurant_rounded, AppColors.goldAccent),
    _BusinessType('Services', Icons.design_services_rounded, AppColors.statusAmber),
    _BusinessType('Healthcare', Icons.medical_services_rounded, AppColors.statusGreen),
    _BusinessType('Export / Import', Icons.import_export_rounded, AppColors.statusRed),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BHAppBar(title: 'Company Setup'),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SetupStepHeader(step: 3, totalSteps: 6, title: 'Business Type', subtitle: 'Select your primary business category'),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.4,
                ),
                itemCount: _types.length,
                itemBuilder: (context, index) {
                  final type = _types[index];
                  final isSelected = _selected == type.label;
                  return GestureDetector(
                    onTap: () => setState(() => _selected = type.label),
                    child: AnimatedContainer(
                      duration: 200.ms,
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: isSelected ? type.color.withOpacity(0.12) : Colors.white,
                        borderRadius: BorderRadius.circular(AppRadius.card),
                        border: Border.all(
                          color: isSelected ? type.color : AppColors.borderLight,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(type.icon, color: isSelected ? type.color : AppColors.neutralGrey, size: 32),
                          const SizedBox(height: 8),
                          Text(type.label, style: AppTypography.labelMedium.copyWith(color: isSelected ? type.color : AppColors.textPrimary), textAlign: TextAlign.center),
                        ],
                      ),
                    ).animate().fadeIn(delay: Duration(milliseconds: index * 60)),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            BHButton(
              label: 'Continue',
              onPressed: _selected != null ? () => context.go('/setup/licenses') : null,
              trailingIcon: Icons.arrow_forward_rounded,
            ),
          ],
        ),
      ),
    );
  }
}

class _BusinessType {
  final String label;
  final IconData icon;
  final Color color;
  const _BusinessType(this.label, this.icon, this.color);
}
