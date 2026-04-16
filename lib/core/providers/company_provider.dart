import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/firestore_service.dart';
import 'auth_provider.dart';

final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});

final companyStreamProvider = StreamProvider<Map<String, dynamic>?>((ref) {
  final authState = ref.watch(authControllerProvider);
  final user = authState.value;
  if (user == null) return Stream.value(null);
  
  return ref.watch(firestoreServiceProvider).getCompanyStream(user.uid);
});

class CompanyNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> createCompanyProfile({
    required String uid,
    required String pan,
    required String name,
    required String type,
    required String turnover,
    required String natureOfBusiness,
    required List<String> subCategories,
    required String gst,
    required String gstStatus,
    required String udyam,
    required String dsc,
  }) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(firestoreServiceProvider).saveCompanyProfile(
        uid: uid,
        pan: pan,
        name: name,
        type: type,
        turnover: turnover,
        natureOfBusiness: natureOfBusiness,
        subCategories: subCategories,
        gst: gst,
        gstStatus: gstStatus,
        udyam: udyam,
        dsc: dsc,
      );
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }
}

final companyControllerProvider =
    AsyncNotifierProvider<CompanyNotifier, void>(() => CompanyNotifier());
