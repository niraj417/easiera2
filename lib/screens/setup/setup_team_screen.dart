import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../widgets/buttons/bh_button.dart';
import '../../widgets/inputs/bh_inputs.dart';
import '../../widgets/navigation/bh_navigation.dart';
import 'setup_pan_screen.dart' show SetupStepHeader;

class SetupTeamScreen extends StatefulWidget {
  const SetupTeamScreen({super.key});
  @override
  State<SetupTeamScreen> createState() => _SetupTeamScreenState();
}

class _SetupTeamScreenState extends State<SetupTeamScreen> {
  final List<_TeamInvite> _invites = [
    _TeamInvite(email: '', role: 'Manager'),
  ];

  final _roles = ['Admin', 'Manager', 'Viewer', 'CA'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BHAppBar(title: 'Company Setup'),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SetupStepHeader(step: 6, totalSteps: 6, title: 'Invite Your Team', subtitle: 'Invite team members to collaborate on compliance'),
                  ..._invites.asMap().entries.map((e) {
                    final i = e.key;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.card), border: Border.all(color: AppColors.borderLight)),
                      child: Column(
                        children: [
                          BHTextInput(label: 'Email Address', hint: 'member@company.com', keyboardType: TextInputType.emailAddress),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Text('Role: ', style: AppTypography.labelMedium),
                              const SizedBox(width: 8),
                              ..._roles.map((r) {
                                final isSelected = _invites[i].role == r;
                                return GestureDetector(
                                  onTap: () => setState(() => _invites[i].role = r),
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 6),
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: isSelected ? AppColors.primaryBlue : AppColors.surfaceBackground,
                                      borderRadius: BorderRadius.circular(AppRadius.chip),
                                    ),
                                    child: Text(r, style: AppTypography.labelSmall.copyWith(color: isSelected ? Colors.white : AppColors.textSecondary)),
                                  ),
                                );
                              }),
                            ],
                          ),
                        ],
                      ),
                    ).animate().fadeIn(duration: 300.ms);
                  }),
                  TextButton.icon(
                    onPressed: () => setState(() => _invites.add(_TeamInvite(email: '', role: 'Viewer'))),
                    icon: const Icon(Icons.add_circle_outline, size: 18),
                    label: Text('Add Another Member', style: AppTypography.labelMedium.copyWith(color: AppColors.primaryBlue)),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            child: Column(
              children: [
                BHButton(label: 'Send Invites & Finish', onPressed: () => context.go('/setup/success')),
                const SizedBox(height: 12),
                BHButton(label: 'Skip for Now', onPressed: () => context.go('/setup/success'), type: BHButtonType.ghost),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TeamInvite {
  String email;
  String role;
  _TeamInvite({required this.email, required this.role});
}

class SetupSuccessScreen extends StatelessWidget {
  const SetupSuccessScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100, height: 100,
                  decoration: BoxDecoration(gradient: AppColors.primaryGradient, shape: BoxShape.circle),
                  child: const Icon(Icons.check_rounded, color: Colors.white, size: 56),
                ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
                const SizedBox(height: 32),
                Text('Setup Complete!', style: AppTypography.displayLarge).animate().fadeIn(delay: 300.ms),
                const SizedBox(height: 12),
                Text('BizHealth360 has been configured for\nSharma Trading Pvt. Ltd.', style: AppTypography.bodyMedium, textAlign: TextAlign.center).animate().fadeIn(delay: 450.ms),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(color: AppColors.lightGreen, borderRadius: BorderRadius.circular(AppRadius.card), border: Border.all(color: AppColors.statusGreen.withOpacity(0.3))),
                  child: Column(
                    children: [
                      _SetupStat('Compliances tracked', '24'),
                      _SetupStat('Documents ready', '0'),
                      _SetupStat('Health Score', 'Calculating...'),
                    ],
                  ),
                ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.3, end: 0),
                const SizedBox(height: 40),
                BHButton(label: 'Go to Dashboard', onPressed: () => context.go('/dashboard'), trailingIcon: Icons.dashboard_rounded).animate().fadeIn(delay: 700.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SetupStat extends StatelessWidget {
  final String label, value;
  const _SetupStat(this.label, this.value);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: AppTypography.bodyMedium),
        Text(value, style: AppTypography.labelLarge.copyWith(color: AppColors.statusGreen)),
      ]),
    );
  }
}
