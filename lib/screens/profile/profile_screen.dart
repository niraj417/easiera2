import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../widgets/buttons/bh_button.dart';
import '../../widgets/indicators/bh_indicators.dart';
import '../../widgets/navigation/bh_navigation.dart';

// Profile & Settings screens

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: AppSpacing.lg,
        title: Text('Profile', style: AppTypography.headlineLarge),
        bottom: const PreferredSize(preferredSize: Size.fromHeight(1), child: Divider(height: 1)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: const BoxDecoration(color: Colors.white),
              child: Column(children: [
                Container(
                  width: 80, height: 80,
                  decoration: BoxDecoration(gradient: AppColors.primaryGradient, shape: BoxShape.circle),
                  child: Center(child: Text('S', style: AppTypography.displayLarge.copyWith(color: Colors.white, fontWeight: FontWeight.w800))),
                ),
                const SizedBox(height: 12),
                Text('Rajesh Sharma', style: AppTypography.headlineLarge),
                Text('rajesh@sharmatrading.com', style: AppTypography.bodyMedium),
                const SizedBox(height: 8),
                VerificationBadge(isVerified: true, label: 'KYC Verified'),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(gradient: AppColors.goldGradient, borderRadius: BorderRadius.circular(20)),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    const Icon(Icons.workspace_premium_rounded, color: Colors.white, size: 16),
                    const SizedBox(width: 6),
                    Text('Biz Pro Plan', style: AppTypography.labelMedium.copyWith(color: Colors.white)),
                  ]),
                ),
              ]),
            ),
            const SizedBox(height: 8),
            // Menu sections
            _MenuSection('Business Details', [
              _MenuItem(Icons.business_rounded, 'Company Information', () => context.push('/settings/business')),
              _MenuItem(Icons.receipt_long_rounded, 'GST & Tax Settings', () => context.push('/settings/gst')),
              _MenuItem(Icons.people_rounded, 'Team Members', () => context.push('/settings/team')),
            ]),
            const SizedBox(height: 8),
            _MenuSection('Account', [
              _MenuItem(Icons.person_rounded, 'Personal Information', () => context.push('/settings/profile')),
              _MenuItem(Icons.notifications_rounded, 'Notification Preferences', () => context.push('/settings/notifications')),
              _MenuItem(Icons.security_rounded, 'Security & Login', () => context.push('/settings/security')),
            ]),
            const SizedBox(height: 8),
            _MenuSection('Subscription', [
              _MenuItem(Icons.workspace_premium_rounded, 'Current Plan: Biz Pro', () => context.push('/settings/subscription'), badge: 'Pro', badgeColor: AppColors.goldAccent),
              _MenuItem(Icons.upgrade_rounded, 'Upgrade Plan', () => context.push('/settings/subscription')),
              _MenuItem(Icons.receipt_rounded, 'Billing History', () => context.push('/settings/billing')),
            ]),
            const SizedBox(height: 8),
            _MenuSection('Help & Support', [
              _MenuItem(Icons.help_rounded, 'Help Center', () {}),
              _MenuItem(Icons.chat_rounded, 'Contact Support', () {}),
              _MenuItem(Icons.star_rate_rounded, 'Rate BizHealth360', () {}),
            ]),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: BHButton(label: 'Sign Out', onPressed: () => context.go('/login'), type: BHButtonType.danger, leadingIcon: Icons.logout_rounded),
            ),
            const SizedBox(height: 20),
            Text('BizHealth360 v2.1.0 • Build 4502', style: AppTypography.bodySmall),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _MenuSection extends StatelessWidget {
  final String title;
  final List<_MenuItem> items;
  const _MenuSection(this.title, this.items);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.sm),
          child: Text(title, style: AppTypography.labelSmall.copyWith(color: AppColors.neutralGrey, letterSpacing: 0.8)),
        ),
        ...items.map((item) => item.build(context)),
        const Divider(height: 1),
      ]),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final String? badge;
  final Color? badgeColor;
  const _MenuItem(this.icon, this.label, this.onTap, {this.badge, this.badgeColor});
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryBlue, size: 22),
      title: Text(label, style: AppTypography.bodyMedium),
      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
        if (badge != null) Container(margin: const EdgeInsets.only(right: 8), padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: badgeColor!.withOpacity(0.15), borderRadius: BorderRadius.circular(10)), child: Text(badge!, style: AppTypography.labelSmall.copyWith(color: badgeColor))),
        const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.neutralGrey),
      ]),
      onTap: onTap,
    );
  }
}

