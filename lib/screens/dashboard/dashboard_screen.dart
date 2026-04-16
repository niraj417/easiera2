import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../widgets/cards/bh_cards.dart';
import '../../widgets/indicators/bh_indicators.dart';
import '../../widgets/navigation/bh_navigation.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  final List<Map<String, dynamic>> _compliance = const [
    {'title': 'GSTR-3B Filing', 'category': 'GST', 'status': 'due_soon', 'days': 5},
    {'title': 'TDS Return Q3', 'category': 'Income Tax', 'status': 'overdue', 'days': -2},
    {'title': 'PF Monthly Return', 'category': 'Labour', 'status': 'compliant', 'days': 15},
    {'title': 'FSSAI Annual Return', 'category': 'License', 'status': 'pending', 'days': 30},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceBackground,
      body: Column(
        children: [
          BHDashboardHeader(
            companyName: 'Sharma Trading Pvt. Ltd.',
            gstin: 'GSTIN: 29AABCS1234Z1ZV',
            onNotification: () => context.push('/notifications'),
            onSearch: () => context.push('/alerts'),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero BHS Meter Card
                  _BHSMeterCard().animate().fadeIn(duration: 500.ms),
                  const SizedBox(height: AppSpacing.lg),
                  // Quick Actions
                  Text('Quick Actions', style: AppTypography.headlineMedium),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      _QuickAction('Add Compliance', Icons.add_task_rounded, AppColors.primaryBlue, () => context.push('/compliance/add')),
                      const SizedBox(width: 10),
                      _QuickAction('Upload Doc', Icons.upload_file_rounded, AppColors.verifiedTeal, () => context.push('/documents/upload')),
                      const SizedBox(width: 10),
                      _QuickAction('View Reports', Icons.bar_chart_rounded, AppColors.goldAccent, () => context.push('/ai-advisor/report')),
                      const SizedBox(width: 10),
                      _QuickAction('Loan Offers', Icons.account_balance_wallet_rounded, AppColors.statusAmber, () => context.push('/loans')),
                    ],
                  ).animate().fadeIn(delay: 200.ms),
                  const SizedBox(height: AppSpacing.lg),
                  // AI Insight Banner
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: AppColors.lightGold,
                      borderRadius: BorderRadius.circular(AppRadius.card),
                      border: Border.all(color: AppColors.goldAccent.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40, height: 40,
                          decoration: const BoxDecoration(gradient: AppColors.goldGradient, shape: BoxShape.circle),
                          child: const Icon(Icons.psychology_rounded, color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text('AI Insight of the Day', style: AppTypography.labelMedium.copyWith(color: AppColors.goldAccent)),
                            const SizedBox(height: 2),
                            Text('Your GSTR-3B is due in 5 days. File now to avoid ₹50/day late fee.', style: AppTypography.bodySmall),
                          ]),
                        ),
                        const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.neutralGrey),
                      ],
                    ),
                  ).animate().fadeIn(delay: 300.ms),
                  const SizedBox(height: AppSpacing.lg),
                  // Upcoming Due Items
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Upcoming Due Items', style: AppTypography.headlineMedium),
                      TextButton(onPressed: () => context.push('/compliance/calendar'), child: Text('View All', style: AppTypography.labelMedium.copyWith(color: AppColors.primaryBlue))),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  ..._compliance.asMap().entries.map((e) {
                    final item = e.value;
                    final days = item['days'] as int;
                    final dueDate = DateTime.now().add(Duration(days: days));
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: ComplianceCard(
                        title: item['title'],
                        category: item['category'],
                        status: item['status'],
                        dueDate: dueDate,
                        onTap: () => context.push('/compliance/gst'),
                      ),
                    ).animate().fadeIn(delay: Duration(milliseconds: 100 * e.key + 400));
                  }),
                  const SizedBox(height: AppSpacing.lg),
                  // Stats Row
                  Text('Business Overview', style: AppTypography.headlineMedium),
                  const SizedBox(height: AppSpacing.md),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.3,
                    children: const [
                      StatCard(label: 'Monthly Revenue', value: '₹24.3L', change: '+12%', isPositive: true, color: AppColors.primaryBlue, icon: Icons.currency_rupee_rounded),
                      StatCard(label: 'Active Compliances', value: '24', change: '', isPositive: true, color: AppColors.verifiedTeal, icon: Icons.task_alt_rounded),
                      StatCard(label: 'Pending Actions', value: '3', change: '-2', isPositive: true, color: AppColors.statusAmber, icon: Icons.pending_actions_rounded),
                      StatCard(label: 'Documents Filed', value: '47', change: '+5', isPositive: true, color: AppColors.statusGreen, icon: Icons.folder_rounded),
                    ],
                  ).animate().fadeIn(delay: 600.ms),
                  const SizedBox(height: AppSpacing.lg),
                  // Activity Timeline
                  Text('Recent Activity', style: AppTypography.headlineMedium),
                  const SizedBox(height: AppSpacing.md),
                  TimelineItem(title: 'GSTR-3B Filed Successfully', subtitle: 'Tax liability: ₹1,24,500', date: DateTime.now().subtract(const Duration(days: 1)), color: AppColors.statusGreen, icon: Icons.check_circle_rounded),
                  TimelineItem(title: 'PF Return Submitted', subtitle: 'For 8 employees', date: DateTime.now().subtract(const Duration(days: 3)), color: AppColors.primaryBlue, icon: Icons.people_rounded),
                  TimelineItem(title: 'FSSAI Licence Renewed', subtitle: 'Valid until 31-03-2026', date: DateTime.now().subtract(const Duration(days: 7)), isLast: true, color: AppColors.verifiedTeal, icon: Icons.verified_rounded),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/compliance/add'),
        backgroundColor: AppColors.primaryBlue,
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
    );
  }
}

