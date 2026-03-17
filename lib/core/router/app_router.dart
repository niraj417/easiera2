import 'package:go_router/go_router.dart';

// Auth screens
import '../../screens/auth/splash_screen.dart';
import '../../screens/auth/onboarding_screen.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/phone_otp_screen.dart';
import '../../screens/auth/email_otp_screen.dart';
import '../../screens/auth/forgot_access_screen.dart';

// Setup screens
import '../../screens/setup/setup_pan_screen.dart';
import '../../screens/setup/setup_business_type_screen.dart';
import '../../screens/setup/setup_licenses_screen.dart';
import '../../screens/setup/setup_team_screen.dart';

// Main shell
import '../../screens/main_shell.dart';

// Dashboard
import '../../screens/dashboard/dashboard_screen.dart';
import '../../screens/dashboard/notifications_screen.dart';
import '../../screens/dashboard/search_screen.dart';

// Compliance
import '../../screens/compliance/compliance_overview_screen.dart';
import '../../screens/compliance/fssai_detail_screen.dart';

// Documents
import '../../screens/documents/document_vault_screen.dart';

// Health Score
import '../../screens/health_score/health_score_dashboard_screen.dart';
import '../../screens/health_score/score_history_screen.dart';

// AI Advisor
import '../../screens/ai_advisor/ai_advisor_screen.dart';
import '../../screens/ai_advisor/daily_insights_screen.dart';

// Loans
import '../../screens/loans/loan_marketplace_screen.dart';
import '../../screens/loans/nbfc_partners_screen.dart';

// CA Portal
import '../../screens/ca_portal/ca_portal_screen.dart';
import '../../screens/ca_portal/switch_company_screen.dart';

// Integrations
import '../../screens/integrations/integrations_hub_screen.dart';
import '../../screens/integrations/zoho_books_screen.dart';

