class PortfolioItem {
  final String itemId;
  final String symbol;
  double weightage;
  final String companyName;
  final double lastTradedPrice;
  final double initialChangePercent; // Renamed from changePercent
  final double currentChangePercent;
  final String logoUrl;
  bool isCaptain;
  bool isViceCaptain;

  // New fields
  double initialStockValue;
  double currentStockValue;
  double extraValue;

  PortfolioItem({
    required this.itemId,
    required this.symbol,
    required this.weightage,
    required this.companyName,
    required this.lastTradedPrice,
    required this.initialChangePercent, // Updated field name
    required this.currentChangePercent,
    required this.logoUrl,
    required this.isCaptain,
    required this.isViceCaptain,
    this.initialStockValue = 0.0, // Default value for new fields
    this.currentStockValue = 0.0,
    this.extraValue = 0.0,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is PortfolioItem && runtimeType == other.runtimeType && itemId == other.itemId;

  @override
  int get hashCode => itemId.hashCode;

  factory PortfolioItem.fromJson(Map<String, dynamic> json) {
    return PortfolioItem(
      itemId: json['itemId'] ?? '',
      symbol: json['symbol'] ?? '',
      weightage: (json['weightage'] ?? 0).toDouble(),
      companyName: json['name'] ?? '',
      lastTradedPrice: (json['lastTradedPrice'] ?? 0).toDouble(),
      initialChangePercent: (json['changePercent'] ?? 0).toDouble(), // Updated field name
      currentChangePercent: (json['changePercent'] ?? 0).toDouble(),
      logoUrl: json['logoUrl'] ?? '',
      isCaptain: json['isCaptain'] ?? false,
      isViceCaptain: json['isViceCaptain'] ?? false,
      initialStockValue: (json['initialValue'] ?? 0).toDouble(), // Parse new fields
      currentStockValue: (json['currentSValue'] ?? 0).toDouble(),
      extraValue: (json['extraValue'] ?? 0).toDouble(),
    );
  }
}
