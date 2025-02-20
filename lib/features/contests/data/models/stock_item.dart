class StockItem {
  final String stockSymbol;
  final String companyName;
  final String industry;
  final double ltp;
  final double previousClose;
  final double changePercent;

  StockItem({
    required this.stockSymbol,
    required this.companyName,
    required this.industry,
    required this.ltp,
    required this.previousClose,
    required this.changePercent,
  });

  // Factory constructor to create a StockItem object from Firestore data
  factory StockItem.fromFirestore(Map<String, dynamic> data) {
    return StockItem(
      stockSymbol: data['stockSymbol'] ?? 'Unknown Symbol',
      companyName: data['stockName'] ?? 'Unknown Company',
      industry: data['industry'] ?? 'Unknown Industry', // Assuming 'industry' field exists; else default value
      ltp: _parseNum(data['ltp']),
      previousClose: _parseNum(data['close']),
      changePercent: _parseNum(data['percent']),
    );
  }

  // Helper function to safely parse and round numbers to two decimal places
  static double _parseNum(dynamic value) {
    if (value is num) {
      return double.parse(value.toDouble().toStringAsFixed(2));
    } else if (value is String) {
      final parsedValue = double.tryParse(value) ?? 0.0;
      return double.parse(parsedValue.toStringAsFixed(2));
    } else {
      return 0.0; // Default to 0.0 if value is neither num nor String
    }
  }
}
