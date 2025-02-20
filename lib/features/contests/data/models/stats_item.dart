import 'package:dalalstreetfantasy/features/contests/data/models/portolio_item.dart';

class StatsItem {
  final PortfolioItem portfolioItem; // The PortfolioItem
  final double percentage; // The percentage of selection

  StatsItem({
    required this.portfolioItem,
    required this.percentage,
  });
}
