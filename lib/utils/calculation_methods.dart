import '../features/contests/data/models/portfolio.dart';
import '../features/contests/data/models/portolio_item.dart';
import '../features/contests/data/models/stats_item.dart';

String calculateCoinsUsed(double totalCoinsGiven, int totalWeightage, double itemWeightage) {
  double result = totalCoinsGiven * itemWeightage / totalWeightage;
  String formattedResult = result.toStringAsFixed(2);

  return formattedResult;
}

List<StatsItem> calculateSelectedByPercentage(List<Portfolio> portfolios) {
  Map<String, int> itemCounts = {}; // Map to store occurrences of each item by ID

  // Count occurrences of each PortfolioItem by itemId
  for (var portfolio in portfolios) {
    for (var item in portfolio.items) {
      itemCounts[item.itemId] = (itemCounts[item.itemId] ?? 0) + 1;
    }
  }

  // Calculate selectedBy percentage for each PortfolioItem
  int totalPortfolios = portfolios.length;
  List<StatsItem> selectedByStats = [];

  itemCounts.forEach((itemId, count) {
    double percentage = (count / totalPortfolios) * 100;

    // Find the corresponding PortfolioItem for the given itemId
    PortfolioItem? correspondingItem;

    // Instead of orElse: () => null, we'll just look for the item
    for (var portfolio in portfolios) {
      for (var item in portfolio.items) {
        if (item.itemId == itemId) {
          correspondingItem = item; // Found the matching item
          break; // Exit the inner loop
        }
      }

      // If we found a valid item, break out of the loop
      if (correspondingItem?.itemId == itemId) {
        break; // valid item found, exit the loop
      }
    }

    // Only add the StatsItem if a corresponding PortfolioItem was found
    if (correspondingItem != null) {
      selectedByStats.add(StatsItem(
        portfolioItem: correspondingItem,
        percentage: percentage,
      ));
    }
  });

  return selectedByStats;
}

