import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../widgets/buttons/bh_button.dart';
import '../../widgets/inputs/bh_inputs.dart';
import '../../widgets/navigation/bh_navigation.dart';

class ForgotAccessScreen extends StatefulWidget {
  const ForgotAccessScreen({super.key});
  @override
  State<ForgotAccessScreen> createState() => _ForgotAccessScreenState();
}

class _ForgotAccessScreenState extends State<ForgotAccessScreen> {
  final _controller = TextEditingController();
  bool _sent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BHAppBar(title: 'Recover Access'),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: _sent ? _SuccessView(onBack: () => context.go('/login')) : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Icon(Icons.lock_reset_rounded, color: AppColors.primaryBlue, size: 48),
            const SizedBox(height: 20),
            Text('Forgot Access?', style: AppTypography.displayMedium),
            const SizedBox(height: 8),
            Text('Enter your registered mobile or email. We\'ll help you recover access.', style: AppTypography.bodyMedium),
            const SizedBox(height: 32),
            BHTextInput(label: 'Mobile or Email', hint: '+91 98765 43210 or email@company.com', controller: _controller),
            const SizedBox(height: 24),
            BHButton(label: 'Send Recovery OTP', onPressed: () => setState(() => _sent = true)),
            const SizedBox(height: 20),
            Center(child: TextButton(onPressed: () => context.go('/login'), child: Text('Back to Login', style: AppTypography.labelMedium.copyWith(color: AppColors.primaryBlue)))),
          ],
        ),
      ),
    );
  }
}

class _SuccessView extends StatelessWidget {
  final VoidCallback onBack;
  const _SuccessView({required this.onBack});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80, height: 80,
            decoration: const BoxDecoration(color: AppColors.lightGreen, shape: BoxShape.circle),
            child: const Icon(Icons.check_circle_rounded, color: AppColors.statusGreen, size: 44),
          ),
          const SizedBox(height: 20),
          Text('OTP Sent!', style: AppTypography.displayMedium),
          const SizedBox(height: 8),
          Text('Check your mobile/email for recovery OTP', style: AppTypography.bodyMedium, textAlign: TextAlign.center),
          const SizedBox(height: 32),
          BHButton(label: 'Back to Login', onPressed: onBack, type: BHButtonType.secondary),
        ],
      ),
    );
  }
}
