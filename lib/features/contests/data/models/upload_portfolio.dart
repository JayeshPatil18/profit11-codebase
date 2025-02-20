import 'package:dalalstreetfantasy/features/contests/data/models/portolio_item.dart';

class UploadPortfolio {
  final String leagueId;
  final int totalWeightage;
  final double portfolioValue;
  final double initialPortfolioValue;
  final String userId;
  final List<PortfolioItem> stocks;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String portfolioId;
  final double returns; // Added returns field

  UploadPortfolio({
    required this.leagueId,
    required this.totalWeightage,
    required this.portfolioValue,
    required this.initialPortfolioValue,
    required this.userId,
    required this.stocks,
    required this.createdAt,
    required this.updatedAt,
    required this.portfolioId,
    required this.returns, // Added returns field to constructor
  });

  // CopyWith method to create a new instance with modified values
  UploadPortfolio copyWith({
    String? leagueId,
    int? totalWeightage,
    double? portfolioValue,
    double? initialPortfolioValue,
    String? userId,
    List<PortfolioItem>? stocks,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? portfolioId,
    double? returns, // Added returns field to copyWith method
  }) {
    return UploadPortfolio(
      leagueId: leagueId ?? this.leagueId,
      totalWeightage: totalWeightage ?? this.totalWeightage,
      portfolioValue: portfolioValue ?? this.portfolioValue,
      initialPortfolioValue: initialPortfolioValue ?? this.initialPortfolioValue,
      userId: userId ?? this.userId,
      stocks: stocks ?? this.stocks,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      portfolioId: portfolioId ?? this.portfolioId,
      returns: returns ?? this.returns, // Added returns field to copyWith method
    );
  }

  Map<String, dynamic> toMap() {
    return {
  'league_id': leagueId,
  'total_wt': totalWeightage,
  'port_val': portfolioValue,
  'init_port_val': initialPortfolioValue,
  'user_ref': userId,
  'stock_list': stocks.map((stock) => {
    'itm_id': stock.itemId,
    'sym': stock.symbol,
    'wtg': stock.weightage,
    'cmp_name': stock.companyName,
    'ltp': stock.lastTradedPrice,
    'init_chg_pct': stock.initialChangePercent,
    'curr_chg_pct': stock.currentChangePercent,
    'logo_link': stock.logoUrl,
    'cap': stock.isCaptain,
    'v_cap': stock.isViceCaptain,
    'init_stk_val': stock.initialStockValue, // New field
    'curr_stk_val': stock.currentStockValue, // New field
    'xtra_val': stock.extraValue, // New field
  }).toList(),
  'created_on': createdAt.toIso8601String(),
  'updated_on': updatedAt.toIso8601String(),
  'portfolio_ref': portfolioId,
  'profit_loss': returns, // Renamed "returns" for clarity
};

  }
}
