import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../widgets/buttons/bh_button.dart';
import '../../widgets/navigation/bh_navigation.dart';
import '../../widgets/indicators/bh_indicators.dart';

// All remaining compliance screens

class FSSAIDetailScreen extends StatelessWidget {
  const FSSAIDetailScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BHAppBar(title: 'FSSAI Licence'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _LicenceHeader(title: 'FSSAI Food Business Licence', licenceNo: '11226098000001', validTill: '31-03-2026', status: 'Active', color: AppColors.goldAccent, icon: Icons.restaurant_rounded),
          const SizedBox(height: 20),
          Text('Licence Details', style: AppTypography.headlineMedium),
          const SizedBox(height: 12),
          _DetailCard([
            {'label': 'Licence Type', 'value': 'State Licence'},
            {'label': 'Food Category', 'value': 'Packaged Food'},
            {'label': 'Issued Date', 'value': '01-04-2023'},
            {'label': 'Valid Till', 'value': '31-03-2026'},
            {'label': 'Issuing Authority', 'value': 'FSSAI Karnataka'},
          ]),
          const SizedBox(height: 20),
          BHButton(label: 'Upload Renewal Documents', onPressed: () => context.push('/documents/upload'), type: BHButtonType.secondary, leadingIcon: Icons.upload_file_rounded),
          const SizedBox(height: 8),
          BHButton(label: 'Request CA Verification', onPressed: () => context.push('/compliance/verification'), leadingIcon: Icons.verified_rounded),
        ]),
      ),
    );
  }
}

class ShopActScreen extends StatelessWidget {
  const ShopActScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BHAppBar(title: 'Shop & Establishment'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _LicenceHeader(title: 'Shop & Establishment Registration', licenceNo: 'MH-MUM-S123456', validTill: '15-01-2025', status: 'Due Soon', color: AppColors.statusAmber, icon: Icons.storefront_rounded),
          const SizedBox(height: 20),
          Container(padding: const EdgeInsets.all(AppSpacing.lg), decoration: BoxDecoration(color: AppColors.lightAmber, borderRadius: BorderRadius.circular(AppRadius.card), border: Border.all(color: AppColors.statusAmber.withOpacity(0.3))), child: Row(children: [
            const Icon(Icons.warning_rounded, color: AppColors.statusAmber),
            const SizedBox(width: 10),
            Expanded(child: Text('Renewal due in 8 days. Late renewal attracts ₹200/day penalty.', style: AppTypography.bodySmall)),
          ])),
          const SizedBox(height: 16),
          BHButton(label: 'Renew Now', onPressed: () => context.push('/documents/upload')),
        ]),
      ),
    );
  }
}

class FactoryLicenseScreen extends StatelessWidget {
  const FactoryLicenseScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BHAppBar(title: 'Factory Licence'),
      body: Center(child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(width: 80, height: 80, decoration: BoxDecoration(color: AppColors.lightBlue, shape: BoxShape.circle), child: const Icon(Icons.factory_rounded, color: AppColors.primaryBlue, size: 40)),
          const SizedBox(height: 16),
          Text('Not Applicable', style: AppTypography.headlineLarge),
          const SizedBox(height: 8),
          Text('Factory Licence is not required for your business type (Retail Trading). If you start manufacturing, set it up here.', style: AppTypography.bodyMedium, textAlign: TextAlign.center),
          const SizedBox(height: 24),
          BHButton(label: 'Set Up Factory Compliance', onPressed: () {}, type: BHButtonType.secondary),
        ]),
      )),
    );
  }
}

class PollutionBoardScreen extends StatelessWidget {
  const PollutionBoardScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BHAppBar(title: 'Pollution Board NOC'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _LicenceHeader(title: 'Pollution Board NOC — Consent to Operate', licenceNo: 'PCB-KA-2024-001234', validTill: '30-06-2025', status: 'Active', color: AppColors.statusGreen, icon: Icons.eco_rounded),
          const SizedBox(height: 20),
          _DetailCard([
            {'label': 'Category', 'value': 'Green Category'},
            {'label': 'Consent Type', 'value': 'Consent to Operate (CTO)'},
            {'label': 'Issued By', 'value': 'KSPCB'},
            {'label': 'Valid Till', 'value': '30-06-2025'},
          ]),
          const SizedBox(height: 16),
          BHButton(label: 'View NOC Certificate', onPressed: () => context.push('/documents/preview'), type: BHButtonType.secondary, leadingIcon: Icons.visibility_rounded),
        ]),
      ),
    );
  }
}

