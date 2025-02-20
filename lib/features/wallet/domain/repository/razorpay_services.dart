import 'dart:convert';
import 'package:http/http.dart' as http;

class RazorpayService {
  static const String _apiUrl = 'https://us-central1-profit-11.cloudfunctions.net/createOrder';

  Future<String?> createOrder(int amount) async {
    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'amount': amount}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['orderId']; // Extract orderId from the response
      } else {
        throw Exception('Failed to create order');
      }
    } catch (e) {
      print('Error creating order: $e');
      return null;
    }
  }
}
