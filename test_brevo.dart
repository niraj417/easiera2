import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  const String apiKey = 'YOUR_BREVO_API_KEY';
  const String senderEmail = '795c48002@smtp-brevo.com';
  const String senderName = 'BizHealth360';
  const String apiUrl = 'https://api.brevo.com/v3/smtp/email';
  const String testToEmail = 'skmohiuddin81@gmail.com'; // I'll use a common test email or just see the response

  print('Testing Brevo API...');
  
  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {
      'accept': 'application/json',
      'api-key': apiKey,
      'content-type': 'application/json',
    },
    body: jsonEncode({
      'sender': {'name': senderName, 'email': senderEmail},
      'to': [
        {'email': testToEmail}
      ],
      'subject': 'Test OTP Code',
      'htmlContent': '<h1>Test</h1><p>Your code is 123456</p>',
    }),
  );

  print('Status Code: ${response.statusCode}');
  print('Response Body: ${response.body}');
}