class TrademarkScreen extends StatelessWidget {
  const TrademarkScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BHAppBar(title: 'Trademark'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _LicenceHeader(title: 'Trademark Registration — Class 29', licenceNo: 'TM-2024-5678901', validTill: 'Pending (Applied)', status: 'Pending', color: AppColors.statusAmber, icon: Icons.verified_rounded),
          const SizedBox(height: 20),
          Container(padding: const EdgeInsets.all(AppSpacing.lg), decoration: BoxDecoration(color: AppColors.lightAmber, borderRadius: BorderRadius.circular(AppRadius.card)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Application Status', style: AppTypography.labelLarge),
            const SizedBox(height: 12),
            ProgressBarWidget(label: 'Examination Stage', value: 0.4, color: AppColors.statusAmber, trailingLabel: '40%'),
          ])),
          const SizedBox(height: 16),
          BHButton(label: 'Track Application', onPressed: () {}, leadingIcon: Icons.track_changes_rounded),
        ]),
      ),
    );
  }
}

class PFESIScreen extends StatelessWidget {
  const PFESIScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BHAppBar(title: 'PF & ESI Compliance'),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          _StatsRow('PF UAN', 'MHROJ1234567890000', '8 Employees'),
          const SizedBox(height: 12),
          _StatsRow('ESI Number', 'KA1234567890001', '₹12,450 last month'),
          const SizedBox(height: 20),
          Text('Monthly Returns', style: AppTypography.headlineMedium),
          const SizedBox(height: 12),
          ...List.generate(4, (i) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.card), border: Border.all(color: AppColors.borderLight)),
              child: Row(children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(['PF Nov 2024', 'ESI Nov 2024', 'PF Oct 2024', 'ESI Oct 2024'][i], style: AppTypography.labelLarge),
                  Text(['Filed 15-12-2024', 'Filed 15-12-2024', 'Filed 15-11-2024', 'Filed 15-11-2024'][i], style: AppTypography.bodySmall),
                ]),
                const Spacer(),
                StatusChip(label: 'Compliant', status: 'compliant'),
              ]),
            ),
          )),
        ],
      ),
    );
  }
}

class ComplianceCalendarScreen extends StatelessWidget {
  const ComplianceCalendarScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final events = [
      {'day': 7, 'title': 'TDS Payment', 'color': 0xFF1A5FB4},
      {'day': 11, 'title': 'GSTR-1', 'color': 0xFF0D9488},
      {'day': 15, 'title': 'PF & ESI', 'color': 0xFF22C55E},
      {'day': 20, 'title': 'GSTR-3B', 'color': 0xFFF59E0B},
      {'day': 25, 'title': 'PT Payment', 'color': 0xFF6366F1},
      {'day': 31, 'title': 'TDS Return', 'color': 0xFFEF4444},
    ];
    return Scaffold(
      appBar: BHAppBar(title: 'Compliance Calendar'),
      body: Column(children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          color: Colors.white,
          child: Column(children: [
            Text('December 2024', style: AppTypography.headlineLarge),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, childAspectRatio: 1),
              itemCount: 31,
              itemBuilder: (context, i) {
                final day = i + 1;
                final event = events.where((e) => e['day'] == day).firstOrNull;
                return Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: event != null ? Color(event['color'] as int).withOpacity(0.15) : null,
                    shape: BoxShape.circle,
                  ),
                  child: Center(child: Text('$day', style: AppTypography.labelSmall.copyWith(
                    color: event != null ? Color(event['color'] as int) : AppColors.textPrimary,
                    fontWeight: event != null ? FontWeight.w700 : FontWeight.w400,
                  ))),
                );
              },
            ),
          ]),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              Text('Upcoming Events', style: AppTypography.headlineMedium),
              const SizedBox(height: 12),
              ...events.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.card), border: Border.all(color: AppColors.borderLight)),
                  child: Row(children: [
                    Container(width: 40, height: 40, decoration: BoxDecoration(color: Color(e['color'] as int).withOpacity(0.12), shape: BoxShape.circle), child: Center(child: Text('${e['day']}', style: AppTypography.labelLarge.copyWith(color: Color(e['color'] as int))))),
                    const SizedBox(width: 12),
                    Text(e['title'] as String, style: AppTypography.labelLarge),
                    const Spacer(),
                    Text('Dec ${e['day']}', style: AppTypography.dataMonoSmall),
                  ]),
                ),
              )),
            ],
          ),
        ),
      ]),
    );
  }
}

class AddComplianceScreen extends StatelessWidget {
  const AddComplianceScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BHAppBar(title: 'Add Compliance'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Manual Compliance Entry', style: AppTypography.headlineMedium),
          const SizedBox(height: 20),
          ...[
            {'label': 'Compliance Name', 'hint': 'e.g. GSTR-3B December'},
            {'label': 'Category', 'hint': 'GST / Income Tax / Labour / License'},
            {'label': 'Due Date', 'hint': 'DD-MM-YYYY'},
            {'label': 'Responsible Person', 'hint': 'CA Ravi Sharma'},
            {'label': 'Amount (if any)', 'hint': '₹0.00'},
            {'label': 'Notes', 'hint': 'Additional information...'},
          ].map((f) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(f['label']!, style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w500)),
              const SizedBox(height: 6),
              TextField(decoration: InputDecoration(hintText: f['hint'], filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: AppColors.borderLight)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: AppColors.borderLight)))),
            ]),
          )),
          const SizedBox(height: 8),
          BHButton(label: 'Add Compliance Item', onPressed: () => context.pop()),
        ]),
      ),
    );
  }
}

