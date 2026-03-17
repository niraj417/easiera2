import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../widgets/buttons/bh_button.dart';
import '../../widgets/indicators/bh_indicators.dart';
import '../../widgets/navigation/bh_navigation.dart';

// AI Advisor — additional screens

class DailyInsightsScreen extends StatelessWidget {
  const DailyInsightsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BHAppBar(title: 'Today\'s Insights', actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.bookmark_rounded, color: AppColors.textSecondary)),
        const SizedBox(width: 4),
      ]),
      backgroundColor: AppColors.surfaceBackground,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(gradient: AppColors.goldGradient, borderRadius: BorderRadius.circular(16)),
            child: Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('17 March 2026', style: AppTypography.labelMedium.copyWith(color: Colors.white70)),
                Text('Good Morning,\nRajesh! 👋', style: AppTypography.headlineLarge.copyWith(color: Colors.white, height: 1.2)),
                const SizedBox(height: 8),
                Text('4 insights generated today', style: AppTypography.bodySmall.copyWith(color: Colors.white60)),
              ])),
              Container(width: 60, height: 60, decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle), child: const Icon(Icons.psychology_rounded, color: Colors.white, size: 32)),
            ]),
          ),
          const SizedBox(height: 20),
          Text('Priority Insights', style: AppTypography.headlineMedium),
          const SizedBox(height: 12),
          ...[
            {'tag': 'URGENT', 'tagColor': 0xFFEF4444, 'title': 'TDS Filing Penalty Accumulating', 'body': '₹400 penalty accrued so far on overdue Q3 TDS. File today to stop escalation.', 'icon': Icons.warning_rounded, 'color': 0xFFEF4444, 'action': 'File Now'},
            {'tag': 'SAVE MONEY', 'tagColor': 0xFF22C55E, 'title': 'Section 44AD Opportunity', 'body': 'Save up to ₹1.2L in taxes by opting for presumptive taxation scheme.', 'icon': Icons.savings_rounded, 'color': 0xFF22C55E, 'action': 'Learn More'},
            {'tag': 'COMPLIANCE', 'tagColor': 0xFF1A5FB4, 'title': 'GSTR-3B due in 3 days', 'body': 'December 2024 GSTR-3B is due on 20-Jan-2025. All data is auto-computed.', 'icon': Icons.receipt_long_rounded, 'color': 0xFF1A5FB4, 'action': 'Review & File'},
            {'tag': 'GROWTH', 'tagColor': 0xFF6366F1, 'title': 'Best Time to Apply for MSME Loan', 'body': 'RBI rate cut boosts MSME credit. Your score 78 qualifies for lowest rates in 2 years.', 'icon': Icons.trending_up_rounded, 'color': 0xFF6366F1, 'action': 'View Offers'},
          ].asMap().entries.map((entry) {
            final i = entry.key;
            final ins = entry.value;
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.card), border: Border.all(color: Color(ins['color'] as int).withOpacity(0.2), width: 1.5)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: Color(ins['tagColor'] as int).withOpacity(0.12), borderRadius: BorderRadius.circular(10)), child: Text(ins['tag'] as String, style: AppTypography.labelSmall.copyWith(color: Color(ins['tagColor'] as int), fontWeight: FontWeight.w700))),
                  const Spacer(),
                  Icon(ins['icon'] as IconData, color: Color(ins['color'] as int), size: 18),
                ]),
                const SizedBox(height: 8),
                Text(ins['title'] as String, style: AppTypography.headlineMedium),
                const SizedBox(height: 4),
                Text(ins['body'] as String, style: AppTypography.bodySmall.copyWith(height: 1.5)),
                const SizedBox(height: 10),
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  TextButton(onPressed: () {}, child: Text('Save', style: AppTypography.labelSmall.copyWith(color: AppColors.neutralGrey))),
                  ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(minimumSize: const Size(0, 32), padding: const EdgeInsets.symmetric(horizontal: 16), backgroundColor: Color(ins['color'] as int)), child: Text(ins['action'] as String, style: AppTypography.labelSmall.copyWith(color: Colors.white))),
                ]),
              ]),
            ).animate().fadeIn(delay: Duration(milliseconds: i * 80));
          }),
        ]),
      ),
    );
  }
}

