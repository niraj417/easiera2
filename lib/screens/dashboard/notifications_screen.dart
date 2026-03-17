import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../widgets/navigation/bh_navigation.dart';
import '../../widgets/indicators/bh_indicators.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  final List<Map<String, dynamic>> _notifications = const [
    {'icon': Icons.warning_rounded, 'color': 0xFFEF4444, 'title': 'TDS Return Overdue', 'body': 'Q3 TDS return was due 2 days ago. File immediately to avoid penalties.', 'time': '2 hours ago', 'isRead': false},
    {'icon': Icons.access_time_rounded, 'color': 0xFFF59E0B, 'title': 'GSTR-3B Due in 5 Days', 'body': 'File your GSTR-3B for November before 20th December 2025.', 'time': '6 hours ago', 'isRead': false},
    {'icon': Icons.check_circle_rounded, 'color': 0xFF22C55E, 'title': 'PF Return Filed Successfully', 'body': 'Your PF return for November has been submitted.', 'time': '1 day ago', 'isRead': true},
    {'icon': Icons.psychology_rounded, 'color': 0xFFF5B800, 'title': 'New AI Insight Available', 'body': 'Your cashflow stability improved by 8% this quarter.', 'time': '2 days ago', 'isRead': true},
    {'icon': Icons.account_balance_wallet_rounded, 'color': 0xFF1A5FB4, 'title': 'New Loan Offer Available', 'body': 'HDFC Bank has a pre-approved offer of ₹50L at 12.5% p.a.', 'time': '3 days ago', 'isRead': true},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BHAppBar(title: 'Notifications', actions: [
        TextButton(onPressed: () {}, child: Text('Mark all read', style: AppTypography.labelMedium.copyWith(color: AppColors.primaryBlue))),
      ]),
      body: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.lg),
        itemCount: _notifications.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final n = _notifications[index];
          return Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: n['isRead'] as bool ? Colors.white : AppColors.lightBlue,
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(color: n['isRead'] as bool ? AppColors.borderLight : AppColors.primaryBlue.withOpacity(0.2)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(color: Color(n['color'] as int).withOpacity(0.12), shape: BoxShape.circle),
                  child: Icon(n['icon'] as IconData, color: Color(n['color'] as int), size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Expanded(child: Text(n['title'] as String, style: AppTypography.labelLarge.copyWith(fontWeight: n['isRead'] as bool ? FontWeight.w500 : FontWeight.w700))),
                      if (!(n['isRead'] as bool)) Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.primaryBlue, shape: BoxShape.circle)),
                    ]),
                    const SizedBox(height: 4),
                    Text(n['body'] as String, style: AppTypography.bodySmall),
                    const SizedBox(height: 6),
                    Text(n['time'] as String, style: AppTypography.labelSmall.copyWith(color: AppColors.primaryBlue)),
                  ]),
                ),
              ],
            ),
          ).animate().fadeIn(delay: Duration(milliseconds: index * 60));
        },
      ),
    );
  }
}

class AlertsCenterScreen extends StatelessWidget {
  const AlertsCenterScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BHAppBar(title: 'Alerts Center'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _AlertBanner(title: '2 Critical Overdue Items', subtitle: 'Immediate action required to avoid penalties', color: AppColors.statusRed, icon: Icons.error_rounded),
            const SizedBox(height: 12),
            _AlertBanner(title: '3 Items Due This Week', subtitle: 'File before deadlines to stay compliant', color: AppColors.statusAmber, icon: Icons.warning_rounded),
            const SizedBox(height: 20),
            Text('All Alerts', style: AppTypography.headlineMedium),
            const SizedBox(height: 12),
            ...List.generate(5, (i) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.card), border: Border.all(color: AppColors.borderLight)),
                child: Row(children: [
                  const Icon(Icons.circle, color: AppColors.statusAmber, size: 8),
                  const SizedBox(width: 12),
                  Expanded(child: Text(['TDS Q3 Overdue', 'GSTR-3B Due in 5 days', 'Shop Act renewal in 20 days', 'PF payment due in 7 days', 'Income Tax Advance Tax'][i], style: AppTypography.labelMedium)),
                  StatusChip(label: ['Overdue', 'Due Soon', 'Due Soon', 'Due Soon', 'Pending'][i], status: ['overdue', 'due_soon', 'due_soon', 'due_soon', 'pending'][i]),
                ]),
              ),
            )),
          ],
        ),
      ),
    );
  }
}

class _AlertBanner extends StatelessWidget {
  final String title, subtitle;
  final Color color;
  final IconData icon;
  const _AlertBanner({required this.title, required this.subtitle, required this.color, required this.icon});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(color: color.withOpacity(0.08), borderRadius: BorderRadius.circular(AppRadius.card), border: Border.all(color: color.withOpacity(0.3))),
      child: Row(children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: AppTypography.labelLarge.copyWith(color: color)),
          Text(subtitle, style: AppTypography.bodySmall),
        ])),
      ]),
    );
  }
}
