import 'dart:convert';
import 'package:dalalstreetfantasy/main.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../data/models/leauge_item.dart';
import '../../data/models/portfolio.dart';

Future<Map<String, dynamic>> updatePortfolioData({
  required String leagueId,
  required String userId,
  required String stockListType,
}) async {
  const String baseUrl = "https://portfolio-cloud-function.onrender.com/api/updatePortfolioData";

  final Map<String, String> requestBody = {
    "leagueId": leagueId,
    "userId": userId,
    "stockListType": stockListType,
  };

  try {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (responseData.containsKey('result')) {
        List<dynamic> resultList = responseData['result'];

        // Iterate over the result list and handle type conversion
        for (var item in resultList) {
          if (item is Map<String, dynamic>) {
            item['rank'] = item['rank'] is int ? item['rank'] : (item['rank'] is double ? item['rank'] : -1);
            item['prize'] = item['prize'] is int ? (item['prize'] as int).toDouble() : (item['prize'] is double ? item['prize'] : 0.0);
            item['returns'] = item['returns'] is int ? (item['returns'] as int).toDouble() : (item['returns'] is double ? item['returns'] : 0.0);
          }
        }

        return {
          'message': responseData['message'],
          'result': resultList,
        };
      } else {
        throw Exception("Missing 'result' in the response.");
      }
    } else if (response.statusCode == 404) {
      final Map<String, dynamic> errorData = jsonDecode(response.body);
      throw Exception("Not Found: ${errorData['error'] ?? 'Unknown error'}");
    } else {
      throw Exception(
          "Failed to fetch portfolio data. Status code: ${response.statusCode}, Response: ${response.body}");
    }
  } catch (e) {
    throw Exception("Error fetching portfolio data: $e");
  }
}

updatePortfolio({
  required LeagueItem league,
}) async {
  DateTime now = DateTime.now();
  String formattedTime = DateFormat("yyyy-MM-dd HH:mm:ss").format(now);

  // formattedTime.compareTo(league.startTime) >= 0 && formattedTime.compareTo(league.endTime) <= 0

  try {
    final portfolioResponse = await updatePortfolioData(
      leagueId: league.leagueId,
      userId: MyApp.loggedInUserId,
      stockListType: league.stockListType,
    );

  } catch (e) {
    print('Error updating portfolio: $e');
  }
}
