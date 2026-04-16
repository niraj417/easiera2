import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

class BHBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BHBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: [
              _NavItem(icon: Icons.dashboard_rounded, label: 'Dash', index: 0, currentIndex: currentIndex, onTap: onTap),
              _NavItem(icon: Icons.task_alt_rounded, label: 'Comp', index: 1, currentIndex: currentIndex, onTap: onTap),
              _NavItem(icon: Icons.psychology_rounded, label: 'Advice', index: 2, currentIndex: currentIndex, onTap: onTap),
              _NavItem(icon: Icons.api_rounded, label: 'Links', index: 3, currentIndex: currentIndex, onTap: onTap),
              _NavItem(icon: Icons.person_outline_rounded, label: 'Profile', index: 4, currentIndex: currentIndex, onTap: onTap),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final int currentIndex;
  final Function(int) onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = index == currentIndex;

    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryBlue.withOpacity(0.08) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  icon,
                  color: isSelected ? AppColors.primaryBlue : AppColors.neutralGrey,
                  size: isSelected ? 26 : 22,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: AppTypography.labelSmall.copyWith(
                  color: isSelected ? AppColors.primaryBlue : AppColors.neutralGrey,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BHAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBack;
  final Widget? leading;
  final Color? backgroundColor;
  final bool centerTitle;

  const BHAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showBack = true,
    this.leading,
    this.backgroundColor,
    this.centerTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? Colors.white,
      elevation: 0,
      centerTitle: centerTitle,
      leading: leading ??
          (showBack
              ? IconButton(
                  icon: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceBackground,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: AppColors.textPrimary),
                  ),
                  onPressed: () => context.pop(),
                )
              : null),
      title: Text(title, style: AppTypography.headlineLarge),
      actions: actions,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: AppColors.borderLight),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);
}

class BHDashboardHeader extends StatelessWidget {
  final String companyName;
  final String gstin;
  final VoidCallback? onNotification;
  final VoidCallback? onSearch;

  const BHDashboardHeader({
    super.key,
    required this.companyName,
    required this.gstin,
    this.onNotification,
    this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: const BoxDecoration(color: Colors.white),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Text('BH', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14)),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: PopupMenuButton<String>(
              offset: const Offset(0, 40),
              position: PopupMenuPosition.under,
              onSelected: (value) {
                if (value == 'add_account') {
                  context.push('/setup/pan');
                } else {
                  // Switch account logic would go here
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Switched to $value')),
                  );
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'Sharma Trading Pvt. Ltd.',
                  child: Text('Sharma Trading Pvt. Ltd.', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                const PopupMenuItem(
                  value: 'Global Logistics',
                  child: Text('Global Logistics'),
                ),
                const PopupMenuDivider(),
                const PopupMenuItem(
                  value: 'add_account',
                  child: Row(
                    children: [
                      Icon(Icons.add_circle_outline, size: 20, color: AppColors.primaryBlue),
                      SizedBox(width: 8),
                      Text('Add New Account', style: TextStyle(color: AppColors.primaryBlue)),
                    ],
                  ),
                ),
              ],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(child: Text(companyName, style: AppTypography.labelLarge, overflow: TextOverflow.ellipsis)),
                      const Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: AppColors.textSecondary),
                    ],
                  ),
                  Text(gstin, style: AppTypography.labelSmall),
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: onSearch,
            icon: const Icon(Icons.search_rounded, color: AppColors.textSecondary),
          ),
          Stack(
            children: [
              IconButton(
                onPressed: onNotification,
                icon: const Icon(Icons.notifications_outlined, color: AppColors.textSecondary),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.statusRed,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
