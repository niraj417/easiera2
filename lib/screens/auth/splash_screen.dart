import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryNavy,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryNavy,
              AppColors.primaryBlue,
              AppColors.surfaceBackground,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: const DecorationImage(
                          image: AssetImage('assets/images/logo.png'),
                          fit: BoxFit.cover,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                    ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack).fadeIn(),
                    const SizedBox(height: 24),
                    Text(
                      'BizHealth360',
                      style: AppTypography.displayMedium.copyWith(
                        color: Colors.white,
                        letterSpacing: -1,
                      ),
                    ).animate().slideY(begin: 0.3, duration: 600.ms).fadeIn(),
                    const SizedBox(height: 8),
                    Text(
                      'AI-Powered Compliance & Business Health',
                      style: AppTypography.bodyMedium.copyWith(
                        color: Colors.white.withOpacity(0.7),
                      ),
                      textAlign: TextAlign.center,
                    ).animate().fadeIn(delay: 500.ms, duration: 600.ms),
                  ],
                ),
              ),
              const Spacer(),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withOpacity(0.2)),
                        ),
                        child: Text('India First 🇮🇳', style: AppTypography.labelSmall.copyWith(color: Colors.white)),
                      ),
                    ],
                  ).animate().fadeIn(delay: 700.ms),
                  const SizedBox(height: 32),
                  const CircularProgressIndicator(
                    color: AppColors.goldAccent,
                    strokeWidth: 2,
                  ).animate().fadeIn(delay: 800.ms),
                  const SizedBox(height: 32),
                  Text(
                    'By Easiera .',
                    style: AppTypography.labelSmall.copyWith(
                      color: Colors.white.withOpacity(0.6),
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ).animate().fadeIn(delay: 900.ms),
                  const SizedBox(height: 24),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
