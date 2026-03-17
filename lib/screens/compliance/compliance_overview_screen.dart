import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../widgets/cards/bh_cards.dart';
import '../../widgets/indicators/bh_indicators.dart';
import '../../widgets/navigation/bh_navigation.dart';


class ComplianceOverviewScreen extends StatefulWidget {
  const ComplianceOverviewScreen({super.key});
  @override
  State<ComplianceOverviewScreen> createState() => _ComplianceOverviewScreenState();
}

class _ComplianceOverviewScreenState extends State<ComplianceOverviewScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _items = [
    {'title': 'GSTR-3B (Dec)', 'cat': 'GST', 'status': 'due_soon', 'days': 5, 'tab': 0},
    {'title': 'GSTR-1 (Dec)', 'cat': 'GST', 'status': 'pending', 'days': 11, 'tab': 0},
    {'title': 'TDS Return Q3', 'cat': 'Income Tax', 'status': 'overdue', 'days': -2, 'tab': 1},
    {'title': 'Advance Tax Q3', 'cat': 'Income Tax', 'status': 'compliant', 'days': 45, 'tab': 1},
    {'title': 'PF Monthly (Nov)', 'cat': 'Labour', 'status': 'compliant', 'days': 15, 'tab': 2},
    {'title': 'ESI Monthly (Nov)', 'cat': 'Labour', 'status': 'compliant', 'days': 20, 'tab': 2},
    {'title': 'FSSAI Annual', 'cat': 'License', 'status': 'pending', 'days': 30, 'tab': 3},
    {'title': 'Shop Act Renewal', 'cat': 'License', 'status': 'due_soon', 'days': 8, 'tab': 3},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  List<Map<String, dynamic>> _filtered(int tab) =>
      tab == 4 ? _items : _items.where((e) => e['tab'] == tab).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('Compliance', style: AppTypography.headlineLarge),
        ),
        actions: [
          IconButton(
            icon: Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: AppColors.primaryBlue, borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.add_rounded, color: Colors.white, size: 18)),
            onPressed: () => context.push('/compliance/add'),
          ),
          IconButton(onPressed: () => context.push('/compliance/calendar'), icon: const Icon(Icons.calendar_month_rounded, color: AppColors.textSecondary)),
          const SizedBox(width: 4),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          tabs: const [
            Tab(text: 'GST'), Tab(text: 'Income Tax'), Tab(text: 'Labour'), Tab(text: 'Licenses'), Tab(text: 'Other'),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                _SummaryChip('24 Active', AppColors.primaryBlue),
                const SizedBox(width: 8),
                _SummaryChip('3 Due Soon', AppColors.statusAmber),
                const SizedBox(width: 8),
                _SummaryChip('1 Overdue', AppColors.statusRed),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: List.generate(5, (tab) {
                final items = _filtered(tab);
                if (items.isEmpty) {
                  return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(Icons.check_circle_rounded, color: AppColors.statusGreen, size: 48),
                    const SizedBox(height: 12),
                    Text('All clear!', style: AppTypography.headlineMedium.copyWith(color: AppColors.statusGreen)),
                    Text('No pending items in this category', style: AppTypography.bodyMedium),
                  ]));
                }
                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, i) {
                    final item = items[i];
                    return ComplianceCard(
                      title: item['title'],
                      category: item['cat'],
                      status: item['status'],
                      dueDate: DateTime.now().add(Duration(days: item['days'])),
                      onTap: () => context.push('/compliance/gst'),
                    ).animate().fadeIn(delay: Duration(milliseconds: i * 60));
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  final String label;
  final Color color;
  const _SummaryChip(this.label, this.color);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: AppTypography.labelSmall.copyWith(color: color, fontWeight: FontWeight.w600)),
    );
  }
}

