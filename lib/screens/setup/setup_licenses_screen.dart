import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../widgets/buttons/bh_button.dart';
import '../../widgets/inputs/bh_inputs.dart';
import '../../widgets/navigation/bh_navigation.dart';
import '../../core/providers/onboarding_provider.dart';
import 'setup_pan_screen.dart' show SetupStepHeader, SkipSetupButton;

// ─── License Requirement Level ───────────────────────────────────────────────

enum LicenseLevel { required, recommended, optional, notRequired }

extension LicenseLevelExt on LicenseLevel {
  String get label {
    switch (this) {
      case LicenseLevel.required:     return 'Required';
      case LicenseLevel.recommended:  return 'Recommended';
      case LicenseLevel.optional:     return 'Optional';
      case LicenseLevel.notRequired:  return 'Not Required';
    }
  }

  Color get color {
    switch (this) {
      case LicenseLevel.required:     return AppColors.statusRed;
      case LicenseLevel.recommended:  return AppColors.primaryBlue;
      case LicenseLevel.optional:     return AppColors.statusAmber;
      case LicenseLevel.notRequired:  return AppColors.neutralGrey;
    }
  }

  Color get bg {
    switch (this) {
      case LicenseLevel.required:     return const Color(0xFFFEF2F2);
      case LicenseLevel.recommended:  return const Color(0xFFEFF6FF);
      case LicenseLevel.optional:     return const Color(0xFFFFFBEB);
      case LicenseLevel.notRequired:  return const Color(0xFFF8FAFC);
    }
  }

  IconData get icon {
    switch (this) {
      case LicenseLevel.required:     return Icons.error_rounded;
      case LicenseLevel.recommended:  return Icons.star_rounded;
      case LicenseLevel.optional:     return Icons.info_rounded;
      case LicenseLevel.notRequired:  return Icons.remove_circle_outline_rounded;
    }
  }
}

// ─── License Model ────────────────────────────────────────────────────────────

class _LicenseDef {
  final String name;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _LicenseDef(this.name, this.subtitle, this.icon, this.color);
}

const List<_LicenseDef> _allLicenses = [
  _LicenseDef('FSSAI License',           'Food Safety & Standards Authority',   Icons.restaurant_rounded,         AppColors.goldAccent),
  _LicenseDef('Shop & Establishment Act','State-wise business registration',    Icons.storefront_rounded,         AppColors.primaryBlue),
  _LicenseDef('Factory License',         'For manufacturing units',             Icons.factory_rounded,            AppColors.verifiedTeal),
  _LicenseDef('Pollution Board NOC',     'Environmental compliance',            Icons.eco_rounded,                AppColors.statusGreen),
  _LicenseDef('Trademark',              'Brand & IP protection',               Icons.verified_rounded,           AppColors.statusAmber),
  _LicenseDef('Import Export Code',      'IE Code for DGFT',                    Icons.import_export_rounded,      AppColors.statusRed),
  _LicenseDef('MSME / Udyam',           'MSME registration certificate',       Icons.business_rounded,           AppColors.primaryBlue),
  _LicenseDef('ISO Certification',       'Quality management standard',         Icons.workspace_premium_rounded,  AppColors.verifiedTeal),
  _LicenseDef('Drug License',           'Pharmaceutical & pharma products',    Icons.medication_rounded,         AppColors.statusRed),
  _LicenseDef('Fire NOC',               'Fire safety clearance',               Icons.local_fire_department_rounded, AppColors.statusRed),
  _LicenseDef('PCB Authorization',      'Plastic/waste handling',              Icons.recycling_rounded,          AppColors.statusGreen),
  _LicenseDef('BIS/ISI Certification',  'Product quality standard',            Icons.verified_user_rounded,      AppColors.primaryBlue),
];

// ─── Business-type → License mapping ─────────────────────────────────────────
// Keys are business type labels from setup_business_type_screen.dart

