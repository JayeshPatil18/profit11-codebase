class MarketIndex {
  final String symbol;
  final String indexName;
  final double currentValue;
  final double changePoints;
  final double changePercent;
  final double openingValue;

  // Constructor
  MarketIndex({
    required this.symbol,
    required this.indexName,
    required this.currentValue,
    required this.changePoints,
    required this.changePercent,
    required this.openingValue,
  });
  // Convert MarketIndex object to map (for storing in Firestore)
  Map<String, dynamic> toMap() {
    return {
      'symbol': symbol,
      'name': indexName,
      'ltp': currentValue.toStringAsFixed(2),
      'change': changePoints.toStringAsFixed(2),
      'percent': changePercent.toStringAsFixed(2),
      'close': openingValue.toStringAsFixed(2),
    };
  }
}