// Profile
import '../../screens/profile/profile_screen.dart';
import '../../screens/profile/help_support_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    // ── Auth ──────────────────────────────────────────────────────────────
    GoRoute(path: '/', builder: (_, __) => const SplashScreen()),
    GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingScreen()),
    GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
    GoRoute(path: '/otp/phone', builder: (_, __) => const PhoneOTPScreen()),
    GoRoute(path: '/otp/email', builder: (_, __) => const EmailOTPScreen()),
    GoRoute(path: '/forgot-access', builder: (_, __) => const ForgotAccessScreen()),

    // ── Setup ─────────────────────────────────────────────────────────────
    GoRoute(path: '/setup/pan', builder: (_, __) => const SetupPanScreen()),
    GoRoute(path: '/setup/gstin', builder: (_, __) => const SetupGstinScreen()),
    GoRoute(path: '/setup/business-type', builder: (_, __) => const SetupBusinessTypeScreen()),
    GoRoute(path: '/setup/licenses', builder: (_, __) => const SetupLicensesScreen()),
    GoRoute(path: '/setup/mca', builder: (_, __) => const SetupMcaScreen()),
    GoRoute(path: '/setup/team', builder: (_, __) => const SetupTeamScreen()),
    GoRoute(path: '/setup/success', builder: (_, __) => const SetupSuccessScreen()),

    // ── Main Shell (bottom nav) ────────────────────────────────────────────
    ShellRoute(
      builder: (_, state, child) => MainShell(child: child),
      routes: [
        GoRoute(path: '/dashboard', builder: (_, __) => const DashboardScreen()),
        GoRoute(path: '/compliance', builder: (_, __) => const ComplianceOverviewScreen()),
        GoRoute(path: '/documents', builder: (_, __) => const DocumentVaultScreen()),
        GoRoute(path: '/health', builder: (_, __) => const HealthScoreDashboardScreen()),
        GoRoute(path: '/ai-advisor', builder: (_, __) => const AIAdvisorScreen()),
      ],
    ),

    // ── Dashboard extras ───────────────────────────────────────────────────
    GoRoute(path: '/notifications', builder: (_, __) => const NotificationsScreen()),
    GoRoute(path: '/alerts', builder: (_, __) => const AlertsCenterScreen()),
    GoRoute(path: '/search', builder: (_, __) => const SearchScreen()),

    // ── Compliance sub-routes ──────────────────────────────────────────────
    GoRoute(path: '/compliance/gst', builder: (_, __) => const GSTComplianceScreen()),
    GoRoute(path: '/compliance/gst/detail', builder: (_, __) => const GSTFilingDetailScreen()),
    GoRoute(path: '/compliance/income-tax', builder: (_, __) => const IncomeTaxScreen()),
    GoRoute(path: '/compliance/labour', builder: (_, __) => const LabourLawsScreen()),
    GoRoute(path: '/compliance/licenses', builder: (_, __) => const LicensesScreen()),
    GoRoute(path: '/compliance/licenses/fssai', builder: (_, __) => const FSSAIDetailScreen()),
    GoRoute(path: '/compliance/licenses/shop-act', builder: (_, __) => const ShopActScreen()),
    GoRoute(path: '/compliance/licenses/factory', builder: (_, __) => const FactoryLicenseScreen()),
    GoRoute(path: '/compliance/licenses/pollution', builder: (_, __) => const PollutionBoardScreen()),
    GoRoute(path: '/compliance/licenses/trademark', builder: (_, __) => const TrademarkScreen()),
    GoRoute(path: '/compliance/pf-esi', builder: (_, __) => const PFESIScreen()),
    GoRoute(path: '/compliance/calendar', builder: (_, __) => const ComplianceCalendarScreen()),
    GoRoute(path: '/compliance/add', builder: (_, __) => const AddComplianceScreen()),
    GoRoute(path: '/compliance/history', builder: (_, __) => const ComplianceHistoryScreen()),
    GoRoute(path: '/compliance/verification', builder: (_, __) => const VerificationRequestScreen()),

    // ── Document sub-routes ────────────────────────────────────────────────
    GoRoute(path: '/documents/upload', builder: (_, __) => const UploadDocumentScreen()),
    GoRoute(path: '/documents/ocr', builder: (_, __) => const OCRProcessingScreen()),
    GoRoute(path: '/documents/preview', builder: (_, __) => const DocumentPreviewScreen()),
    GoRoute(path: '/documents/categories', builder: (_, __) => const DocumentCategoriesScreen()),
    GoRoute(path: '/documents/versions', builder: (_, __) => const VersionHistoryScreen()),

    // ── Health Score sub-routes ────────────────────────────────────────────
    GoRoute(path: '/health/detail', builder: (_, __) => const HealthScoreDetailScreen()),
    GoRoute(path: '/health/comparison', builder: (_, __) => const HealthComparisonScreen()),
    GoRoute(path: '/health/history', builder: (_, __) => const ScoreHistoryScreen()),
    GoRoute(path: '/health/tips', builder: (_, __) => const ScoreImprovementScreen()),
    GoRoute(path: '/health/certificate', builder: (_, __) => const ScoreCertificateScreen()),

    // ── AI Advisor sub-routes ──────────────────────────────────────────────
    GoRoute(path: '/ai-advisor/chat', builder: (_, __) => const AIChatScreen()),
    GoRoute(path: '/ai-advisor/report', builder: (_, __) => const AIReportScreen()),
    GoRoute(path: '/ai-advisor/daily', builder: (_, __) => const DailyInsightsScreen()),
    GoRoute(path: '/ai-advisor/saved', builder: (_, __) => const SavedInsightsScreen()),
    GoRoute(path: '/ai-advisor/financial', builder: (_, __) => const FinancialInsightsScreen()),
    GoRoute(path: '/ai-advisor/risks', builder: (_, __) => const RiskAlertsScreen()),

    // ── Loans ──────────────────────────────────────────────────────────────
    GoRoute(path: '/loans', builder: (_, __) => const LoanMarketplaceScreen()),
    GoRoute(path: '/loans/eligibility', builder: (_, __) => const LoanEligibilityScreen()),
    GoRoute(path: '/loans/offers', builder: (_, __) => const LoanOffersScreen()),
    GoRoute(path: '/loans/apply', builder: (_, __) => const LoanApplicationScreen()),
    GoRoute(path: '/loans/nbfc', builder: (_, __) => const NBFCPartnersScreen()),
    GoRoute(path: '/loans/status', builder: (_, __) => const LoanApplicationStatusScreen()),

    // ── CA Portal ──────────────────────────────────────────────────────────
    GoRoute(path: '/ca', builder: (_, __) => const CAPortalScreen()),
    GoRoute(path: '/ca/client-dashboard', builder: (_, __) => const CAClientDashboardScreen()),
    GoRoute(path: '/ca/add-client', builder: (_, __) => const AddCAClientScreen()),
    GoRoute(path: '/ca/switch', builder: (_, __) => const SwitchCompanyScreen()),
    GoRoute(path: '/ca/bulk-reports', builder: (_, __) => const BulkReportsScreen()),
    GoRoute(path: '/ca/settings', builder: (_, __) => const CASettingsScreen()),

    // ── Integrations ───────────────────────────────────────────────────────
    GoRoute(path: '/integrations', builder: (_, __) => const IntegrationsHubScreen()),
    GoRoute(path: '/integrations/tally', builder: (_, __) => const TallyConnectScreen()),
    GoRoute(path: '/integrations/bank', builder: (_, __) => const BankStatementScreen()),
    GoRoute(path: '/integrations/zoho', builder: (_, __) => const ZohoBooksScreen()),
    GoRoute(path: '/integrations/hr', builder: (_, __) => const HRIntegrationScreen()),
    GoRoute(path: '/integrations/excel', builder: (_, __) => const ExcelUploadScreen()),

    // ── Profile & Settings ─────────────────────────────────────────────────
    GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
    GoRoute(path: '/settings/business', builder: (_, __) => const BusinessSettingsScreen()),
    GoRoute(path: '/settings/security', builder: (_, __) => const SecuritySettingsScreen()),
    GoRoute(path: '/settings/subscription', builder: (_, __) => const SubscriptionScreen()),
    GoRoute(path: '/settings/notifications', builder: (_, __) => const NotificationSettingsScreen()),
    GoRoute(path: '/settings/billing', builder: (_, __) => const BillingHistoryScreen()),
    GoRoute(path: '/settings/team', builder: (_, __) => const TeamSettingsScreen()),
    GoRoute(path: '/settings/gst', builder: (_, __) => const GSTSettingsScreen()),
    GoRoute(path: '/help', builder: (_, __) => const HelpSupportScreen()),
  ],
);