Map<String, LicenseLevel> _levelsFor(String businessTypes) {
  // businessTypes is a comma-separated string like "Manufacturing, Food & Beverage"
  final types = businessTypes.toLowerCase();

  // Start with a default "optional" for all
  final Map<String, LicenseLevel> result = {
    for (final l in _allLicenses) l.name: LicenseLevel.optional,
  };

  // Rules applied left-to-right; later rules override earlier ones
  // ── Shop & Establishment is recommended for ALL ──
  result['Shop & Establishment Act'] = LicenseLevel.recommended;
  result['MSME / Udyam']             = LicenseLevel.recommended;

  if (types.contains('manufacturing') || types.contains('factory')) {
    result['Factory License']       = LicenseLevel.required;
    result['Pollution Board NOC']   = LicenseLevel.required;
    result['Fire NOC']              = LicenseLevel.required;
    result['PCB Authorization']     = LicenseLevel.recommended;
    result['BIS/ISI Certification'] = LicenseLevel.recommended;
    result['ISO Certification']     = LicenseLevel.recommended;
    result['FSSAI License']         = LicenseLevel.notRequired;
    result['Drug License']          = LicenseLevel.notRequired;
  }

  if (types.contains('retail') || types.contains('trading')) {
    result['Shop & Establishment Act'] = LicenseLevel.required;
    result['Trademark']              = LicenseLevel.recommended;
    result['FSSAI License']          = LicenseLevel.optional;
    result['Factory License']        = LicenseLevel.notRequired;
    result['PCB Authorization']      = LicenseLevel.notRequired;
    result['Drug License']           = LicenseLevel.notRequired;
    result['Fire NOC']               = LicenseLevel.optional;
  }

  if (types.contains('food') || types.contains('beverage') || types.contains('restaurant')) {
    result['FSSAI License']          = LicenseLevel.required;
    result['Shop & Establishment Act'] = LicenseLevel.required;
    result['Fire NOC']               = LicenseLevel.required;
    result['Pollution Board NOC']    = LicenseLevel.recommended;
    result['Trademark']              = LicenseLevel.recommended;
    result['Factory License']        = LicenseLevel.optional;
    result['Import Export Code']     = LicenseLevel.optional;
    result['Drug License']           = LicenseLevel.notRequired;
    result['PCB Authorization']      = LicenseLevel.notRequired;
    result['BIS/ISI Certification']  = LicenseLevel.notRequired;
  }

  if (types.contains('services')) {
    result['Shop & Establishment Act'] = LicenseLevel.required;
    result['ISO Certification']      = LicenseLevel.recommended;
    result['Trademark']              = LicenseLevel.recommended;
    result['Factory License']        = LicenseLevel.notRequired;
    result['Pollution Board NOC']    = LicenseLevel.notRequired;
    result['PCB Authorization']      = LicenseLevel.notRequired;
    result['Fire NOC']               = LicenseLevel.notRequired;
    result['Drug License']           = LicenseLevel.notRequired;
    result['FSSAI License']          = LicenseLevel.notRequired;
    result['BIS/ISI Certification']  = LicenseLevel.notRequired;
    result['Import Export Code']     = LicenseLevel.optional;
  }

  if (types.contains('healthcare') || types.contains('pharma')) {
    result['Drug License']           = LicenseLevel.required;
    result['Shop & Establishment Act'] = LicenseLevel.required;
    result['Fire NOC']               = LicenseLevel.required;
    result['ISO Certification']      = LicenseLevel.recommended;
    result['Trademark']              = LicenseLevel.recommended;
    result['Pollution Board NOC']    = LicenseLevel.optional;
    result['FSSAI License']          = LicenseLevel.notRequired;
    result['Factory License']        = LicenseLevel.notRequired;
    result['PCB Authorization']      = LicenseLevel.notRequired;
    result['BIS/ISI Certification']  = LicenseLevel.optional;
    result['Import Export Code']     = LicenseLevel.optional;
  }

  if (types.contains('export') || types.contains('import')) {
    result['Import Export Code']     = LicenseLevel.required;
    result['Trademark']              = LicenseLevel.required;
    result['MSME / Udyam']           = LicenseLevel.required;
    result['ISO Certification']      = LicenseLevel.recommended;
    result['BIS/ISI Certification']  = LicenseLevel.recommended;
    result['Pollution Board NOC']    = LicenseLevel.optional;
    result['Drug License']           = LicenseLevel.optional;
    result['Fire NOC']               = LicenseLevel.optional;
    result['FSSAI License']          = LicenseLevel.optional;
  }

  return result;
}

