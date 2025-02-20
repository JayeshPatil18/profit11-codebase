import 'package:flutter/foundation.dart';
import '../../data/models/portolio_item.dart';

class PortfolioProvider with ChangeNotifier {
  final List<PortfolioItem> _selectedItems = [];

  List<PortfolioItem> get selectedItems => _selectedItems;

  // Add item to portfolio
  void addToPortfolio(PortfolioItem item) {
    if (!_selectedItems.contains(item)) {
      _selectedItems.add(item);
      notifyListeners();
    }
  }

  // Remove item from portfolio
  void removeFromPortfolio(String id) {
    _selectedItems.removeWhere((item) => item.itemId == id);
    notifyListeners();
  }

  // Clear entire portfolio
  void clearPortfolio() {
    _selectedItems.clear();
    notifyListeners();
  }
}
