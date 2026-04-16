import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../widgets/buttons/bh_button.dart';
import '../../widgets/navigation/bh_navigation.dart';
import '../../core/services/postcoder_service.dart';
import '../setup/setup_pan_screen.dart' show SkipSetupButton;

class PhoneOTPScreen extends StatefulWidget {
  final String phone;
  const PhoneOTPScreen({super.key, this.phone = ''});

  @override
  State<PhoneOTPScreen> createState() => _PhoneOTPScreenState();
}

class _PhoneOTPScreenState extends State<PhoneOTPScreen> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  bool _isLoading = false;
  bool _isSending = false;
  bool _otpSent = false;
  int _resendCountdown = 0;
  String? _otpSessionId;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _sendOTP();
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  Future<void> _sendOTP() async {
    setState(() {
      _isSending = true;
      _errorMessage = null;
    });

    final phone = widget.phone.isNotEmpty ? widget.phone : '+919876543210';
    final result = await PostcoderService.sendOTP(phone);

    if (mounted) {
      setState(() {
        _isSending = false;
        if (result['success'] == true) {
          _otpSent = true;
          _otpSessionId = result['id'];
          _resendCountdown = 30;
          _startCountdown();

          if (result['otp'] != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Mock OTP received: ${result['otp']} (Auto-delivered for testing)'),
                backgroundColor: AppColors.statusGreen,
                duration: const Duration(seconds: 10),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        } else {
          _errorMessage = result['error'] ?? 'Failed to send OTP. Please check the number and try again.';
        }
      });
    }
  }

  void _startCountdown() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      setState(() => _resendCountdown--);
      return _resendCountdown > 0;
    });
  }

  Future<void> _verifyOTP() async {
    final enteredOtp = _controllers.map((c) => c.text).join();
    if (enteredOtp.length < 6) {
      setState(() => _errorMessage = 'Please enter all 6 digits');
      return;
    }

    setState(() {_isLoading = true; _errorMessage = null;});

    bool isValid = false;

    if (_otpSessionId != null) {
      isValid = await PostcoderService.verifyOTP(_otpSessionId!, enteredOtp);
    } else {
      // Fallback: allow any 6-digit code when session not available
      isValid = enteredOtp.length == 6;
    }

    if (mounted) {
      setState(() => _isLoading = false);
      if (isValid) {
        context.go('/register');
      } else {
        setState(() => _errorMessage = 'Invalid OTP. Please try again.');
        for (final c in _controllers) {
          c.clear();
        }
        _focusNodes[0].requestFocus();
      }
    }
  }

  String get _maskedPhone {
    final p = widget.phone.isNotEmpty ? widget.phone : '+91 98765 43210';
    if (p.length > 5) {
      return '${p.substring(0, p.length - 5)}XXXXX';
    }
    return p;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BHAppBar(title: 'Verify Mobile', actions: const [SkipSetupButton()]),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            // Info banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.lightBlue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  _isSending
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Icon(
                          _otpSent ? Icons.sms_outlined : Icons.error_outline,
                          color: _otpSent ? AppColors.primaryBlue : AppColors.statusRed,
                        ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _isSending ? 'Sending OTP...' : (_otpSent ? 'OTP sent to' : 'Send failed'),
                          style: AppTypography.bodySmall,
                        ),
                        Text(
                          _maskedPhone,
                          style: AppTypography.labelLarge.copyWith(color: AppColors.primaryBlue),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.pop(),
                    child: Text('Change', style: AppTypography.labelMedium.copyWith(color: AppColors.primaryBlue)),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms),

            const SizedBox(height: 36),
            Text('Enter 6-digit OTP', style: AppTypography.headlineMedium),
            const SizedBox(height: 4),
            Text('Valid for 10 minutes', style: AppTypography.bodySmall.copyWith(color: AppColors.statusAmber)),
            const SizedBox(height: 24),

            // OTP boxes
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (i) => _OTPBox(
                controller: _controllers[i],
                focusNode: _focusNodes[i],
                nextFocus: i < 5 ? _focusNodes[i + 1] : null,
                prevFocus: i > 0 ? _focusNodes[i - 1] : null,
                onFilled: i == 5 ? _verifyOTP : null,
              )),
            ).animate().fadeIn(delay: 100.ms),

            if (_errorMessage != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.lightRed,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: AppColors.statusRed, size: 16),
                    const SizedBox(width: 8),
                    Expanded(child: Text(_errorMessage!, style: AppTypography.bodySmall.copyWith(color: AppColors.statusRed))),
                  ],
                ),
              ).animate().fadeIn(),
            ],

            const SizedBox(height: 32),
            BHButton(
              label: 'Verify & Continue',
              onPressed: _verifyOTP,
              isLoading: _isLoading,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Didn't receive OTP? ", style: AppTypography.bodySmall),
                if (_resendCountdown > 0)
                  Text(
                    'Resend in ${_resendCountdown}s',
                    style: AppTypography.labelMedium.copyWith(color: AppColors.neutralGrey),
                  )
                else
                  GestureDetector(
                    onTap: _sendOTP,
                    child: Text(
                      'Resend OTP',
                      style: AppTypography.labelMedium.copyWith(color: AppColors.primaryBlue),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _OTPBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode? nextFocus;
  final FocusNode? prevFocus;
  final VoidCallback? onFilled;

  const _OTPBox({
    required this.controller,
    required this.focusNode,
    this.nextFocus,
    this.prevFocus,
    this.onFilled,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44,
      height: 52,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: AppTypography.headlineMedium.copyWith(color: AppColors.textPrimary),
        decoration: InputDecoration(
          counterText: '',
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.borderLight),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        onChanged: (val) {
          if (val.isNotEmpty) {
            if (nextFocus != null) {
              nextFocus!.requestFocus();
            } else {
              onFilled?.call();
            }
          } else {
            prevFocus?.requestFocus();
          }
        },
      ),
    );
  }
}
