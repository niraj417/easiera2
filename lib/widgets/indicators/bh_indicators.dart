import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';

class StatusChip extends StatelessWidget {
  final String label;
  final String status; // 'compliant', 'due_soon', 'overdue', 'pending', 'verified'
  final bool isSmall;

  const StatusChip({super.key, required this.label, required this.status, this.isSmall = false});

  Color get _color {
    switch (status) {
      case 'compliant': return AppColors.statusGreen;
      case 'due_soon': return AppColors.statusAmber;
      case 'overdue': return AppColors.statusRed;
      case 'verified': return AppColors.verifiedTeal;
      default: return AppColors.neutralGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? 8 : 12,
        vertical: isSmall ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(AppRadius.chip),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: _color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: (isSmall ? AppTypography.labelSmall : AppTypography.labelMedium).copyWith(
              color: _color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class VerificationBadge extends StatelessWidget {
  final bool isVerified;
  final String? label;

  const VerificationBadge({super.key, required this.isVerified, this.label});

  @override
  Widget build(BuildContext context) {
    final color = isVerified ? AppColors.verifiedTeal : AppColors.neutralGrey;
    final bg = isVerified ? AppColors.lightTeal : AppColors.surfaceBackground;
    final icon = isVerified ? Icons.verified : Icons.pending_outlined;
    final text = label ?? (isVerified ? 'Verified' : 'Pending Verification');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.chip),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 4),
          Text(
            text,
            style: AppTypography.labelSmall.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class ProgressBarWidget extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  final String? trailingLabel;

  const ProgressBarWidget({
    super.key,
    required this.label,
    required this.value,
    required this.color,
    this.trailingLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTypography.bodySmall),
            Text(
              trailingLabel ?? '${(value * 100).toInt()}%',
              style: AppTypography.labelSmall.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: value,
            backgroundColor: color.withOpacity(0.12),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}

class TimelineItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final DateTime date;
  final bool isLast;
  final Color color;
  final IconData icon;

  const TimelineItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.date,
    this.isLast = false,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 16, color: color),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 36,
                color: AppColors.borderLight,
              ),
          ],
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTypography.labelMedium),
              const SizedBox(height: 2),
              Text(subtitle, style: AppTypography.bodySmall),
              const SizedBox(height: 4),
              Text(
                '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}',
                style: AppTypography.labelSmall,
              ),
              if (!isLast) const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ],
    );
  }
}

class LoadingSkeleton extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const LoadingSkeleton({
    super.key,
    this.width = double.infinity,
    this.height = 16,
    this.borderRadius = 8,
  });

  @override
  State<LoadingSkeleton> createState() => _LoadingSkeletonState();
}

class _LoadingSkeletonState extends State<LoadingSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _animation = Tween<double>(begin: -1.5, end: 1.5)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment(_animation.value - 1, 0),
              end: Alignment(_animation.value + 1, 0),
              colors: [
                const Color(0xFFE2E8F0),
                const Color(0xFFF1F5F9),
                const Color(0xFFE2E8F0),
              ],
            ),
          ),
        );
      },
    );
  }
}
