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

// Document Vault screens bundled together

class DocumentVaultScreen extends StatelessWidget {
  const DocumentVaultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'label': 'GST Documents', 'count': 12, 'icon': Icons.receipt_long, 'color': 0xFF1A5FB4},
      {'label': 'Income Tax', 'count': 8, 'icon': Icons.account_balance, 'color': 0xFF0D9488},
      {'label': 'Labour & HR', 'count': 5, 'icon': Icons.people, 'color': 0xFF22C55E},
      {'label': 'Licences', 'count': 6, 'icon': Icons.verified, 'color': 0xFFF5B800},
      {'label': 'Bank Statements', 'count': 13, 'icon': Icons.account_balance_wallet, 'color': 0xFF6366F1},
      {'label': 'MCA / ROC Filings', 'count': 4, 'icon': Icons.business, 'color': 0xFFEF4444},
    ];

    return Scaffold(
      backgroundColor: AppColors.surfaceBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: AppSpacing.lg,
        title: Text('Document Vault', style: AppTypography.headlineLarge),
        bottom: const PreferredSize(preferredSize: Size.fromHeight(1), child: Divider(height: 1)),
        actions: [
          IconButton(onPressed: () => context.push('/documents/upload'), icon: Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: AppColors.primaryBlue, borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.upload_rounded, color: Colors.white, size: 18))),
          IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded, color: AppColors.textSecondary)),
          const SizedBox(width: 4),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Storage banner
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(AppRadius.card)),
              child: Row(children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Storage Used', style: AppTypography.labelMedium.copyWith(color: Colors.white70)),
                  Text('234 MB of 5 GB', style: AppTypography.headlineLarge.copyWith(color: Colors.white)),
                  const SizedBox(height: 8),
                  SizedBox(width: 200, child: ClipRRect(borderRadius: BorderRadius.circular(4), child: const LinearProgressIndicator(value: 0.05, backgroundColor: Colors.white24, valueColor: AlwaysStoppedAnimation<Color>(AppColors.goldAccent), minHeight: 6))),
                ]),
                const Spacer(),
                const Icon(Icons.folder_rounded, color: AppColors.goldAccent, size: 48),
              ]),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Categories', style: AppTypography.headlineMedium),
            const SizedBox(height: AppSpacing.sm),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 1.5),
              itemCount: categories.length,
              itemBuilder: (context, i) {
                final cat = categories[i];
                return GestureDetector(
                  onTap: () => context.push('/documents/categories'),
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.card), border: Border.all(color: AppColors.borderLight)),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Icon(cat['icon'] as IconData, color: Color(cat['color'] as int), size: 28),
                      const Spacer(),
                      Text(cat['label'] as String, style: AppTypography.labelMedium),
                      Text('${cat['count']} files', style: AppTypography.bodySmall),
                    ]),
                  ).animate().fadeIn(delay: Duration(milliseconds: i * 60)),
                );
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Recent Documents', style: AppTypography.headlineMedium),
              TextButton(onPressed: () {}, child: Text('See all', style: AppTypography.labelMedium.copyWith(color: AppColors.primaryBlue))),
            ]),
            const SizedBox(height: AppSpacing.sm),
            ...List.generate(4, (i) {
              final docs = [
                {'name': 'GSTR-3B_Dec2024.pdf', 'type': 'PDF', 'size': '234 KB'},
                {'name': 'PF_Return_Nov2024.xlsx', 'type': 'XLSX', 'size': '89 KB'},
                {'name': 'FSSAI_Certificate.pdf', 'type': 'PDF', 'size': '1.2 MB'},
                {'name': 'GST_Invoice_Dec.jpg', 'type': 'JPG', 'size': '456 KB'},
              ];
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: DocumentCard(
                  title: docs[i]['name']!,
                  type: docs[i]['type']!,
                  size: docs[i]['size']!,
                  uploadedAt: DateTime.now().subtract(Duration(days: i + 1)),
                  isVerified: i % 2 == 0,
                  onTap: () => context.push('/documents/preview'),
                ).animate().fadeIn(delay: Duration(milliseconds: i * 60)),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class UploadDocumentScreen extends StatefulWidget {
  const UploadDocumentScreen({super.key});
  @override
  State<UploadDocumentScreen> createState() => _UploadDocumentScreenState();
}

class _UploadDocumentScreenState extends State<UploadDocumentScreen> {
  bool _uploading = false;
  bool _uploaded = false;
  String? _selectedType = 'PDF';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BHAppBar(title: 'Upload Document'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: _uploaded ? _SuccessUpload(onOCR: () => context.push('/documents/ocr'), onVault: () => context.pop()) : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drop zone
            GestureDetector(
              onTap: () {},
              child: Container(
                width: double.infinity,
                height: 160,
                decoration: BoxDecoration(
                  color: AppColors.lightBlue,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primaryBlue.withOpacity(0.4), width: 2, style: BorderStyle.solid),
                ),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Icon(Icons.cloud_upload_rounded, color: AppColors.primaryBlue, size: 48),
                  const SizedBox(height: 8),
                  Text('Tap to select file', style: AppTypography.labelLarge.copyWith(color: AppColors.primaryBlue)),
                  Text('PDF, Excel, JPG, PNG supported', style: AppTypography.bodySmall),
                ]),
              ),
            ),
            const SizedBox(height: 20),
            Text('Document Details', style: AppTypography.headlineMedium),
            const SizedBox(height: 12),
            const _InputField('Document Name', 'e.g. GSTR-3B December 2024'),
            const SizedBox(height: 12),
            Text('Category', style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w500)),
            const SizedBox(height: 6),
            Wrap(spacing: 8, children: ['GST', 'Income Tax', 'Labour', 'Licence', 'Bank', 'Other'].map((c) {
              final isSelected = _selectedType == c;
              return ChoiceChip(
                label: Text(c, style: AppTypography.labelSmall.copyWith(color: isSelected ? AppColors.primaryBlue : AppColors.textSecondary)),
                selected: isSelected,
                selectedColor: AppColors.lightBlue,
                onSelected: (_) => setState(() => _selectedType = c),
              );
            }).toList()),
            const SizedBox(height: 12),
            const _InputField('Document Date', 'DD-MM-YYYY'),
            const SizedBox(height: 24),
            Row(children: [
              const Icon(Icons.auto_awesome_rounded, color: AppColors.goldAccent, size: 16),
              const SizedBox(width: 6),
              Text('AI OCR will auto-extract data from your document', style: AppTypography.bodySmall.copyWith(color: AppColors.goldAccent)),
            ]),
            const SizedBox(height: 20),
            BHButton(
              label: _uploading ? 'Uploading...' : 'Upload Document',
              isLoading: _uploading,
              onPressed: () {
                setState(() => _uploading = true);
                Future.delayed(const Duration(seconds: 2), () {
                  if (mounted) setState(() { _uploading = false; _uploaded = true; });
                });
              },
              leadingIcon: Icons.upload_rounded,
            ),
          ],
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final String label, hint;
  const _InputField(this.label, this.hint);
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w500)),
      const SizedBox(height: 6),
      TextField(decoration: InputDecoration(hintText: hint, filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.borderLight)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.borderLight)))),
    ]);
  }
}

