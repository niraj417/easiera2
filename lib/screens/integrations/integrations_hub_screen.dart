import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../widgets/buttons/bh_button.dart';
import '../../widgets/navigation/bh_navigation.dart';

// Integrations Hub screens

class IntegrationsHubScreen extends StatefulWidget {
  const IntegrationsHubScreen({super.key});
  @override
  State<IntegrationsHubScreen> createState() => _IntegrationsHubScreenState();
}

class _IntegrationsHubScreenState extends State<IntegrationsHubScreen> {
  final Map<String, bool> _connected = {'Tally Prime': true, 'Zoho Books': false, 'QuickBooks': false, 'Bank (HDFC)': true, 'Bank (SBI)': false, 'TRACES Portal': true, 'FSSAI': false, 'ROC (MCA)': false, 'GST': false};

  final List<Map<String, dynamic>> _integrations = const [
    {'name': 'Tally Prime', 'category': 'Accounting', 'icon': Icons.receipt, 'color': 0xFF1A5FB4, 'desc': 'Sync vouchers & balance sheet'},
    {'name': 'Zoho Books', 'category': 'Accounting', 'icon': Icons.menu_book, 'color': 0xFF22C55E, 'desc': 'Auto-import invoices & expenses'},
    {'name': 'QuickBooks', 'category': 'Accounting', 'icon': Icons.calculate, 'color': 0xFF6366F1, 'desc': 'Cloud accounting sync'},
    {'name': 'Bank (HDFC)', 'category': 'Banking', 'icon': Icons.account_balance_wallet, 'color': 0xFFF5B800, 'desc': 'Auto bank statement fetch'},
    {'name': 'Bank (SBI)', 'category': 'Banking', 'icon': Icons.account_balance_wallet, 'color': 0xFF0D9488, 'desc': 'Real-time payment alerts'},
    {'name': 'FSSAI', 'category': 'Compliances', 'icon': Icons.restaurant_menu_rounded, 'color': 0xFFF59E0B, 'desc': 'License status & renewal sync'},
    {'name': 'ROC (MCA)', 'category': 'Compliances', 'icon': Icons.gavel_rounded, 'color': 0xFF1A5FB4, 'desc': 'Sync CIN & master data'},
    {'name': 'GST', 'category': 'Compliances', 'icon': Icons.payments_rounded, 'color': 0xFF6366F1, 'desc': 'GSTIN status & return tracking'},
    {'name': 'TRACES Portal', 'category': 'Government', 'icon': Icons.business_center, 'color': 0xFFEF4444, 'desc': 'Auto TDS certificate download'},
    {'name': 'MCA21 Portal', 'category': 'Government', 'icon': Icons.domain, 'color': 0xFF1A5FB4, 'desc': 'ROC filing status sync'},
    {'name': 'IEC/DGFT', 'category': 'Government', 'icon': Icons.import_export, 'color': 0xFF6366F1, 'desc': 'Import Export Code management'},
    {'name': 'Darwinbox HR', 'category': 'HR System', 'icon': Icons.people, 'color': 0xFF22C55E, 'desc': 'Employee data for PF/ESI'},
    {'name': 'GreytHR', 'category': 'HR System', 'icon': Icons.manage_accounts, 'color': 0xFFF59E0B, 'desc': 'Payroll data sync'},
  ];

  @override
  Widget build(BuildContext context) {
    final categories = ['Compliances', 'Accounting', 'Banking', 'Government', 'HR System'];
    return Scaffold(
      appBar: const BHAppBar(title: 'Integrations Hub'),
      backgroundColor: AppColors.surfaceBackground,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: categories.map((cat) {
            final items = _integrations.where((e) => e['category'] == cat).toList();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(cat, style: AppTypography.headlineMedium),
                ),
                ...items.map((item) {
                  final isConnected = _connected[item['name']] ?? false;
                  return InkWell(
                    onTap: cat == 'Compliances' 
                      ? () => context.push('/integrations/compliance/${item['name'].toString().split(' ')[0].toLowerCase()}')
                      : null,
                    borderRadius: BorderRadius.circular(AppRadius.card),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: Colors.white, 
                        borderRadius: BorderRadius.circular(AppRadius.card), 
                        border: Border.all(
                          color: isConnected ? Color(item['color'] as int).withOpacity(0.3) : AppColors.borderLight, 
                          width: isConnected ? 1.5 : 1
                        )
                      ),
                      child: Row(children: [
                        Container(width: 44, height: 44, decoration: BoxDecoration(color: Color(item['color'] as int).withOpacity(0.12), borderRadius: BorderRadius.circular(8)), child: Icon(item['icon'] as IconData, color: Color(item['color'] as int), size: 24)),
                        const SizedBox(width: 12),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(item['name'] as String, style: AppTypography.labelLarge),
                          Text(item['desc'] as String, style: AppTypography.bodySmall),
                        ])),
                        if (cat == 'Compliances')
                          Icon(isConnected ? Icons.check_circle_rounded : Icons.arrow_forward_ios_rounded, 
                               color: isConnected ? AppColors.statusGreen : AppColors.neutralGrey, size: 20)
                        else
                          Switch(
                            value: isConnected,
                            activeThumbColor: Color(item['color'] as int),
                            onChanged: (v) => setState(() => _connected[item['name'] as String] = v),
                          ),
                      ]),
                    ),
                  ).animate().fadeIn(delay: 100.ms);
                }),
                const SizedBox(height: 8),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