// ─── Screen ───────────────────────────────────────────────────────────────────

class SetupLicensesScreen extends ConsumerStatefulWidget {
  const SetupLicensesScreen({super.key});
  @override
  ConsumerState<SetupLicensesScreen> createState() => _SetupLicensesScreenState();
}

class _SetupLicensesScreenState extends ConsumerState<SetupLicensesScreen> {
  final Set<String> _selected = {};
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      final businessTypes = ref.read(onboardingProvider).natureOfBusiness;
      final levels = _levelsFor(businessTypes);
      // Auto-select all Required licenses
      for (final entry in levels.entries) {
        if (entry.value == LicenseLevel.required) {
          _selected.add(entry.key);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final businessTypes = ref.watch(onboardingProvider).natureOfBusiness;
    final levels = _levelsFor(businessTypes);

    // Sort licenses into groups
    final required     = _allLicenses.where((l) => levels[l.name] == LicenseLevel.required).toList();
    final recommended  = _allLicenses.where((l) => levels[l.name] == LicenseLevel.recommended).toList();
    final optional     = _allLicenses.where((l) => levels[l.name] == LicenseLevel.optional).toList();
    final notRequired  = _allLicenses.where((l) => levels[l.name] == LicenseLevel.notRequired).toList();

    final manuallySelected = _selected.length;

    return Scaffold(
      appBar: BHAppBar(title: 'Company Setup', actions: const [SkipSetupButton()]),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Step header
                  const SetupStepHeader(
                    step: 4,
                    totalSteps: 6,
                    title: 'Licences & Compliance',
                    subtitle: 'Licences shown are tailored to your business type',
                  ),
                  const SizedBox(height: 12),

                  // Business type context banner
                  if (businessTypes.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.lightBlue,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.primaryBlue.withOpacity(0.2)),
                      ),
                      child: Row(children: [
                        const Icon(Icons.business_center_rounded, color: AppColors.primaryBlue, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Business type: $businessTypes',
                            style: AppTypography.bodySmall.copyWith(color: AppColors.primaryBlue, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ]),
                    ).animate().fadeIn(duration: 300.ms),
                  const SizedBox(height: 16),

                  // Legend
                  _LicenseLegend(),
                  const SizedBox(height: 20),

                  // Group: Required
                  if (required.isNotEmpty) ...[
                    _GroupHeader(level: LicenseLevel.required),
                    const SizedBox(height: 8),
                    ...required.asMap().entries.map((e) => _LicenseTile(
                      license: e.value,
                      level: LicenseLevel.required,
                      isSelected: _selected.contains(e.value.name),
                      isLocked: true, // required = always selected
                      onToggle: null,
                    ).animate().fadeIn(delay: Duration(milliseconds: 60 * e.key))),
                    const SizedBox(height: 20),
                  ],

                  // Group: Recommended
                  if (recommended.isNotEmpty) ...[
                    _GroupHeader(level: LicenseLevel.recommended),
                    const SizedBox(height: 8),
                    ...recommended.asMap().entries.map((e) => _LicenseTile(
                      license: e.value,
                      level: LicenseLevel.recommended,
                      isSelected: _selected.contains(e.value.name),
                      isLocked: false,
                      onToggle: () => setState(() {
                        _selected.contains(e.value.name) ? _selected.remove(e.value.name) : _selected.add(e.value.name);
                      }),
                    ).animate().fadeIn(delay: Duration(milliseconds: 60 * e.key + 80))),
                    const SizedBox(height: 20),
                  ],

                  // Group: Optional
                  if (optional.isNotEmpty) ...[
                    _GroupHeader(level: LicenseLevel.optional),
                    const SizedBox(height: 8),
                    ...optional.asMap().entries.map((e) => _LicenseTile(
                      license: e.value,
                      level: LicenseLevel.optional,
                      isSelected: _selected.contains(e.value.name),
                      isLocked: false,
                      onToggle: () => setState(() {
                        _selected.contains(e.value.name) ? _selected.remove(e.value.name) : _selected.add(e.value.name);
                      }),
                    ).animate().fadeIn(delay: Duration(milliseconds: 60 * e.key + 160))),
                    const SizedBox(height: 20),
                  ],

                  // Group: Not Required (collapsed/dimmed)
                  if (notRequired.isNotEmpty) ...[
                    _GroupHeader(level: LicenseLevel.notRequired),
                    const SizedBox(height: 8),
                    ...notRequired.asMap().entries.map((e) => _LicenseTile(
                      license: e.value,
                      level: LicenseLevel.notRequired,
                      isSelected: false,
                      isLocked: false,
                      onToggle: null, // cannot select "not required"
                    ).animate().fadeIn(delay: Duration(milliseconds: 60 * e.key + 240))),
                    const SizedBox(height: 8),
                  ],
                ],
              ),
            ),
          ),

          // Continue button
          Container(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: AppColors.borderLight)),
            ),
            child: BHButton(
              label: 'Continue  ($manuallySelected licence${manuallySelected == 1 ? '' : 's'} selected)',
              onPressed: () {
                final state = ref.read(onboardingProvider);
                ref.read(onboardingProvider.notifier).updateBusinessInfo(
                  state.turnover,
                  state.natureOfBusiness,
                  _selected.toList(),
                );
                context.go('/setup/mca');
              },
              trailingIcon: Icons.arrow_forward_rounded,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── License Tile ─────────────────────────────────────────────────────────────

class _LicenseTile extends StatelessWidget {
  final _LicenseDef license;
  final LicenseLevel level;
  final bool isSelected;
  final bool isLocked;
  final VoidCallback? onToggle;

  const _LicenseTile({
    required this.license,
    required this.level,
    required this.isSelected,
    required this.isLocked,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isDimmed = level == LicenseLevel.notRequired;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: isSelected ? license.color.withOpacity(0.06) : (isDimmed ? const Color(0xFFF8FAFC) : Colors.white),
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.card),
          onTap: isDimmed ? null : onToggle,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(
                color: isSelected ? license.color.withOpacity(0.5) : AppColors.borderLight,
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                // Icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isDimmed ? AppColors.surfaceBackground : license.color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    license.icon,
                    color: isDimmed ? AppColors.neutralGrey : license.color,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),

                // Text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                        Flexible(
                          child: Text(
                            license.name,
                            style: AppTypography.labelMedium.copyWith(
                              color: isDimmed ? AppColors.textSecondary : AppColors.textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        // Level badge
                        _LevelBadge(level: level),
                      ]),
                      const SizedBox(height: 2),
                      Text(
                        license.subtitle,
                        style: AppTypography.bodySmall.copyWith(
                          color: isDimmed ? AppColors.textTertiary : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Checkbox / Lock icon
                if (isDimmed)
                  const Icon(Icons.block_rounded, color: AppColors.textTertiary, size: 20)
                else if (isLocked)
                  Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Icon(Icons.lock_rounded, color: level.color, size: 18),
                  )
                else
                  Checkbox(
                    value: isSelected,
                    onChanged: (_) => onToggle?.call(),
                    activeColor: license.color,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    side: BorderSide(color: AppColors.borderLight),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Level Badge ──────────────────────────────────────────────────────────────

class _LevelBadge extends StatelessWidget {
  final LicenseLevel level;
  const _LevelBadge({required this.level});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: level.color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        level.label,
        style: AppTypography.labelSmall.copyWith(
          color: level.color,
          fontWeight: FontWeight.w700,
          fontSize: 9,
        ),
      ),
    );
  }
}

// ─── Group Header ─────────────────────────────────────────────────────────────

class _GroupHeader extends StatelessWidget {
  final LicenseLevel level;
  const _GroupHeader({required this.level});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: level.bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: level.color.withOpacity(0.2)),
      ),
      child: Row(children: [
        Icon(level.icon, color: level.color, size: 16),
        const SizedBox(width: 8),
        Text(
          level.label,
          style: AppTypography.labelMedium.copyWith(color: level.color, fontWeight: FontWeight.w700),
        ),
        const Spacer(),
        if (level == LicenseLevel.required)
          Text('Auto-selected · cannot be skipped', style: AppTypography.labelSmall.copyWith(color: level.color.withOpacity(0.8), fontSize: 9))
        else if (level == LicenseLevel.recommended)
          Text('Strongly advised for your business', style: AppTypography.labelSmall.copyWith(color: level.color.withOpacity(0.8), fontSize: 9))
        else if (level == LicenseLevel.optional)
          Text('Select if applicable', style: AppTypography.labelSmall.copyWith(color: level.color.withOpacity(0.8), fontSize: 9))
        else
          Text('Typically not applicable', style: AppTypography.labelSmall.copyWith(color: level.color.withOpacity(0.8), fontSize: 9)),
      ]),
    );
  }
}

