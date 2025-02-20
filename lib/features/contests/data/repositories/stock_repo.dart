import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../presentation/pages/create_portfolio.dart';
import '../../presentation/provider/stock_select_provider.dart';
import '../models/stock_item.dart';

void fetchStocks({
  required BuildContext context,
  required String stockListType,
  required Function() onChange,
}) {
  FirebaseFirestore.instance.collection('stocks').doc('stocksdoc').snapshots().listen((document) {
    if (document.exists && document.data() != null) {
      // Fetch the array from the document's data
      final data = document.data();
      if (data != null && data[stockListType] != null) {
        CreatePortfolioPage.originalStocksList = (data[stockListType] as List)
            .map((stockData) => StockItem.fromFirestore(stockData))
            .toList();

      } else {
        CreatePortfolioPage.originalStocksList = [];
        CreatePortfolioPage.stocksList = [];
        onChange();
      }
    } else {
      CreatePortfolioPage.originalStocksList = [];
      CreatePortfolioPage.stocksList = [];
      onChange();
    }
  }, onError: (error) {
    print("Error fetching stocks: $error");
  });

}