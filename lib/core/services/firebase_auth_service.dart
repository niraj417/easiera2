import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get the current logged-in user
  User? get currentUser => _auth.currentUser;

  /// Stream of auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Logs in the user anonymously if they aren't already logged in.
  /// After successful custom OTP verification via Postcoder/Brevo,
  /// we use this to get a Firebase UID to associate data with.
  Future<UserCredential> signInAnonymously() async {
    return await _auth.signInAnonymously();
  }

  /// Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Create or update user profile in Firestore after registration
  Future<void> saveUserProfile({
    required String uid,
    required String fullName,
    String? mobile,
    String? email,
    required String role,
    required String dob,
    required String city,
    required String pinCode,
  }) async {
    await _firestore.collection('users').doc(uid).set({
      'uid': uid,
      'fullName': fullName,
      'mobile': mobile,
      'email': email,
      'role': role,
      'dob': dob,
      'city': city,
      'pinCode': pinCode,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
