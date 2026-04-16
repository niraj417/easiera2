import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../widgets/buttons/bh_button.dart';
import '../../widgets/navigation/bh_navigation.dart';

// Loan Marketplace — extra screens

class NBFCPartnersScreen extends StatelessWidget {
  const NBFCPartnersScreen({super.key});

  final List<Map<String, dynamic>> _partners = const [
    {'name': 'HDFC Bank', 'type': 'Bank', 'max': '₹5 Cr', 'rate': '11.5%', 'color': 0xFF1A5FB4, 'feature': 'Pre-Approved'},
    {'name': 'SBI Business', 'type': 'PSU Bank', 'max': '₹10 Cr', 'rate': '10.75%', 'color': 0xFF22C55E, 'feature': 'MSME Scheme'},
    {'name': 'Axis Bank', 'type': 'Bank', 'max': '₹2 Cr', 'rate': '12%', 'color': 0xFFEF4444, 'feature': 'Fast Approval'},
    {'name': 'SIDBI', 'type': 'DFI', 'max': '₹25 Cr', 'rate': '9.5%', 'color': 0xFF6366F1, 'feature': 'Govt. Subsidy'},
    {'name': 'Lendingkart', 'type': 'NBFC', 'max': '₹1 Cr', 'rate': '18%', 'color': 0xFF0D9488, 'feature': 'Instant Disbursal'},
    {'name': 'Capital Float', 'type': 'NBFC', 'max': '₹50 Lakh', 'rate': '20%', 'color': 0xFFF59E0B, 'feature': 'No Collateral'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BHAppBar(title: 'Lending Partners'),
      backgroundColor: AppColors.surfaceBackground,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(12)),
            child: Row(children: [
              const Icon(Icons.verified_rounded, color: AppColors.goldAccent, size: 24),
              const SizedBox(width: 10),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('6 Verified Lending Partners', style: AppTypography.labelLarge.copyWith(color: Colors.white)),
                Text('All partners are RBI-regulated', style: AppTypography.bodySmall.copyWith(color: Colors.white60)),
              ])),
            ]),
          ),
          const SizedBox(height: 16),
          ..._partners.asMap().entries.map((entry) {
            final i = entry.key;
            final p = entry.value;
            final color = Color(p['color'] as int);
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.card), border: Border.all(color: AppColors.borderLight)),
              child: Column(children: [
                Row(children: [
                  Container(width: 48, height: 48, decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(10)), child: Icon(Icons.account_balance_rounded, color: color, size: 26)),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(p['name'] as String, style: AppTypography.headlineMedium),
                    Container(margin: const EdgeInsets.only(top: 2), padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(6)), child: Text(p['type'] as String, style: AppTypography.labelSmall.copyWith(color: color, fontSize: 10))),
                  ])),
                  Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(gradient: AppColors.greenGradient, borderRadius: BorderRadius.circular(20)), child: Text(p['feature'] as String, style: AppTypography.labelSmall.copyWith(color: Colors.white, fontSize: 10))),
                ]),
                const SizedBox(height: 12),
                Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                  _NBFCStat('Max Loan', p['max'] as String),
                  _NBFCStat('Rate', '${p['rate']} p.a.'),
                ]),
                const SizedBox(height: 10),
                BHButton(label: 'Check Eligibility & Apply', onPressed: () => context.push('/loans/apply'), type: BHButtonType.secondary),
              ]),
            ).animate().fadeIn(delay: Duration(milliseconds: i * 70));
          }),
        ]),
      ),
    );
  }
}

class _NBFCStat extends StatelessWidget {
  final String label, value;
  const _NBFCStat(this.label, this.value);
  @override
  Widget build(BuildContext context) => Column(children: [
    Text(value, style: AppTypography.headlineMedium.copyWith(color: AppColors.primaryBlue, fontWeight: FontWeight.w700)),
    Text(label, style: AppTypography.bodySmall),
  ]);
}

class LoanApplicationStatusScreen extends StatelessWidget {
  const LoanApplicationStatusScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BHAppBar(title: 'Application Status'),
      backgroundColor: AppColors.surfaceBackground,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(16)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('HDFC Business Loan', style: AppTypography.headlineLarge.copyWith(color: Colors.white)),
              Text('Ref: HDFC-2024-98765', style: AppTypography.dataMonoSmall.copyWith(color: Colors.white60)),
              const SizedBox(height: 16),
              const Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                _AppStat('Amount', '₹50L'),
                _AppStat('Interest', '11.5%'),
                _AppStat('Status', 'Reviewing'),
              ]),
            ]),
          ),
          const SizedBox(height: 24),
          Text('Application Progress', style: AppTypography.headlineMedium),
          const SizedBox(height: 16),
          ...[
            {'step': 'Application Submitted', 'date': '15-Mar-2026', 'done': true, 'color': AppColors.statusGreen},
            {'step': 'Documents Verified', 'date': '16-Mar-2026', 'done': true, 'color': AppColors.statusGreen},
            {'step': 'Credit Assessment', 'date': '17-Mar-2026', 'done': false, 'color': AppColors.statusAmber},
            {'step': 'Loan Committee Review', 'date': 'Est. 18-Mar-2026', 'done': false, 'color': AppColors.neutralGrey},
            {'step': 'Approval & Disbursal', 'date': 'Est. 20-Mar-2026', 'done': false, 'color': AppColors.neutralGrey},
          ].asMap().entries.map((entry) {
            final i = entry.key;
            final step = entry.value;
            final isDone = step['done'] as bool;
            final color = step['color'] as Color;
            return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Column(children: [
                Container(width: 28, height: 28, decoration: BoxDecoration(color: isDone ? color : color.withOpacity(0.15), shape: BoxShape.circle), child: Icon(isDone ? Icons.check_rounded : (i == 2 ? Icons.hourglass_top_rounded : Icons.circle_outlined), color: isDone ? Colors.white : color, size: 14)),
                if (i < 4) Container(width: 2, height: 40, color: color.withOpacity(isDone ? 0.7 : 0.2)),
              ]),
              const SizedBox(width: 14),
              Expanded(child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(step['step'] as String, style: AppTypography.labelLarge.copyWith(color: isDone ? AppColors.textPrimary : AppColors.textSecondary)),
                  Text(step['date'] as String, style: AppTypography.bodySmall.copyWith(color: isDone ? color : AppColors.textTertiary)),
                ]),
              )),
            ]);
          }),
          const SizedBox(height: 8),
          BHButton(label: 'Contact Loan Manager', onPressed: () {}, leadingIcon: Icons.headset_mic_rounded, type: BHButtonType.secondary),
        ]),
      ),
    );
  }
}

class _AppStat extends StatelessWidget {
  final String label, value;
  const _AppStat(this.label, this.value);
  @override
  Widget build(BuildContext context) => Column(children: [
    Text(value, style: AppTypography.headlineMedium.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
    Text(label, style: AppTypography.labelSmall.copyWith(color: Colors.white60)),
  ]);
}
