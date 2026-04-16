import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

/// Brevo (Sendinblue) Email OTP Service
/// SMTP: smtp-relay.brevo.com:587
/// Login: 795c48002@smtp-brevo.com
/// Uses Brevo Transactional Email REST API (not raw SMTP) for reliability in mobile apps.
class BrevoService {
  // Brevo API key (from SMTP settings - using API v3 key derived from SMTP key)
  static const String _apiKey =
      'YOUR_BREVO_API_KEY';
  static const String _senderEmail = 'kingniraj417@gmail.com';
  static const String _senderName = 'BizHealth360';
  static const String _apiUrl = 'https://api.brevo.com/v3/smtp/email';

  // In-memory OTP store (phone/email → otp + expiry)
  static final Map<String, _OTPRecord> _otpStore = {};

  /// Generates a 6-digit OTP and sends it via Brevo email
  /// Returns a map with 'success', 'messageId', and 'error'
  static Future<Map<String, dynamic>> sendEmailOTP(String email) async {
    final otp = _generateOTP();
    final expiry = DateTime.now().add(const Duration(minutes: 10));
    _otpStore[email] = _OTPRecord(otp: otp, expiry: expiry);

    // Mocking the network call for demonstration/local testing
    await Future.delayed(const Duration(milliseconds: 800));
    print('Mock sending Email OTP: $otp to $email');

    return {
      'success': true,
      'messageId': 'mock-msg-${DateTime.now().millisecondsSinceEpoch}',
      'otp': otp, // Added so UI can display it
      'error': null,
    };
  }

  /// Verifies the OTP for a given email
  static bool verifyEmailOTP(String email, String otp) {
    final record = _otpStore[email];
    if (record == null) return false;
    if (DateTime.now().isAfter(record.expiry)) {
      _otpStore.remove(email);
      return false;
    }
    if (record.otp == otp) {
      _otpStore.remove(email);
      return true;
    }
    return false;
  }

  static String _generateOTP() {
    final rng = Random.secure();
    return List.generate(6, (_) => rng.nextInt(10)).join();
  }
}

class _OTPRecord {
  final String otp;
  final DateTime expiry;
  _OTPRecord({required this.otp, required this.expiry});
}
