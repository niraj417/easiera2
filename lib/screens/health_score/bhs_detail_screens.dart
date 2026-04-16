import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../widgets/buttons/bh_button.dart';
import '../../widgets/navigation/bh_navigation.dart';
import '../../widgets/indicators/bh_indicators.dart';
import 'health_score_dashboard_screen.dart';

// ─── Reusable BHS Detail Base ────────────────────────────────────────────────

class _BHSDetailSheet extends StatelessWidget {
  final BHSCategory category;
  final List<Map<String, dynamic>> indicators;
  final List<_DataSource> dataSources;
  final String frequency;
  final bool isUnverified;
  final bool isPending;

  const _BHSDetailSheet({
    required this.category,
    required this.indicators,
    required this.dataSources,
    required this.frequency,
    this.isUnverified = false,
    this.isPending = false,
  });

  @override
  Widget build(BuildContext context) {
    final percent = isPending ? 0.0 : category.score / 100;

    return Scaffold(
      backgroundColor: AppColors.surfaceBackground,
      body: Column(
        children: [
          // Custom header with gradient
          Container(
            padding: EdgeInsets.fromLTRB(16, MediaQuery.of(context).padding.top + 4, 16, 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [category.color.withOpacity(0.9), category.color],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Container(
                        width: 36, height: 36,
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                        child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 16),
                      ),
                    ),
                    const Spacer(),
                    if (isUnverified)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.statusAmber.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.statusAmber.withOpacity(0.5)),
                        ),
                        child: Row(children: [
                          const Icon(Icons.warning_amber_rounded, color: AppColors.statusAmber, size: 12),
                          const SizedBox(width: 4),
                          Text('Unverified', style: AppTypography.labelSmall.copyWith(color: AppColors.statusAmber)),
                        ]),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      width: 48, height: 48,
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                      child: Icon(category.icon, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(category.name, style: AppTypography.headlineLarge.copyWith(color: Colors.white)),
                        Text('Weight: ${(category.weight * 100).round()}% of overall BHS', style: AppTypography.bodySmall.copyWith(color: Colors.white70)),
                      ]),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Score display
                Row(
                  children: [
                    // Speedometer
                    CircularPercentIndicator(
                      radius: 52,
                      lineWidth: 10,
                      percent: percent,
                      center: isPending
                          ? const Icon(Icons.hourglass_empty_rounded, color: Colors.white, size: 22)
                          : Text('${category.score}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white)),
                      progressColor: Colors.white,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      circularStrokeCap: CircularStrokeCap.round,
                      animation: true,
                      animationDuration: 1000,
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        if (!isPending) ...[
                          Text(category.rating, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white)),
                          Text(category.ratingLabel, style: AppTypography.labelMedium.copyWith(color: Colors.white70)),
                        ] else ...[
                          Text('No Data', style: AppTypography.headlineLarge.copyWith(color: Colors.white)),
                          Text('Add data to unlock your score', style: AppTypography.bodySmall.copyWith(color: Colors.white70)),
                        ],
                      ]),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Indicators
                  Text('Score Indicators', style: AppTypography.headlineMedium).animate().fadeIn(duration: 400.ms),
                  const SizedBox(height: AppSpacing.sm),
                  ...indicators.asMap().entries.map((e) {
                    final ind = e.value;
                    final score = ind['score'] as int;
                    final color = ind['color'] as Color;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.borderLight),
                      ),
                      child: Row(children: [
                        Container(
                          width: 36, height: 36,
                          decoration: BoxDecoration(color: color.withOpacity(0.12), shape: BoxShape.circle),
                          child: Icon(ind['icon'] as IconData, color: color, size: 18),
                        ),
                        const SizedBox(width: 10),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(ind['name'] as String, style: AppTypography.labelMedium),
                          const SizedBox(height: 4),
                          ProgressBarWidget(label: '', value: score / 100, color: color, trailingLabel: '$score%'),
                        ])),
                      ]),
                    ).animate().fadeIn(delay: Duration(milliseconds: 80 * e.key));
                  }),

                  const SizedBox(height: AppSpacing.lg),

                  // Data Sources
                  Text('Data Input Methods', style: AppTypography.headlineMedium),
                  const SizedBox(height: AppSpacing.sm),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.lightBlue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(children: [
                      const Icon(Icons.schedule_rounded, color: AppColors.primaryBlue, size: 14),
                      const SizedBox(width: 6),
                      Text('Update Frequency: $frequency', style: AppTypography.labelSmall.copyWith(color: AppColors.primaryBlue)),
                    ]),
                  ),
                  const SizedBox(height: 10),
                  ...dataSources.map((ds) => _DataSourceCard(source: ds)),

                  const SizedBox(height: AppSpacing.lg),

                  // Trend chart
                  Text('6-Month Trend', style: AppTypography.headlineMedium),
                  const SizedBox(height: AppSpacing.sm),
                  Container(
                    height: 100,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderLight)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ...[
                          ['Oct', 65],
                          ['Nov', 68],
                          ['Dec', 70],
                          ['Jan', 72],
                          ['Feb', 75],
                          ['Mar', category.isPending ? 0 : category.score],
                        ].map((m) {
                          final s = m[1] as int;
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text('$s', style: AppTypography.labelSmall.copyWith(color: category.color, fontWeight: FontWeight.w600, fontSize: 9)),
                              const SizedBox(height: 2),
                              Container(
                                width: 24,
                                height: s == 0 ? 4 : (s - 60) * 2.2,
                                decoration: BoxDecoration(
                                  color: s == 0 ? AppColors.borderLight : category.color.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(m[0] as String, style: const TextStyle(fontSize: 8, color: AppColors.textTertiary)),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // Action buttons
                  if (isUnverified) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.lightAmber,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.statusAmber.withOpacity(0.3)),
                      ),
                      child: Row(children: [
                        const Icon(Icons.warning_amber_rounded, color: AppColors.statusAmber, size: 18),
                        const SizedBox(width: 10),
                        Expanded(child: Text(
                          'This data is unverified. Request our CA/expert team to validate for an official rating.',
                          style: AppTypography.bodySmall,
                        )),
                      ]),
                    ),
                    const SizedBox(height: 12),
                    BHButton(
                      label: 'Request Expert Verification',
                      onPressed: () => context.push('/compliance/verification'),
                      leadingIcon: Icons.verified_user_outlined,
                    ),
                    const SizedBox(height: 8),
                  ],
                  BHButton(
                    label: 'Update ${category.shortName} Data',
                    onPressed: () {},
                    type: BHButtonType.secondary,
                    leadingIcon: Icons.edit_rounded,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Data Source Card ─────────────────────────────────────────────────────────

class _DataSourceCard extends StatelessWidget {
  final _DataSource source;
  const _DataSourceCard({required this.source});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: source.onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(children: [
              Container(
                width: 38, height: 38,
                decoration: BoxDecoration(color: source.color.withOpacity(0.1), shape: BoxShape.circle),
                child: Icon(source.icon, color: source.color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(source.title, style: AppTypography.labelMedium),
                Text(source.subtitle, style: AppTypography.bodySmall),
              ])),
              const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.neutralGrey),
            ]),
          ),
        ),
      ),
    );
  }
}

