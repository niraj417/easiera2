import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../widgets/buttons/bh_button.dart';
import '../../widgets/navigation/bh_navigation.dart';

class ComplianceIntegrationScreen extends StatefulWidget {
  final String complianceType;

  const ComplianceIntegrationScreen({
    super.key,
    required this.complianceType,
  });

  @override
  State<ComplianceIntegrationScreen> createState() => _ComplianceIntegrationScreenState();
}

class _ComplianceIntegrationScreenState extends State<ComplianceIntegrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  bool _isLoading = false;

  String get _title {
    switch (widget.complianceType.toUpperCase()) {
      case 'FSSAI':
        return 'FSSAI Integration';
      case 'ROC':
        return 'ROC (MCA) Integration';
      case 'GST':
        return 'GST Integration';
      default:
        return 'Compliance Integration';
    }
  }

  String get _label {
    switch (widget.complianceType.toUpperCase()) {
      case 'FSSAI':
        return 'FSSAI License Number';
      case 'ROC':
        return 'Corporate Identity Number (CIN)';
      case 'GST':
        return 'GST Identification Number (GSTIN)';
      default:
        return 'Registration Number';
    }
  }

  String get _hint {
    switch (widget.complianceType.toUpperCase()) {
      case 'FSSAI':
        return '14-digit license number';
      case 'ROC':
        return '21-character CIN';
      case 'GST':
        return '15-character GSTIN';
      default:
        return 'Enter number';
    }
  }

  String? _validator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the identifier';
    }
    
    final type = widget.complianceType.toUpperCase();
    if (type == 'FSSAI') {
      if (value.length != 14 || !RegExp(r'^[0-9]+$').hasMatch(value)) {
        return 'FSSAI Number must be 14 digits';
      }
    } else if (type == 'ROC') {
      if (value.length != 21) {
        return 'CIN must be exactly 21 characters';
      }
    } else if (type == 'GST') {
      if (value.length != 15) {
        return 'GSTIN must be exactly 15 characters';
      }
      final gstRegex = RegExp(r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$');
      if (!gstRegex.hasMatch(value.toUpperCase())) {
        return 'Enter a valid GSTIN format';
      }
    }
    return null;
  }

  Future<void> _handleConnect() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) {
        setState(() => _isLoading = false);
        
        // Show success
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle_rounded, color: Colors.white),
                const SizedBox(width: 12),
                Text('${widget.complianceType.toUpperCase()} connected successfully!'),
              ],
            ),
            backgroundColor: AppColors.statusGreen,
            behavior: SnackBarBehavior.floating,
          ),
        );
        
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceBackground,
      appBar: BHAppBar(title: _title),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Info Card
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.lightBlue.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primaryBlue.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline_rounded, color: AppColors.primaryBlue),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Connecting your ${widget.complianceType.toUpperCase()} account allows BizHealth360 to automatically sync your filing status and metadata.',
                        style: AppTypography.bodySmall.copyWith(color: AppColors.primaryBlue),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
              Text('Integration Details', style: AppTypography.headlineMedium),
              const SizedBox(height: 8),
              Text(
                'Enter your official credentials registered with the department.',
                style: AppTypography.bodySmall,
              ),
              const SizedBox(height: 24),
              
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_label, style: AppTypography.labelLarge),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _idController,
                      style: AppTypography.bodyLarge,
                      decoration: InputDecoration(
                        hintText: _hint,
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.borderLight),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.borderLight),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
                        ),
                      ),
                      validator: _validator,
                      textCapitalization: TextCapitalization.characters,
                    ),
                    const SizedBox(height: 40),
                    
                    BHButton(
                      label: 'Verify & Connect',
                      isLoading: _isLoading,
                      onPressed: _handleConnect,
                      leadingIcon: Icons.link_rounded,
                    ),
                    
                    const SizedBox(height: 24),
                    Center(
                      child: TextButton(
                        onPressed: () => context.pop(),
                        child: Text(
                          'Cancel',
                          style: AppTypography.labelLarge.copyWith(color: AppColors.neutralGrey),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
