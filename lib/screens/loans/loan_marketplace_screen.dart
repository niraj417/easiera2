import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../widgets/buttons/bh_button.dart';
import '../../widgets/indicators/bh_indicators.dart';
import '../../widgets/navigation/bh_navigation.dart';

// Loan Marketplace screens

class LoanMarketplaceScreen extends StatelessWidget {
  const LoanMarketplaceScreen({super.key});

  final List<Map<String, dynamic>> _offers = const [
    {'bank': 'HDFC Bank', 'amount': '₹50 Lakhs', 'rate': '11.5%', 'tenure': '5 Years', 'color': 0xFF1A5FB4, 'logo': Icons.account_balance_rounded, 'score': 95},
    {'bank': 'SBI Business', 'amount': '₹75 Lakhs', 'rate': '10.75%', 'tenure': '7 Years', 'color': 0xFF22C55E, 'logo': Icons.account_balance_rounded, 'score': 88},
    {'bank': 'Axis Bank', 'amount': '₹35 Lakhs', 'rate': '12%', 'tenure': '3 Years', 'color': 0xFFEF4444, 'logo': Icons.account_balance_rounded, 'score': 82},
    {'bank': 'SIDBI MUDRA', 'amount': '₹10 Lakhs', 'rate': '9.5%', 'tenure': '5 Years', 'color': 0xFF6366F1, 'logo': Icons.account_balance_rounded, 'score': 90},
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
        title: Text('Loan Marketplace', style: AppTypography.headlineLarge),
        bottom: const PreferredSize(preferredSize: Size.fromHeight(1), child: Divider(height: 1)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Eligibility Banner
            Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(gradient: AppColors.greenGradient, borderRadius: BorderRadius.circular(16)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Text('Pre-Qualified for Loans', style: AppTypography.labelMedium.copyWith(color: Colors.white70)),
                ]),
                const SizedBox(height: 8),
                Text('₹50–75 Lakhs\neligible based on\nyour Score: 78', style: AppTypography.displayMedium.copyWith(color: Colors.white, height: 1.2)),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () => context.push('/loans/eligibility'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white30)),
                    child: Text('View Eligibility Details', style: AppTypography.labelMedium.copyWith(color: Colors.white)),
                  ),
                ),
              ]),
            ).animate().fadeIn(duration: 500.ms),
            const SizedBox(height: AppSpacing.lg),
            Text('Best Offers For You', style: AppTypography.headlineMedium),
            const SizedBox(height: AppSpacing.sm),
            ..._offers.asMap().entries.map((entry) {
              final i = entry.key;
              final offer = entry.value;
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.card), border: Border.all(color: AppColors.borderLight)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Container(width: 44, height: 44, decoration: BoxDecoration(color: Color(offer['color'] as int).withOpacity(0.12), borderRadius: BorderRadius.circular(8)), child: Icon(offer['logo'] as IconData, color: Color(offer['color'] as int), size: 24)),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(offer['bank'] as String, style: AppTypography.headlineMedium),
                      Row(children: [
                        const Icon(Icons.star_rounded, color: AppColors.goldAccent, size: 14),
                        const SizedBox(width: 2),
                        Text('Match Score: ${offer['score']}%', style: AppTypography.labelSmall.copyWith(color: AppColors.goldAccent)),
                      ]),
                    ])),
                    Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(gradient: AppColors.greenGradient, borderRadius: BorderRadius.circular(20)), child: Text('Pre-Approved', style: AppTypography.labelSmall.copyWith(color: Colors.white))),
                  ]),
                  const SizedBox(height: 16),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                    _LoanStat('Amount', offer['amount'] as String),
                    _LoanStat('Rate', offer['rate'] as String),
                    _LoanStat('Tenure', offer['tenure'] as String),
                  ]),
                  const SizedBox(height: 12),
                  Row(children: [
                    Expanded(child: BHButton(label: 'Apply Now', onPressed: () => context.push('/loans/apply'), type: BHButtonType.secondary)),
                    const SizedBox(width: 10),
                    Expanded(child: BHButton(label: 'View Details', onPressed: () => context.push('/loans/offers'))),
                  ]),
                ]),
              ).animate().fadeIn(delay: Duration(milliseconds: i * 80));
            }),
          ],
        ),
      ),
    );
  }
}

class _LoanStat extends StatelessWidget {
  final String label, value;
  const _LoanStat(this.label, this.value);
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(value, style: AppTypography.headlineMedium.copyWith(color: AppColors.primaryBlue, fontWeight: FontWeight.w700)),
      Text(label, style: AppTypography.bodySmall),
    ]);
  }
}

