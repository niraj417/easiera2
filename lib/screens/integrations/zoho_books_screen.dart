import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../widgets/buttons/bh_button.dart';
import '../../widgets/navigation/bh_navigation.dart';

// Additional Integrations screens

class ZohoBooksScreen extends StatelessWidget {
  const ZohoBooksScreen({super.key});
  @override
  Widget build(BuildContext context) => const _IntegrationDetailScreen(
    name: 'Zoho Books',
    icon: Icons.menu_book_rounded,
    color: AppColors.statusGreen,
    isConnected: false,
    description: 'Sync invoices, expenses, and financial reports from Zoho Books automatically.',
    features: ['Auto-import invoices', 'Expense categorisation', 'P&L sync', 'GST-ready reports'],
    steps: ['Log in to your Zoho Books account', 'Go to Settings → Integrations', 'Enable BizHealth360 API access', 'Paste the API key below'],
  );
}

class HRIntegrationScreen extends StatelessWidget {
  const HRIntegrationScreen({super.key});
  @override
  Widget build(BuildContext context) => const _IntegrationDetailScreen(
    name: 'HR System',
    icon: Icons.people_rounded,
    color: AppColors.statusAmber,
    isConnected: false,
    description: 'Connect GreytHR or Darwinbox to auto-populate PF, ESI, and professional tax data.',
    features: ['Employee headcount sync', 'Salary register import', 'PF/ESI auto-compute', 'Payroll-to-compliance link'],
    steps: ['Choose your HR platform (GreytHR / Darwinbox)', 'Generate API credentials', 'Enter them here', 'Click Connect'],
  );
}

class ExcelUploadScreen extends StatelessWidget {
  const ExcelUploadScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BHAppBar(title: 'Excel / CSV Upload'),
      backgroundColor: AppColors.surfaceBackground,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.xxl),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.primaryBlue.withOpacity(0.3), width: 2, style: BorderStyle.solid),
            ),
            child: Column(children: [
              Container(width: 64, height: 64, decoration: const BoxDecoration(color: AppColors.lightBlue, shape: BoxShape.circle), child: const Icon(Icons.upload_file_rounded, color: AppColors.primaryBlue, size: 32)),
              const SizedBox(height: 16),
              Text('Drag & Drop or Browse', style: AppTypography.headlineMedium),
              const SizedBox(height: 4),
              Text('Supports .xlsx, .xls, .csv — Max 10 MB', style: AppTypography.bodySmall),
              const SizedBox(height: 16),
              BHButton(label: 'Browse File', onPressed: () {}, type: BHButtonType.secondary, leadingIcon: Icons.folder_open_rounded),
            ]),
          ).animate().fadeIn(duration: 400.ms),
          const SizedBox(height: 24),
          Text('Supported Templates', style: AppTypography.headlineMedium),
          const SizedBox(height: 12),
          ...[
            {'title': 'Sales Register Template', 'desc': 'Upload monthly sales for GST mapping'},
            {'title': 'Purchase Register Template', 'desc': 'Import purchase invoices for ITC match'},
            {'title': 'Salary Register Template', 'desc': 'Upload payroll data for PF/ESI'},
            {'title': 'Compliance Tracker Template', 'desc': 'Bulk import compliance due dates'},
          ].map((t) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.card), border: Border.all(color: AppColors.borderLight)),
            child: Row(children: [
              const Icon(Icons.table_chart_rounded, color: AppColors.statusGreen, size: 22),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(t['title']!, style: AppTypography.labelLarge),
                Text(t['desc']!, style: AppTypography.bodySmall),
              ])),
              TextButton(onPressed: () {}, child: Text('Download', style: AppTypography.labelSmall.copyWith(color: AppColors.primaryBlue))),
            ]),
          )),
        ]),
      ),
    );
  }
}

class _IntegrationDetailScreen extends StatefulWidget {
  final String name, description;
  final IconData icon;
  final Color color;
  final bool isConnected;
  final List<String> features, steps;
  const _IntegrationDetailScreen({required this.name, required this.icon, required this.color, required this.isConnected, required this.description, required this.features, required this.steps});
  @override
  State<_IntegrationDetailScreen> createState() => _IntegrationDetailScreenState();
}

class _IntegrationDetailScreenState extends State<_IntegrationDetailScreen> {
  bool _connected = false;
  bool _connecting = false;

  @override
  void initState() {
    super.initState();
    _connected = widget.isConnected;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BHAppBar(title: '${widget.name} Integration'),
      backgroundColor: AppColors.surfaceBackground,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              color: widget.color.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: widget.color.withOpacity(0.2)),
            ),
            child: Row(children: [
              Container(width: 56, height: 56, decoration: BoxDecoration(color: widget.color.withOpacity(0.15), borderRadius: BorderRadius.circular(12)), child: Icon(widget.icon, color: widget.color, size: 28)),
              const SizedBox(width: 16),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(widget.name, style: AppTypography.headlineLarge),
                Text(widget.description, style: AppTypography.bodySmall.copyWith(height: 1.4)),
              ])),
            ]),
          ),
          const SizedBox(height: 20),
          Text('Features', style: AppTypography.headlineMedium),
          const SizedBox(height: 10),
          ...widget.features.map((f) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(children: [
              Icon(Icons.check_circle_rounded, color: widget.color, size: 16),
              const SizedBox(width: 10),
              Text(f, style: AppTypography.bodyMedium),
            ]),
          )),
          const SizedBox(height: 20),
          Text('Setup Steps', style: AppTypography.headlineMedium),
          const SizedBox(height: 10),
          ...widget.steps.asMap().entries.map((e) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(width: 24, height: 24, decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle), child: Center(child: Text('${e.key + 1}', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)))),
              const SizedBox(width: 12),
              Expanded(child: Padding(padding: const EdgeInsets.only(top: 2), child: Text(e.value, style: AppTypography.bodyMedium))),
            ]),
          )),
          const SizedBox(height: 24),
          if (_connected)
            BHButton(label: 'Disconnect', onPressed: () => setState(() => _connected = false), type: BHButtonType.danger)
          else
            BHButton(
              label: _connecting ? 'Connecting…' : 'Connect ${widget.name}',
              onPressed: _connecting ? null : () async {
                setState(() => _connecting = true);
                await Future.delayed(const Duration(seconds: 2));
                if (mounted) setState(() { _connecting = false; _connected = true; });
              },
              isLoading: _connecting,
              leadingIcon: Icons.link_rounded,
            ),
        ]),
      ),
    );
  }
}
