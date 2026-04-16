import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_provider.dart';
import 'company_provider.dart';

class OnboardingState {
  // Personal Setup
  final String fullName;
  final String mobile;
  final String email;
  final String role;
  final String dob;
  final String city;
  final String pinCode;
  
  // Company Setup
  final String pan;
  final String companyName;
  final String companyType;
  final String turnover;
  final String natureOfBusiness;
  final List<String> subCategories;
  final String gstin;
  final String gstinStatus;
  final String udyam;
  final String dscStatus;

  const OnboardingState({
    this.fullName = '',
    this.mobile = '',
    this.email = '',
    this.role = '',
    this.dob = '',
    this.city = '',
    this.pinCode = '',
    this.pan = '',
    this.companyName = '',
    this.companyType = '',
    this.turnover = '',
    this.natureOfBusiness = '',
    this.subCategories = const [],
    this.gstin = '',
    this.gstinStatus = '',
    this.udyam = '',
    this.dscStatus = '',
  });

  OnboardingState copyWith({
    String? fullName,
    String? mobile,
    String? email,
    String? role,
    String? dob,
    String? city,
    String? pinCode,
    String? pan,
    String? companyName,
    String? companyType,
    String? turnover,
    String? natureOfBusiness,
    List<String>? subCategories,
    String? gstin,
    String? gstinStatus,
    String? udyam,
    String? dscStatus,
  }) {
    return OnboardingState(
      fullName: fullName ?? this.fullName,
      mobile: mobile ?? this.mobile,
      email: email ?? this.email,
      role: role ?? this.role,
      dob: dob ?? this.dob,
      city: city ?? this.city,
      pinCode: pinCode ?? this.pinCode,
      pan: pan ?? this.pan,
      companyName: companyName ?? this.companyName,
      companyType: companyType ?? this.companyType,
      turnover: turnover ?? this.turnover,
      natureOfBusiness: natureOfBusiness ?? this.natureOfBusiness,
      subCategories: subCategories ?? this.subCategories,
      gstin: gstin ?? this.gstin,
      gstinStatus: gstinStatus ?? this.gstinStatus,
      udyam: udyam ?? this.udyam,
      dscStatus: dscStatus ?? this.dscStatus,
    );
  }
}

class OnboardingNotifier extends Notifier<OnboardingState> {
  @override
  OnboardingState build() => const OnboardingState();

  void updatePersonalInfo({
    String? fullName,
    String? mobile,
    String? email,
    String? role,
    String? dob,
    String? city,
    String? pinCode,
  }) {
    state = state.copyWith(
      fullName: fullName,
      mobile: mobile,
      email: email,
      role: role,
      dob: dob,
      city: city,
      pinCode: pinCode,
    );
  }

  void updatePanInfo(String pan, String companyName, String companyType) {
    state = state.copyWith(pan: pan, companyName: companyName, companyType: companyType);
  }
  
  void updateBusinessInfo(String turnover, String natureOfBusiness, List<String> subCategories) {
    state = state.copyWith(turnover: turnover, natureOfBusiness: natureOfBusiness, subCategories: subCategories);
  }

  void updateGstInfo(String gstin, String gstinStatus) {
    state = state.copyWith(gstin: gstin, gstinStatus: gstinStatus);
  }

  void updateComplianceInfo(String udyam, String dscStatus) {
    state = state.copyWith(udyam: udyam, dscStatus: dscStatus);
  }

  /// Finalizes the onboarding flow by invoking Auth and Company providers
  Future<void> submitToFirebase() async {
    try {
      // 1. Authenticate & Save User Profile
      await ref.read(authControllerProvider.notifier).signInAnonymouslyAndSaveProfile(
        fullName: state.fullName,
        mobile: state.mobile,
        email: state.email,
        role: state.role,
        dob: state.dob,
        city: state.city,
        pinCode: state.pinCode,
      );

      // 2. Obtain UID
      final authState = ref.read(authControllerProvider);
      final user = authState.value;
      if (user == null) {
        throw Exception("Authentication failed: User is null after sign-in.");
      }

      // 3. Save Company Profile
      await ref.read(companyControllerProvider.notifier).createCompanyProfile(
        uid: user.uid,
        pan: state.pan,
        name: state.companyName.isEmpty ? 'BizHealth360 User Company' : state.companyName,
        type: state.companyType,
        turnover: state.turnover,
        natureOfBusiness: state.natureOfBusiness,
        subCategories: state.subCategories,
        gst: state.gstin,
        gstStatus: state.gstinStatus,
        udyam: state.udyam,
        dsc: state.dscStatus,
      );
    } catch (e) {
      print('DEBUG: Onboarding submission error: $e');
      rethrow;
    }
  }
}

final onboardingProvider = NotifierProvider<OnboardingNotifier, OnboardingState>(() => OnboardingNotifier());
