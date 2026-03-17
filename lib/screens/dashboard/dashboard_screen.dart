import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/india_formatter.dart';
import '../../widgets/cards/bh_cards.dart';
import '../../widgets/charts/gauge_chart.dart';
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
                  // Hero Compliance Score Card
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text('Compliance Health', style: AppTypography.labelMedium.copyWith(color: Colors.white70)),
                              Text('Score', style: AppTypography.headlineLarge.copyWith(color: Colors.white)),
                            ]),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(color: AppColors.goldAccent.withOpacity(0.2), borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.goldAccent.withOpacity(0.4))),
                              child: Row(children: [
                                const Icon(Icons.trending_up, color: AppColors.goldAccent, size: 14),
                                const SizedBox(width: 4),
                                Text('+4 pts this month', style: AppTypography.labelSmall.copyWith(color: AppColors.goldAccent)),
                              ]),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        GaugeChart(score: 78, label: 'Overall Health', size: 200),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _MiniScore('GST', 85, AppColors.statusGreen),
                            _MiniScore('Income Tax', 72, AppColors.statusAmber),
                            _MiniScore('Labour', 80, AppColors.statusGreen),
                            _MiniScore('Licences', 65, AppColors.statusAmber),
                          ],
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 500.ms),
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
                          decoration: BoxDecoration(gradient: AppColors.goldGradient, shape: BoxShape.circle),
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
                    children: [
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

class _MiniScore extends StatelessWidget {
  final String label;
  final int score;
  final Color color;
  const _MiniScore(this.label, this.score, this.color);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('$score', style: AppTypography.headlineMedium.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
        Text(label, style: AppTypography.labelSmall.copyWith(color: Colors.white60)),
      ],
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
