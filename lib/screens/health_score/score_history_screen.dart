import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../widgets/buttons/bh_button.dart';
import '../../widgets/indicators/bh_indicators.dart';
import '../../widgets/navigation/bh_navigation.dart';

// Health Score — additional screens

class ScoreHistoryScreen extends StatelessWidget {
  const ScoreHistoryScreen({super.key});

  final List<Map<String, dynamic>> _history = const [
    {'month': 'Nov 2024', 'score': 78, 'change': '+4', 'positive': true},
    {'month': 'Oct 2024', 'score': 74, 'change': '+2', 'positive': true},
    {'month': 'Sep 2024', 'score': 72, 'change': '-1', 'positive': false},
    {'month': 'Aug 2024', 'score': 73, 'change': '+5', 'positive': true},
    {'month': 'Jul 2024', 'score': 68, 'change': '+3', 'positive': true},
    {'month': 'Jun 2024', 'score': 65, 'change': '0', 'positive': true},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BHAppBar(title: 'Score History', actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.download_rounded, color: AppColors.textSecondary)),
        const SizedBox(width: 4),
      ]),
      backgroundColor: AppColors.surfaceBackground,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Trend chart visual
          Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(16)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Score Trend — Last 6 Months', style: AppTypography.labelMedium.copyWith(color: Colors.white70)),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: _history.reversed.toList().asMap().entries.map((e) {
                  final item = e.value;
                  final score = item['score'] as int;
                  final barH = ((score - 55) * 2.5).clamp(4.0, 90.0);
                  return Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Text('$score', style: AppTypography.labelSmall.copyWith(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 10)),
                    const SizedBox(height: 3),
                    Container(width: 28, height: barH, decoration: BoxDecoration(color: Colors.white.withOpacity(0.8), borderRadius: BorderRadius.circular(4))),
                    const SizedBox(height: 6),
                    Text(item['month'].toString().substring(0, 3), style: AppTypography.labelSmall.copyWith(color: Colors.white60, fontSize: 9)),
                  ]);
                }).toList(),
              ),
            ]),
          ),
          const SizedBox(height: 20),
          Text('Monthly Breakdown', style: AppTypography.headlineMedium),
          const SizedBox(height: 12),
          ..._history.asMap().entries.map((entry) {
            final i = entry.key;
            final item = entry.value;
            final isPos = item['positive'] as bool;
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.card), border: Border.all(color: AppColors.borderLight)),
              child: Row(children: [
                Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(gradient: i == 0 ? AppColors.primaryGradient : null, color: i != 0 ? AppColors.surfaceBackground : null, shape: BoxShape.circle),
                  child: Center(child: Text('${item['score']}', style: AppTypography.labelLarge.copyWith(color: i == 0 ? Colors.white : AppColors.primaryBlue, fontWeight: FontWeight.w700))),
                ),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(item['month'] as String, style: AppTypography.labelLarge),
                  Text(i == 0 ? 'Current Period' : 'Historical', style: AppTypography.bodySmall),
                ])),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: (isPos ? AppColors.statusGreen : AppColors.statusRed).withOpacity(0.12), borderRadius: BorderRadius.circular(20)),
                  child: Text(item['change'] as String, style: AppTypography.labelMedium.copyWith(color: isPos ? AppColors.statusGreen : AppColors.statusRed)),
                ),
              ]),
            ).animate().fadeIn(delay: Duration(milliseconds: i * 60));
          }),
        ]),
      ),
    );
  }
}

