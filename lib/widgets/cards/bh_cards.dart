import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/india_formatter.dart';

class ComplianceCard extends StatelessWidget {
  final String title;
  final String category;
  final String status; // 'compliant', 'due_soon', 'overdue', 'pending'
  final DateTime dueDate;
  final String? subtitle;
  final VoidCallback? onTap;
  final bool isVerified;

  const ComplianceCard({
    super.key,
    required this.title,
    required this.category,
    required this.status,
    required this.dueDate,
    this.subtitle,
    this.onTap,
    this.isVerified = false,
  });

  Color get _statusColor {
    switch (status) {
      case 'compliant': return AppColors.statusGreen;
      case 'due_soon': return AppColors.statusAmber;
      case 'overdue': return AppColors.statusRed;
      default: return AppColors.neutralGrey;
    }
  }

  String get _statusLabel {
    switch (status) {
      case 'compliant': return 'Compliant';
      case 'due_soon': return 'Due Soon';
      case 'overdue': return 'Overdue';
      default: return 'Pending';
    }
  }

  IconData get _categoryIcon {
    switch (category) {
      case 'GST': return Icons.receipt_long;
      case 'Income Tax': return Icons.account_balance;
      case 'Labour': return Icons.people;
      case 'License': return Icons.verified;
      default: return Icons.task;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: AppColors.borderLight),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(_categoryIcon, color: _statusColor, size: 22),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(title, style: AppTypography.labelLarge),
                      ),
                      if (isVerified) ...[
                        const SizedBox(width: 4),
                        const Icon(Icons.verified, size: 14, color: AppColors.verifiedTeal),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle ?? IndiaFormatter.daysUntilDue(dueDate),
                    style: AppTypography.bodySmall.copyWith(
                      color: _statusColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppRadius.chip),
              ),
              child: Text(
                _statusLabel,
                style: AppTypography.labelSmall.copyWith(
                  color: _statusColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DocumentCard extends StatelessWidget {
  final String title;
  final String type;
  final String size;
  final DateTime uploadedAt;
  final bool isVerified;
  final VoidCallback? onTap;

  const DocumentCard({
    super.key,
    required this.title,
    required this.type,
    required this.size,
    required this.uploadedAt,
    this.isVerified = false,
    this.onTap,
  });

  Color get _typeColor {
    switch (type.toUpperCase()) {
      case 'PDF': return AppColors.statusRed;
      case 'XLSX':
      case 'XLS': return AppColors.statusGreen;
      case 'JPG':
      case 'PNG': return AppColors.primaryBlue;
      default: return AppColors.neutralGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 52,
              decoration: BoxDecoration(
                color: _typeColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.description, color: _typeColor, size: 20),
                  Text(
                    type.toUpperCase(),
                    style: AppTypography.labelSmall.copyWith(
                      color: _typeColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(title, style: AppTypography.labelMedium, maxLines: 1, overflow: TextOverflow.ellipsis)),
                      if (isVerified)
                        const Icon(Icons.verified, size: 14, color: AppColors.verifiedTeal),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$size • ${IndiaFormatter.formatDateFull(uploadedAt)}',
                    style: AppTypography.labelSmall,
                  ),
                ],
              ),
            ),
            const Icon(Icons.more_vert, color: AppColors.neutralGrey, size: 18),
          ],
        ),
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String? change;
  final bool isPositive;
  final Color color;
  final IconData icon;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    this.change,
    this.isPositive = true,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              if (change != null)
                Row(
                  children: [
                    Icon(
                      isPositive ? Icons.trending_up : Icons.trending_down,
                      color: isPositive ? AppColors.statusGreen : AppColors.statusRed,
                      size: 14,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      change!,
                      style: AppTypography.labelSmall.copyWith(
                        color: isPositive ? AppColors.statusGreen : AppColors.statusRed,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(value, style: AppTypography.displayMedium.copyWith(color: AppColors.textPrimary)),
          const SizedBox(height: 2),
          Text(label, style: AppTypography.bodySmall),
        ],
      ),
    );
  }
}
