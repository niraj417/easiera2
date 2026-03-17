import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../widgets/buttons/bh_button.dart';
import '../../widgets/inputs/bh_inputs.dart';
import '../../widgets/navigation/bh_navigation.dart';

class PhoneOTPScreen extends StatefulWidget {
  const PhoneOTPScreen({super.key});
  @override
  State<PhoneOTPScreen> createState() => _PhoneOTPScreenState();
}

class _PhoneOTPScreenState extends State<PhoneOTPScreen> {
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  bool _isLoading = false;
  int _resendCountdown = 30;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() async {
    while (_resendCountdown > 0) {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) setState(() => _resendCountdown--);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BHAppBar(title: 'Verify Mobile'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.lightBlue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.sms_outlined, color: AppColors.primaryBlue),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('OTP sent to', style: AppTypography.bodySmall),
                        Text('+91 98765 43210', style: AppTypography.labelLarge.copyWith(color: AppColors.primaryBlue)),
                      ],
                    ),
                  ),
                  TextButton(onPressed: () => context.pop(), child: Text('Change', style: AppTypography.labelMedium.copyWith(color: AppColors.primaryBlue))),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms),
            const SizedBox(height: 36),
            Text('Enter 6-digit OTP', style: AppTypography.headlineMedium),
            const SizedBox(height: 8),
            Text('Valid for 10 minutes', style: AppTypography.bodySmall.copyWith(color: AppColors.statusAmber)),
            const SizedBox(height: 24),
            BHOTPInput(controllers: _controllers),
            const SizedBox(height: 32),
            BHButton(
              label: 'Verify & Continue',
              onPressed: () {
                setState(() => _isLoading = true);
                Future.delayed(const Duration(seconds: 1), () {
                  if (mounted) {
                    setState(() => _isLoading = false);
                    context.go('/setup/pan');
                  }
                });
              },
              isLoading: _isLoading,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Didn't receive OTP? ", style: AppTypography.bodySmall),
                if (_resendCountdown > 0)
                  Text('Resend in ${_resendCountdown}s', style: AppTypography.labelMedium.copyWith(color: AppColors.neutralGrey))
                else
                  GestureDetector(
                    onTap: () => setState(() => _resendCountdown = 30),
                    child: Text('Resend OTP', style: AppTypography.labelMedium.copyWith(color: AppColors.primaryBlue)),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
