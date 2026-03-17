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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
                  Text('Welcome back', style: AppTypography.displayMedium.copyWith(color: Colors.white)).animate().fadeIn(delay: 100.ms),
                  const SizedBox(height: 4),
                  Text('Sign in to manage your compliance', style: AppTypography.bodyMedium.copyWith(color: Colors.white.withOpacity(0.7))).animate().fadeIn(delay: 200.ms),
                ],
              ),
            ),
            // Form
            Container(
              color: AppColors.surfaceBackground,
              child: Container(
                margin: const EdgeInsets.all(0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
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
                        height: 240,
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            Column(
                              children: [
                                BHPhoneInput(controller: _phoneController),
                                const SizedBox(height: 8),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text('We\'ll send a 6-digit OTP to this number', style: AppTypography.bodySmall),
                                ),
                                const SizedBox(height: 24),
                                BHButton(
                                  label: 'Send OTP',
                                  onPressed: () => context.push('/phone-otp'),
                                  isLoading: _isLoading,
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                BHTextInput(
                                  label: 'Email Address',
                                  hint: 'you@company.com',
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                const SizedBox(height: 24),
                                BHButton(
                                  label: 'Send OTP',
                                  onPressed: () => context.push('/email-otp'),
                                ),
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
                            onPressed: () => context.go('/setup/pan'),
                            child: Text('New? Register →', style: AppTypography.labelMedium.copyWith(color: AppColors.primaryBlue, fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(children: [
                        Expanded(child: Divider(color: AppColors.borderLight)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text('or continue as', style: AppTypography.bodySmall),
                        ),
                        Expanded(child: Divider(color: AppColors.borderLight)),
                      ]),
                      const SizedBox(height: 16),
                      Row(children: [
                        Expanded(child: _SocialButton(label: 'CA Login', icon: Icons.account_balance_wallet_rounded, onTap: () => context.go('/ca-portal'))),
                      ]),
                      const SizedBox(height: 32),
                      Center(child: Text('By continuing, you agree to BizHealth360\'s Terms & Privacy Policy', style: AppTypography.labelSmall, textAlign: TextAlign.center)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
