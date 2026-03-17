import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../widgets/buttons/bh_button.dart';
import '../../widgets/charts/gauge_chart.dart';
import '../../widgets/indicators/bh_indicators.dart';
import '../../widgets/navigation/bh_navigation.dart';

// Health Score module screens

class HealthScoreDashboardScreen extends StatelessWidget {
  const HealthScoreDashboardScreen({super.key});

  final List<Map<String, dynamic>> _dimensions = const [
    {'label': 'GST Compliance', 'score': 85, 'trend': '+3', 'color': 0xFF22C55E, 'icon': Icons.receipt_long_rounded},
    {'label': 'Income Tax', 'score': 72, 'trend': '+1', 'color': 0xFFF59E0B, 'icon': Icons.account_balance_rounded},
    {'label': 'Labour Laws', 'score': 80, 'trend': '0', 'color': 0xFF22C55E, 'icon': Icons.people_rounded},
    {'label': 'Licences', 'score': 65, 'trend': '-2', 'color': 0xFFF59E0B, 'icon': Icons.verified_rounded},
    {'label': 'Document Health', 'score': 78, 'trend': '+5', 'color': 0xFF22C55E, 'icon': Icons.folder_rounded},
    {'label': 'Cashflow Stability', 'score': 91, 'trend': '+8', 'color': 0xFF22C55E, 'icon': Icons.trending_up_rounded},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: AppSpacing.lg,
        title: Text('Business Health', style: AppTypography.headlineLarge),
        bottom: const PreferredSize(preferredSize: Size.fromHeight(1), child: Divider(height: 1)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Master score
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(16)),
              child: Column(children: [
                Text('BizHealth Score™', style: AppTypography.labelMedium.copyWith(color: Colors.white70)),
                GaugeChart(score: 78, label: 'Overall Health', size: 200),
                const SizedBox(height: 8),
                Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), decoration: BoxDecoration(color: AppColors.statusGreen.withOpacity(0.2), borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.statusGreen.withOpacity(0.4))), child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.trending_up, color: AppColors.statusGreen, size: 14),
                  const SizedBox(width: 4),
                  Text('Grade: A  |  +4 pts this month', style: AppTypography.labelSmall.copyWith(color: AppColors.statusGreen)),
                ])),
              ]),
            ).animate().fadeIn(duration: 500.ms),
            const SizedBox(height: AppSpacing.lg),
            // Score dimensions
            Text('Dimension Scores', style: AppTypography.headlineMedium),
            const SizedBox(height: AppSpacing.sm),
            ..._dimensions.asMap().entries.map((entry) {
              final i = entry.key;
              final dim = entry.value;
              final score = dim['score'] as int;
              final trend = dim['trend'] as String;
              final color = Color(dim['color'] as int);
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.card), border: Border.all(color: AppColors.borderLight)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Icon(dim['icon'] as IconData, color: color, size: 20),
                    const SizedBox(width: 8),
                    Expanded(child: Text(dim['label'] as String, style: AppTypography.labelLarge)),
                    Text('$score', style: AppTypography.headlineMedium.copyWith(color: color, fontWeight: FontWeight.w700)),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: trend.startsWith('+') ? AppColors.lightGreen : trend == '0' ? AppColors.surfaceBackground : AppColors.lightAmber, borderRadius: BorderRadius.circular(4)),
                      child: Text(trend, style: AppTypography.labelSmall.copyWith(color: trend.startsWith('+') ? AppColors.statusGreen : trend == '0' ? AppColors.neutralGrey : AppColors.statusAmber)),
                    ),
                  ]),
                  const SizedBox(height: 8),
                  ProgressBarWidget(label: '', value: score / 100, color: color, trailingLabel: '${score}%'),
                ]),
              ).animate().fadeIn(delay: Duration(milliseconds: i * 80));
            }),
            const SizedBox(height: AppSpacing.lg),
            // AI Recommendations
            Text('AI Recommendations to Improve Score', style: AppTypography.headlineMedium),
            const SizedBox(height: AppSpacing.sm),
            ...[
              {'icon': Icons.warning_rounded, 'color': 0xFFEF4444, 'title': 'File TDS Return immediately', 'sub': '+5 score if filed today', 'action': 'File Now'},
              {'icon': Icons.upload_file_rounded, 'color': 0xFFF59E0B, 'title': 'Upload Shop Act renewal docs', 'sub': '+3 score when renewed', 'action': 'Upload'},
              {'icon': Icons.add_task_rounded, 'color': 0xFF22C55E, 'title': 'Add Trademark to tracking', 'sub': '+2 score for completeness', 'action': 'Add'},
            ].map((rec) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.card), border: Border.all(color: AppColors.borderLight)),
              child: Row(children: [
                Container(width: 36, height: 36, decoration: BoxDecoration(color: Color(rec['color'] as int).withOpacity(0.12), borderRadius: BorderRadius.circular(8)), child: Icon(rec['icon'] as IconData, color: Color(rec['color'] as int), size: 18)),
                const SizedBox(width: 10),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(rec['title'] as String, style: AppTypography.labelMedium),
                  Text(rec['sub'] as String, style: AppTypography.bodySmall.copyWith(color: AppColors.statusGreen)),
                ])),
                TextButton(onPressed: () => context.push('/compliance/gst'), child: Text(rec['action'] as String, style: AppTypography.labelSmall.copyWith(color: AppColors.primaryBlue))),
              ]),
            )),
            const SizedBox(height: AppSpacing.lg),
            BHButton(label: 'Download Health Report', onPressed: () => context.push('/ai-advisor/report'), type: BHButtonType.secondary, leadingIcon: Icons.download_rounded),
          ],
        ),
      ),
    );
  }
}