class _SuccessUpload extends StatelessWidget {
  final VoidCallback onOCR, onVault;
  const _SuccessUpload({required this.onOCR, required this.onVault});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const SizedBox(height: 40),
        Container(width: 80, height: 80, decoration: const BoxDecoration(gradient: AppColors.greenGradient, shape: BoxShape.circle), child: const Icon(Icons.check_rounded, color: Colors.white, size: 44)).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
        const SizedBox(height: 20),
        Text('Upload Successful!', style: AppTypography.displayMedium).animate().fadeIn(delay: 300.ms),
        const SizedBox(height: 8),
        Text('AI OCR is processing your document', style: AppTypography.bodyMedium).animate().fadeIn(delay: 450.ms),
        const SizedBox(height: 32),
        BHButton(label: 'View OCR Results', onPressed: onOCR, leadingIcon: Icons.auto_awesome_rounded).animate().fadeIn(delay: 600.ms),
        const SizedBox(height: 12),
        BHButton(label: 'Back to Vault', onPressed: onVault, type: BHButtonType.secondary).animate().fadeIn(delay: 700.ms),
      ]),
    );
  }
}

class OCRProcessingScreen extends StatefulWidget {
  const OCRProcessingScreen({super.key});
  @override
  State<OCRProcessingScreen> createState() => _OCRProcessingScreenState();
}

class _OCRProcessingScreenState extends State<OCRProcessingScreen> with SingleTickerProviderStateMixin {
  bool _complete = false;
  late AnimationController _rotController;

  @override
  void initState() {
    super.initState();
    _rotController = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _complete = true);
    });
  }

  @override
  void dispose() {
    _rotController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BHAppBar(title: 'AI OCR Processing'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: _complete ? _OCRResults() : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            RotationTransition(
              turns: _rotController,
              child: Container(width: 80, height: 80, decoration: const BoxDecoration(gradient: AppColors.goldGradient, shape: BoxShape.circle), child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 40)),
            ),
            const SizedBox(height: 24),
            Text('AI Extracting Data...', style: AppTypography.headlineLarge),
            const SizedBox(height: 8),
            Text('BizHealth360 AI is reading your document', style: AppTypography.bodyMedium),
            const SizedBox(height: 32),
            ...['Detecting document type...', 'Extracting text fields...', 'Reading financial data...', 'Validating against GST records...'].asMap().entries.map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(children: [
                const Icon(Icons.check_circle_rounded, color: AppColors.statusGreen, size: 16),
                const SizedBox(width: 8),
                Text(e.value, style: AppTypography.bodySmall),
              ]).animate().fadeIn(delay: Duration(milliseconds: e.key * 500)),
            )),
          ],
        ),
      ),
    );
  }
}