class LoanEligibilityScreen extends StatelessWidget {
  const LoanEligibilityScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BHAppBar(title: 'Loan Eligibility'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(16)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Creditworthiness Score', style: AppTypography.labelMedium.copyWith(color: Colors.white70)),
              Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text('78', style: AppTypography.displayLarge.copyWith(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 64)),
                const SizedBox(width: 8),
                Text('/100', style: AppTypography.headlineMedium.copyWith(color: Colors.white60)),
                const Spacer(),
                Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: AppColors.statusGreen.withOpacity(0.2), borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.statusGreen.withOpacity(0.4))), child: Text('Grade: A', style: AppTypography.labelLarge.copyWith(color: AppColors.statusGreen))),
              ]),
            ]),
          ),
          const SizedBox(height: 20),
          Text('What factors affect eligibility?', style: AppTypography.headlineMedium),
          const SizedBox(height: 12),
          ...[
            {'label': 'GST Compliance Rate', 'value': '100%', 'isPositive': true},
            {'label': 'Filing Timeliness', 'value': '92%', 'isPositive': true},
            {'label': 'Annual Turnover', 'value': '₹2.9 Cr', 'isPositive': true},
            {'label': 'Director Credit Score', 'value': '750+', 'isPositive': true},
            {'label': 'Business Vintage', 'value': '6 Years', 'isPositive': true},
            {'label': 'Overdue Compliances', 'value': '1 (TDS)', 'isPositive': false},
          ].map((f) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.card), border: Border.all(color: AppColors.borderLight)),
            child: Row(children: [
              Icon(f['isPositive'] as bool ? Icons.check_circle_rounded : Icons.cancel_rounded, color: f['isPositive'] as bool ? AppColors.statusGreen : AppColors.statusRed, size: 18),
              const SizedBox(width: 10),
              Expanded(child: Text(f['label'] as String, style: AppTypography.bodyMedium)),
              Text(f['value'] as String, style: AppTypography.labelMedium.copyWith(color: f['isPositive'] as bool ? AppColors.statusGreen : AppColors.statusRed)),
            ]),
          )),
          const SizedBox(height: 16),
          BHButton(label: 'View Loan Offers', onPressed: () => context.pop(), trailingIcon: Icons.arrow_forward_rounded),
        ]),
      ),
    );
  }
}

class LoanOffersScreen extends StatelessWidget {
  const LoanOffersScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BHAppBar(title: 'HDFC Bank Offer'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(16)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Container(width: 44, height: 44, decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.account_balance_rounded, color: Colors.white, size: 24)),
                const SizedBox(width: 12),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('HDFC Bank', style: AppTypography.headlineLarge.copyWith(color: Colors.white)),
                  Text('Business Growth Loan', style: AppTypography.bodySmall.copyWith(color: Colors.white70)),
                ]),
              ]),
              const SizedBox(height: 20),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                _LoanDetailPill('Amount', '₹50 Lakhs'),
                _LoanDetailPill('Rate', '11.5% p.a.'),
                _LoanDetailPill('EMI', '₹1,08,700'),
              ]),
            ]),
          ),
          const SizedBox(height: 20),
          Text('Loan Details', style: AppTypography.headlineMedium),
          const SizedBox(height: 12),
          ...[
            {'label': 'Loan Type', 'value': 'Term Loan'},
            {'label': 'Processing Fee', 'value': '1% (₹50,000)'},
            {'label': 'Prepayment', 'value': '2% after 1 year'},
            {'label': 'Collateral', 'value': 'Not Required'},
            {'label': 'Disbursement', 'value': '3-5 Working Days'},
            {'label': 'Valid Until', 'value': '31-Jan-2025'},
          ].map((r) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.card), border: Border.all(color: AppColors.borderLight)),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(r['label']!, style: AppTypography.bodySmall),
              Text(r['value']!, style: AppTypography.labelMedium),
            ]),
          )),
          const SizedBox(height: 16),
          BHButton(label: 'Apply for This Loan', onPressed: () => context.push('/loans/apply'), leadingIcon: Icons.arrow_forward_rounded),
        ]),
      ),
    );
  }
}

class _LoanDetailPill extends StatelessWidget {
  final String label, value;
  const _LoanDetailPill(this.label, this.value);
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(value, style: AppTypography.headlineMedium.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
      Text(label, style: AppTypography.labelSmall.copyWith(color: Colors.white60)),
    ]);
  }
}

class LoanApplicationScreen extends StatefulWidget {
  const LoanApplicationScreen({super.key});
  @override
  State<LoanApplicationScreen> createState() => _LoanApplicationScreenState();
}

class _LoanApplicationScreenState extends State<LoanApplicationScreen> {
  int _step = 1;
  bool _submitted = false;