// ─── BHS Meter Card (same meter as BHS Dashboard) ─────────────────────────

class _BHSMeterCard extends StatelessWidget {
  // Mirrors the score data from health_score_dashboard_screen.dart
  static const double _overallScore = 78.0;
  static const List<Map<String, dynamic>> _categories = [
    {'label': 'CHS', 'score': 82,  'color': Color(0xFF1A5FB4)},
    {'label': 'FHS', 'score': 75,  'color': Color(0xFF22C55E)},
    {'label': 'HPS', 'score': 68,  'color': Color(0xFF8B5CF6)},
    {'label': 'SHS', 'score': 0,   'color': Color(0xFF0D9488), 'pending': true},
    {'label': 'OES', 'score': 71,  'color': Color(0xFFF59E0B)},
    {'label': 'GOS', 'score': 85,  'color': Color(0xFFF5B800)},
  ];

  const _BHSMeterCard();

  @override
  Widget build(BuildContext context) {
    const percent = _overallScore / 100;
    const ratingColor = AppColors.gradeAA;
    return GestureDetector(
      onTap: () => context.push('/health'),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: AppColors.primaryNavy.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8))],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('BizHealth Score™', style: AppTypography.labelMedium.copyWith(color: Colors.white70)),
                  Text('Overall BHS', style: AppTypography.headlineLarge.copyWith(color: Colors.white)),
                ]),
                Row(children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: ratingColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: ratingColor.withOpacity(0.5)),
                    ),
                    child: Row(children: [
                      const Icon(Icons.star_rounded, color: ratingColor, size: 13),
                      const SizedBox(width: 4),
                      Text('AA', style: AppTypography.labelMedium.copyWith(color: ratingColor, fontWeight: FontWeight.w800)),
                    ]),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.goldAccent.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.goldAccent.withOpacity(0.4)),
                    ),
                    child: Row(children: [
                      const Icon(Icons.trending_up_rounded, color: AppColors.goldAccent, size: 13),
                      const SizedBox(width: 4),
                      Text('+4 pts', style: AppTypography.labelSmall.copyWith(color: AppColors.goldAccent)),
                    ]),
                  ),
                ]),
              ],
            ),
            const SizedBox(height: 20),
            CircularPercentIndicator(
              radius: 90,
              lineWidth: 14,
              percent: percent.clamp(0.0, 1.0),
              center: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${_overallScore.round()}', style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w800, color: Colors.white)),
                  Text('/100', style: AppTypography.bodySmall.copyWith(color: Colors.white60)),
                ],
              ),
              progressColor: ratingColor,
              backgroundColor: Colors.white.withOpacity(0.15),
              circularStrokeCap: CircularStrokeCap.round,
              animation: true,
              animationDuration: 1200,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text('Good — Tap to view full BHS', style: AppTypography.labelMedium.copyWith(color: Colors.white)),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _categories.map((c) => Column(
                children: [
                  Text(c['label'] as String, style: AppTypography.labelSmall.copyWith(color: Colors.white60, fontSize: 9)),
                  const SizedBox(height: 2),
                  Text(
                    (c['pending'] == true) ? '--' : '${c['score']}',
                    style: AppTypography.labelMedium.copyWith(
                      color: (c['pending'] == true) ? Colors.white38 : (c['color'] as Color),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _QuickAction(this.label, this.icon, this.color, this.onTap);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Column(
            children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(color: color.withOpacity(0.12), shape: BoxShape.circle),
                child: Icon(icon, color: color, size: 18),
              ),
              const SizedBox(height: 6),
              Text(label, style: AppTypography.labelSmall.copyWith(fontWeight: FontWeight.w500), textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
