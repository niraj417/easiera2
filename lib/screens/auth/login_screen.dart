import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../widgets/buttons/bh_button.dart';
import '../../widgets/inputs/bh_inputs.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _disclaimerShown = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _showDisclaimer());
  }

  @override
  void dispose() {
    _tabController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _showDisclaimer() {
    if (_disclaimerShown) return;
    _disclaimerShown = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const _DisclaimerDialog(),
    );
  }

  void _sendPhoneOTP() {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Please enter mobile number'), backgroundColor: AppColors.statusRed, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
      );
      return;
    }
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() => _isLoading = false);
        context.push('/otp/phone', extra: phone);
      }
    });
  }

  void _sendEmailOTP() {
    final email = _emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Please enter a valid email'), backgroundColor: AppColors.statusRed, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
      );
      return;
    }
    context.push('/otp/email', extra: email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 60, 24, 32),
              decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.monitor_heart_rounded, color: AppColors.goldAccent, size: 22),
                      ),
                      const SizedBox(width: 10),
                      Text('BizHealth360', style: AppTypography.headlineLarge.copyWith(color: Colors.white)),
                    ],
                  ).animate().fadeIn(duration: 500.ms),
                  const SizedBox(height: 24),
                  Text('Welcome Back', style: AppTypography.displayMedium.copyWith(color: Colors.white)).animate().fadeIn(delay: 100.ms),
                  const SizedBox(height: 4),
                  Text('Sign in to manage your business health', style: AppTypography.bodyMedium.copyWith(color: Colors.white.withOpacity(0.7))).animate().fadeIn(delay: 200.ms),
                ],
              ),
            ),

            // Form card
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xxl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TabBar(
                      controller: _tabController,
                      tabs: const [Tab(text: 'Mobile OTP'), Tab(text: 'Email OTP')],
                      labelStyle: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.w600),
                      unselectedLabelStyle: AppTypography.labelLarge,
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      height: 180,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          // Phone tab
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BHPhoneInput(controller: _phoneController),
                              const SizedBox(height: 8),
                              Text("We'll send a 6-digit OTP via SMS", style: AppTypography.bodySmall),
                              const SizedBox(height: 24),
                              BHButton(label: 'Send OTP', onPressed: _sendPhoneOTP, isLoading: _isLoading),
                            ],
                          ),
                          // Email tab
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BHTextInput(
                                label: 'Email Address',
                                hint: 'you@company.com',
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                              ),
                              const SizedBox(height: 8),
                              Text("We'll send a 6-digit OTP to your inbox", style: AppTypography.bodySmall),
                              const SizedBox(height: 24),
                              BHButton(label: 'Send OTP', onPressed: _sendEmailOTP),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () => context.push('/forgot-access'),
                          child: Text('Forgot Access?', style: AppTypography.labelMedium.copyWith(color: AppColors.primaryBlue)),
                        ),
                        TextButton(
                          onPressed: () {
                            _tabController.index == 0 ? _sendPhoneOTP() : _sendEmailOTP();
                          },
                          child: Text('New? Register →', style: AppTypography.labelMedium.copyWith(color: AppColors.primaryBlue, fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),
                    Row(children: [
                      const Expanded(child: Divider(color: AppColors.borderLight)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text('or continue as', style: AppTypography.bodySmall),
                      ),
                      const Expanded(child: Divider(color: AppColors.borderLight)),
                    ]),
                    const SizedBox(height: 16),
                    _SocialButton(
                      label: 'CA / Expert Login',
                      icon: Icons.account_balance_wallet_rounded,
                      onTap: () => context.go('/ca'),
                    ),
                    const SizedBox(height: 32),
                    Center(
                      child: Text(
                        "By continuing, you agree to BizHealth360's Terms & Privacy Policy",
                        style: AppTypography.labelSmall,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Disclaimer Dialog ────────────────────────────────────────────────────────

class _DisclaimerDialog extends StatelessWidget {
  const _DisclaimerDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.info_outline_rounded, color: AppColors.goldAccent, size: 26),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Important Disclaimer',
                    style: AppTypography.headlineLarge.copyWith(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Content
            const Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _DisclaimerPoint(
                      icon: Icons.analytics_outlined,
                      color: AppColors.primaryBlue,
                      text: 'This platform provides an AI-based Business Health Score and advisory insights for informational and internal business assessment purposes only.',
                    ),
                    SizedBox(height: 12),
                    _DisclaimerPoint(
                      icon: Icons.gavel_outlined,
                      color: AppColors.statusAmber,
                      text: 'It is NOT a government-approved rating, credit rating, or financial advice, and is NOT issued or regulated by RBI, SEBI, or any statutory authority.',
                    ),
                    SizedBox(height: 12),
                    _DisclaimerPoint(
                      icon: Icons.warning_amber_outlined,
                      color: AppColors.statusRed,
                      text: 'The outputs are based on user-provided data and third-party integrations. Verify information or consult qualified professionals before making any financial or business decisions.',
                    ),
                  ],
                ),
              ),
            ),

            // Action button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text('I Understand & Proceed', style: AppTypography.labelLarge.copyWith(color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().scale(begin: const Offset(0.8, 0.8), duration: 300.ms, curve: Curves.easeOut);
  }
}

class _DisclaimerPoint extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;

  const _DisclaimerPoint({required this.icon, required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(text, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, height: 1.5)),
        ),
      ],
    );
  }
}

// ─── Social Button ─────────────────────────────────────────────────────────

class _SocialButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _SocialButton({required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.borderLight),
          borderRadius: BorderRadius.circular(8),
          color: AppColors.surfaceBackground,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: AppColors.primaryBlue),
            const SizedBox(width: 8),
            Text(label, style: AppTypography.labelLarge.copyWith(color: AppColors.primaryBlue)),
          ],
        ),
      ),
    );
  }
}
