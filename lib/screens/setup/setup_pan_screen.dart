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

// ─── Skip Setup Dialog ────────────────────────────────────────────────────────

Future<void> showSkipSetupDialog(BuildContext context) async {
  await showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) => _SkipSetupSheet(),
  );
}

class _SkipSetupSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40, height: 4,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: AppColors.borderLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Warning icon
            Container(
              width: 64, height: 64,
              decoration: BoxDecoration(
                color: AppColors.statusAmber.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.exit_to_app_rounded, color: AppColors.statusAmber, size: 32),
            ),
            const SizedBox(height: 16),

            Text(
              'Skip Company Setup?',
              style: AppTypography.headlineLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'You can explore the app now and complete your setup later from the Profile section.\n\nSome features may be limited until setup is complete.',
              style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // What will be skipped
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.lightAmber,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.statusAmber.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    const Icon(Icons.info_outline_rounded, color: AppColors.statusAmber, size: 16),
                    const SizedBox(width: 6),
                    Text('What gets skipped:', style: AppTypography.labelMedium.copyWith(color: AppColors.statusAmber)),
                  ]),
                  const SizedBox(height: 8),
                  ..._skipItems.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Icon(Icons.remove_rounded, color: AppColors.neutralGrey, size: 14),
                      const SizedBox(width: 6),
                      Expanded(child: Text(item, style: AppTypography.bodySmall)),
                    ]),
                  )),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // CTA buttons
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // close sheet
                  context.go('/dashboard');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: const Text('Yes, Skip & Enter App', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text('Continue Setup', style: AppTypography.labelMedium.copyWith(color: AppColors.textSecondary)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const _skipItems = [
  'Company PAN & GSTIN verification',
  'Business type & licence mapping',
  'MCA / ROC connection',
  'Team member invitations',
];

// ─── Skip Setup Button (reusable in AppBar actions) ───────────────────────────

class SkipSetupButton extends StatelessWidget {
  const SkipSetupButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => context.go('/dashboard'),
      style: TextButton.styleFrom(
        foregroundColor: AppColors.textSecondary,
        padding: const EdgeInsets.symmetric(horizontal: 12),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Text('Skip', style: AppTypography.labelMedium.copyWith(color: AppColors.textSecondary)),
        const SizedBox(width: 2),
        const Icon(Icons.keyboard_double_arrow_right_rounded, size: 16, color: AppColors.textSecondary),
      ]),
    );
  }
}

// Reusable Setup Step Header
class SetupStepHeader extends StatelessWidget {
  final int step;
  final int totalSteps;
  final String title;
  final String subtitle;

  const SetupStepHeader({
    super.key,
    required this.step,
    required this.totalSteps,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(totalSteps, (i) {
            final isActive = i < step;
            return Expanded(
              child: Container(
                margin: EdgeInsets.only(right: i < totalSteps - 1 ? 4 : 0),
                height: 4,
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primaryBlue : AppColors.borderLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        Text('Step $step of $totalSteps', style: AppTypography.labelSmall.copyWith(color: AppColors.primaryBlue)),
        const SizedBox(height: 16),
        Text(title, style: AppTypography.displayMedium),
        const SizedBox(height: 4),
        Text(subtitle, style: AppTypography.bodyMedium),
        const SizedBox(height: 28),
      ],
    );
  }
}

class SetupPanScreen extends ConsumerStatefulWidget {
  const SetupPanScreen({super.key});
  @override
  ConsumerState<SetupPanScreen> createState() => _SetupPanScreenState();
}

class _SetupPanScreenState extends ConsumerState<SetupPanScreen> {
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
            const SetupStepHeader(step: 1, totalSteps: 6, title: 'Enter PAN Number', subtitle: 'We\'ll fetch your company details automatically'),
            BHTextInput(
              label: 'Company / Business PAN',
              hint: 'AAAPL1234C',
              controller: _controller,
              inputFormatters: const [],
            ),
            const SizedBox(height: 8),
            Text('Enter 10-digit PAN (e.g., AAAPA1234A)', style: AppTypography.labelSmall),
            const SizedBox(height: 24),
            BHButton(
              label: _fetched ? 'Details Fetched ✓' : 'Fetch Company Details',
              isLoading: _isLoading,
              onPressed: () {
                setState(() => _isLoading = true);
                Future.delayed(const Duration(seconds: 1), () {
                  if (mounted) setState(() { _isLoading = false; _fetched = true; });
                });
              },
            ),
            if (_fetched) ...[
              const SizedBox(height: 24),
              _CompanyDetailCard().animate().fadeIn(duration: 400.ms).slideY(begin: 0.3, end: 0),
              const SizedBox(height: 24),
              BHButton(label: 'Continue', onPressed: () {
                ref.read(onboardingProvider.notifier).updatePanInfo(_controller.text.trim(), 'Sharma Trading Pvt. Ltd.', 'Private Limited Company');
                context.go('/setup/gstin');
              }, trailingIcon: Icons.arrow_forward_rounded),
            ],
          ],
        ),
      ),
    );
  }
}

