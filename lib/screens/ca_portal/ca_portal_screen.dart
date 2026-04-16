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

// CA Portal screens

class CAPortalScreen extends StatelessWidget {
  const CAPortalScreen({super.key});

  final List<Map<String, dynamic>> _clients = const [
    {'name': 'Sharma Trading Pvt. Ltd.', 'gstin': '29AABCS1234Z1ZV', 'score': 78, 'status': 'compliant', 'pending': 1},
    {'name': 'Patel Foods LLP', 'gstin': '27AAECP5555Q1ZR', 'score': 62, 'status': 'due_soon', 'pending': 3},
    {'name': 'Gupta Services Pvt. Ltd.', 'gstin': '07AAACG7890B1ZX', 'score': 88, 'status': 'compliant', 'pending': 0},
    {'name': 'Mehta Exports Ltd.', 'gstin': '33AABCM2468A1ZN', 'score': 45, 'status': 'overdue', 'pending': 5},
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
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('CA Portal', style: AppTypography.headlineLarge),
          Text('CA Ravi Sharma, FCA', style: AppTypography.bodySmall.copyWith(color: AppColors.verifiedTeal)),
        ]),
        actions: [
          IconButton(onPressed: () => context.push('/ca/add-client'), icon: Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: AppColors.primaryBlue, borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.person_add_rounded, color: Colors.white, size: 18))),
          const SizedBox(width: 8),
        ],
        bottom: const PreferredSize(preferredSize: Size.fromHeight(1), child: Divider(height: 1)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // CA Summary
          const Row(children: [
            _CAStat('4', 'Clients', AppColors.primaryBlue),
            SizedBox(width: 10),
            _CAStat('9', 'Pending\nActions', AppColors.statusAmber),
            SizedBox(width: 10),
            _CAStat('1', 'Overdue\nClients', AppColors.statusRed),
            SizedBox(width: 10),
            _CAStat('72', 'Avg\nScore', AppColors.statusGreen),
          ]),
          const SizedBox(height: AppSpacing.lg),
          Text('My Clients', style: AppTypography.headlineMedium),
          const SizedBox(height: AppSpacing.sm),
          ..._clients.asMap().entries.map((entry) {
            final i = entry.key;
            final client = entry.value;
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.card), border: Border.all(color: AppColors.borderLight)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Container(width: 44, height: 44, decoration: const BoxDecoration(gradient: AppColors.primaryGradient, shape: BoxShape.circle), child: Center(child: Text(client['name'].toString().substring(0, 1), style: AppTypography.headlineMedium.copyWith(color: Colors.white, fontWeight: FontWeight.w700)))),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(client['name'] as String, style: AppTypography.labelLarge),
                    Text(client['gstin'] as String, style: AppTypography.dataMonoSmall),
                  ])),
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Text('${client['score']}', style: AppTypography.headlineMedium.copyWith(color: _scoreColor(client['score'] as int), fontWeight: FontWeight.w700)),
                    StatusChip(label: client['status'] == 'compliant' ? 'Compliant' : client['status'] == 'due_soon' ? 'Due Soon' : 'Overdue', status: client['status'] as String, isSmall: true),
                  ]),
                ]),
                if ((client['pending'] as int) > 0) ...[
                  const SizedBox(height: 8),
                  Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: AppColors.lightAmber, borderRadius: BorderRadius.circular(8)), child: Text('${client['pending']} pending actions', style: AppTypography.labelSmall.copyWith(color: AppColors.statusAmber))),
                ],
                const SizedBox(height: 8),
                Row(children: [
                  Expanded(child: BHButton(label: 'View Dashboard', onPressed: () => context.push('/ca/client-dashboard'), type: BHButtonType.secondary)),
                  const SizedBox(width: 8),
                  Expanded(child: BHButton(label: 'File Returns', onPressed: () => context.push('/compliance/gst'))),
                ]),
              ]),
            ).animate().fadeIn(delay: Duration(milliseconds: i * 80));
          }),
        ]),
      ),
    );
  }

  Color _scoreColor(int score) => score >= 80 ? AppColors.statusGreen : score >= 60 ? AppColors.statusAmber : AppColors.statusRed;
}

