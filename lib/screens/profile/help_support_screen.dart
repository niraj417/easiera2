import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../widgets/buttons/bh_button.dart';
import '../../widgets/navigation/bh_navigation.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  final List<Map<String, dynamic>> _faqs = const [
    {'q': 'How is my BizHealth Score calculated?', 'a': 'Your score factors in GST compliance (30%), income tax (20%), labour laws (15%), licences (15%), document health (10%), and cashflow stability (10%). Each dimension is updated in real-time from your integrated data.'},
    {'q': 'Is my data safe on BizHealth360?', 'a': 'Yes. All data is encrypted at rest and in transit using AES-256 and TLS 1.3. We are ISO 27001 certified and do not share your data with third parties without your consent.'},
    {'q': 'How do I add multiple GSTIN?', 'a': 'Navigate to Settings → GST & Tax Settings → Add GSTIN. You can manage up to 5 GSTINs on the Biz Pro plan and unlimited on Enterprise.'},
    {'q': 'Can my CA access my account?', 'a': 'Yes. Invite your CA through Settings → Team Members with the "CA" role. They get read and filing access; they cannot modify your business settings.'},
    {'q': 'How long does OCR processing take?', 'a': 'AI OCR typically processes documents in 30–60 seconds. Complex multi-page PDFs may take up to 2 minutes.'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BHAppBar(title: 'Help & Support'),
      backgroundColor: AppColors.surfaceBackground,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Contact options
            Row(children: [
              _SupportCard(Icons.chat_rounded, 'Live Chat', 'Avg reply: 2 min', AppColors.primaryBlue, () {}),
              const SizedBox(width: 10),
              _SupportCard(Icons.email_rounded, 'Email Us', 'help@bizheath360.in', AppColors.statusGreen, () {}),
              const SizedBox(width: 10),
              _SupportCard(Icons.phone_rounded, 'Call Now', '1800-XXX-XXXX', AppColors.goldAccent, () {}),
            ]).animate().fadeIn(duration: 400.ms),
            const SizedBox(height: 20),
            // Quick links
            Text('Quick Help', style: AppTypography.headlineMedium),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 1.8,
              children: [
                {'label': 'Getting Started', 'icon': Icons.play_circle_rounded, 'color': AppColors.primaryBlue},
                {'label': 'Video Tutorials', 'icon': Icons.ondemand_video_rounded, 'color': AppColors.statusAmber},
                {'label': 'API Docs', 'icon': Icons.code_rounded, 'color': AppColors.statusGreen},
                {'label': 'Compliance Guide', 'icon': Icons.menu_book_rounded, 'color': AppColors.statusRed},
              ].map((q) => GestureDetector(
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.card), border: Border.all(color: AppColors.borderLight)),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(q['icon'] as IconData, color: q['color'] as Color, size: 26),
                    const SizedBox(height: 6),
                    Text(q['label'] as String, style: AppTypography.labelMedium, textAlign: TextAlign.center),
                  ]),
                ),
              )).toList(),
            ),
            const SizedBox(height: 24),
            Text('Frequently Asked Questions', style: AppTypography.headlineMedium),
            const SizedBox(height: 12),
            ..._faqs.asMap().entries.map((entry) {
              final i = entry.key;
              final faq = entry.value;
              return _FAQTile(q: faq['q'] as String, a: faq['a'] as String)
                .animate().fadeIn(delay: Duration(milliseconds: i * 60));
            }),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(16)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Still need help?', style: AppTypography.headlineMedium.copyWith(color: Colors.white)),
                const SizedBox(height: 4),
                Text('Our compliance experts are available\nMon-Sat, 9 AM – 8 PM IST', style: AppTypography.bodySmall.copyWith(color: Colors.white60, height: 1.5)),
                const SizedBox(height: 16),
                BHButton(label: 'Contact Expert', onPressed: () {}, type: BHButtonType.ghost),
              ]),
            ),
            const SizedBox(height: 20),
            Center(child: Text('BizHealth360 v2.1.0 • © 2026 BizHealth Technologies Pvt. Ltd.', style: AppTypography.bodySmall, textAlign: TextAlign.center)),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _SupportCard extends StatelessWidget {
  final IconData icon;
  final String label, sub;
  final Color color;
  final VoidCallback onTap;
  const _SupportCard(this.icon, this.label, this.sub, this.color, this.onTap);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.card), border: Border.all(color: AppColors.borderLight)),
          child: Column(children: [
            Container(width: 36, height: 36, decoration: BoxDecoration(color: color.withOpacity(0.12), shape: BoxShape.circle), child: Icon(icon, color: color, size: 18)),
            const SizedBox(height: 6),
            Text(label, style: AppTypography.labelSmall.copyWith(fontWeight: FontWeight.w600), textAlign: TextAlign.center),
            Text(sub, style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary, fontSize: 9), textAlign: TextAlign.center),
          ]),
        ),
      ),
    );
  }
}

class _FAQTile extends StatefulWidget {
  final String q, a;
  const _FAQTile({required this.q, required this.a});
  @override
  State<_FAQTile> createState() => _FAQTileState();
}

class _FAQTileState extends State<_FAQTile> {
  bool _expanded = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.card), border: Border.all(color: _expanded ? AppColors.primaryBlue.withOpacity(0.3) : AppColors.borderLight)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: Text(widget.q, style: AppTypography.labelLarge)),
            Icon(_expanded ? Icons.expand_less_rounded : Icons.expand_more_rounded, color: AppColors.textSecondary, size: 20),
          ]),
          if (_expanded) ...[
            const SizedBox(height: 10),
            const Divider(height: 1),
            const SizedBox(height: 10),
            Text(widget.a, style: AppTypography.bodySmall.copyWith(height: 1.6)),
          ],
        ]),
      ),
    );
  }
}