// Settings sub-screens
class BusinessSettingsScreen extends StatelessWidget {
  const BusinessSettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BHAppBar(title: 'Business Settings'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(16)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Container(width: 60, height: 60, decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.business_rounded, color: Colors.white, size: 32)),
                const SizedBox(width: 16),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Sharma Trading Pvt. Ltd.', style: AppTypography.headlineLarge.copyWith(color: Colors.white)),
                  Text('Private Limited • Retail Trading', style: AppTypography.bodySmall.copyWith(color: Colors.white60)),
                ])),
              ]),
            ]),
          ),
          const SizedBox(height: 20),
          ...[
            {'label': 'Company Name', 'value': 'Sharma Trading Pvt. Ltd.'},
            {'label': 'PAN', 'value': 'AABCS1234Z'},
            {'label': 'GSTIN', 'value': '29AABCS1234Z1ZV'},
            {'label': 'CIN', 'value': 'U74900KA2018PTC123456'},
            {'label': 'Registered Address', 'value': '123, MG Road, Bengaluru - 560001'},
            {'label': 'Business Type', 'value': 'Retail / Trading'},
          ].map((f) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.card), border: Border.all(color: AppColors.borderLight)),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(f['label']!, style: AppTypography.bodySmall),
                Text(f['value']!, style: AppTypography.labelLarge),
              ]),
              const Icon(Icons.edit_rounded, color: AppColors.neutralGrey, size: 18),
            ]),
          )),
          const SizedBox(height: 8),
          BHButton(label: 'Save Changes', onPressed: () => context.pop()),
        ]),
      ),
    );
  }
}

class SecuritySettingsScreen extends StatefulWidget {
  const SecuritySettingsScreen({super.key});
  @override
  State<SecuritySettingsScreen> createState() => _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState extends State<SecuritySettingsScreen> {
  bool _biometric = true;
  bool _twoFA = true;
  bool _loginAlerts = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BHAppBar(title: 'Security & Login'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Authentication', style: AppTypography.headlineMedium),
          const SizedBox(height: 12),
          _ToggleSetting('Biometric Login', 'Use fingerprint or Face ID', Icons.fingerprint_rounded, _biometric, (v) => setState(() => _biometric = v)),
          _ToggleSetting('Two-Factor Authentication', 'OTP on every login', Icons.security_rounded, _twoFA, (v) => setState(() => _twoFA = v)),
          _ToggleSetting('Login Alerts', 'Email alert on new device login', Icons.notifications_active_rounded, _loginAlerts, (v) => setState(() => _loginAlerts = v)),
          const SizedBox(height: 20),
          Text('Actions', style: AppTypography.headlineMedium),
          const SizedBox(height: 12),
          ...[
            {'label': 'Change Mobile Number', 'icon': Icons.phone_rounded},
            {'label': 'Change Email', 'icon': Icons.email_rounded},
            {'label': 'Active Sessions', 'icon': Icons.devices_rounded},
          ].map((item) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              tileColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.card), side: BorderSide(color: AppColors.borderLight)),
              leading: Icon(item['icon'] as IconData, color: AppColors.primaryBlue),
              title: Text(item['label'] as String, style: AppTypography.bodyMedium),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.neutralGrey),
              onTap: () {},
            ),
          )),
        ]),
      ),
    );
  }
}

class _ToggleSetting extends StatelessWidget {
  final String label, subtitle;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _ToggleSetting(this.label, this.subtitle, this.icon, this.value, this.onChanged);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.card), border: Border.all(color: AppColors.borderLight)),
      child: Row(children: [
        Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.lightBlue, borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: AppColors.primaryBlue, size: 20)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: AppTypography.labelLarge),
          Text(subtitle, style: AppTypography.bodySmall),
        ])),
        Switch(value: value, activeColor: AppColors.primaryBlue, onChanged: onChanged),
      ]),
    );
  }
}

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BHAppBar(title: 'Subscription'),
      backgroundColor: AppColors.surfaceBackground,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Current plan
          Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(gradient: AppColors.goldGradient, borderRadius: BorderRadius.circular(16)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                const Icon(Icons.workspace_premium_rounded, color: Colors.white, size: 28),
                const SizedBox(width: 8),
                Text('Biz Pro Plan', style: AppTypography.headlineLarge.copyWith(color: Colors.white)),
              ]),
              const SizedBox(height: 4),
              Text('₹999/month • Renews 01-Feb-2025', style: AppTypography.bodySmall.copyWith(color: Colors.white70)),
              const SizedBox(height: 16),
              Wrap(spacing: 8, runSpacing: 6, children: ['5 Compliances', '2 GSTIN', 'AI Insights', 'Document Vault', 'CA Portal'].map((f) => Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)), child: Text(f, style: AppTypography.labelSmall.copyWith(color: Colors.white)))).toList()),
            ]),
          ),
          const SizedBox(height: 24),
          Text('Upgrade to Enterprise', style: AppTypography.headlineMedium),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.primaryBlue.withOpacity(0.3), width: 2)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Enterprise', style: AppTypography.headlineLarge.copyWith(color: AppColors.primaryBlue)),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text('₹2,999', style: AppTypography.headlineLarge.copyWith(color: AppColors.primaryBlue)),
                  Text('/month', style: AppTypography.bodySmall),
                ]),
              ]),
              const Divider(),
              ...[
                'Unlimited Compliances',
                'Unlimited GSTIN',
                'Priority AI Advisor',
                '50 GB Document Vault',
                'Multi-Entity Support',
                'Dedicated CA Manager',
                'API Access',
                'White-label Reports',
              ].map((f) => Padding(padding: const EdgeInsets.symmetric(vertical: 3), child: Row(children: [
                const Icon(Icons.check_circle_rounded, color: AppColors.statusGreen, size: 16),
                const SizedBox(width: 8),
                Text(f, style: AppTypography.bodyMedium),
              ]))),
              const SizedBox(height: 16),
              BHButton(label: 'Upgrade to Enterprise', onPressed: () {}, trailingIcon: Icons.upgrade_rounded),
            ]),
          ),
        ]),
      ),
    );
  }
}

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});
  @override
  State<NotificationSettingsScreen> createState() => _NotifSettingsState();
}

