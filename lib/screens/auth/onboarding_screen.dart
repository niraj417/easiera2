import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../widgets/buttons/bh_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<_OnboardingData> _pages = [
    const _OnboardingData(
      icon: Icons.task_alt_rounded,
      iconColor: AppColors.primaryBlue,
      title: 'Virtual Compliance\nOfficer',
      description: 'Never miss a GST filing, licence renewal, or tax deadline again. Get real-time alerts for all 30+ compliances.',
      gradient: [AppColors.lightBlue, Colors.white],
    ),
    const _OnboardingData(
      icon: Icons.monitor_heart_rounded,
      iconColor: AppColors.verifiedTeal,
      title: 'Business Health\nScore (BizScore)',
      description: 'Know your company\'s financial fitness across 6 dimensions — from cashflow to growth, rated AAA to C.',
      gradient: [AppColors.lightTeal, Colors.white],
    ),
    const _OnboardingData(
      icon: Icons.psychology_rounded,
      iconColor: AppColors.goldAccent,
      title: 'AI Growth\nAdvisor',
      description: 'Get personalised financial insights, risk alerts, and loan offers matched to your business health profile.',
      gradient: [AppColors.lightGold, Colors.white],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: TextButton(
                  onPressed: () => context.go('/login'),
                  child: Text('Skip', style: AppTypography.labelMedium.copyWith(color: AppColors.primaryBlue)),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: page.gradient,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(page.icon, color: page.iconColor, size: 72),
                        ).animate(key: ValueKey(index)).scale(duration: 500.ms, curve: Curves.elasticOut),
                        const SizedBox(height: 40),
                        Text(
                          page.title,
                          style: AppTypography.displayMedium.copyWith(fontWeight: FontWeight.w700),
                          textAlign: TextAlign.center,
                        ).animate(key: ValueKey('t$index')).fadeIn(duration: 400.ms).slideY(begin: 0.3, end: 0),
                        const SizedBox(height: 16),
                        Text(
                          page.description,
                          style: AppTypography.bodyMedium,
                          textAlign: TextAlign.center,
                        ).animate(key: ValueKey('d$index')).fadeIn(delay: 150.ms, duration: 400.ms),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_pages.length, (i) {
                      return AnimatedContainer(
                        duration: 300.ms,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == i ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == i ? AppColors.primaryBlue : AppColors.borderLight,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 32),
                  if (_currentPage < _pages.length - 1)
                    BHButton(
                      label: 'Next',
                      onPressed: () => _controller.nextPage(
                        duration: 300.ms,
                        curve: Curves.easeInOut,
                      ),
                      trailingIcon: Icons.arrow_forward_rounded,
                    )
                  else
                    BHButton(
                      label: 'Get Started',
                      onPressed: () => context.go('/login'),
                      trailingIcon: Icons.arrow_forward_rounded,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingData {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;
  final List<Color> gradient;

  const _OnboardingData({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
    required this.gradient,
  });
}
