import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../widgets/charts/gauge_chart.dart';
import '../../widgets/buttons/bh_button.dart';
import '../../widgets/cards/bh_cards.dart';
import '../../widgets/indicators/bh_indicators.dart';
import '../../widgets/navigation/bh_navigation.dart';
import '../../core/providers/bhs_provider.dart';

// ─── BHS Data Model ─────────────────────────────────────────────────────────

class BHSCategory {
  final String id;
  final String name;
  final String shortName;
  final double weight;
  final int score;
  final Color color;
  final IconData icon;
  final bool isPending;
  final bool isUnverified;

  const BHSCategory({
    required this.id,
    required this.name,
    required this.shortName,
    required this.weight,
    required this.score,
    required this.color,
    required this.icon,
    this.isPending = false,
    this.isUnverified = false,
  });

  String get rating {
    if (isPending) return 'Pending';
    if (score >= 90) return 'AAA';
    if (score >= 80) return 'AA';
    if (score >= 70) return 'A';
    if (score >= 60) return 'B';
    return 'C';
  }

  Color get ratingColor {
    if (isPending) return AppColors.neutralGrey;
    if (score >= 90) return AppColors.gradeAAA;
    if (score >= 80) return AppColors.gradeAA;
    if (score >= 70) return AppColors.gradeA;
    if (score >= 60) return AppColors.gradeB;
    return AppColors.gradeC;
  }

  String get ratingLabel {
    if (isPending) return 'Data Pending';
    if (score >= 90) return 'Excellent';
    if (score >= 80) return 'Good';
    if (score >= 70) return 'Satisfactory';
    if (score >= 60) return 'Need Improvement';
    return 'Poor';
  }

  String get route => '/health/$id';

  BHSCategory copyWith({int? score, bool? isPending}) {
    return BHSCategory(
      id: id,
      name: name,
      shortName: shortName,
      weight: weight,
      score: score ?? this.score,
      color: color,
      icon: icon,
      isPending: isPending ?? this.isPending,
      isUnverified: isUnverified,
    );
  }
}


final List<BHSCategory> bhsCategories = [
  const BHSCategory(id: 'chs', name: 'Compliance Health Score', shortName: 'CHS', weight: 0.20, score: 82, color: Color(0xFF1A5FB4), icon: Icons.task_alt_rounded),
  const BHSCategory(id: 'fhs', name: 'Financial Health Score', shortName: 'FHS', weight: 0.30, score: 75, color: Color(0xFF22C55E), icon: Icons.account_balance_rounded, isUnverified: true),
  const BHSCategory(id: 'hps', name: 'HR Productivity Score', shortName: 'HPS', weight: 0.15, score: 68, color: Color(0xFF8B5CF6), icon: Icons.people_rounded),
  const BHSCategory(id: 'shs', name: 'Stakeholder Health Score', shortName: 'SHS', weight: 0.15, score: 0, color: Color(0xFF0D9488), icon: Icons.handshake_rounded, isPending: true),
  const BHSCategory(id: 'oes', name: 'Operational Efficiency Score', shortName: 'OES', weight: 0.10, score: 71, color: Color(0xFFF59E0B), icon: Icons.settings_rounded),
  const BHSCategory(id: 'gos', name: 'Growth Outlook Score', shortName: 'GOS', weight: 0.10, score: 85, color: Color(0xFFF5B800), icon: Icons.trending_up_rounded),
];

double get overallBHS {
  final active = bhsCategories.where((c) => !c.isPending);
  double weightedSum = 0;
  double totalWeight = 0;
  for (final c in active) {
    weightedSum += c.score * c.weight;
    totalWeight += c.weight;
  }
  return totalWeight > 0 ? weightedSum / totalWeight : 0;
}

// ─── BHS Dashboard Screen ──────────────────────────────────────────────────

class HealthScoreDashboardScreen extends ConsumerWidget {
  const HealthScoreDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bhsState = ref.watch(bhsProvider);