class ComplianceHistoryScreen extends StatelessWidget {
  const ComplianceHistoryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BHAppBar(title: 'Compliance History'),
      backgroundColor: AppColors.surfaceBackground,
      body: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.lg),
        itemCount: 12,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, i) {
          final categories = ['GSTR-3B', 'GSTR-1', 'TDS Return', 'PF Return', 'ESI Return', 'Advance Tax'];
          final months = ['Nov 2024', 'Nov 2024', 'Q2 FY25', 'Oct 2024', 'Oct 2024', 'Sep 2024'];
          final dates = ['18-12-2024', '11-12-2024', '31-10-2024', '15-11-2024', '15-11-2024', '15-09-2024'];
          return Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.card), border: Border.all(color: AppColors.borderLight)),
            child: Row(children: [
              Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.lightGreen, shape: BoxShape.circle), child: const Icon(Icons.check_rounded, color: AppColors.statusGreen)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('${categories[i % 6]} — ${months[i % 6]}', style: AppTypography.labelLarge),
                Text('Filed on ${dates[i % 6]}', style: AppTypography.bodySmall),
              ])),
              Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: AppColors.lightGreen, borderRadius: BorderRadius.circular(20)), child: Text('Filed', style: AppTypography.labelSmall.copyWith(color: AppColors.statusGreen, fontWeight: FontWeight.w600))),
            ]),
          ).animate().fadeIn(delay: Duration(milliseconds: i * 50));
        },
      ),
    );
  }
}

class VerificationRequestScreen extends StatelessWidget {
  const VerificationRequestScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BHAppBar(title: 'Request Verification'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(gradient: AppColors.tealGradient, borderRadius: BorderRadius.circular(16)),
            child: Column(children: [
              const Icon(Icons.verified_user_rounded, color: Colors.white, size: 48),
              const SizedBox(height: 12),
              Text('CA Verification Service', style: AppTypography.headlineLarge.copyWith(color: Colors.white), textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text('Get your compliance documents verified by a registered CA and receive an official certification stamp.', style: AppTypography.bodySmall.copyWith(color: Colors.white70), textAlign: TextAlign.center),
            ]),
          ),
          const SizedBox(height: 20),
          ...[
            {'icon': Icons.timer_rounded, 'label': 'Processing Time', 'value': '24-48 hours'},
            {'icon': Icons.currency_rupee_rounded, 'label': 'Verification Fee', 'value': '₹499 per document'},
            {'icon': Icons.security_rounded, 'label': 'Digital Signature', 'value': 'DSC certified'},
            {'icon': Icons.cloud_upload_rounded, 'label': 'Delivery', 'value': 'PDF + email'},
          ].map((item) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.card), border: Border.all(color: AppColors.borderLight)),
            child: Row(children: [
              Icon(item['icon'] as IconData, color: AppColors.verifiedTeal, size: 20),
              const SizedBox(width: 12),
              Text(item['label'] as String, style: AppTypography.bodyMedium),
              const Spacer(),
              Text(item['value'] as String, style: AppTypography.labelMedium.copyWith(color: AppColors.verifiedTeal)),
            ]),
          )),
          const SizedBox(height: 20),
          BHButton(label: 'Request Verification', onPressed: () => Navigator.pop(context), leadingIcon: Icons.verified_rounded),
        ]),
      ),
    );
  }
}

// Helper widgets
class _LicenceHeader extends StatelessWidget {
  final String title, licenceNo, validTill, status;
  final Color color;
  final IconData icon;
  const _LicenceHeader({required this.title, required this.licenceNo, required this.validTill, required this.status, required this.color, required this.icon});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(16)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: color, size: 28)),
        const SizedBox(height: 12),
        Text(title, style: AppTypography.headlineLarge.copyWith(color: Colors.white)),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Licence No.', style: AppTypography.labelSmall.copyWith(color: Colors.white60)),
            Text(licenceNo, style: AppTypography.dataMono.copyWith(color: Colors.white)),
          ])),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text('Valid Till', style: AppTypography.labelSmall.copyWith(color: Colors.white60)),
            Text(validTill, style: AppTypography.labelLarge.copyWith(color: color)),
          ]),
        ]),
      ]),
    );
  }
}

class _DetailCard extends StatelessWidget {
  final List<Map<String, String>> rows;
  const _DetailCard(this.rows);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.card), border: Border.all(color: AppColors.borderLight)),
      child: Column(children: rows.map((r) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(r['label']!, style: AppTypography.bodySmall),
          Text(r['value']!, style: AppTypography.labelMedium),
        ]),
      )).toList()),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final String label, value, sub;
  const _StatsRow(this.label, this.value, this.sub);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.card), border: Border.all(color: AppColors.borderLight)),
      child: Row(children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: AppTypography.bodySmall),
          Text(value, style: AppTypography.dataMono),
        ])),
        StatusChip(label: sub, status: 'compliant', isSmall: true),
      ]),
    );
  }
}
