import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../widgets/buttons/bh_button.dart';
import '../../widgets/indicators/bh_indicators.dart';
import '../../widgets/navigation/bh_navigation.dart';

// AI Advisor module screens

class AIAdvisorScreen extends StatelessWidget {
  const AIAdvisorScreen({super.key});

  final List<Map<String, dynamic>> _insights = const [
    {'category': 'Cashflow', 'title': 'Cashflow gap predicted in Q4', 'body': 'Based on your last 6 months of GST data, we predict a ₹8.5L cashflow gap in January. Consider pre-billing outstanding invoices.', 'priority': 'high', 'icon': Icons.trending_down_rounded},
    {'category': 'Tax Saving', 'title': 'Eligible for Section 44AD Presumptive Tax', 'body': 'Your turnover of ₹42L qualifies for presumptive taxation, saving up to ₹1.2L in tax liability.', 'priority': 'medium', 'icon': Icons.savings_rounded},
    {'category': 'Compliance', 'title': 'GSTR-3B mismatch with GSTR-2B detected', 'body': 'AI found a ₹23,000 difference between your GSTR-2B ITC and claimed ITC. Reconcile to avoid notice.', 'priority': 'high', 'icon': Icons.warning_amber_rounded},
    {'category': 'Growth', 'title': 'Apply for MSME loan now — best timing', 'body': 'Your BizHealth Score of 78 meets HDFC criteria for ₹50L business loan at 11.5% — lowest in 2 years.', 'priority': 'low', 'icon': Icons.account_balance_wallet_rounded},
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
        title: Text('AI Advisor', style: AppTypography.headlineLarge),
        actions: [
          IconButton(onPressed: () => context.push('/ai-advisor/chat'), icon: Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(gradient: AppColors.goldGradient, borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.chat_rounded, color: Colors.white, size: 18))),
          const SizedBox(width: 8),
        ],
        bottom: const PreferredSize(preferredSize: Size.fromHeight(1), child: Divider(height: 1)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AI Summary Banner
            Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(gradient: AppColors.goldGradient, borderRadius: BorderRadius.circular(16)),
              child: Row(
                children: [
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Bizzy AI™', style: AppTypography.labelMedium.copyWith(color: Colors.white70)),
                      Text('4 new insights\nfor your business', style: AppTypography.headlineLarge.copyWith(color: Colors.white, height: 1.2)),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () => context.push('/ai-advisor/chat'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white30)),
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            const Icon(Icons.chat_bubble_rounded, color: Colors.white, size: 14),
                            const SizedBox(width: 6),
                            Text('Ask Bizzy', style: AppTypography.labelMedium.copyWith(color: Colors.white)),
                          ]),
                        ),
                      ),
                    ]),
                  ),
                  const SizedBox(width: 16),
                  Container(width: 64, height: 64, decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle), child: const Icon(Icons.psychology_rounded, color: Colors.white, size: 36)),
                ],
              ),
            ).animate().fadeIn(duration: 500.ms),
            const SizedBox(height: AppSpacing.lg),
            Row(children: [
              _FilterChip('All', true),
              _FilterChip('High Priority', false),
              _FilterChip('Tax Saving', false),
              _FilterChip('Compliance', false),
            ]),
            const SizedBox(height: AppSpacing.sm),
            ..._insights.asMap().entries.map((entry) {
              final i = entry.key;
              final insight = entry.value;
              final priorityColor = insight['priority'] == 'high' ? AppColors.statusRed : insight['priority'] == 'medium' ? AppColors.statusAmber : AppColors.statusGreen;
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.card), border: Border.all(color: AppColors.borderLight)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: priorityColor.withOpacity(0.12), borderRadius: BorderRadius.circular(10)), child: Text(insight['category'] as String, style: AppTypography.labelSmall.copyWith(color: priorityColor))),
                    const Spacer(),
                    Icon(insight['icon'] as IconData, color: priorityColor, size: 18),
                  ]),
                  const SizedBox(height: 8),
                  Text(insight['title'] as String, style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text(insight['body'] as String, style: AppTypography.bodySmall),
                  const SizedBox(height: 12),
                  Row(children: [
                    TextButton.icon(onPressed: () => context.push('/compliance/gst'), icon: const Icon(Icons.arrow_forward_rounded, size: 14), label: Text('Take Action', style: AppTypography.labelSmall.copyWith(color: AppColors.primaryBlue))),
                    const Spacer(),
                    TextButton(onPressed: () {}, child: Text('Dismiss', style: AppTypography.labelSmall.copyWith(color: AppColors.neutralGrey))),
                  ]),
                ]),
              ).animate().fadeIn(delay: Duration(milliseconds: i * 80));
            }),
            const SizedBox(height: AppSpacing.lg),
            BHButton(label: 'View Full AI Report', onPressed: () => context.push('/ai-advisor/report'), leadingIcon: Icons.bar_chart_rounded),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  const _FilterChip(this.label, this.isSelected);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: isSelected ? AppColors.primaryBlue : Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: isSelected ? AppColors.primaryBlue : AppColors.borderLight)),
      child: Text(label, style: AppTypography.labelSmall.copyWith(color: isSelected ? Colors.white : AppColors.textSecondary, fontWeight: FontWeight.w500)),
    );
  }
}

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});
  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final List<Map<String, dynamic>> _messages = [
    {'role': 'ai', 'text': 'Hello! I\'m Bizzy, your BizHealth360 AI Advisor. I\'ve analysed your compliance data. What would you like to know?'},
    {'role': 'user', 'text': 'What\'s my biggest compliance risk right now?'},
    {'role': 'ai', 'text': 'Your biggest risk is the overdue TDS Return for Q3 FY2025. It was due on 31-Oct-2024 and a penalty of ₹200 per day is accumulating. I recommend filing it immediately via the TRACES portal. Shall I guide you through the process?'},
  ];

  final _controller = TextEditingController();
  bool _isTyping = false;

  final List<String> _suggestions = ['How can I save more tax?', 'When is my next GST due?', 'What is my credit score?', 'Apply for a loan'];

  void _sendMessage(String text) {
    if (text.isEmpty) return;
    setState(() {
      _messages.add({'role': 'user', 'text': text});
      _controller.clear();
      _isTyping = true;
    });
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isTyping = false;
          _messages.add({'role': 'ai', 'text': 'Great question! Based on your BizHealth Score of 78 and recent compliance data, I recommend reviewing your ITC claims in GSTR-3B for November to avoid any mismatch notices.'});
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BHAppBar(title: 'Bizzy AI Chat'),
      body: Column(
        children: [
          // Suggestions
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 8),
            child: Row(children: _suggestions.map((s) => GestureDetector(
              onTap: () => _sendMessage(s),
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: AppColors.lightGold, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.goldAccent.withOpacity(0.3))),
                child: Text(s, style: AppTypography.labelSmall.copyWith(color: AppColors.goldAccent, fontWeight: FontWeight.w500)),
              ),
            )).toList()),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.lg),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, i) {
                if (i == _messages.length) {
                  return _TypingIndicator();
                }
                final msg = _messages[i];
                final isAI = msg['role'] == 'ai';
                return Align(
                  alignment: isAI ? Alignment.centerLeft : Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      gradient: isAI ? null : AppColors.primaryGradient,
                      color: isAI ? Colors.white : null,
                      borderRadius: BorderRadius.circular(14).copyWith(
                        bottomLeft: isAI ? Radius.zero : const Radius.circular(14),
                        bottomRight: isAI ? const Radius.circular(14) : Radius.zero,
                      ),
                      border: isAI ? Border.all(color: AppColors.borderLight) : null,
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      if (isAI) Row(children: [
                        Container(width: 20, height: 20, decoration: BoxDecoration(gradient: AppColors.goldGradient, shape: BoxShape.circle), child: const Icon(Icons.psychology_rounded, size: 12, color: Colors.white)),
                        const SizedBox(width: 6),
                        Text('Bizzy AI', style: AppTypography.labelSmall.copyWith(color: AppColors.goldAccent)),
                        const SizedBox(height: 4),
                      ]),
                      if (isAI) const SizedBox(height: 4),
                      Text(msg['text'] as String, style: AppTypography.bodyMedium.copyWith(color: isAI ? AppColors.textPrimary : Colors.white)),
                    ]),
                  ).animate().fadeIn(duration: 300.ms),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: AppColors.borderLight))),
            child: SafeArea(
              child: Row(children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Ask Bizzy anything...',
                      filled: true,
                      fillColor: AppColors.surfaceBackground,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    onSubmitted: _sendMessage,
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => _sendMessage(_controller.text),
                  child: Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(gradient: AppColors.primaryGradient, shape: BoxShape.circle),
                    child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.borderLight)),
        child: Row(children: [
          const SizedBox(width: 4),
          ...List.generate(3, (i) => Container(
            width: 6, height: 6,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: const BoxDecoration(color: AppColors.neutralGrey, shape: BoxShape.circle),
          ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(delay: Duration(milliseconds: i * 200), duration: 400.ms)),
        ]),
      ),
    ]);
  }
}

