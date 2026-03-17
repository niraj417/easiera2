import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../widgets/buttons/bh_button.dart';
import '../../widgets/inputs/bh_inputs.dart';
import '../../widgets/navigation/bh_navigation.dart';

class EmailOTPScreen extends StatefulWidget {
  const EmailOTPScreen({super.key});
  @override
  State<EmailOTPScreen> createState() => _EmailOTPScreenState();
}

class _EmailOTPScreenState extends State<EmailOTPScreen> {
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BHAppBar(title: 'Verify Email'),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.lightBlue, borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  const Icon(Icons.email_outlined, color: AppColors.primaryBlue),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('OTP sent to', style: AppTypography.bodySmall),
                      Text('owner@company.com', style: AppTypography.labelLarge.copyWith(color: AppColors.primaryBlue)),
                    ]),
                  ),
                  TextButton(onPressed: () => context.pop(), child: Text('Change', style: AppTypography.labelMedium.copyWith(color: AppColors.primaryBlue))),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text('Enter 6-digit OTP', style: AppTypography.headlineMedium),
            const SizedBox(height: 24),
            BHOTPInput(controllers: _controllers),
            const SizedBox(height: 32),
            BHButton(
              label: 'Verify & Continue',
              isLoading: _isLoading,
              onPressed: () {
                setState(() => _isLoading = true);
                Future.delayed(const Duration(seconds: 1), () {
                  if (mounted) {
                    setState(() => _isLoading = false);
                    context.go('/setup/pan');
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