    return Scaffold(
      backgroundColor: AppColors.surfaceBackground,
      body: bhsState.when(
        data: (bhsData) {
          final categoriesData = bhsData['categories'] as Map<String, dynamic>? ?? {};
          final double overallScore = bhsData['overallScore'] ?? 0.0;
          
          List<BHSCategory> currentCategories = bhsCategories.map((cat) {
            final score = categoriesData[cat.id];
            if (score != null) {
              return cat.copyWith(score: (score as num).toInt(), isPending: false);
            }
            return cat;
          }).toList();

          double computedOverall = overallScore;
          if (computedOverall == 0.0) {
              final active = currentCategories.where((c) => !c.isPending);
              double weightedSum = 0;
              double totalWeight = 0;
              for (final c in active) {
                weightedSum += c.score * c.weight;
                totalWeight += c.weight;
              }
              computedOverall = totalWeight > 0 ? weightedSum / totalWeight : 0;
          }

          final overallRating = _getOverallRating(computedOverall);

          return Column(
            children: [
          // App bar
          Container(
            padding: EdgeInsets.fromLTRB(16, MediaQuery.of(context).padding.top + 8, 16, 12),
            color: Colors.white,
            child: Row(
              children: [
                const SizedBox(width: 4),
                Text('Business Health Score', style: AppTypography.headlineLarge),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.notifications_outlined, color: AppColors.textSecondary),
                  onPressed: () => context.push('/notifications'),
                ),
                GestureDetector(
                  onTap: () => context.push('/profile'),
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: const BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text('A', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(height: 1, color: AppColors.borderLight),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Master BHS Speedometer Card
                  _MasterBHSCard(score: computedOverall, rating: overallRating, categories: currentCategories).animate().fadeIn(duration: 600.ms),
                  const SizedBox(height: AppSpacing.lg),

                  // Rating legend
                  _RatingLegend(),
                  const SizedBox(height: AppSpacing.lg),

                  // Category header
                  Text('6 Health Categories', style: AppTypography.headlineMedium),
                  const SizedBox(height: 4),
                  Text('Tap any category to update data and view details', style: AppTypography.bodySmall),
                  const SizedBox(height: AppSpacing.md),

                  // 6 Category speedometer cards (2 per row)
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 0.78,
                    ),
                    itemCount: currentCategories.length,
                    itemBuilder: (ctx, i) => _CategoryCard(
                      category: currentCategories[i],
                    ).animate().fadeIn(delay: Duration(milliseconds: 100 * i)),
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // Action buttons
                  BHButton(
                    label: 'Download BHS Report',
                    onPressed: () => context.push('/ai-advisor/report'),
                    type: BHButtonType.secondary,
                    leadingIcon: Icons.download_rounded,
                  ),
                  const SizedBox(height: 10),
                  BHButton(
                    label: 'Request Expert Verification',
                    onPressed: () => context.push('/compliance/verification'),
                    type: BHButtonType.ghost,
                    leadingIcon: Icons.verified_user_outlined,
                  ),
                  const SizedBox(height: 28),

                  // ─── Compliance Summary ────────────────────────────────
                  _SectionHeader(
                    title: 'Compliance Overview',
                    actionLabel: 'View All',
                    onAction: () => context.push('/compliance'),
                  ).animate().fadeIn(delay: 200.ms),
                  const SizedBox(height: 12),
                  Row(children: const [
                    _StatusChipWidget('24 Active', AppColors.primaryBlue),
                    SizedBox(width: 8),
                    _StatusChipWidget('3 Due Soon', AppColors.statusAmber),
                    SizedBox(width: 8),
                    _StatusChipWidget('1 Overdue', AppColors.statusRed),
                  ]).animate().fadeIn(delay: 250.ms),
                  const SizedBox(height: 12),
                  ...const [
                    {'title': 'GSTR-3B (Dec)', 'cat': 'GST', 'status': 'due_soon', 'days': 5},
                    {'title': 'TDS Return Q3', 'cat': 'Income Tax', 'status': 'overdue', 'days': -2},
                    {'title': 'PF Monthly (Nov)', 'cat': 'Labour', 'status': 'compliant', 'days': 15},
                    {'title': 'FSSAI Annual', 'cat': 'License', 'status': 'pending', 'days': 30},
                  ].asMap().entries.map((e) {
                    final item = e.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: ComplianceCard(
                        title: item['title'] as String,
                        category: item['cat'] as String,
                        status: item['status'] as String,
                        dueDate: DateTime.now().add(Duration(days: item['days'] as int)),
                        onTap: () => context.push('/compliance/gst'),
                      ),
                    ).animate().fadeIn(delay: Duration(milliseconds: 300 + 80 * e.key));
                  }),
                  const SizedBox(height: 28),

                  // ─── Alerts & Notifications ───────────────────────────
                  _SectionHeader(
                    title: 'Alerts & Notifications',
                    actionLabel: 'View All',
                    onAction: () => context.push('/alerts'),
                  ).animate().fadeIn(delay: 350.ms),
                  const SizedBox(height: 12),
                  const _AlertBannerWidget(
                    title: '2 Critical Overdue Items',
                    subtitle: 'Immediate action required to avoid penalties',
                    color: AppColors.statusRed,
                    icon: Icons.error_rounded,
                  ),
                  const SizedBox(height: 8),
                  const _AlertBannerWidget(
                    title: '3 Items Due This Week',
                    subtitle: 'File before deadlines to stay compliant',
                    color: AppColors.statusAmber,
                    icon: Icons.warning_rounded,
                  ),
                  const SizedBox(height: 12),
                  ...[
                    {'text': 'TDS Q3 Overdue', 'status': 'overdue'},
                    {'text': 'GSTR-3B Due in 5 days', 'status': 'due_soon'},
                    {'text': 'Shop Act renewal in 20 days', 'status': 'due_soon'},
                    {'text': 'PF payment due in 7 days', 'status': 'due_soon'},
                    {'text': 'Income Tax Advance Tax', 'status': 'pending'},
                  ].asMap().entries.map((e) {
                    final item = e.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(AppRadius.card),
                          border: Border.all(color: AppColors.borderLight),
                        ),
                        child: Row(children: [
                          Icon(
                            Icons.circle,
                            color: {'overdue': AppColors.statusRed, 'due_soon': AppColors.statusAmber, 'pending': AppColors.neutralGrey}[item['status']] ?? AppColors.neutralGrey,
                            size: 8,
                          ),
                          const SizedBox(width: 12),
                          Expanded(child: Text(item['text'] as String, style: AppTypography.labelMedium)),
                          StatusChip(label: item['status'] as String, status: item['status'] as String),
                        ]),
                      ),
                    ).animate().fadeIn(delay: Duration(milliseconds: 400 + 60 * e.key));
                  }),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      );
    },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Map<String, dynamic> _getOverallRating(double score) {
    if (score >= 90) return {'rating': 'AAA', 'label': 'Excellent', 'color': AppColors.gradeAAA};
    if (score >= 80) return {'rating': 'AA', 'label': 'Good', 'color': AppColors.gradeAA};
    if (score >= 70) return {'rating': 'A', 'label': 'Satisfactory', 'color': AppColors.gradeA};
    if (score >= 60) return {'rating': 'B', 'label': 'Need Improvement', 'color': AppColors.gradeB};
    return {'rating': 'C', 'label': 'Poor — Urgent Action', 'color': AppColors.gradeC};
  }
}

// ─── Master BHS Card ─────────────────────────────────────────────────────────

class _MasterBHSCard extends StatelessWidget {
  final double score;
  final Map<String, dynamic> rating;
  final List<BHSCategory> categories;