class TallyConnectScreen extends StatelessWidget {
  const TallyConnectScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BHAppBar(title: 'Tally Prime Integration'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(16)),
            child: Row(children: [
              Container(width: 60, height: 60, decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.receipt_rounded, color: Colors.white, size: 32)),
              const SizedBox(width: 16),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Tally Prime', style: AppTypography.headlineLarge.copyWith(color: Colors.white)),
                Text('Connected • Last sync: 2 hrs ago', style: AppTypography.bodySmall.copyWith(color: Colors.white70)),
              ])),
              const Icon(Icons.check_circle_rounded, color: AppColors.statusGreen, size: 28),
            ]),
          ),
          const SizedBox(height: 24),
          Text('Synced Data', style: AppTypography.headlineMedium),
          const SizedBox(height: 12),
          ...[
            {'icon': Icons.receipt_long_rounded, 'label': 'Purchase & Sales Vouchers', 'count': '1,247 entries'},
            {'icon': Icons.account_balance_rounded, 'label': 'Balance Sheet', 'count': 'Q3 FY25 updated'},
            {'icon': Icons.currency_rupee_rounded, 'label': 'GST Sales Register', 'count': '₹2.4Cr this FY'},
            {'icon': Icons.people_rounded, 'label': 'Payroll Data', 'count': '8 employees'},
          ].map((item) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.card), border: Border.all(color: AppColors.borderLight)),
            child: Row(children: [
              Icon(item['icon'] as IconData, color: AppColors.primaryBlue, size: 20),
              const SizedBox(width: 12),
              Expanded(child: Text(item['label'] as String, style: AppTypography.labelMedium)),
              Text(item['count'] as String, style: AppTypography.bodySmall),
            ]),
          )),
          const SizedBox(height: 20),
          BHButton(label: 'Sync Now', onPressed: () {}, leadingIcon: Icons.sync_rounded),
          const SizedBox(height: 8),
          BHButton(label: 'Disconnect', onPressed: () => context.pop(), type: BHButtonType.danger),
        ]),
      ),
    );
  }
}

class BankStatementScreen extends StatelessWidget {
  const BankStatementScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BHAppBar(title: 'Bank Statement AI'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(16)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('HDFC Bank — Current Account', style: AppTypography.headlineLarge.copyWith(color: Colors.white)),
              Text('A/c: ****7890', style: AppTypography.bodySmall.copyWith(color: Colors.white60)),
              const SizedBox(height: 16),
              const Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                _BankStat('Balance', '₹12.4L'),
                _BankStat('Credits', '₹24.3L'),
                _BankStat('Debits', '₹11.9L'),
              ]),
            ]),
          ),
          const SizedBox(height: 20),
          Text('Recent Transactions', style: AppTypography.headlineMedium),
          const SizedBox(height: 12),
          ...List.generate(6, (i) {
            final isCredit = i % 2 == 0;
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.card), border: Border.all(color: AppColors.borderLight)),
              child: Row(children: [
                Container(width: 36, height: 36, decoration: BoxDecoration(color: (isCredit ? AppColors.statusGreen : AppColors.statusRed).withOpacity(0.12), shape: BoxShape.circle), child: Icon(isCredit ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded, color: isCredit ? AppColors.statusGreen : AppColors.statusRed, size: 18)),
                const SizedBox(width: 10),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(['Customer Payment', 'GST Tax Payment', 'Supplier Invoice', 'TDS Deposit', 'Customer Payment', 'Salary Transfer'][i], style: AppTypography.labelMedium),
                  Text('${DateTime.now().subtract(Duration(days: i + 1)).day}-12-2024', style: AppTypography.bodySmall),
                ])),
                Text('${isCredit ? '+' : '-'}₹${[(1.24), (0.62), (0.85), (0.31), (2.10), (1.85)][i]}L', style: AppTypography.labelLarge.copyWith(color: isCredit ? AppColors.statusGreen : AppColors.statusRed)),
              ]),
            ).animate().fadeIn(delay: Duration(milliseconds: i * 60));
          }),
        ]),
      ),
    );
  }
}

class _BankStat extends StatelessWidget {
  final String label, value;
  const _BankStat(this.label, this.value);
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(value, style: AppTypography.headlineMedium.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
      Text(label, style: AppTypography.labelSmall.copyWith(color: Colors.white60)),
    ]);
  }
}