  @override
  Widget build(BuildContext context) {
    if (_submitted) {
      return Scaffold(
        appBar: BHAppBar(title: 'Application Submitted'),
        body: Center(child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(width: 80, height: 80, decoration: BoxDecoration(gradient: AppColors.greenGradient, shape: BoxShape.circle), child: const Icon(Icons.check_rounded, color: Colors.white, size: 44)),
            const SizedBox(height: 24),
            Text('Application Submitted!', style: AppTypography.displayMedium),
            const SizedBox(height: 12),
            Text('Your HDFC Bank loan application has been submitted.\nReference: HDFC-2024-98765', style: AppTypography.bodyMedium, textAlign: TextAlign.center),
            const SizedBox(height: 32),
            BHButton(label: 'Track Application', onPressed: () => context.pop()),
          ]),
        )),
      );
    }
    return Scaffold(
      appBar: BHAppBar(title: 'Apply for Loan'),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(children: List.generate(4, (i) => Expanded(child: Container(
            margin: EdgeInsets.only(right: i < 3 ? 4 : 0),
            height: 4,
            decoration: BoxDecoration(color: i < _step ? AppColors.primaryBlue : AppColors.borderLight, borderRadius: BorderRadius.circular(2)),
          )))),
        ),
        Expanded(child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(['Business Information', 'Financial Details', 'Document Upload', 'Review & Submit'][_step - 1], style: AppTypography.headlineLarge),
            const SizedBox(height: 20),
            if (_step == 1) ...[
              _AppField('Business Name', 'Sharma Trading Pvt. Ltd.'),
              const SizedBox(height: 12),
              _AppField('Type of Business', 'Private Limited'),
              const SizedBox(height: 12),
              _AppField('Business Vintage', '6 Years'),
              const SizedBox(height: 12),
              _AppField('Loan Purpose', 'Working Capital / Expansion'),
            ] else if (_step == 2) ...[
              _AppField('Annual Turnover', '₹2,92,00,000'),
              const SizedBox(height: 12),
              _AppField('Loan Amount Required', '₹50,00,000'),
              const SizedBox(height: 12),
              _AppField('Existing Loan EMI', '₹0'),
              const SizedBox(height: 12),
              _AppField('Preferred Tenure', '5 Years'),
            ] else if (_step == 3) ...[
              ...[
                'Last 6 months GST Returns',
                'Bank Statement (12 months)',
                'ITR for last 2 years',
                'Business PAN & Udyam Certificate',
              ].map((doc) => Container(margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(AppSpacing.md), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.card), border: Border.all(color: AppColors.borderLight)), child: Row(children: [
                const Icon(Icons.upload_file_rounded, color: AppColors.primaryBlue, size: 20),
                const SizedBox(width: 10),
                Expanded(child: Text(doc, style: AppTypography.labelMedium)),
                Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: AppColors.lightGreen, borderRadius: BorderRadius.circular(8)), child: Text('Upload', style: AppTypography.labelSmall.copyWith(color: AppColors.statusGreen))),
              ]))),
            ] else ...[
              Container(padding: const EdgeInsets.all(AppSpacing.lg), decoration: BoxDecoration(color: AppColors.lightGreen, borderRadius: BorderRadius.circular(AppRadius.card), border: Border.all(color: AppColors.statusGreen.withOpacity(0.3))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Application Summary', style: AppTypography.headlineMedium),
                const SizedBox(height: 12),
                _SummaryRow('Bank', 'HDFC Bank'),
                _SummaryRow('Amount', '₹50 Lakhs'),
                _SummaryRow('Rate', '11.5% p.a.'),
                _SummaryRow('Tenure', '5 Years'),
                _SummaryRow('EMI', '₹1,08,700/month'),
              ])),
            ],
          ]),
        )),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(children: [
            if (_step > 1) ...[
              Expanded(child: BHButton(label: 'Back', onPressed: () => setState(() => _step--), type: BHButtonType.ghost)),
              const SizedBox(width: 12),
            ],
            Expanded(flex: 2, child: BHButton(label: _step == 4 ? 'Submit Application' : 'Continue', onPressed: () {
              if (_step < 4) setState(() => _step++); else setState(() => _submitted = true);
            }, trailingIcon: _step < 4 ? Icons.arrow_forward_rounded : Icons.send_rounded)),
          ]),
        ),
      ]),
    );
  }
}

class _AppField extends StatelessWidget {
  final String label, hint;
  const _AppField(this.label, this.hint);
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w500)),
      const SizedBox(height: 6),
      TextField(decoration: InputDecoration(hintText: hint, filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: AppColors.borderLight)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: AppColors.borderLight)))),
    ]);
  }
}

class _SummaryRow extends StatelessWidget {
  final String label, value;
  const _SummaryRow(this.label, this.value);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: AppTypography.bodyMedium),
        Text(value, style: AppTypography.labelMedium.copyWith(color: AppColors.primaryBlue)),
      ]),
    );
  }
}
