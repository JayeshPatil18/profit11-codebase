import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> createOrder(
    {required int orderAmount,
      required String customerId,
      required String customerName,
      required String customerEmail,
      required String customerPhone,
      required String orderNote}) async {
  const String url = 'https://order-cashfree.onrender.com/create-order';

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'order_amount': orderAmount.toString(),
        'order_currency': 'INR',
        'customer_details': {
          'customer_id': customerId,
          'customer_name': customerName,
          'customer_email': customerEmail,
          'customer_phone': customerPhone,
        },
        'order_meta': {
          'return_url': 'https://yourwebsite.com/return-url',
        },
        'order_note': orderNote,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Failed to create order. Status code: ${response.statusCode}, Response: ${response.body}');
    }
  } catch (e) {
    throw Exception('Error creating order: $e');
  }
}
