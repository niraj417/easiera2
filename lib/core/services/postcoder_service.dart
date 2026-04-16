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
    try {
      // Normalise: strip non-digits
      final cleaned = phone.replaceAll(RegExp(r'\D'), '');
      // Build normalised number: exactly 10 digits → prepend 91
      // Already has 91 prefix (12 digits) → use as-is
      // Anything else → use as-is and let API report the error
      final String normalised;
      if (cleaned.length == 10) {
        normalised = '91$cleaned';
      } else if (cleaned.length == 12 && cleaned.startsWith('91')) {
        normalised = cleaned;
      } else {
        normalised = cleaned;
      }

      final url = Uri.parse(
        '$_baseUrl/$_apiKey/otp/send?format=json&identifier=$_identifier',
      );

      final body = jsonEncode({
        'to': normalised,
        'from': _from,
        'message':
            'Your BizHealth360 verification code is [otp]. Valid for [expiry] minutes. Do not share this code.',
        'otplength': 6,
        'expiry': 10,
      });

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      print('Postcoder sendOTP → status: ${response.statusCode}, body: ${response.body}');

      // Safely decode — API may return plain text or HTML on errors
      Map<String, dynamic>? data;
      try {
        data = jsonDecode(response.body) as Map<String, dynamic>;
      } catch (_) {
        data = null;
      }

      if (response.statusCode == 200 && data != null) {
        return {
          'success': true,
          'id': data['id'] as String?,
        };
      } else {
        final errorMsg = data?['error'] ??
            data?['message'] ??
            response.headers['x-pcw-error'] ??
            'Failed to send SMS OTP (HTTP ${response.statusCode})';
        print('Postcoder Error: $errorMsg');
        return {
          'success': false,
          'error': errorMsg.toString(),
        };
      }
    } catch (e) {
      print('Postcoder sendOTP error: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
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