class _OCRResults extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(padding: const EdgeInsets.all(AppSpacing.lg), decoration: BoxDecoration(gradient: AppColors.greenGradient, borderRadius: BorderRadius.circular(AppRadius.card)), child: Row(children: [
        const Icon(Icons.auto_awesome_rounded, color: Colors.white),
        const SizedBox(width: 10),
        Text('AI Extracted Successfully', style: AppTypography.headlineMedium.copyWith(color: Colors.white)),
      ])),
      const SizedBox(height: 20),
      ...[
        {'key': 'Document Type', 'value': 'GSTR-3B Return'},
        {'key': 'GSTIN', 'value': '29AABCS1234Z1ZV'},
        {'key': 'Tax Period', 'value': 'November 2024'},
        {'key': 'Total Tax', 'value': '₹1,24,500'},
        {'key': 'IGST', 'value': '₹0'},
        {'key': 'CGST', 'value': '₹62,250'},
        {'key': 'SGST', 'value': '₹62,250'},
        {'key': 'Filed Date', 'value': '18-12-2024'},
      ].map((row) => Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.borderLight)),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(row['key']!, style: AppTypography.bodySmall),
          Text(row['value']!, style: AppTypography.dataMono.copyWith(color: AppColors.primaryBlue)),
        ]),
      )),
      const SizedBox(height: 16),
      BHButton(label: 'Confirm & Save to Vault', onPressed: () => context.go('/documents')),
    ]);
  }
}

class DocumentPreviewScreen extends StatelessWidget {
  const DocumentPreviewScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BHAppBar(title: 'Document Preview', actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.share_rounded)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.download_rounded)),
        const SizedBox(width: 4),
      ]),
      body: Column(children: [
        Container(
          height: 400,
          color: const Color(0xFFF8FAFF),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(Icons.picture_as_pdf_rounded, color: AppColors.statusRed, size: 80),
            const SizedBox(height: 16),
            Text('GSTR-3B_Dec2024.pdf', style: AppTypography.headlineMedium),
            Text('234 KB • 3 pages', style: AppTypography.bodySmall),
            const SizedBox(height: 12),
            const VerificationBadge(isVerified: true),
          ]),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Document Info', style: AppTypography.headlineMedium),
              const SizedBox(height: 12),
              ...[
                {'label': 'File Name', 'value': 'GSTR-3B_Dec2024.pdf'},
                {'label': 'Uploaded', 'value': '18-12-2024'},
                {'label': 'Size', 'value': '234 KB'},
                {'label': 'Status', 'value': 'CA Verified ✓'},
              ].map((r) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(r['label']!, style: AppTypography.bodySmall),
                  Text(r['value']!, style: AppTypography.labelMedium),
                ]),
              )),
            ]),
          ),
        ),
      ]),
    );
  }
}

class DocumentCategoriesScreen extends StatelessWidget {
  const DocumentCategoriesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BHAppBar(title: 'GST Documents'),
      backgroundColor: AppColors.surfaceBackground,
      body: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.lg),
        itemCount: 8,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, i) => DocumentCard(title: ['GSTR-3B Nov 2024.pdf', 'GSTR-1 Nov 2024.pdf', 'GSTR-3B Oct 2024.pdf'][i % 3], type: ['PDF', 'PDF', 'XLSX'][i % 3], size: '${(i + 1) * 120} KB', uploadedAt: DateTime.now().subtract(Duration(days: i * 5)), isVerified: i % 2 == 0, onTap: () => context.push('/documents/preview')),
      ),
    );
  }
}

class VersionHistoryScreen extends StatelessWidget {
  const VersionHistoryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BHAppBar(title: 'Version History'),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.lg),
        itemCount: 4,
        itemBuilder: (context, i) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(color: i == 0 ? AppColors.lightBlue : Colors.white, borderRadius: BorderRadius.circular(AppRadius.card), border: Border.all(color: i == 0 ? AppColors.primaryBlue.withOpacity(0.3) : AppColors.borderLight)),
          child: Row(children: [
            Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.primaryBlue.withOpacity(0.12), shape: BoxShape.circle), child: Center(child: Text('v${4 - i}', style: AppTypography.labelMedium.copyWith(color: AppColors.primaryBlue)))),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text('Version ${4 - i}${i == 0 ? ' (Current)' : ''}', style: AppTypography.labelLarge),
                if (i == 0) ...[const SizedBox(width: 6), Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: AppColors.primaryBlue, borderRadius: BorderRadius.circular(10)), child: Text('Current', style: AppTypography.labelSmall.copyWith(color: Colors.white)))],
              ]),
              Text('Uploaded ${i * 7 + 1} days ago', style: AppTypography.bodySmall),
            ])),
            if (i > 0) TextButton(onPressed: () {}, child: Text('Restore', style: AppTypography.labelMedium.copyWith(color: AppColors.primaryBlue))),
          ]),
        ),
      ),
    );
  }
}
