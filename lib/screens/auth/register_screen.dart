import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../widgets/buttons/bh_button.dart';
import '../../widgets/inputs/bh_inputs.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/onboarding_provider.dart';

/// Step 2 in the registration flow:
/// After OTP verification → personal info → company PAN setup
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _cityController = TextEditingController();
  final _pinController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? _selectedRole;
  DateTime? _dateOfBirth;
  bool _isLoading = false;

  static const List<String> _roles = [
    'Partner',
    'Proprietor',
    'Director',
    'Manager',
    'Executive',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _cityController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _pickDOB() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 25),
      firstDate: DateTime(1950),
      lastDate: DateTime(now.year - 18),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryBlue,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _dateOfBirth = picked);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedRole == null) {
      _showError('Please select your role');
      return;
    }
    if (_dateOfBirth == null) {
      _showError('Please enter your date of birth');
      return;
    }

    setState(() => _isLoading = true);
    
    // Save to global onboarding state
    ref.read(onboardingProvider.notifier).updatePersonalInfo(
      fullName: _nameController.text.trim(),
      mobile: _mobileController.text.trim(),
      email: _emailController.text.trim(),
      role: _selectedRole!,
      dob: _dateOfBirth!.toIso8601String(),
      city: _cityController.text.trim(),
      pinCode: _pinController.text.trim(),
    );

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() => _isLoading = false);
        context.go('/setup/pan');
      }
    });
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: AppColors.statusRed,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceBackground,
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 56, 24, 24),
            decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 16),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text('Step 1 of 4', style: AppTypography.labelSmall.copyWith(color: Colors.white70)),
                    ),
                  ],
                ).animate().fadeIn(duration: 400.ms),
                const SizedBox(height: 20),
                Text('Personal Information', style: AppTypography.displayMedium.copyWith(color: Colors.white)).animate().fadeIn(delay: 100.ms),
                const SizedBox(height: 4),
                Text('Tell us about yourself to get started', style: AppTypography.bodyMedium.copyWith(color: Colors.white70)).animate().fadeIn(delay: 200.ms),
              ],
            ),
          ),

          // Form
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xxl),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Progress bar
                        Row(
                          children: List.generate(4, (i) => Expanded(
                            child: Container(
                              margin: EdgeInsets.only(right: i < 3 ? 6 : 0),
                              height: 4,
                              decoration: BoxDecoration(
                                color: i == 0 ? AppColors.primaryBlue : AppColors.borderLight,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          )),
                        ),
                        const SizedBox(height: 28),

                        // Full Name
                        BHTextInput(
                          label: 'Full Name *',
                          hint: 'Rajesh Kumar Sharma',
                          controller: _nameController,
                          validator: (v) => (v == null || v.trim().isEmpty) ? 'Name is required' : null,
                        ),
                        const SizedBox(height: 16),

                        // Mobile
                        BHPhoneInput(controller: _mobileController),
                        const SizedBox(height: 8),
                        Text('Enter if registered via email', style: AppTypography.labelSmall),
                        const SizedBox(height: 16),

                        // Email
                        BHTextInput(
                          label: 'Email Address',
                          hint: 'you@company.com',
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 8),
                        Text('Enter if registered via mobile', style: AppTypography.labelSmall),
                        const SizedBox(height: 16),

                        // Role dropdown
                        Text('Your Role *', style: AppTypography.labelMedium),
                        const SizedBox(height: 6),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.borderLight),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedRole,
                              hint: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 14),
                                child: Text('Select your role', style: AppTypography.bodyMedium.copyWith(color: AppColors.textTertiary)),
                              ),
                              onChanged: (v) => setState(() => _selectedRole = v),
                              isExpanded: true,
                              borderRadius: BorderRadius.circular(10),
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              items: _roles.map((r) => DropdownMenuItem(
                                value: r,
                                child: Text(r, style: AppTypography.bodyMedium),
                              )).toList(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Date of Birth
                        Text('Date of Birth *', style: AppTypography.labelMedium),
                        const SizedBox(height: 6),
                        GestureDetector(
                          onTap: _pickDOB,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.borderLight),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today_outlined, color: AppColors.neutralGrey, size: 18),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    _dateOfBirth != null
                                        ? '${_dateOfBirth!.day.toString().padLeft(2, '0')}-${_dateOfBirth!.month.toString().padLeft(2, '0')}-${_dateOfBirth!.year}'
                                        : 'DD-MM-YYYY',
                                    style: _dateOfBirth != null
                                        ? AppTypography.bodyMedium
                                        : AppTypography.bodyMedium.copyWith(color: AppColors.textTertiary),
                                  ),
                                ),
                                const Icon(Icons.arrow_drop_down, color: AppColors.neutralGrey),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Location
                        Text('Location', style: AppTypography.labelMedium),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: BHTextInput(
                                label: '',
                                hint: 'City (e.g., Mumbai)',
                                controller: _cityController,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 2,
                              child: BHTextInput(
                                label: '',
                                hint: 'PIN Code',
                                controller: _pinController,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        BHButton(
                          label: 'Continue to Company Info',
                          onPressed: _submit,
                          isLoading: _isLoading,
                          trailingIcon: Icons.arrow_forward_rounded,
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: Text(
                            'Your information is secure and encrypted',
                            style: AppTypography.labelSmall.copyWith(color: AppColors.neutralGrey),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
