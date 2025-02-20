import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/news_item.dart';

class NewsService {
  final String _baseUrl = 'https://finnhub.io/api/v1';
  final String _apiKey = 'ctmrmf9r01qjlgiqr6q0ctmrmf9r01qjlgiqr6qg'; // Replace with your API key

  /// Fetch market news by category
  Future<List<News>> fetchMarketNews({String category = 'general'}) async {
    final Uri url = Uri.parse('$_baseUrl/news?category=$category&token=$_apiKey');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);


        return data.map((json) => News.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch market news: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching market news: $e');
    }
  }
}