class _NotifSettingsState extends State<NotificationSettingsScreen> {
  final Map<String, bool> _settings = {
    'Compliance Reminders': true,
    'AI Insights': true,
    'Loan Offers': false,
    'Document Expiry': true,
    'Team Updates': true,
    'Weekly Report': false,
    'Marketing Updates': false,
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BHAppBar(title: 'Notification Preferences'),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: _settings.entries.map((e) => Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.card), border: Border.all(color: AppColors.borderLight)),
          child: Row(children: [
            Expanded(child: Text(e.key, style: AppTypography.labelLarge)),
            Switch(value: e.value, activeColor: AppColors.primaryBlue, onChanged: (v) => setState(() => _settings[e.key] = v)),
          ]),
        )).toList(),
      ),
    );
  }
}

class BillingHistoryScreen extends StatelessWidget {
  const BillingHistoryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BHAppBar(title: 'Billing History'),
      backgroundColor: AppColors.surfaceBackground,
      body: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.lg),
        itemCount: 6,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, i) => Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.card), border: Border.all(color: AppColors.borderLight)),
          child: Row(children: [
            Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.lightGreen, shape: BoxShape.circle), child: const Icon(Icons.receipt_rounded, color: AppColors.statusGreen, size: 20)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Biz Pro Plan — ${['Jan', 'Dec', 'Nov', 'Oct', 'Sep', 'Aug'][i]} 2025', style: AppTypography.labelLarge),
              Text('Invoice #BH2024${1000 + i}', style: AppTypography.bodySmall),
            ])),
            Text('₹999', style: AppTypography.headlineMedium.copyWith(color: AppColors.statusGreen)),
          ]),
        ),
      ),
    );
  }
}

class TeamSettingsScreen extends StatelessWidget {
  const TeamSettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BHAppBar(title: 'Team Members', actions: [
        IconButton(onPressed: () => context.push('/setup/team'), icon: const Icon(Icons.person_add_rounded, color: AppColors.primaryBlue)),
        const SizedBox(width: 4),
      ]),
      backgroundColor: AppColors.surfaceBackground,
      body: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.lg),
        itemCount: 3,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, i) {
          final members = [
            {'name': 'Rajesh Sharma', 'role': 'Admin', 'email': 'rajesh@sharmatrading.com'},
            {'name': 'Priya Sharma', 'role': 'Manager', 'email': 'priya@sharmatrading.com'},
            {'name': 'CA Ravi Kumar', 'role': 'CA', 'email': 'ravi@ravisharmaca.com'},
          ];
          final m = members[i];
          return Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.card), border: Border.all(color: AppColors.borderLight)),
            child: Row(children: [
              Container(width: 44, height: 44, decoration: BoxDecoration(gradient: AppColors.primaryGradient, shape: BoxShape.circle), child: Center(child: Text(m['name']!.substring(0, 1), style: AppTypography.headlineMedium.copyWith(color: Colors.white)))),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(m['name']!, style: AppTypography.labelLarge),
                Text(m['email']!, style: AppTypography.bodySmall),
              ])),
              Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: AppColors.lightBlue, borderRadius: BorderRadius.circular(20)), child: Text(m['role']!, style: AppTypography.labelSmall.copyWith(color: AppColors.primaryBlue, fontWeight: FontWeight.w600))),
            ]),
          );
        },
      ),
    );
  }
}

class GSTSettingsScreen extends StatelessWidget {
  const GSTSettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BHAppBar(title: 'GST & Tax Settings'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('GST Registration', style: AppTypography.headlineMedium),
          const SizedBox(height: 12),
          ...[
            {'label': 'GSTIN', 'value': '29AABCS1234Z1ZV'},
            {'label': 'GST Type', 'value': 'Regular'},
            {'label': 'State', 'value': 'Karnataka (29)'},
            {'label': 'Filing Frequency', 'value': 'Monthly'},
          ].map((f) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.card), border: Border.all(color: AppColors.borderLight)),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(f['label']!, style: AppTypography.bodySmall),
              Text(f['value']!, style: AppTypography.labelMedium),
            ]),
          )),
          const SizedBox(height: 20),
          Text('Add Another GSTIN', style: AppTypography.headlineMedium),
          const SizedBox(height: 12),
          BHButton(label: 'Add GSTIN', onPressed: () {}, type: BHButtonType.secondary, leadingIcon: Icons.add_rounded),
        ]),
      ),
    );
  }
}