class _CAStat extends StatelessWidget {
  final String value, label;
  final Color color;
  const _CAStat(this.value, this.label, this.color);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.card), border: Border.all(color: AppColors.borderLight)),
        child: Column(children: [
          Text(value, style: AppTypography.headlineLarge.copyWith(color: color, fontWeight: FontWeight.w800)),
          Text(label, style: AppTypography.labelSmall, textAlign: TextAlign.center),
        ]),
      ),
    );
  }
}

class CAClientDashboardScreen extends StatelessWidget {
  const CAClientDashboardScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BHAppBar(title: 'Sharma Trading Pvt. Ltd.'),
      backgroundColor: AppColors.surfaceBackground,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(16)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Client Health Score', style: AppTypography.labelMedium.copyWith(color: Colors.white70)),
              Text('78 / 100', style: AppTypography.displayLarge.copyWith(color: Colors.white, fontWeight: FontWeight.w800)),
              const SizedBox(height: 16),
              const Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                _ClientStat('GST', '85', AppColors.statusGreen),
                _ClientStat('TDS', '↓ Overdue', AppColors.statusRed),
                _ClientStat('PF', '80', AppColors.statusGreen),
                _ClientStat('Licence', '65', AppColors.statusAmber),
              ]),
            ]),
          ),
          const SizedBox(height: 20),
          Text('Pending Actions', style: AppTypography.headlineMedium),
          const SizedBox(height: 12),
          ComplianceCard(title: 'TDS Return Q3 FY25 — Overdue', category: 'Income Tax', status: 'overdue', dueDate: DateTime.now().subtract(const Duration(days: 2)), onTap: () => context.push('/compliance/gst/detail')),
          const SizedBox(height: 8),
          ComplianceCard(title: 'GSTR-3B December 2024', category: 'GST', status: 'due_soon', dueDate: DateTime.now().add(const Duration(days: 5)), onTap: () => context.push('/compliance/gst/detail')),
          const SizedBox(height: 20),
          BHButton(label: 'File Return on Behalf', onPressed: () => context.push('/compliance/gst'), leadingIcon: Icons.upload_rounded),
          const SizedBox(height: 8),
          BHButton(label: 'Generate Client Report', onPressed: () => context.push('/ai-advisor/report'), type: BHButtonType.secondary, leadingIcon: Icons.summarize_rounded),
        ]),
      ),
    );
  }
}

class _ClientStat extends StatelessWidget {
  final String label, value;
  final Color color;
  const _ClientStat(this.label, this.value, this.color);
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(value, style: AppTypography.labelLarge.copyWith(color: color, fontSize: 11)),
      Text(label, style: AppTypography.labelSmall.copyWith(color: Colors.white60)),
    ]);
  }
}

class AddCAClientScreen extends StatelessWidget {
  const AddCAClientScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BHAppBar(title: 'Add Client'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Connect a new client to your CA portal. They will receive an invitation to grant you access.', style: AppTypography.bodyMedium),
          const SizedBox(height: 24),
          ...[
            {'label': 'Client Business Name', 'hint': 'ABC Pvt. Ltd.'},
            {'label': 'PAN Number', 'hint': 'AAAPL1234C'},
            {'label': 'GSTIN (Optional)', 'hint': '29AAAPL1234C1ZV'},
            {'label': 'Contact Person', 'hint': 'Owner Name'},
            {'label': 'Contact Mobile', 'hint': '+91 98765 43210'},
            {'label': 'Access Level', 'hint': 'CA - Full Access'},
          ].map((f) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(f['label']!, style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w500)),
              const SizedBox(height: 6),
              TextField(decoration: InputDecoration(hintText: f['hint'], filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.borderLight)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.borderLight)))),
            ]),
          )),
          BHButton(label: 'Send Invitation', onPressed: () => context.pop(), leadingIcon: Icons.send_rounded),
        ]),
      ),
    );
  }
}
