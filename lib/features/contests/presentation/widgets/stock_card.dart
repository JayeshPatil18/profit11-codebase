import 'package:flutter/material.dart';

import '../../../../constants/color.dart';
import '../../data/models/index_item.dart';

class StockCard extends StatelessWidget {
  final MarketIndex data; // Use StockIndex class instead of Map

  StockCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.lightBlackColor.withOpacity(0.2),
          width: 0.9,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      margin: EdgeInsets.only(right: 14),
      padding: EdgeInsets.only(top: 10, bottom: 10, left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.indexName, // Use indexName from StockIndex
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 6),
          Row(
            children: [
              Text(
                data.currentValue.toString(), // Use currentValue from StockIndex
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              SizedBox(width: 6),
              Text(
                '${data.changePoints.toString()}', // Use changePoints from StockIndex
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: data.changePoints > 0 ? Colors.green : data.changePoints < 0 ? Colors.red : Colors.grey,
                ),
              ),
              SizedBox(width: 4),
              Text(
                '(${data.changePercent.toString()}%)', // Use changePercent from StockIndex
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: data.changePercent > 0 ? Colors.green : data.changePercent < 0 ? Colors.red : Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