class _CompanyDetailCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.lightGreen,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.statusGreen.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.check_circle_rounded, color: AppColors.statusGreen, size: 18),
            const SizedBox(width: 6),
            Text('Details Found', style: AppTypography.labelLarge.copyWith(color: AppColors.statusGreen)),
          ]),
          const SizedBox(height: 12),
          const _DetailRow(label: 'Company Name', value: 'Sharma Trading Pvt. Ltd.'),
          const _DetailRow(label: 'PAN', value: 'AABCS1234Z'),
          const _DetailRow(label: 'Type', value: 'Private Limited Company'),
          const _DetailRow(label: 'Registered', value: '15-08-2018'),
          const _DetailRow(label: 'Status', value: 'Active'),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow({required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.bodySmall),
          Text(value, style: AppTypography.dataMono.copyWith(fontSize: 12)),
        ],
      ),
    );
  }
}

class SetupGstinScreen extends ConsumerStatefulWidget {
  const SetupGstinScreen({super.key});
  @override
  ConsumerState<SetupGstinScreen> createState() => _SetupGstinScreenState();
}

class _SetupGstinScreenState extends ConsumerState<SetupGstinScreen> {
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
            const SetupStepHeader(step: 2, totalSteps: 6, title: 'Enter GSTIN', subtitle: 'We\'ll verify your GST registration and fetch filing history'),
            BHTextInput(
              label: 'GSTIN',
              hint: '29AABCS1234Z1ZV',
              controller: _controller,
            ),
            const SizedBox(height: 8),
            Row(children: [
              const Icon(Icons.info_outline, size: 14, color: AppColors.primaryBlue),
              const SizedBox(width: 4),
              Expanded(child: Text('15-character GST Identification Number', style: AppTypography.labelSmall)),
            ]),
            const SizedBox(height: 24),
            BHButton(
              label: _fetched ? 'GST Data Fetched ✓' : 'Verify GSTIN',
              isLoading: _isLoading,
              onPressed: () {
                setState(() => _isLoading = true);
                Future.delayed(const Duration(seconds: 1), () {
                  if (mounted) setState(() { _isLoading = false; _fetched = true; });
                });
              },
            ),
            if (_fetched) ...[
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.lightGreen,
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  border: Border.all(color: AppColors.statusGreen.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      const Icon(Icons.verified_rounded, color: AppColors.verifiedTeal, size: 18),
                      const SizedBox(width: 6),
                      Text('GST Verified', style: AppTypography.labelLarge.copyWith(color: AppColors.verifiedTeal)),
                    ]),
                    const SizedBox(height: 12),
                    const _DetailRow(label: 'GSTIN', value: '29AABCS1234Z1ZV'),
                    const _DetailRow(label: 'GST Status', value: 'Active'),
                    const _DetailRow(label: 'Registration Type', value: 'Regular'),
                    const _DetailRow(label: 'Filing Status', value: '24/24 filed'),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms),
              const SizedBox(height: 24),
              BHButton(label: 'Continue', onPressed: () {
                ref.read(onboardingProvider.notifier).updateGstInfo(_controller.text.trim(), 'Active');
                context.go('/setup/business-type');
              }, trailingIcon: Icons.arrow_forward_rounded),
            ],
          ],
        ),
      ),
    );
  }
}
