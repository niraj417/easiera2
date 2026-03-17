import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../widgets/buttons/bh_button.dart';
import '../../widgets/cards/bh_cards.dart';
import '../../widgets/indicators/bh_indicators.dart';
import '../../widgets/navigation/bh_navigation.dart';

// CA Portal — extra screens

class SwitchCompanyScreen extends StatefulWidget {
  const SwitchCompanyScreen({super.key});
  @override
  State<SwitchCompanyScreen> createState() => _SwitchCompanyScreenState();
}

class _SwitchCompanyScreenState extends State<SwitchCompanyScreen> {
  int _selected = 0;
  final List<Map<String, dynamic>> _companies = const [
    {'name': 'Sharma Trading Pvt. Ltd.', 'gstin': '29AABCS1234Z1ZV', 'score': 78, 'role': 'CA'},
    {'name': 'Patel Foods LLP', 'gstin': '27AAECP5555Q1ZR', 'score': 62, 'role': 'CA'},
    {'name': 'Gupta Services Pvt. Ltd.', 'gstin': '07AAACG7890B1ZX', 'score': 88, 'role': 'CA'},
    {'name': 'Mehta Exports Ltd.', 'gstin': '33AABCM2468A1ZN', 'score': 45, 'role': 'CA'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BHAppBar(title: 'Switch Company'),
      backgroundColor: AppColors.surfaceBackground,
      body: Column(children: [
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.lg),
            itemCount: _companies.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, i) {
              final c = _companies[i];
              final isSelected = i == _selected;
              final score = c['score'] as int;
              final scoreColor = score >= 80 ? AppColors.statusGreen : score >= 60 ? AppColors.statusAmber : AppColors.statusRed;
              return GestureDetector(
                onTap: () => setState(() => _selected = i),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppRadius.card),
                    border: Border.all(color: isSelected ? AppColors.primaryBlue : AppColors.borderLight, width: isSelected ? 2 : 1),
                  ),
                  child: Row(children: [
                    Container(width: 48, height: 48, decoration: BoxDecoration(gradient: isSelected ? AppColors.primaryGradient : null, color: isSelected ? null : AppColors.surfaceBackground, shape: BoxShape.circle), child: Center(child: Text(c['name'].toString().substring(0, 1), style: AppTypography.headlineLarge.copyWith(color: isSelected ? Colors.white : AppColors.primaryBlue, fontWeight: FontWeight.w700)))),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(c['name'] as String, style: AppTypography.labelLarge),
                      Text(c['gstin'] as String, style: AppTypography.dataMonoSmall),
                    ])),
                    Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                      Text('$score', style: AppTypography.headlineMedium.copyWith(color: scoreColor)),
                      if (isSelected) const Icon(Icons.check_circle_rounded, color: AppColors.primaryBlue, size: 20),
                    ]),
                  ]),
                ).animate().fadeIn(delay: Duration(milliseconds: i * 60)),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: BHButton(label: 'Switch to ${_companies[_selected]['name']}', onPressed: () => context.go('/dashboard'), trailingIcon: Icons.swap_horiz_rounded),
        ),
      ]),
    );
  }
}

