import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../widgets/buttons/bh_button.dart';
import '../../widgets/inputs/bh_inputs.dart';
import '../../widgets/navigation/bh_navigation.dart';
import 'setup_pan_screen.dart' show SetupStepHeader;

class SetupLicensesScreen extends StatefulWidget {
  const SetupLicensesScreen({super.key});
  @override
  State<SetupLicensesScreen> createState() => _SetupLicensesScreenState();
}

class _SetupLicensesScreenState extends State<SetupLicensesScreen> {
  final Set<String> _selected = {};

  final List<_License> _licenses = [
    _License('FSSAI License', 'Food Safety & Standards', Icons.restaurant_rounded, AppColors.goldAccent, true),
    _License('Shop & Establishment Act', 'State-wise compliance', Icons.storefront_rounded, AppColors.primaryBlue, false),
    _License('Factory License', 'Manufacturing units', Icons.factory_rounded, AppColors.verifiedTeal, false),
    _License('Pollution Board NOC', 'Environmental compliance', Icons.eco_rounded, AppColors.statusGreen, false),
    _License('Trademark', 'Brand protection', Icons.verified_rounded, AppColors.statusAmber, false),
    _License('Import Export Code', 'IE Code for DGFT', Icons.import_export_rounded, AppColors.statusRed, false),
    _License('MSME / Udyam', 'Registration certificate', Icons.business_rounded, AppColors.primaryBlue, false),
    _License('ISO Certification', 'Quality management', Icons.workspace_premium_rounded, AppColors.verifiedTeal, false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BHAppBar(title: 'Company Setup'),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SetupStepHeader(step: 4, totalSteps: 6, title: 'Licences & Compliance', subtitle: 'Select all applicable licences for your business'),
                  ..._licenses.asMap().entries.map((entry) {
                    final i = entry.key;
                    final lic = entry.value;
                    final isSelected = _selected.contains(lic.name);
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Material(
                        color: isSelected ? lic.color.withOpacity(0.06) : Colors.white,
                        borderRadius: BorderRadius.circular(AppRadius.card),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(AppRadius.card),
                          onTap: () => setState(() {
                            if (isSelected) _selected.remove(lic.name); else _selected.add(lic.name);
                          }),
                          child: Container(
                            padding: const EdgeInsets.all(AppSpacing.lg),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(AppRadius.card),
                              border: Border.all(color: isSelected ? lic.color : AppColors.borderLight, width: isSelected ? 1.5 : 1),
                            ),
                            child: Row(
                              children: [
                                Container(width: 40, height: 40, decoration: BoxDecoration(color: lic.color.withOpacity(0.12), borderRadius: BorderRadius.circular(8)), child: Icon(lic.icon, color: lic.color, size: 20)),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                    Row(children: [
                                      Text(lic.name, style: AppTypography.labelMedium),
                                      if (lic.required) ...[const SizedBox(width: 4), Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: AppColors.statusRed.withOpacity(0.12), borderRadius: BorderRadius.circular(4)), child: Text('Required', style: AppTypography.labelSmall.copyWith(color: AppColors.statusRed, fontSize: 9)))],
                                    ]),
                                    Text(lic.subtitle, style: AppTypography.bodySmall),
                                  ]),
                                ),
                                Checkbox(value: isSelected, onChanged: (_) => setState(() { if (isSelected) _selected.remove(lic.name); else _selected.add(lic.name); }), activeColor: lic.color),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ).animate().fadeIn(delay: Duration(milliseconds: i * 50));
                  }),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            child: BHButton(label: 'Continue (${_selected.length} selected)', onPressed: () => context.go('/setup/mca'), trailingIcon: Icons.arrow_forward_rounded),
          ),
        ],
      ),
    );
  }
}

class _License {
  final String name;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool required;
  const _License(this.name, this.subtitle, this.icon, this.color, this.required);
}

class SetupMcaScreen extends StatefulWidget {
  const SetupMcaScreen({super.key});
  @override
  State<SetupMcaScreen> createState() => _SetupMcaScreenState();
}

class _SetupMcaScreenState extends State<SetupMcaScreen> {
  final _controller = TextEditingController();
  bool _isLoading = false;
  bool _fetched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BHAppBar(title: 'Company Setup'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SetupStepHeader(step: 5, totalSteps: 6, title: 'MCA / ROC Connection', subtitle: 'Enter CIN to fetch ROC filing data from MCA portal'),
            BHTextInput(label: 'Corporate Identification Number (CIN)', hint: 'U74900MH2018PTC123456', controller: _controller),
            const SizedBox(height: 8),
            Text('21-character CIN from your Certificate of Incorporation', style: AppTypography.labelSmall),
            const SizedBox(height: 24),
            BHButton(label: _fetched ? 'ROC Data Connected ✓' : 'Connect to MCA Portal', isLoading: _isLoading, onPressed: () {
              setState(() => _isLoading = true);
              Future.delayed(const Duration(seconds: 1), () {
                if (mounted) setState(() { _isLoading = false; _fetched = true; });
              });
            }),
            if (_fetched) ...[
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(color: AppColors.lightTeal, borderRadius: BorderRadius.circular(AppRadius.card), border: Border.all(color: AppColors.verifiedTeal.withOpacity(0.3))),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [const Icon(Icons.account_balance_rounded, color: AppColors.verifiedTeal, size: 18), const SizedBox(width: 6), Text('MCA Verified', style: AppTypography.labelLarge.copyWith(color: AppColors.verifiedTeal))]),
                  const SizedBox(height: 12),
                  _Row('CIN', 'U74900MH2018PTC123456'),
                  _Row('ROC', 'ROC-Mumbai'),
                  _Row('Last AGM', '30-09-2024'),
                  _Row('Paid Up Capital', '₹10,00,000'),
                  _Row('Directors', '2 active'),
                ]),
              ).animate().fadeIn(duration: 400.ms),
              const SizedBox(height: 24),
              BHButton(label: 'Continue', onPressed: () => context.go('/setup/team'), trailingIcon: Icons.arrow_forward_rounded),
            ] else ...[
              const SizedBox(height: 16),
              BHButton(label: 'Skip for Now', onPressed: () => context.go('/setup/team'), type: BHButtonType.ghost),
            ],
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label, value;
  const _Row(this.label, this.value);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: AppTypography.bodySmall),
        Text(value, style: AppTypography.dataMonoSmall),
      ]),
    );
  }
}
