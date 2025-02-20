import 'package:dalalstreetfantasy/features/contests/data/models/portolio_item.dart';

class Portfolio {
  final List<PortfolioItem> items; // Store items as a list of PortfolioItem
  final double portfolioValue;
  final double initialPortfolioValue;
  final double totalWeightage;
  final String userId;
  final String leagueId;
  final String portfolioId;
  final double returns; // New field for returns

  Portfolio({
    required this.items,
    required this.portfolioValue,
    required this.initialPortfolioValue,
    required this.totalWeightage,
    required this.userId,
    required this.leagueId,
    required this.portfolioId,
    required this.returns, // Add returns to the constructor
  });

  factory Portfolio.fromJson(Map<String, dynamic> json) {
    // Extract and convert 'stocks' to List<PortfolioItem>
    var stocksJson = json['stocks'] as List<dynamic>?; // Cast to List<dynamic>
    List<PortfolioItem> itemsList = [];

    if (stocksJson != null) {
      itemsList = stocksJson
          .map((item) => PortfolioItem.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    return Portfolio(
      items: itemsList,
      portfolioValue: (json['lastPortfolioValue'] ?? 0).toDouble(),
      initialPortfolioValue: (json['portfolioValue'] ?? 0).toDouble(),
      totalWeightage: (json['totalWeightage'] ?? 0).toDouble(),
      userId: json['uid'] ?? '',
      leagueId: json['leagueId'] ?? '',
      portfolioId: json['id'] ?? '',
      returns: (json['returns'] ?? 0).toDouble(), // Parse returns from JSON
    );
  }

  double calculateInitialStockValue(double weightage) {
    return (weightage / totalWeightage) * initialPortfolioValue;
  }

  double calculateTotalCurrentStockValue() {
    double totalCurrentStockValue = 0.0;

    for (var stock in items) {
      totalCurrentStockValue += calculateCurrentStockValue(stock);
    }

    return totalCurrentStockValue;
  }

}