  const _MasterBHSCard({required this.score, required this.rating, required this.categories});

  @override
  Widget build(BuildContext context) {
    final percent = score / 100;
    final ratingColor = rating['color'] as Color;

    return Container(
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
                Text('Complete BHS', style: AppTypography.headlineLarge.copyWith(color: Colors.white)),
              ]),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: ratingColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: ratingColor.withOpacity(0.5)),
                ),
                child: Row(children: [
                  Icon(Icons.star_rounded, color: ratingColor, size: 14),
                  const SizedBox(width: 4),
                  Text(rating['rating'] as String, style: AppTypography.labelMedium.copyWith(color: ratingColor, fontWeight: FontWeight.w800)),
                ]),
              ),
            ],
          ),
          const SizedBox(height: 20),

          GaugeChart(
            score: score,
            maxScore: 100,
            label: '',
            color: ratingColor,
            size: 180,
          ),

          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(rating['label'] as String, style: AppTypography.labelMedium.copyWith(color: Colors.white)),
          ),
          const SizedBox(height: 16),

          // Weight breakdown
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: categories.map((c) => Column(
              children: [
                Text(c.shortName, style: AppTypography.labelSmall.copyWith(color: Colors.white60, fontSize: 9)),
                const SizedBox(height: 2),
                Text(
                  c.isPending ? '--' : '${c.score}',
                  style: AppTypography.labelMedium.copyWith(
                    color: c.isPending ? Colors.white38 : c.color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            )).toList(),
          ),
        ],
      ),
    );
  }
}

// ─── Category Speedometer Card ────────────────────────────────────────────────

class _CategoryCard extends StatelessWidget {
  final BHSCategory category;
  const _CategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    final percent = category.isPending ? 0.0 : category.score / 100;

