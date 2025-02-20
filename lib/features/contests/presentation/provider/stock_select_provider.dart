import 'package:flutter/material.dart';

class StockProvider with ChangeNotifier {
  List<Map<String, dynamic>> listOfStocks = [];
  int selectedStockCount = 0;

  void initializeSelectedStocks(List<String> stockIds) {
    if (listOfStocks.length != stockIds.length) {
      listOfStocks = stockIds.map((stockId) {
        return {
          'stockId': stockId,
          'isSelected': false,
        };
      }).toList();
      selectedStockCount = 0;
      notifyListeners();
    }
  }

  void toggleSelection(String stockId) {
    final index = listOfStocks.indexWhere((stock) => stock['stockId'] == stockId);
    if (index != -1) {
      listOfStocks[index]['isSelected'] = !listOfStocks[index]['isSelected'];

      if (listOfStocks[index]['isSelected']) {
        selectedStockCount++;
      } else {
        selectedStockCount--;
      }

      notifyListeners();
    }
  }

  void clearStocks() {
    for (var stock in listOfStocks) {
      stock['isSelected'] = false;
    }
    selectedStockCount = 0;
    notifyListeners();
  }

  bool isSelected(String stockId) {
    bool isSelected = false;
    for(var stock in listOfStocks){
      if(stock['stockId'] == stockId){
        isSelected = stock['isSelected'];
      }
    }
    return isSelected;
  }

  int get selectedCount => selectedStockCount;
}