// GST Compliance Screen
class GSTComplianceScreen extends StatelessWidget {
  const GSTComplianceScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BHAppBar(title: 'GST Compliance'),
      backgroundColor: AppColors.surfaceBackground,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(16)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Text('GST Health Score', style: AppTypography.labelMedium.copyWith(color: Colors.white70)),
                  const Spacer(),
                  VerificationBadge(isVerified: true, label: 'GST Verified'),
                ]),
                const SizedBox(height: 4),
                Text('85/100', style: AppTypography.displayLarge.copyWith(color: Colors.white, fontWeight: FontWeight.w800)),
                const SizedBox(height: 16),
                Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                  _GSTStat('GSTIN', '29AABCS\n1234Z1ZV', Colors.white),
                  _GSTStat('Returns Filed', '24/24', AppColors.statusGreen),
                  _GSTStat('Tax Paid', '₹12.4L', AppColors.goldAccent),
                ]),
              ]),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Return Filing Schedule', style: AppTypography.headlineMedium),
            const SizedBox(height: AppSpacing.sm),
            ...[
              {'title': 'GSTR-3B (Dec 2024)', 'due': 'Due: 20-01-2025', 'status': 'due_soon'},
              {'title': 'GSTR-1 (Dec 2024)', 'due': 'Due: 11-01-2025', 'status': 'pending'},
              {'title': 'GSTR-3B (Nov 2024)', 'due': 'Filed: 18-12-2024', 'status': 'compliant'},
              {'title': 'GSTR-1 (Nov 2024)', 'due': 'Filed: 11-12-2024', 'status': 'compliant'},
            ].map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: ComplianceCard(
                title: item['title']!,
                category: 'GST',
                status: item['status']!,
                dueDate: DateTime.now().add(const Duration(days: 5)),
                subtitle: item['due'],
                onTap: () => context.push('/compliance/gst/detail'),
              ),
            )),
            const SizedBox(height: AppSpacing.lg),
            Text('Quick Actions', style: AppTypography.headlineMedium),
            const SizedBox(height: AppSpacing.sm),
            Row(children: [
              _ActionBtn('File Return', Icons.send_rounded, AppColors.primaryBlue, () => context.push('/compliance/gst/detail')),
              const SizedBox(width: 10),
              _ActionBtn('Upload Docs', Icons.upload_rounded, AppColors.verifiedTeal, () => context.push('/documents/upload')),
              const SizedBox(width: 10),
              _ActionBtn('History', Icons.history_rounded, AppColors.statusAmber, () => context.push('/compliance/history')),
            ]),
          ],
        ),
      ),
    );
  }
}

class _GSTStat extends StatelessWidget {
  final String label, value;
  final Color color;
  const _GSTStat(this.label, this.value, this.color);
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(value, style: AppTypography.labelLarge.copyWith(color: color, fontWeight: FontWeight.w700)),
      Text(label, style: AppTypography.labelSmall.copyWith(color: Colors.white60)),
    ]);
  }
}

class _ActionBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _ActionBtn(this.label, this.icon, this.color, this.onTap);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.card), border: Border.all(color: AppColors.borderLight)),
          child: Column(children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 4),
            Text(label, style: AppTypography.labelSmall.copyWith(fontWeight: FontWeight.w500)),
          ]),
        ),
      ),
    );
  }
}

// Placeholder re-exports for remaining compliance screens
class GSTFilingDetailScreen extends StatelessWidget {
  const GSTFilingDetailScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return _DetailScaffold(
      title: 'GSTR-3B Filing',
      category: 'GST',
      dueDate: '20-01-2025',
      amount: '₹1,24,500',
      status: 'Due in 5 days',
      statusColor: AppColors.statusAmber,
      onDocument: () => context.push('/documents/upload'),
      onVerify: () => context.push('/compliance/verification'),
      onHistory: () => context.push('/compliance/history'),
    );
  }
}

class IncomeTaxScreen extends StatelessWidget {
  const IncomeTaxScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return _CategoryListScaffold(title: 'Income Tax', category: 'Income Tax', color: AppColors.primaryBlue, items: ['TDS Return Q3 FY25', 'Advance Tax Q3', 'ITR Filing FY24', 'Form 15CA/CB']);
  }
}

class LabourLawsScreen extends StatelessWidget {
  const LabourLawsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return _CategoryListScaffold(title: 'Labour Laws', category: 'Labour', color: AppColors.verifiedTeal, items: ['PF Monthly Contribution', 'ESI Monthly Contribution', 'Professional Tax', 'Gratuity Return']);
  }
}

class LicensesScreen extends StatelessWidget {
  const LicensesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BHAppBar(title: 'Licences'),
      backgroundColor: AppColors.surfaceBackground,
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          _LicenseCard('FSSAI Licence', 'Valid till 31-Mar-2026', AppColors.goldAccent, Icons.restaurant_rounded, 'compliant', () => context.push('/compliance/licenses/fssai')),
          const SizedBox(height: 10),
          _LicenseCard('Shop & Establishment', 'Renewal due in 8 days', AppColors.primaryBlue, Icons.storefront_rounded, 'due_soon', () => context.push('/compliance/licenses/shop-act')),
          const SizedBox(height: 10),
          _LicenseCard('Factory Licence', 'Not applicable', AppColors.neutralGrey, Icons.factory_rounded, 'pending', () => context.push('/compliance/licenses/factory')),
          const SizedBox(height: 10),
          _LicenseCard('Pollution Board NOC', 'Valid till 30-Jun-2025', AppColors.statusGreen, Icons.eco_rounded, 'compliant', () => context.push('/compliance/licenses/pollution')),
          const SizedBox(height: 10),
          _LicenseCard('Trademark (Class 29)', 'Application filed', AppColors.statusAmber, Icons.verified_rounded, 'pending', () => context.push('/compliance/licenses/trademark')),
        ],
      ),
    );
  }
}