class ScoreImprovementScreen extends StatelessWidget {
  const ScoreImprovementScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BHAppBar(title: 'Improvement Tips'),
      backgroundColor: AppColors.surfaceBackground,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(gradient: AppColors.goldGradient, borderRadius: BorderRadius.circular(16)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                const Icon(Icons.lightbulb_rounded, color: Colors.white, size: 24),
                const SizedBox(width: 8),
                Text('Potential Score: 92', style: AppTypography.headlineLarge.copyWith(color: Colors.white)),
              ]),
              const SizedBox(height: 4),
              Text('Follow these steps to unlock +14 points', style: AppTypography.bodySmall.copyWith(color: Colors.white70)),
            ]),
          ),
          const SizedBox(height: 20),
          Text('High Impact Actions', style: AppTypography.headlineMedium),
          const SizedBox(height: 12),
          ...[
            {'icon': Icons.warning_rounded, 'color': 0xFFEF4444, 'title': 'File TDS Return Q3', 'points': '+5', 'effort': 'Low', 'desc': 'Already overdue. File immediately via TRACES portal to avoid penalty escalation.'},
            {'icon': Icons.receipt_long_rounded, 'color': 0xFFF59E0B, 'title': 'Reconcile GSTR-2B vs 3B', 'points': '+3', 'effort': 'Medium', 'desc': 'AI detected ₹23,000 ITC mismatch. Reconcile before next filing cycle.'},
            {'icon': Icons.upload_file_rounded, 'color': 0xFF1A5FB4, 'title': 'Upload Pending Documents', 'points': '+2', 'effort': 'Low', 'desc': 'Shop Act, FSSAI renewal doc missing. Upload to improve document health score.'},
            {'icon': Icons.add_task_rounded, 'color': 0xFF22C55E, 'title': 'Renew Shop & Est. Act', 'points': '+2', 'effort': 'Low', 'desc': 'Due in 8 days. Applies online at Labour Department portal.'},
            {'icon': Icons.people_rounded, 'color': 0xFF6366F1, 'title': 'Add HR Integration', 'points': '+2', 'effort': 'Medium', 'desc': 'Connect GreytHR or Darwinbox to auto-sync PF/ESI data.'},
          ].asMap().entries.map((entry) {
            final i = entry.key;
            final tip = entry.value;
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.card), border: Border.all(color: AppColors.borderLight)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Container(width: 36, height: 36, decoration: BoxDecoration(color: Color(tip['color'] as int).withOpacity(0.12), shape: BoxShape.circle), child: Icon(tip['icon'] as IconData, color: Color(tip['color'] as int), size: 18)),
                  const SizedBox(width: 10),
                  Expanded(child: Text(tip['title'] as String, style: AppTypography.labelLarge)),
                  Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(gradient: AppColors.goldGradient, borderRadius: BorderRadius.circular(12)), child: Text(tip['points'] as String, style: AppTypography.labelSmall.copyWith(color: Colors.white, fontWeight: FontWeight.w700))),
                ]),
                const SizedBox(height: 8),
                Text(tip['desc'] as String, style: AppTypography.bodySmall.copyWith(height: 1.5)),
                const SizedBox(height: 8),
                Row(children: [
                  Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: AppColors.surfaceBackground, borderRadius: BorderRadius.circular(8)), child: Text('Effort: ${tip['effort']}', style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary))),
                  const Spacer(),
                  TextButton(onPressed: () => context.push('/compliance/gst'), child: Text('Action →', style: AppTypography.labelSmall.copyWith(color: AppColors.primaryBlue))),
                ]),
              ]),
            ).animate().fadeIn(delay: Duration(milliseconds: i * 70));
          }),
        ]),
      ),
    );
  }
}

class ScoreCertificateScreen extends StatelessWidget {
  const ScoreCertificateScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BHAppBar(title: 'BizHealth Certificate', actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.share_rounded, color: AppColors.textSecondary)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.download_rounded, color: AppColors.textSecondary)),
        const SizedBox(width: 4),
      ]),
      backgroundColor: AppColors.surfaceBackground,
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: AppColors.primaryNavy.withOpacity(0.3), blurRadius: 24, offset: const Offset(0, 8))],
              ),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.workspace_premium_rounded, color: AppColors.goldAccent, size: 64),
                const SizedBox(height: 16),
                Text('BizHealth360', style: AppTypography.headlineLarge.copyWith(color: Colors.white70, fontSize: 14, letterSpacing: 2)),
                const SizedBox(height: 8),
                Text('COMPLIANCE CERTIFICATE', style: AppTypography.headlineLarge.copyWith(color: Colors.white, fontSize: 20, letterSpacing: 1.5)),
                const SizedBox(height: 24),
                Container(
                  width: 100, height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                    border: Border.all(color: AppColors.goldAccent, width: 2),
                  ),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text('78', style: AppTypography.displayLarge.copyWith(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 36)),
                    Text('Grade A', style: AppTypography.labelSmall.copyWith(color: AppColors.goldAccent)),
                  ]),
                ),
                const SizedBox(height: 24),
                Text('Sharma Trading Pvt. Ltd.', style: AppTypography.headlineLarge.copyWith(color: Colors.white, fontSize: 18)),
                const SizedBox(height: 4),
                Text('GSTIN: 29AABCS1234Z1ZV', style: AppTypography.bodySmall.copyWith(color: Colors.white60)),
                const SizedBox(height: 24),
                Container(margin: const EdgeInsets.symmetric(horizontal: 40), height: 1, color: Colors.white24),
                const SizedBox(height: 16),
                Text('Valid: November 2024', style: AppTypography.bodySmall.copyWith(color: Colors.white54)),
                Text('Certificate ID: BH2024-78432', style: AppTypography.dataMonoSmall.copyWith(color: Colors.white38, fontSize: 10)),
                const SizedBox(height: 16),
              ]),
            ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
          ),
          const SizedBox(height: 16),
          BHButton(label: 'Share Certificate', onPressed: () {}, leadingIcon: Icons.share_rounded),
          const SizedBox(height: 8),
          BHButton(label: 'Download PDF', onPressed: () {}, type: BHButtonType.secondary, leadingIcon: Icons.download_rounded),
        ]),
      ),
    );
  }
}