class HealthScoreDetailScreen extends StatelessWidget {
  final String dimension;
  const HealthScoreDetailScreen({super.key, this.dimension = 'GST Compliance'});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BHAppBar(title: dimension),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(16)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(dimension, style: AppTypography.headlineLarge.copyWith(color: Colors.white)),
              Text('Score Breakdown', style: AppTypography.bodySmall.copyWith(color: Colors.white60)),
              const SizedBox(height: 20),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                _ScorePill('Filing Rate', '100%', AppColors.statusGreen),
                _ScorePill('On-Time Rate', '92%', AppColors.statusGreen),
                _ScorePill('Amount Paid', '₹12.4L', AppColors.goldAccent),
              ]),
            ]),
          ),
          const SizedBox(height: 20),
          Text('Trend (Last 6 Months)', style: AppTypography.headlineMedium),
          const SizedBox(height: 12),
          Container(
            height: 100,
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.card), border: Border.all(color: AppColors.borderLight)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [72, 74, 78, 80, 83, 85].map((score) => Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('$score', style: AppTypography.labelSmall.copyWith(color: AppColors.primaryBlue, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Container(width: 28, height: (score - 70) * 4.0, color: AppColors.primaryBlue.withOpacity(0.7), decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: AppColors.primaryBlue.withOpacity(0.7))),
                ],
              )).toList(),
            ),
          ),
          const SizedBox(height: 20),
          BHButton(label: 'Improve $dimension Score', onPressed: () => context.push('/compliance/gst')),
        ]),
      ),
    );
  }
}

class _ScorePill extends StatelessWidget {
  final String label, value;
  final Color color;
  const _ScorePill(this.label, this.value, this.color);
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(value, style: AppTypography.headlineMedium.copyWith(color: color, fontWeight: FontWeight.w700)),
      Text(label, style: AppTypography.labelSmall.copyWith(color: Colors.white60)),
    ]);
  }
}

class HealthComparisonScreen extends StatelessWidget {
  const HealthComparisonScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BHAppBar(title: 'Industry Comparison'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(16)),
            child: Column(children: [
              Text('Your Score vs Industry', style: AppTypography.headlineMedium.copyWith(color: Colors.white)),
              const SizedBox(height: 16),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                _CompareCard('Your Score', 78, AppColors.goldAccent),
                Column(children: [const Icon(Icons.compare_arrows_rounded, color: Colors.white54, size: 28), const SizedBox(height: 4), Text('vs', style: AppTypography.labelSmall.copyWith(color: Colors.white54))]),
                _CompareCard('Industry Avg', 65, AppColors.statusGreen),
              ]),
            ]),
          ),
          const SizedBox(height: 20),
          Text('Dimension Comparison', style: AppTypography.headlineMedium),
          const SizedBox(height: 12),
          ...['GST Compliance', 'Income Tax', 'Labour Laws', 'Licences'].asMap().entries.map((e) {
            final yours = [85, 72, 80, 65][e.key];
            final avg = [70, 65, 60, 55][e.key];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.card), border: Border.all(color: AppColors.borderLight)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(e.value, style: AppTypography.labelLarge),
                const SizedBox(height: 8),
                ProgressBarWidget(label: 'You', value: yours / 100, color: AppColors.primaryBlue, trailingLabel: '$yours'),
                const SizedBox(height: 4),
                ProgressBarWidget(label: 'Avg', value: avg / 100, color: AppColors.neutralGrey, trailingLabel: '$avg'),
              ]),
            );
          }),
          const SizedBox(height: 16),
          BHButton(label: 'Download Benchmark Report', onPressed: () => context.push('/ai-advisor/report'), type: BHButtonType.secondary, leadingIcon: Icons.bar_chart_rounded),
        ]),
      ),
    );
  }
}

class _CompareCard extends StatelessWidget {
  final String label;
  final int score;
  final Color color;
  const _CompareCard(this.label, this.score, this.color);
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text('$score', style: AppTypography.displayLarge.copyWith(color: color, fontWeight: FontWeight.w800)),
      Text(label, style: AppTypography.labelSmall.copyWith(color: Colors.white70)),
    ]);
  }
}
