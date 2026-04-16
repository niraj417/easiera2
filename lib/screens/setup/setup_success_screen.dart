import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../widgets/buttons/bh_button.dart';

class SetupSuccessScreen extends StatelessWidget {
  const SetupSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            child: Column(
              children: [
                const SizedBox(height: 32),
                // Success icon
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.goldAccent,
                    size: 60,
                  ),
                ).animate().scale(begin: const Offset(0, 0), duration: 600.ms, curve: Curves.elasticOut),

                const SizedBox(height: 24),
                Text(
                  'Setup Complete! 🎉',
                  style: AppTypography.displayLarge.copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 300.ms),

                const SizedBox(height: 8),
                Text(
                  'Your business profile has been created.\nYour Business Health Score is being calculated.',
                  style: AppTypography.bodyMedium.copyWith(color: Colors.white70),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 400.ms),

                const SizedBox(height: 36),

                // pending summary card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Compliance Summary',
                        style: AppTypography.headlineMedium.copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      const _SummaryRow('Compliances Completed', '6', Icons.check_circle_rounded, AppColors.statusGreen),
                      const _SummaryRow('Pending Actions', '3', Icons.pending_outlined, AppColors.statusAmber),
                      const _SummaryRow('Optional (Skipped)', '2', Icons.info_outline_rounded, Colors.white54),
                    ],
                  ),
                ).animate().fadeIn(delay: 500.ms),

                const SizedBox(height: 24),

                // Pending notice
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.statusAmber.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.statusAmber.withOpacity(0.4)),
                  ),
                  child: Row(children: [
                    const Icon(Icons.notifications_active_outlined, color: AppColors.goldAccent, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'You have 3 pending compliance items. We will send you reminders so you don\'t miss deadlines.',
                        style: AppTypography.bodySmall.copyWith(color: Colors.white70),
                      ),
                    ),
                  ]),
                ).animate().fadeIn(delay: 600.ms),

                const SizedBox(height: 40),

                BHButton(
                  label: 'Go to Dashboard',
                  onPressed: () => context.go('/dashboard'),
                  trailingIcon: Icons.arrow_forward_rounded,
                ).animate().fadeIn(delay: 700.ms),

                const SizedBox(height: 12),

                TextButton(
                  onPressed: () => context.go('/health'),
                  child: Text(
                    'View Business Health Score →',
                    style: AppTypography.labelMedium.copyWith(color: Colors.white70),
                  ),
                ).animate().fadeIn(delay: 800.ms),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryRow(this.label, this.value, this.icon, this.color);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 10),
        Expanded(child: Text(label, style: AppTypography.bodyMedium.copyWith(color: Colors.white70))),
        Text(value, style: AppTypography.headlineMedium.copyWith(color: color)),
      ]),
    );
  }
}
