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

    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'accept': 'application/json',
          'api-key': _apiKey,
          'content-type': 'application/json',
        },
        body: jsonEncode({
          'sender': {'name': _senderName, 'email': _senderEmail},
          'to': [
            {'email': email}
          ],
          'subject': 'Your BizHealth360 OTP Code',
          'htmlContent': '''
<div style="font-family:Arial,sans-serif;max-width:480px;margin:0 auto;padding:32px;background:#f8fafc;border-radius:12px;">
  <div style="text-align:center;margin-bottom:24px;">
    <span style="font-size:28px;font-weight:800;color:#1A5FB4;">BizHealth<span style="color:#F5B800">360</span></span>
  </div>
  <div style="background:#ffffff;border-radius:10px;padding:28px;border:1px solid #E2E8F0;">
    <h2 style="color:#0F1E35;margin-top:0;font-size:20px;">Your Verification Code</h2>
    <p style="color:#475569;font-size:14px;">Use the code below to verify your email address. It expires in 10 minutes.</p>
    <div style="text-align:center;margin:28px 0;">
      <span style="display:inline-block;font-size:42px;font-weight:800;letter-spacing:12px;color:#1A5FB4;background:#EFF6FF;padding:16px 28px;border-radius:8px;">$otp</span>
    </div>
    <p style="color:#94A3B8;font-size:12px;text-align:center;">Do not share this code with anyone. BizHealth360 will never ask for your OTP.</p>
  </div>
  <p style="color:#CBD5E1;font-size:11px;text-align:center;margin-top:20px;">© 2024 BizHealth360. All rights reserved.</p>
</div>
''',
        }),
      );

      print('Brevo status: ${response.statusCode}');
      print('Brevo body: ${response.body}');

      final isSuccess = response.statusCode == 201 || response.statusCode == 200;
      final body = jsonDecode(response.body);
      
      return {
        'success': isSuccess,
        'messageId': body['messageId'],
        'error': isSuccess ? null : (body['message'] ?? 'Unknown error'),
      };
    } catch (e) {
      print('Brevo sendOTP error: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
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