class _LicenseCard extends StatelessWidget {
  final String title, subtitle, status;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;
  const _LicenseCard(this.title, this.subtitle, this.color, this.icon, this.status, this.onTap);
  @override
  Widget build(BuildContext context) {
    return ComplianceCard(title: title, category: 'License', status: status, dueDate: DateTime.now().add(const Duration(days: 10)), subtitle: subtitle, onTap: onTap);
  }
}

// Simple reusable detail scaffold
class _DetailScaffold extends StatelessWidget {
  final String title, category, dueDate, amount, status;
  final Color statusColor;
  final VoidCallback onDocument, onVerify, onHistory;
  const _DetailScaffold({required this.title, required this.category, required this.dueDate, required this.amount, required this.status, required this.statusColor, required this.onDocument, required this.onVerify, required this.onHistory});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BHAppBar(title: title),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(16)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              StatusChip(label: category, status: 'pending'),
              const SizedBox(height: 12),
              Text(title, style: AppTypography.headlineLarge.copyWith(color: Colors.white)),
              const SizedBox(height: 16),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                _InfoBox('Due Date', dueDate),
                _InfoBox('Amount', amount),
                _InfoBox('Status', status, statusColor),
              ]),
            ]),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text('Actions', style: AppTypography.headlineMedium),
          const SizedBox(height: AppSpacing.md),
          _ActionTile(Icons.upload_file_rounded, 'Upload Supporting Documents', 'PDF, Excel, Images accepted', onDocument),
          _ActionTile(Icons.verified_rounded, 'Request Verification', 'CA-verified compliance stamp', onVerify),
          _ActionTile(Icons.history_rounded, 'View Filing History', 'Past submissions and records', onHistory),
          const SizedBox(height: AppSpacing.xl),
          Text('Activity Timeline', style: AppTypography.headlineMedium),
          const SizedBox(height: AppSpacing.md),
          TimelineItem(title: 'Return generated', subtitle: 'System auto-populated', date: DateTime.now().subtract(const Duration(days: 2)), color: AppColors.primaryBlue, icon: Icons.auto_awesome_rounded),
          TimelineItem(title: 'Reminder sent', subtitle: 'Email & SMS notification', date: DateTime.now().subtract(const Duration(days: 1)), color: AppColors.statusAmber, icon: Icons.notifications_rounded),
          TimelineItem(title: 'Action required', subtitle: 'File before due date', date: DateTime.now(), isLast: true, color: AppColors.statusRed, icon: Icons.warning_rounded),
        ]),
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  final String label, value;
  final Color? color;
  const _InfoBox(this.label, this.value, [this.color]);
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(value, style: AppTypography.labelLarge.copyWith(color: color ?? Colors.white, fontWeight: FontWeight.w700)),
      Text(label, style: AppTypography.labelSmall.copyWith(color: Colors.white60)),
    ]);
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;
  final VoidCallback onTap;
  const _ActionTile(this.icon, this.title, this.subtitle, this.onTap);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.card), border: Border.all(color: AppColors.borderLight)),
        child: Row(children: [
          Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.lightBlue, borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: AppColors.primaryBlue, size: 20)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: AppTypography.labelLarge),
            Text(subtitle, style: AppTypography.bodySmall),
          ])),
          const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.neutralGrey),
        ]),
      ),
    );
  }
}

// Category list reusable
class _CategoryListScaffold extends StatelessWidget {
  final String title, category;
  final Color color;
  final List<String> items;
  const _CategoryListScaffold({required this.title, required this.category, required this.color, required this.items});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BHAppBar(title: title),
      backgroundColor: AppColors.surfaceBackground,
      body: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.lg),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, i) => ComplianceCard(
          title: items[i],
          category: category,
          status: ['compliant', 'due_soon', 'overdue', 'pending'][i % 4],
          dueDate: DateTime.now().add(Duration(days: (i * 7) - 2)),
          onTap: () => context.push('/compliance/gst/detail'),
        ),
      ),
    );
  }
}