class BulkReportsScreen extends StatelessWidget {
  const BulkReportsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BHAppBar(title: 'Bulk Reports', actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.download_rounded, color: AppColors.textSecondary)),
        const SizedBox(width: 4),
      ]),
      backgroundColor: AppColors.surfaceBackground,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(16)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Generate Bulk Reports', style: AppTypography.headlineLarge.copyWith(color: Colors.white)),
              Text('Download compliance reports for all 4 clients at once', style: AppTypography.bodySmall.copyWith(color: Colors.white60)),
            ]),
          ),
          const SizedBox(height: 20),
          Text('Report Types', style: AppTypography.headlineMedium),
          const SizedBox(height: 12),
          ...[
            {'title': 'Monthly Compliance Summary', 'desc': 'All tasks, due dates, and statuses for selected month', 'icon': Icons.summarize_rounded, 'color': AppColors.primaryBlue},
            {'title': 'BizHealth Score Report', 'desc': 'Detailed score breakdown per client in PDF', 'icon': Icons.monitor_heart_rounded, 'color': AppColors.statusGreen},
            {'title': 'GST Filing Summary', 'desc': 'All GSTR-1, GSTR-3B filed returns across clients', 'icon': Icons.receipt_long_rounded, 'color': AppColors.statusAmber},
            {'title': 'Pending Actions Report', 'desc': 'Overdue and upcoming items across all clients', 'icon': Icons.pending_actions_rounded, 'color': AppColors.statusRed},
          ].map((r) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.card), border: Border.all(color: AppColors.borderLight)),
            child: Row(children: [
              Container(width: 44, height: 44, decoration: BoxDecoration(color: (r['color'] as Color).withOpacity(0.12), borderRadius: BorderRadius.circular(8)), child: Icon(r['icon'] as IconData, color: r['color'] as Color, size: 22)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(r['title'] as String, style: AppTypography.labelLarge),
                Text(r['desc'] as String, style: AppTypography.bodySmall),
              ])),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(minimumSize: const Size(56, 32), padding: const EdgeInsets.symmetric(horizontal: 12), backgroundColor: r['color'] as Color),
                child: const Icon(Icons.download_rounded, color: Colors.white, size: 16),
              ),
            ]),
          )),
          const SizedBox(height: 20),
          Text('Recent Downloads', style: AppTypography.headlineMedium),
          const SizedBox(height: 12),
          ...List.generate(3, (i) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.card), border: Border.all(color: AppColors.borderLight)),
            child: Row(children: [
              const Icon(Icons.picture_as_pdf_rounded, color: AppColors.statusRed, size: 22),
              const SizedBox(width: 10),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(['Monthly Compliance Summary', 'GST Filing Summary', 'BizHealth Score Report'][i], style: AppTypography.labelMedium),
                Text(['Feb 2026', 'Jan 2026', 'Dec 2025'][i], style: AppTypography.bodySmall),
              ])),
              const Icon(Icons.file_download_outlined, color: AppColors.primaryBlue, size: 20),
            ]),
          )),
        ]),
      ),
    );
  }
}

class CASettingsScreen extends StatelessWidget {
  const CASettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BHAppBar(title: 'CA Settings'),
      backgroundColor: AppColors.surfaceBackground,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(16)),
            child: Row(children: [
              Container(width: 64, height: 64, decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle), child: const Icon(Icons.account_circle_rounded, color: Colors.white, size: 36)),
              const SizedBox(width: 16),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('CA Ravi Sharma', style: AppTypography.headlineLarge.copyWith(color: Colors.white)),
                Text('FCA, DISA, CISA', style: AppTypography.bodySmall.copyWith(color: Colors.white70)),
                Text('M. No: 123456', style: AppTypography.dataMonoSmall.copyWith(color: Colors.white.withOpacity(0.5))),
              ])),
            ]),
          ),
          const SizedBox(height: 20),
          ...[
            {'section': 'Professional Details', 'items': [
              {'label': 'Membership Number', 'value': 'M-123456'},
              {'label': 'Firm Name', 'value': 'Ravi Sharma & Associates'},
              {'label': 'Practice Region', 'value': 'Bengaluru, Karnataka'},
            ]},
            {'section': 'Portal Settings', 'items': [
              {'label': 'Client Access Level', 'value': 'Full (Default)'},
              {'label': 'Report Signature', 'value': 'Auto-sign enabled'},
              {'label': 'Invoice Prefix', 'value': 'RSA-INV-'},
            ]},
          ].map((sec) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(sec['section'] as String, style: AppTypography.headlineMedium),
            const SizedBox(height: 10),
            ...(sec['items'] as List<Map<String, String>>).map((item) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.card), border: Border.all(color: AppColors.borderLight)),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(item['label']!, style: AppTypography.bodySmall),
                Text(item['value']!, style: AppTypography.labelMedium),
              ]),
            )),
            const SizedBox(height: 16),
          ])),
          BHButton(label: 'Save Changes', onPressed: () => context.pop()),
        ]),
      ),
    );
  }
}
