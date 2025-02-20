import 'package:dalalstreetfantasy/constants/boarder.dart';
import 'package:dalalstreetfantasy/features/contests/presentation/widgets/image_shimmer.dart';
import 'package:dalalstreetfantasy/features/contests/presentation/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';

import '../../../../constants/color.dart';
import '../../../../constants/values.dart';
import '../../data/models/portolio_item.dart';
import '../pages/create_portfolio.dart';
import '../provider/portfolio_provider.dart';
import '../provider/stock_select_provider.dart';

class StockModel extends StatelessWidget {
  final int index;
  final String symbol;
  final String companyName;
  final String logo;
  final Color color;
  final double lastTradedPrice;
  final double changePercent;

  const StockModel({
    super.key,
    required this.index,
    required this.symbol,        // New parameter
    required this.companyName,        // New parameter
    required this.logo,        // New parameter
    required this.color,        // New parameter
    required this.lastTradedPrice,    // New parameter
    required this.changePercent,
  });

  @override
  Widget build(BuildContext context) {
    final stockProvider = Provider.of<StockProvider>(context);
    final isSelected = stockProvider.isSelected(symbol);
    final portfolioProvider = Provider.of<PortfolioProvider>(context, listen: false);

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            if (isSelected) {
              portfolioProvider.removeFromPortfolio(symbol);
              stockProvider.toggleSelection(symbol);
            } else {
              if (portfolioProvider.selectedItems.length < AppValues.maxStocksCount) {

                final portfolioItem = PortfolioItem(
                    itemId: symbol,
                    symbol: symbol, // Assuming symbol is the same as companyName; adjust if needed
                    weightage: 0, // Default weightage; adjust if there's a specific value
                    companyName: companyName,
                    lastTradedPrice: lastTradedPrice,
                    initialChangePercent: changePercent,
                    currentChangePercent: changePercent,
                    logoUrl: logo,
                    isCaptain: false,
                    isViceCaptain: false
                );
                portfolioProvider.addToPortfolio(portfolioItem);
                stockProvider.toggleSelection(symbol);
              } else {
                mySnackBarShow(context, 'You can select up to 10 stocks only.');
              }
            }
          },
          child: Container(
            padding: EdgeInsets.all(18),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.lightBlackColor.withOpacity(0.2), width: 1),
              borderRadius: BorderRadius.circular(20),
              color: isSelected ? Colors.green.withOpacity(0.15) : Colors.transparent,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 45,
                      width: 45,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(80.0), // same value as the container
                        child: logo == 'null' || logo.isEmpty ? Container(
                          color: color.withOpacity(0.5),
                          padding: EdgeInsets.all(2),
                          child: Center(
                            child: Text(symbol, textAlign: TextAlign.center, style: TextStyle(fontSize: 6)),
                          ),
                        ) : Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: color.withOpacity(0.5),
                              width: 1,
                            ),
                          ),
                          child: ClipOval(
                            child: CustomImageShimmer(
                              imageUrl: logo,
                              fit: BoxFit.contain,
                              height: 45, width: 45,
                            ),
                          ),
                        )
                      ),
                    ),
                    SizedBox(width: 12),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.52, // Adjust container width
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 24.0, // Set a fixed height (adjust as needed)
                            child: companyName.length > 20 ? Marquee(
                              text: companyName,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                              // Customize marquee properties
                              scrollAxis: Axis.horizontal, // Scroll horizontally
                              crossAxisAlignment: CrossAxisAlignment.start,
                              blankSpace: 20.0, // Space on the right side when scrolling
                              velocity: 30.0, // Speed of the scrolling
                              startAfter: Duration(seconds: 1), // Delay before starting the scroll
                              pauseAfterRound: Duration(seconds: 2), // Increase pause time after each round
                              showFadingOnlyWhenScrolling: true, // Fade only while scrolling
                              fadingEdgeStartFraction: 0.1, // Start fading at 10% of the text width
                              fadingEdgeEndFraction: 0.1, // End fading at 10% of the text width
                              // Optionally add the following to customize the behavior more
                              // a. using `repeatForever: true` makes the text scroll indefinitely
                              // b. Consider implementing a static portion of text next to the marquee
                            ) : Text(
                              companyName,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Text(symbol, style: TextStyle(
                            color: AppColors.lightBlackColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                          ),),
                          SizedBox(height: 3),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                child: Text(
                                  '₹${lastTradedPrice.toString()}',
                                  style: TextStyle(
                                    color: AppColors.lightBlackColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              Image.asset(
                                changePercent >= 0 ? 'assets/icons/uparrow.png' : 'assets/icons/downarrow.png',
                                height: 24,
                                width: 24,
                                color: changePercent >= 0 ? Colors.green : Colors.red,
                              ),
                              Text(
                                '${changePercent.toString()}%',
                                style: TextStyle(
                                  color: changePercent >= 0 ? Colors.green : Colors.red,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                isSelected
                    ? Icon(
                  Icons.check_rounded,
                  color: Colors.green,
                  size: 30,
                )
                    : Icon(
                  Icons.add_circle_outline_outlined,
                  size: 30,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}
