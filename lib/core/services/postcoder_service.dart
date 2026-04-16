import 'dart:convert';
import 'package:http/http.dart' as http;

/// Postcoder OTP Service — sends and verifies SMS OTPs
/// API Key: PCW5R-JD4DU-4YGHA-V7J3M
class PostcoderService {
  static const String _apiKey = 'PCW5R-JD4DU-4YGHA-V7J3M';
  static const String _baseUrl = 'https://ws.postcoder.com/pcw';
  static const String _from = 'BizHealth';
  static const String _identifier = 'bizheath360';

  /// Sends an OTP SMS to the given mobile number.
  /// [phone] should be in international format e.g. +919876543210 or 09876543210
  /// Returns a map with 'success', 'id', and 'error'
  static Future<Map<String, dynamic>> sendOTP(String phone) async {
    // Mocking the network call for demonstration/local testing
    await Future.delayed(const Duration(milliseconds: 800));
    final mockOtp = '123456';
    print('Mock sending SMS OTP: $mockOtp to $phone');

    return {
      'success': true,
      'id': null, // Forces the fallback validation entirely locally
      'otp': mockOtp, // Added so UI can display it
      'error': null,
    };
  }

  /// Verifies the OTP entered by the user.
  /// [id] is the session ID returned by [sendOTP].
  /// [otp] is the 6-digit code entered by the user.
  /// Returns true if valid, false otherwise.
  static Future<bool> verifyOTP(String id, String otp) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/$_apiKey/otp/verify?format=json&identifier=$_identifier',
      );

      final body = jsonEncode({'id': id, 'otp': otp});

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      print('Postcoder verifyOTP → status: ${response.statusCode}, body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(response.body) as Map<String, dynamic>;
          return data['valid'] == true;
        } catch (_) {
          return false;
        }
      }
      return false;
    } catch (e) {
      print('Postcoder verifyOTP error: $e');
      return false;
    }
  }
}
