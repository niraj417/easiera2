import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firebase_auth_service.dart';

final authServiceProvider = Provider<FirebaseAuthService>((ref) {
  return FirebaseAuthService();
});

class AuthNotifier extends AsyncNotifier<User?> {
  @override
  FutureOr<User?> build() {
    final service = ref.watch(authServiceProvider);
    service.authStateChanges.listen((user) {
      state = AsyncValue.data(user);
    });
    return service.authStateChanges.first;
  }

  Future<void> signInAnonymouslyAndSaveProfile({
    required String fullName,
    String? mobile,
    String? email,
    required String role,
    required String dob,
    required String city,
    required String pinCode,
  }) async {
    state = const AsyncValue.loading();
    try {
      final cred = await ref.read(authServiceProvider).signInAnonymously();
      final user = cred.user;
      if (user != null) {
        await ref.read(authServiceProvider).saveUserProfile(
          uid: user.uid,
          fullName: fullName,
          mobile: mobile,
          email: email,
          role: role,
          dob: dob,
          city: city,
          pinCode: pinCode,
        );
      }
      state = AsyncValue.data(user);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> signOut() async {
    await ref.read(authServiceProvider).signOut();
  }
}

final authControllerProvider =
    AsyncNotifierProvider<AuthNotifier, User?>(() => AuthNotifier());
