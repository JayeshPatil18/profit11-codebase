import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dalalstreetfantasy/features/contests/data/models/user_item.dart';

import '../features/contests/data/models/portfolio.dart';
import '../features/contests/data/models/user.dart';
import '../features/contests/presentation/pages/view_contest.dart';
import '../main.dart';

Future<double> getPrizeForRank(List<Map<String, dynamic>> winnings, int rank) async{
  double userPrizeOfLeague = 0.0;
  for (var entry in winnings) {
    if (entry['rank'] == rank) {
      userPrizeOfLeague = entry['prize']?.toDouble() ?? 0.0;
      break;
    }
  }

  return userPrizeOfLeague;
}

Future<int> fetchAndCalculateUserRank(String leagueId, String userId) async {
  // Fetch data from Firestore
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('portfolios')
      .where('leagueId', isEqualTo: leagueId)
      .get();

  // Convert documents to a list of Portfolio objects
  List<Portfolio> allPortfolios = querySnapshot.docs.map((doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Portfolio.fromJson(data);
  }).toList();

  if (allPortfolios.isEmpty) {
    return -1; // Return -1 if no portfolios found
  }

  // Calculate percentage change for each portfolio
  List<Map<String, dynamic>> portfolioWithChange = allPortfolios.map((portfolio) {
    double totalCurrentStockValue = portfolio.calculateTotalCurrentStockValue();
    double percentageChange = calculatePercentageChange(
      totalCurrentStockValue,
      portfolio.initialPortfolioValue,
    );

    return {
      'portfolio': portfolio,
      'percentageChange': percentageChange,
    };
  }).toList();

  // Sort portfolios by percentage change in descending order
  portfolioWithChange.sort((a, b) {
    return (b['percentageChange'] as double).compareTo(a['percentageChange'] as double);
  });

  // Find the user's rank
  int userRank = portfolioWithChange.indexWhere((entry) {
    Portfolio portfolio = entry['portfolio'] as Portfolio;
    return portfolio.userId == userId;
  });

  return userRank == -1 ? -1 : userRank + 1; // Return -1 if not found, otherwise 1-based rank
}

double calculatePercentageChange(
    double totalCurrentStockValue, double initialPortfolioValue) {
  if (initialPortfolioValue == 0) {
    throw ArgumentError("Initial portfolio value cannot be zero");
  }
  return (((totalCurrentStockValue - initialPortfolioValue) /
      initialPortfolioValue) *
      100);
}

Future<List<UserItem>> fetchAllUsers() async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users').get();
  return querySnapshot.docs.map((doc) {
    return UserItem.fromFirestore(doc.data() as Map<String, dynamic>);
  }).toList();
}

Future<void> fetchUsers() async {
  List<UserItem> users = await fetchAllUsers();
    ViewContestPage.userList = users;
}