// ─── Legend ───────────────────────────────────────────────────────────────────

class _LicenseLegend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Licence Categories', style: AppTypography.labelMedium.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: LicenseLevel.values.map((l) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(l.icon, color: l.color, size: 14),
                const SizedBox(width: 4),
                Text(l.label, style: AppTypography.labelSmall.copyWith(color: l.color, fontWeight: FontWeight.w600)),
              ],
            )).toList(),
          ),
        ],
      ),
    );
  }
}

// ─── MCA Screen (unchanged, lives in same file) ───────────────────────────────

class SetupMcaScreen extends ConsumerStatefulWidget {
  const SetupMcaScreen({super.key});
  @override
  ConsumerState<SetupMcaScreen> createState() => _SetupMcaScreenState();
}

class _SetupMcaScreenState extends ConsumerState<SetupMcaScreen> {
  final _controller = TextEditingController();
  bool _isLoading = false;
  bool _fetched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BHAppBar(title: 'Company Setup', actions: const [SkipSetupButton()]),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SetupStepHeader(step: 5, totalSteps: 6, title: 'MCA / ROC Connection', subtitle: 'Enter CIN to fetch ROC filing data from MCA portal'),
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
                  const _Row('CIN', 'U74900MH2018PTC123456'),
                  const _Row('ROC', 'ROC-Mumbai'),
                  const _Row('Last AGM', '30-09-2024'),
                  const _Row('Paid Up Capital', '₹10,00,000'),
                  const _Row('Directors', '2 active'),
                ]),
              ).animate().fadeIn(duration: 400.ms),
              const SizedBox(height: 24),
              BHButton(label: 'Continue', onPressed: () {
                ref.read(onboardingProvider.notifier).updateComplianceInfo('Verified', 'Active');
                context.go('/setup/team');
              }, trailingIcon: Icons.arrow_forward_rounded),
            ] else ...[
              const SizedBox(height: 16),
              BHButton(label: 'Skip for Now', onPressed: () {
                ref.read(onboardingProvider.notifier).updateComplianceInfo('Skipped', 'Skipped');
                context.go('/setup/team');
              }, type: BHButtonType.ghost),
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