    return GestureDetector(
      onTap: () => context.push(category.route),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: category.isPending ? AppColors.borderLight : category.color.withOpacity(0.2),
            width: 1.5,
          ),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Header row: icon + weight
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 32, height: 32,
                  decoration: BoxDecoration(
                    color: category.isPending ? AppColors.surfaceBackground : category.color.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(category.icon, color: category.isPending ? AppColors.neutralGrey : category.color, size: 16),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceBackground,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${(category.weight * 100).round()}%',
                    style: AppTypography.labelSmall.copyWith(color: AppColors.neutralGrey, fontSize: 9),
                  ),
                ),
              ],
            ),

            // Speedometer
            CircularPercentIndicator(
              radius: 46,
              lineWidth: 8,
              percent: percent,
              center: category.isPending
                  ? const Icon(Icons.hourglass_empty_rounded, color: AppColors.neutralGrey, size: 20)
                  : Text(
                      '${category.score}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: category.color,
                      ),
                    ),
              progressColor: category.isPending ? AppColors.borderLight : category.color,
              backgroundColor: AppColors.surfaceBackground,
              circularStrokeCap: CircularStrokeCap.round,
              animation: true,
              animationDuration: 1000,
            ),

            // Name and rating
            Column(
              children: [
                Text(
                  category.shortName,
                  style: AppTypography.labelSmall.copyWith(fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: category.ratingColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        category.rating,
                        style: AppTypography.labelSmall.copyWith(
                          color: category.ratingColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    if (category.isUnverified) ...[
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.statusAmber.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text('⚠ Unverified', style: AppTypography.labelSmall.copyWith(color: AppColors.statusAmber, fontSize: 8)),
                      ),
                    ],
                  ],
                ),
              ],
            ),

            // Tap hint
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  category.isPending ? 'Tap to add data' : 'Tap to view details',
                  style: AppTypography.labelSmall.copyWith(color: AppColors.primaryBlue, fontSize: 9),
                ),
                const Icon(Icons.arrow_forward_ios_rounded, size: 8, color: AppColors.primaryBlue),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Rating Legend ─────────────────────────────────────────────────────────

class _RatingLegend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ratings = [
      {'code': 'AAA', 'label': 'Excellent', 'range': '≥ 90', 'color': AppColors.gradeAAA},
      {'code': 'AA', 'label': 'Good', 'range': '80–89', 'color': AppColors.gradeAA},
      {'code': 'A', 'label': 'Satisfactory', 'range': '70–79', 'color': AppColors.gradeA},
      {'code': 'B', 'label': 'Improve', 'range': '60–69', 'color': AppColors.gradeB},
      {'code': 'C', 'label': 'Poor', 'range': '< 60', 'color': AppColors.gradeC},
    ];

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Rating Scale', style: AppTypography.labelMedium.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 8),
          Row(
            children: ratings.map((r) => Expanded(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: (r['color'] as Color).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: Text(r['code'] as String, style: TextStyle(color: r['color'] as Color, fontWeight: FontWeight.w800, fontSize: 11)),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(r['range'] as String, style: const TextStyle(fontSize: 8, color: AppColors.textTertiary)),
                ],
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }
}

// ─── Score History Screen ──────────────────────────────────────────────────

// ─── Section Header ──────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final String actionLabel;
  final VoidCallback onAction;
  const _SectionHeader({required this.title, required this.actionLabel, required this.onAction});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTypography.headlineMedium),
        GestureDetector(
          onTap: onAction,
          child: Text(actionLabel, style: AppTypography.labelMedium.copyWith(color: AppColors.primaryBlue)),
        ),
      ],
    );
  }
}

// ─── Status Chip Widget ────────────────────────────────────────────────────

class _StatusChipWidget extends StatelessWidget {
  final String label;
  final Color color;
  const _StatusChipWidget(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: AppTypography.labelSmall.copyWith(color: color, fontWeight: FontWeight.w600)),
    );
  }
}

// ─── Alert Banner Widget ─────────────────────────────────────────────────────

class _AlertBannerWidget extends StatelessWidget {
  final String title, subtitle;
  final Color color;
  final IconData icon;
  const _AlertBannerWidget({required this.title, required this.subtitle, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: AppTypography.labelLarge.copyWith(color: color)),
            const SizedBox(height: 2),
            Text(subtitle, style: AppTypography.bodySmall),
          ]),
        ),
      ]),
    );
  }
}

// ─── Score History Screen ──────────────────────────────────────────────────

class ScoreHistoryScreen extends StatelessWidget {
  const ScoreHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BHAppBar(title: 'Score History'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('BHS Trend (Last 6 Months)', style: AppTypography.headlineMedium),
            const SizedBox(height: 16),
            Container(
              height: 160,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderLight)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ...['Oct', 'Nov', 'Dec', 'Jan', 'Feb', 'Mar'].asMap().entries.map((e) {
                    final scores = [68, 71, 73, 75, 76, 78];
                    final score = scores[e.key];
                    final height = (score - 60) * 4.0;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('$score', style: AppTypography.labelSmall.copyWith(color: AppColors.primaryBlue, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        Container(
                          width: 28,
                          height: height,
                          decoration: BoxDecoration(
                            color: AppColors.primaryBlue.withOpacity(e.key == 5 ? 1.0 : 0.5),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(e.value, style: AppTypography.labelSmall.copyWith(fontSize: 9)),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