class SavedInsightsScreen extends StatelessWidget {
  const SavedInsightsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BHAppBar(title: 'Saved Insights'),
      backgroundColor: AppColors.surfaceBackground,
      body: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.lg),
        itemCount: 4,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, i) {
          final items = [
            {'title': 'Section 44AD Tax Saving', 'date': '15-Mar-2026', 'tag': 'SAVE MONEY'},
            {'title': 'MSME Loan Rate Opportunity', 'date': '14-Mar-2026', 'tag': 'GROWTH'},
            {'title': 'TDS ITC Reconciliation Guide', 'date': '12-Mar-2026', 'tag': 'COMPLIANCE'},
            {'title': 'GST Threshold Crossed', 'date': '10-Mar-2026', 'tag': 'URGENT'},
          ];
          final item = items[i];
          return Dismissible(
            key: Key('saved_$i'),
            direction: DismissDirection.endToStart,
            background: Container(padding: const EdgeInsets.only(right: 16), alignment: Alignment.centerRight, color: AppColors.statusRed, child: const Icon(Icons.delete_rounded, color: Colors.white)),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.card), border: Border.all(color: AppColors.borderLight)),
              child: Row(children: [
                Container(width: 36, height: 36, decoration: BoxDecoration(color: AppColors.lightGold, shape: BoxShape.circle), child: const Icon(Icons.bookmark_rounded, color: AppColors.goldAccent, size: 18)),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(item['title']!, style: AppTypography.labelLarge),
                  Text('Saved on ${item['date']}', style: AppTypography.bodySmall),
                ])),
                Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: AppColors.lightBlue, borderRadius: BorderRadius.circular(8)), child: Text(item['tag']!, style: AppTypography.labelSmall.copyWith(color: AppColors.primaryBlue, fontSize: 9))),
              ]),
            ),
          );
        },
      ),
    );
  }
}

class FinancialInsightsScreen extends StatelessWidget {
  const FinancialInsightsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BHAppBar(title: 'Financial Insights'),
      backgroundColor: AppColors.surfaceBackground,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(gradient: AppColors.greenGradient, borderRadius: BorderRadius.circular(16)),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              _FinStat('Revenue', '₹24.3L', '/month'),
              _FinStat('Tax Liability', '₹1.24L', 'this month'),
              _FinStat('Net Savings', '₹23.1L', 'post tax'),
            ]),
          ),
          const SizedBox(height: 20),
          Text('AI Financial Analysis', style: AppTypography.headlineMedium),
          const SizedBox(height: 12),
          ...[
            {'title': 'Revenue Growing at 12% YoY', 'body': 'Consistent growth detected. Monthly avg ₹24.3L vs ₹21.7L last year. Q4 seasonality risk flagged.', 'icon': Icons.trending_up_rounded, 'color': AppColors.statusGreen},
            {'title': 'Working Capital Healthy', 'body': 'Current ratio of 2.1 indicates strong short-term liquidity. Inventory turnover improved to 8x.', 'icon': Icons.account_balance_wallet_rounded, 'color': AppColors.primaryBlue},
            {'title': 'Tax Planning Opportunity', 'body': 'Estimated advance tax for Q4 is ₹3.2L. Pre-book payments before 15-Mar to avoid interest.', 'icon': Icons.savings_rounded, 'color': AppColors.goldAccent},
          ].map((item) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.card), border: Border.all(color: AppColors.borderLight)),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(width: 40, height: 40, decoration: BoxDecoration(color: (item['color'] as Color).withOpacity(0.12), borderRadius: BorderRadius.circular(8)), child: Icon(item['icon'] as IconData, color: item['color'] as Color, size: 20)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(item['title'] as String, style: AppTypography.labelLarge),
                const SizedBox(height: 4),
                Text(item['body'] as String, style: AppTypography.bodySmall.copyWith(height: 1.5)),
              ])),
            ]),
          )),
        ]),
      ),
    );
  }
}

