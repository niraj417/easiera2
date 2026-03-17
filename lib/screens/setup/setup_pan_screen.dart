import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../widgets/buttons/bh_button.dart';
import '../../widgets/inputs/bh_inputs.dart';
import '../../widgets/navigation/bh_navigation.dart';

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
            final isCurrent = i == step - 1;
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

class SetupPanScreen extends StatefulWidget {
  const SetupPanScreen({super.key});
  @override
  State<SetupPanScreen> createState() => _SetupPanScreenState();
}

class _SetupPanScreenState extends State<SetupPanScreen> {
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
            SetupStepHeader(step: 1, totalSteps: 6, title: 'Enter PAN Number', subtitle: 'We\'ll fetch your company details automatically'),
            BHTextInput(
              label: 'Company / Business PAN',
              hint: 'AAAPL1234C',
              controller: _controller,
              inputFormatters: [],
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
              BHButton(label: 'Continue', onPressed: () => context.go('/setup/gstin'), trailingIcon: Icons.arrow_forward_rounded),
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
          _DetailRow(label: 'Company Name', value: 'Sharma Trading Pvt. Ltd.'),
          _DetailRow(label: 'PAN', value: 'AABCS1234Z'),
          _DetailRow(label: 'Type', value: 'Private Limited Company'),
          _DetailRow(label: 'Registered', value: '15-08-2018'),
          _DetailRow(label: 'Status', value: 'Active'),
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

class SetupGstinScreen extends StatefulWidget {
  const SetupGstinScreen({super.key});
  @override
  State<SetupGstinScreen> createState() => _SetupGstinScreenState();
}

class _SetupGstinScreenState extends State<SetupGstinScreen> {
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
            SetupStepHeader(step: 2, totalSteps: 6, title: 'Enter GSTIN', subtitle: 'We\'ll verify your GST registration and fetch filing history'),
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
                    _DetailRow(label: 'GSTIN', value: '29AABCS1234Z1ZV'),
                    _DetailRow(label: 'GST Status', value: 'Active'),
                    _DetailRow(label: 'Registration Type', value: 'Regular'),
                    _DetailRow(label: 'Filing Status', value: '24/24 filed'),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms),
              const SizedBox(height: 24),
              BHButton(label: 'Continue', onPressed: () => context.go('/setup/business-type'), trailingIcon: Icons.arrow_forward_rounded),
            ],
          ],
        ),
      ),
    );
  }
}