class AIReportScreen extends StatelessWidget {
  const AIReportScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BHAppBar(title: 'AI Business Report', actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.share_rounded)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.download_rounded)),
        const SizedBox(width: 4),
      ]),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(padding: const EdgeInsets.all(AppSpacing.xl), decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(16)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('BizHealth360 AI Report', style: AppTypography.headlineLarge.copyWith(color: Colors.white)),
            Text('Sharma Trading Pvt. Ltd.', style: AppTypography.bodyMedium.copyWith(color: Colors.white70)),
            Text('November 2024 • Generated by Bizzy AI™', style: AppTypography.bodySmall.copyWith(color: Colors.white60)),
          ])),
          const SizedBox(height: 20),
          ...[
            {'title': 'Executive Summary', 'body': 'Your overall BizHealth Score has improved by 4 points to 78/100. Key improvements were seen in cashflow stability (+8%) and GST compliance (+3%). TDS filing delay remains the primary risk.'},
            {'title': 'Compliance Health', 'body': '24 compliances tracked. 22 are on-time, 1 is overdue (TDS), 1 is due soon (GSTR-3B). Recommend immediate action on TDS.'},
            {'title': 'Financial Overview', 'body': 'Monthly revenue of ₹24.3L shows 12% growth YoY. Tax liability of ₹1.24L for November was filed on time. Net working capital improved.'},
            {'title': 'AI Recommendations', 'body': '1. File TDS return immediately\n2. Reconcile GSTR-2B vs GSTR-3B ITC\n3. Renew Shop & Establishment Act licence\n4. Consider MSME loan for expansion'},
          ].map((section) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(section['title']!, style: AppTypography.headlineMedium),
            const SizedBox(height: 8),
            Container(padding: const EdgeInsets.all(AppSpacing.lg), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.card), border: Border.all(color: AppColors.borderLight)), child: Text(section['body']!, style: AppTypography.bodyMedium.copyWith(height: 1.6))),
            const SizedBox(height: 16),
          ])),
        ]),
      ),
    );
  }
}