class _FinStat extends StatelessWidget {
  final String label, value, sub;
  const _FinStat(this.label, this.value, this.sub);
  @override
  Widget build(BuildContext context) => Column(children: [
    Text(label, style: AppTypography.labelSmall.copyWith(color: Colors.white60)),
    Text(value, style: AppTypography.headlineLarge.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
    Text(sub, style: AppTypography.labelSmall.copyWith(color: Colors.white.withOpacity(0.5), fontSize: 9)),
  ]);
}

class RiskAlertsScreen extends StatelessWidget {
  const RiskAlertsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BHAppBar(title: 'Compliance Risk Alerts'),
      backgroundColor: AppColors.surfaceBackground,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(color: AppColors.statusRed.withOpacity(0.08), borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.statusRed.withOpacity(0.2))),
            child: Row(children: [
              const Icon(Icons.shield_rounded, color: AppColors.statusRed, size: 40),
              const SizedBox(width: 16),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('2 Critical Risks', style: AppTypography.headlineLarge.copyWith(color: AppColors.statusRed)),
                Text('Immediate action required to avoid penalties', style: AppTypography.bodySmall),
              ])),
            ]),
          ),
          const SizedBox(height: 20),
          ...[
            {'severity': 'CRITICAL', 'color': 0xFFEF4444, 'title': 'TDS Return Overdue', 'penalty': '₹200/day penalty', 'desc': 'Q3 TDS return was due 31-Oct-2024. Current penalty: ₹400. File immediately.', 'deadline': 'Act Now'},
            {'severity': 'HIGH', 'color': 0xFFF59E0B, 'title': 'GSTR-2B ITC Mismatch', 'penalty': 'Possible GST notice', 'desc': 'AI detected ₹23,000 ITC mismatch. Reconcile before GSTR-3B filing.', 'deadline': '3 Days Left'},
            {'severity': 'MEDIUM', 'color': 0xFF1A5FB4, 'title': 'Shop Act Renewal Due', 'penalty': '₹5,000 fine if lapsed', 'desc': 'Renewal due in 8 days. Apply online at Labour Department portal.', 'deadline': '8 Days Left'},
            {'severity': 'LOW', 'color': 0xFF22C55E, 'title': 'FSSAI Licence Expiry', 'penalty': 'Operational risk', 'desc': 'Expires 31-Mar-2026. Begin renewal process 30 days before expiry.', 'deadline': '14 Days Left'},
          ].asMap().entries.map((entry) {
            final i = entry.key;
            final alert = entry.value;
            final color = Color(alert['color'] as int);
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.card), border: Border.all(color: color.withOpacity(0.3), width: 1.5)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(8)), child: Text(alert['severity'] as String, style: AppTypography.labelSmall.copyWith(color: color, fontWeight: FontWeight.w700))),
                  const Spacer(),
                  Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: AppColors.surfaceBackground, borderRadius: BorderRadius.circular(8)), child: Text(alert['deadline'] as String, style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary))),
                ]),
                const SizedBox(height: 8),
                Text(alert['title'] as String, style: AppTypography.headlineMedium),
                Container(margin: const EdgeInsets.symmetric(vertical: 4), padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: color.withOpacity(0.08), borderRadius: BorderRadius.circular(6)), child: Text(alert['penalty'] as String, style: AppTypography.labelSmall.copyWith(color: color))),
                Text(alert['desc'] as String, style: AppTypography.bodySmall.copyWith(height: 1.5)),
                const SizedBox(height: 10),
                BHButton(label: 'Take Action', onPressed: () => context.push('/compliance/gst'), type: i == 0 ? BHButtonType.primary : BHButtonType.secondary),
              ]),
            ).animate().fadeIn(delay: Duration(milliseconds: i * 80));
          }),
        ]),
      ),
    );
  }
}
