import 'package:dalalstreetfantasy/constants/boarder.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

import '../../../../constants/color.dart';
import '../../../../constants/values.dart';
import '../../../../utils/method1.dart';
import '../../data/models/stats_item.dart';
import '../pages/create_portfolio.dart';
import 'image_shimmer.dart';

class StatsStockModel extends StatefulWidget {
  final StatsItem statsItem;
  final Color color;

  const StatsStockModel({super.key, required this.statsItem, required this.color});

  @override
  State<StatsStockModel> createState() => _StatsStockModelState();
}

class _StatsStockModelState extends State<StatsStockModel> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: AppColors.lightBlackColor.withOpacity(0.2),
              width: 0.9,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    height: 45,
                    width: 45,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(80.0), // same value as the container
                      child: widget.statsItem.portfolioItem.logoUrl == 'null' || widget.statsItem.portfolioItem.logoUrl.isEmpty ? Container(
                        color: widget.color.withOpacity(0.5),
                        padding: EdgeInsets.all(2),
                        child: Center(
                          child: Text(widget.statsItem.portfolioItem.symbol, textAlign: TextAlign.center, style: TextStyle(fontSize: 6)),
                        ),
                      ): Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: widget.color.withOpacity(0.5),
                            width: 1,
                          ),
                        ),
                        child: ClipOval(
                          child: CustomImageShimmer(
                            imageUrl: widget.statsItem.portfolioItem.logoUrl,
                            fit: BoxFit.contain,
                            height: 45, width: 45,
                          ),
                        ),
                      )
                    ),
                  ),
                  SizedBox(width: 12),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 20.0, // Set a fixed height (adjust as needed)
                          width: MediaQuery.of(context).size.width * 0.40,
                          child: widget.statsItem.portfolioItem.companyName.length > 20 ? Marquee(
                            text: widget.statsItem.portfolioItem.companyName,
                            style: TextStyle(
                              fontSize: 16,
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
                            widget.statsItem.portfolioItem.companyName,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(height: 3),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment:
                          MainAxisAlignment.start,
                          children: [
                            Container(
                                child: Text(
                                  '₹${formatDoubleWithCommas(widget.statsItem.portfolioItem.lastTradedPrice)}',
                                  style: TextStyle(
                                      color: AppColors.lightBlackColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                                )),
                            SizedBox(width: 5),
                            Image.asset(
                              widget.statsItem.portfolioItem.currentChangePercent >= 0 ? 'assets/icons/uparrow.png' : 'assets/icons/downarrow.png',
                              height: 25,
                              width: 25,
                              color: widget.statsItem.portfolioItem.currentChangePercent >= 0 ? Colors.green : Colors.red,
                            ),
                            Text('${formatDoubleWithCommas(widget.statsItem.portfolioItem.currentChangePercent)}%',
                                style: TextStyle(
                                    color: widget.statsItem.portfolioItem.currentChangePercent >= 0 ? Colors.green : Colors.red,
                                    fontSize: 16,
                                    fontWeight:
                                    FontWeight.w400))
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      'Selected By',
                      style: TextStyle(
                          color: AppColors.lightBlackColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w400)
                  ),
                  SizedBox(height: 3),
                  Container(
                      child: Text(
                        '${formatDoubleWithCommas(widget.statsItem.percentage)}%',
                        style: TextStyle(
                            color: AppColors.lightBlackColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      )),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
