import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../widgets/cards/bh_cards.dart';
import '../../widgets/indicators/bh_indicators.dart';
import '../../widgets/navigation/bh_navigation.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  String _query = '';
  final List<Map<String, dynamic>> _allItems = [
    {'title': 'GSTR-3B December 2024', 'category': 'GST', 'route': '/compliance/gst', 'icon': Icons.receipt_long_rounded, 'color': 0xFF1A5FB4},
    {'title': 'TDS Return Q3 FY25', 'category': 'Income Tax', 'route': '/compliance/income-tax', 'icon': Icons.account_balance_rounded, 'color': 0xFF6366F1},
    {'title': 'PAN Card — AABCS1234Z', 'category': 'Document', 'route': '/documents', 'icon': Icons.badge_rounded, 'color': 0xFFF59E0B},
    {'title': 'FSSAI Licence', 'category': 'Licence', 'route': '/compliance/licenses/fssai', 'icon': Icons.restaurant_rounded, 'color': 0xFF22C55E},
    {'title': 'HDFC Loan Offer', 'category': 'Loan', 'route': '/loans', 'icon': Icons.account_balance_wallet_rounded, 'color': 0xFF0D9488},
    {'title': 'Shop & Establishment Renewal', 'category': 'Licence', 'route': '/compliance/licenses/shop-act', 'icon': Icons.storefront_rounded, 'color': 0xFFEF4444},
    {'title': 'AI Insights — Cashflow Risk', 'category': 'AI Advisor', 'route': '/ai-advisor', 'icon': Icons.psychology_rounded, 'color': 0xFFF5B800},
    {'title': 'Tally Prime Integration', 'category': 'Integration', 'route': '/integrations/tally', 'icon': Icons.receipt_rounded, 'color': 0xFF1A5FB4},
    {'title': 'Business Health Score', 'category': 'Health', 'route': '/health', 'icon': Icons.monitor_heart_rounded, 'color': 0xFF22C55E},
    {'title': 'Compliance Calendar', 'category': 'Calendar', 'route': '/compliance/calendar', 'icon': Icons.calendar_month_rounded, 'color': 0xFF6366F1},
  ];

  List<Map<String, dynamic>> get _filtered => _query.isEmpty ? [] : _allItems.where((e) => e['title'].toString().toLowerCase().contains(_query.toLowerCase()) || e['category'].toString().toLowerCase().contains(_query.toLowerCase())).toList();

  final List<String> _recent = ['GSTR-3B', 'FSSAI Licence', 'TDS Return', 'Loan Eligibility'];
  final List<String> _trending = ['GST Filing', 'BizHealth Score', 'Bizzy AI Chat', 'NBFC Loans'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: AppSpacing.md,
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => context.pop()),
        title: TextField(
          controller: _controller,
          autofocus: true,
          onChanged: (v) => setState(() => _query = v),
          decoration: InputDecoration(
            hintText: 'Search compliances, documents, loans…',
            filled: true,
            fillColor: AppColors.surfaceBackground,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
            suffixIcon: _query.isNotEmpty ? IconButton(icon: const Icon(Icons.close_rounded, size: 18), onPressed: () => setState(() { _controller.clear(); _query = ''; })) : null,
          ),
        ),
      ),
      body: _query.isEmpty ? _EmptyState(recent: _recent, trending: _trending, onTap: (s) { _controller.text = s; setState(() => _query = s); }) : _ResultList(items: _filtered),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final List<String> recent, trending;
  final ValueChanged<String> onTap;
  const _EmptyState({required this.recent, required this.trending, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _ChipRow('Recent Searches', recent, onTap, Icons.history_rounded),
        const SizedBox(height: 20),
        _ChipRow('Trending', trending, onTap, Icons.trending_up_rounded),
        const SizedBox(height: 24),
        Text('Quick Access', style: AppTypography.headlineMedium),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 2.2,
          children: [
            {'label': 'Compliance', 'icon': Icons.fact_check_rounded, 'route': '/compliance', 'color': 0xFF1A5FB4},
            {'label': 'Documents', 'icon': Icons.folder_rounded, 'route': '/documents', 'color': 0xFF22C55E},
            {'label': 'AI Advisor', 'icon': Icons.psychology_rounded, 'route': '/ai-advisor', 'color': 0xFFF5B800},
            {'label': 'Loans', 'icon': Icons.account_balance_wallet_rounded, 'route': '/loans', 'color': 0xFF6366F1},
          ].map((q) => GestureDetector(
            onTap: () => context.push(q['route'] as String),
            child: Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.card), border: Border.all(color: AppColors.borderLight)),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(q['icon'] as IconData, color: Color(q['color'] as int), size: 20),
                const SizedBox(width: 8),
                Text(q['label'] as String, style: AppTypography.labelMedium),
              ]),
            ),
          )).toList(),
        ),
      ]),
    );
  }
}

class _ChipRow extends StatelessWidget {
  final String title;
  final List<String> items;
  final ValueChanged<String> onTap;
  final IconData icon;
  const _ChipRow(this.title, this.items, this.onTap, this.icon);
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [Icon(icon, size: 16, color: AppColors.textSecondary), const SizedBox(width: 6), Text(title, style: AppTypography.headlineMedium)]),
      const SizedBox(height: 10),
      Wrap(spacing: 8, runSpacing: 6, children: items.map((s) => GestureDetector(
        onTap: () => onTap(s),
        child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.borderLight)), child: Text(s, style: AppTypography.labelSmall)),
      )).toList()),
    ]);
  }
}

class _ResultList extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  const _ResultList({required this.items});
  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Icon(Icons.search_off_rounded, size: 64, color: AppColors.neutralGrey),
      const SizedBox(height: 12),
      Text('No results found', style: AppTypography.headlineMedium.copyWith(color: AppColors.textSecondary)),
      Text('Try a different search term', style: AppTypography.bodySmall),
    ]));
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, i) {
        final item = items[i];
        return GestureDetector(
          onTap: () => context.push(item['route'] as String),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.card), border: Border.all(color: AppColors.borderLight)),
            child: Row(children: [
              Container(width: 40, height: 40, decoration: BoxDecoration(color: Color(item['color'] as int).withOpacity(0.12), borderRadius: BorderRadius.circular(8)), child: Icon(item['icon'] as IconData, color: Color(item['color'] as int), size: 20)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(item['title'] as String, style: AppTypography.labelLarge),
                Text(item['category'] as String, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
              ])),
              const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.neutralGrey),
            ]),
          ).animate().fadeIn(delay: Duration(milliseconds: i * 50)),
        );
      },
    );
  }
}
