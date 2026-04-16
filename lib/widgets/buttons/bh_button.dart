import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import 'package:flutter_animate/flutter_animate.dart';

enum BHButtonType { primary, secondary, danger, ghost }

class BHButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final BHButtonType type;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final double height;

  const BHButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.type = BHButtonType.primary,
    this.isLoading = false,
    this.isFullWidth = true,
    this.leadingIcon,
    this.trailingIcon,
    this.height = 52,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    BorderSide? border;

    switch (type) {
      case BHButtonType.primary:
        bgColor = AppColors.primaryBlue;
        textColor = Colors.white;
        border = null;
        break;
      case BHButtonType.secondary:
        bgColor = AppColors.lightBlue;
        textColor = AppColors.primaryBlue;
        border = const BorderSide(color: AppColors.primaryBlue, width: 1.5);
        break;
      case BHButtonType.danger:
        bgColor = AppColors.statusRed;
        textColor = Colors.white;
        border = null;
        break;
      case BHButtonType.ghost:
        bgColor = Colors.transparent;
        textColor = AppColors.primaryBlue;
        border = null;
        break;
    }

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: height,
      child: Material(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppRadius.button),
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(AppRadius.button),
          splashColor: Colors.white.withOpacity(0.2),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.button),
              border: border != null ? Border.fromBorderSide(border) : null,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xl,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (leadingIcon != null && !isLoading) ...[
                  Icon(leadingIcon, color: textColor, size: 20),
                  const SizedBox(width: AppSpacing.sm),
                ],
                if (isLoading)
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: textColor,
                      strokeWidth: 2.5,
                    ),
                  )
                else
                  Text(
                    label,
                    style: AppTypography.labelLarge.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                if (trailingIcon != null && !isLoading) ...[
                  const SizedBox(width: AppSpacing.sm),
                  Icon(trailingIcon, color: textColor, size: 20),
                ],
              ],
            ),
          ),
        ),
      ),
    ).animate().scale(
          duration: const Duration(milliseconds: 120),
          begin: const Offset(1.0, 1.0),
        );
  }
}

class BHSmallButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color? color;

  const BHSmallButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: color ?? AppColors.primaryBlue,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      child: Text(
        label,
        style: AppTypography.labelMedium.copyWith(
          color: color ?? AppColors.primaryBlue,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