class _DataSource {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const _DataSource({required this.title, required this.subtitle, required this.icon, required this.color, this.onTap});
}

// ═══════════════════════════════════════════════════════════════════════════
// Compliance Health Score (CHS) — 20% weight
// ═══════════════════════════════════════════════════════════════════════════

class CHSDetailScreen extends StatelessWidget {
  const CHSDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cat = bhsCategories.firstWhere((c) => c.id == 'chs');
    return _BHSDetailSheet(
      category: cat,
      frequency: 'Monthly / Real-time',
      indicators: const [
        {'name': 'Filing Timeliness', 'score': 90, 'icon': Icons.access_time_rounded, 'color': AppColors.statusGreen},
        {'name': 'Error-Free Returns', 'score': 85, 'icon': Icons.check_circle_outline_rounded, 'color': AppColors.statusGreen},
        {'name': 'Certificate Renewals', 'score': 72, 'icon': Icons.verified_rounded, 'color': AppColors.statusAmber},
        {'name': 'License Validity', 'score': 80, 'icon': Icons.card_membership_rounded, 'color': AppColors.statusGreen},
      ],
      dataSources: [
        _DataSource(title: 'Government Portals API', subtitle: 'Auto-sync GST, MCA, Income Tax data', icon: Icons.account_balance_rounded, color: AppColors.primaryBlue, onTap: () => context.push('/integrations')),
        _DataSource(title: 'Upload Certificates / Licenses', subtitle: 'OCR-based extraction of validity dates', icon: Icons.upload_file_rounded, color: AppColors.verifiedTeal, onTap: () => context.push('/documents/upload')),
        const _DataSource(title: 'Manual Entry', subtitle: 'Manually record compliance status', icon: Icons.edit_note_rounded, color: AppColors.neutralGrey),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Financial Health Score (FHS) — 30% weight
// ═══════════════════════════════════════════════════════════════════════════

class FHSDetailScreen extends StatelessWidget {
  const FHSDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cat = bhsCategories.firstWhere((c) => c.id == 'fhs');
    return _BHSDetailSheet(
      category: cat,
      frequency: 'Monthly or Real-time',
      isUnverified: cat.isUnverified,
      indicators: const [
        {'name': 'Profit Margin', 'score': 72, 'icon': Icons.trending_up_rounded, 'color': AppColors.statusGreen},
        {'name': 'Expense Ratio', 'score': 68, 'icon': Icons.pie_chart_rounded, 'color': AppColors.statusAmber},
        {'name': 'Liquidity Ratio', 'score': 80, 'icon': Icons.water_drop_rounded, 'color': AppColors.statusGreen},
        {'name': 'Debt-to-Equity', 'score': 74, 'icon': Icons.balance_rounded, 'color': AppColors.statusGreen},
      ],
      dataSources: [
        _DataSource(title: 'Connect Accounting API', subtitle: 'Tally, Zoho Books, QuickBooks integration', icon: Icons.link_rounded, color: const Color(0xFF22C55E), onTap: () => context.push('/integrations')),
        _DataSource(title: 'Upload Ledger / P&L', subtitle: 'Upload Excel or PDF — marked Unverified until reviewed', icon: Icons.upload_file_rounded, color: AppColors.statusAmber, onTap: () => context.push('/documents/upload')),
        _DataSource(title: 'Bank Statement Import', subtitle: 'Auto-extract transactions for analysis', icon: Icons.account_balance_wallet_rounded, color: AppColors.primaryBlue, onTap: () => context.push('/integrations/bank')),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// HR Productivity Score (HPS) — 15% weight
// ═══════════════════════════════════════════════════════════════════════════

class HPSDetailScreen extends StatelessWidget {
  const HPSDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cat = bhsCategories.firstWhere((c) => c.id == 'hps');
    return _BHSDetailSheet(
      category: cat,
      frequency: 'Monthly or Real-time',
      indicators: const [
        {'name': 'Employee Retention Rate', 'score': 70, 'icon': Icons.people_rounded, 'color': Color(0xFF8B5CF6)},
        {'name': 'Payroll Regularity', 'score': 80, 'icon': Icons.payments_rounded, 'color': Color(0xFF8B5CF6)},
        {'name': 'Attendance Rate', 'score': 75, 'icon': Icons.calendar_month_rounded, 'color': AppColors.statusAmber},
        {'name': 'Training & Development', 'score': 50, 'icon': Icons.school_rounded, 'color': AppColors.statusRed},
      ],
      dataSources: [
        _DataSource(title: 'Connect HRM API', subtitle: 'Zoho People, GreytHR, Keka integration', icon: Icons.link_rounded, color: const Color(0xFF8B5CF6), onTap: () => context.push('/integrations/hr')),
        _DataSource(title: 'Upload Payroll Excel', subtitle: 'Monthly payroll sheet — analysed by system', icon: Icons.upload_file_rounded, color: AppColors.statusAmber, onTap: () => context.push('/integrations/excel')),
        const _DataSource(title: 'Manual Entry', subtitle: 'Enter headcount, retention %, payroll data', icon: Icons.edit_note_rounded, color: AppColors.neutralGrey),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Stakeholder Health Score (SHS) — 15% weight
// ═══════════════════════════════════════════════════════════════════════════

class SHSDetailScreen extends StatelessWidget {
  const SHSDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cat = bhsCategories.firstWhere((c) => c.id == 'shs');
    return _BHSDetailSheet(
      category: cat,
      frequency: 'Monthly / Quarterly',
      isPending: cat.isPending,
      indicators: const [
        {'name': 'Customer Repeat Rate', 'score': 0, 'icon': Icons.repeat_rounded, 'color': AppColors.neutralGrey},
        {'name': 'Satisfaction Index (NPS)', 'score': 0, 'icon': Icons.star_rounded, 'color': AppColors.neutralGrey},
        {'name': 'Vendor Payment Timeliness', 'score': 0, 'icon': Icons.handshake_rounded, 'color': AppColors.neutralGrey},
      ],
      dataSources: [
        _DataSource(title: 'Connect CRM API', subtitle: 'Salesforce, Zoho CRM, HubSpot integration', icon: Icons.link_rounded, color: const Color(0xFF0D9488), onTap: () => context.push('/integrations')),
        _DataSource(title: 'Upload Survey Results', subtitle: 'Customer satisfaction survey Excel/PDF', icon: Icons.upload_file_rounded, color: AppColors.statusAmber, onTap: () => context.push('/documents/upload')),
        const _DataSource(title: 'Manual Input', subtitle: 'Enter NPS score, repeat customer %', icon: Icons.edit_note_rounded, color: AppColors.neutralGrey),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Operational Efficiency Score (OES) — 10% weight
// ═══════════════════════════════════════════════════════════════════════════

class OESDetailScreen extends StatelessWidget {
  const OESDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cat = bhsCategories.firstWhere((c) => c.id == 'oes');
    return _BHSDetailSheet(
      category: cat,
      frequency: 'Monthly / Real-time',
      indicators: const [
        {'name': 'Process Cycle Time', 'score': 65, 'icon': Icons.timer_rounded, 'color': AppColors.statusAmber},
        {'name': 'Automation Index', 'score': 70, 'icon': Icons.auto_mode_rounded, 'color': AppColors.statusAmber},
        {'name': 'Defect/Error Rate', 'score': 80, 'icon': Icons.bug_report_rounded, 'color': AppColors.statusGreen},
        {'name': 'Resource Utilisation', 'score': 70, 'icon': Icons.analytics_rounded, 'color': AppColors.statusAmber},
      ],
      dataSources: [
        _DataSource(title: 'Connect Internal Tools', subtitle: 'ERP, project management tool APIs', icon: Icons.link_rounded, color: const Color(0xFFF59E0B), onTap: () => context.push('/integrations')),
        _DataSource(title: 'Upload Process Reports', subtitle: 'Operations reports, SLA data', icon: Icons.upload_file_rounded, color: AppColors.statusAmber, onTap: () => context.push('/documents/upload')),
        const _DataSource(title: 'Manual Input', subtitle: 'Enter cycle time, error rates, utilisation', icon: Icons.edit_note_rounded, color: AppColors.neutralGrey),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Growth Outlook Score (GOS) — 10% weight
// ═══════════════════════════════════════════════════════════════════════════

class GOSDetailScreen extends StatelessWidget {
  const GOSDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cat = bhsCategories.firstWhere((c) => c.id == 'gos');
    return _BHSDetailSheet(
      category: cat,
      frequency: 'Quarterly / Real-time',
      indicators: const [
        {'name': 'Month-on-Month Sales Growth', 'score': 88, 'icon': Icons.trending_up_rounded, 'color': AppColors.statusGreen},
        {'name': 'Market Trend Alignment', 'score': 82, 'icon': Icons.bar_chart_rounded, 'color': AppColors.statusGreen},
        {'name': 'AI Revenue Forecast', 'score': 85, 'icon': Icons.psychology_rounded, 'color': AppColors.statusGreen},
        {'name': 'New Customer Acquisition', 'score': 78, 'icon': Icons.person_add_rounded, 'color': AppColors.statusAmber},
      ],
      dataSources: [
        _DataSource(title: 'Connect Accounting + AI', subtitle: 'Tally/Zoho + AI regression forecast', icon: Icons.auto_awesome_rounded, color: const Color(0xFFF5B800), onTap: () => context.push('/integrations')),
        _DataSource(title: 'Upload Sales Reports', subtitle: 'Monthly/quarterly P&L and sales data', icon: Icons.upload_file_rounded, color: AppColors.statusAmber, onTap: () => context.push('/documents/upload')),
        _DataSource(title: 'AI Advisor Analysis', subtitle: 'Get AI-driven growth projections', icon: Icons.psychology_rounded, color: AppColors.primaryBlue, onTap: () => context.push('/ai-advisor')),
      ],
    );
  }
}

// ─── Keep existing detail screens for backwards compat ──────────────────────

class HealthScoreDetailScreen extends StatelessWidget {
  final String dimension;
  const HealthScoreDetailScreen({super.key, this.dimension = 'BHS Detail'});

  @override
  Widget build(BuildContext context) => const CHSDetailScreen();
}

class HealthComparisonScreen extends StatelessWidget {
  const HealthComparisonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: BHAppBar(title: 'Industry Comparison'),
      body: Center(child: Text('Coming Soon')),
    );
  }
}

