import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

import '../../../../constants/color.dart';
import '../../../../utils/method1.dart';
import '../../../../utils/methods.dart';
import 'image_shimmer.dart';
import 'line.dart';

class PortfolioStockModel extends StatefulWidget {
  final Color color;
  final double initialStockValue;
  final double extraValue;
  final double currentStockValue;
  final double totalWeightage;
  final bool isCaptain;
  final bool isViceCaptain;
  final String logoUrl;
  final String symbol;
  final String companyName;
  final double weightage;
  final double currentChangePercent;
  final double lastTradedPrice;

  const PortfolioStockModel({
    Key? key,
    required this.color,
    required this.initialStockValue,
    required this.extraValue,
    required this.currentStockValue,
    required this.totalWeightage,
    required this.isCaptain,
    required this.isViceCaptain,
    required this.logoUrl,
    required this.symbol,
    required this.companyName,
    required this.weightage,
    required this.currentChangePercent,
    required this.lastTradedPrice,
  }) : super(key: key);

  @override
  State<PortfolioStockModel> createState() => _PortfolioStockModelState();
}

class _PortfolioStockModelState extends State<PortfolioStockModel> {
  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: AppColors.lightBlackColor.withOpacity(0.2),
            width: 0.9,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(14),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Company logo
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 28,
                              width: 28,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: widget.logoUrl == 'null' || widget.logoUrl.isEmpty ? Container(
                                  color: widget.color.withOpacity(0.5),
                                  padding: EdgeInsets.all(2),
                                  child: Center(
                                    child: Text(widget.symbol, textAlign: TextAlign.center, style: TextStyle(fontSize: 6)),
                                  ),
                                ) : Container(
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
                                      imageUrl: widget.logoUrl,
                                      fit: BoxFit.contain,
                                      height: 28, width: 28,
                                    ),
                                  ),
                                )
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(width: 12),
                                Container(
                                  height: 18.0, // Set a fixed height (adjust as needed)
                                  width: MediaQuery.of(context).size.width * 0.48,
                                  child: widget.companyName.length > 20 ? Marquee(
                                    text: widget.companyName,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
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
                                    widget.companyName,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            widget.currentChangePercent >= 0 ? 'assets/icons/uparrow.png' : 'assets/icons/downarrow.png',
                            height: 25,
                            width: 25,
                            color: widget.currentChangePercent >= 0 ? Colors.green : Colors.red,
                          ),
                          Text(
                            '${widget.currentChangePercent.toString()}%',
                            style: TextStyle(
                              color: widget.currentChangePercent >= 0 ? Colors.green : Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 14)
                    ],
                  ),
                  SizedBox(height: 6),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Current Value: ',
                                  style: TextStyle(color: Colors.black54),
                                ),
                                TextSpan(
                                  text: '${formatDoubleWithCommas(widget.currentStockValue, removeZeros: false)}',
                                  style: TextStyle(
                                    color: widget.currentStockValue > widget.initialStockValue
                                        ? Colors.green
                                        : widget.currentStockValue < widget.initialStockValue
                                        ? Colors.red
                                        : Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 6),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Initial Value: ',
                                  style: TextStyle(color: Colors.black54),
                                ),
                                TextSpan(
                                  text: formatDoubleWithCommas(widget.initialStockValue, removeZeros: false),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          widget.isCaptain || widget.isViceCaptain ? Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              CircleAvatar(
                                radius: 14,
                                backgroundColor: AppColors.secondaryColor10,
                                child: Text(
                                  widget.isCaptain ? 'C' : widget.isViceCaptain ? 'VC' : '',
                                  style: TextStyle(
                                    color: AppColors.backgroundColor60,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 10
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(width: 5),
                              Text('${widget.isCaptain ? '2.5x' : '1.5x'}', style: TextStyle(color: Colors.black54, fontSize: 12))
                            ],
                          ) : SizedBox(),
                          SizedBox(height: 7),
                          Text(
                            'Wgt: ${widget.weightage.toStringAsFixed(2)}%',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            widget.isCaptain || widget.isViceCaptain ? Column(
              children: [
                Line(),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (widget.isCaptain ? AppColors.goldColor : AppColors.silverColor).withOpacity(0.2),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                  ),
                  child: RichText(
                    textAlign: TextAlign.end,
                    text: TextSpan(
                      text: '${widget.isCaptain ? 'Captain' : 'Vice Captain'} Earned Extra: ',
                      style: TextStyle(fontSize: 11, color: Colors.black, fontWeight: FontWeight.w300),
                      children: [
                        TextSpan(
                          text: widget.extraValue < 0
                        ? '${formatDoubleWithCommas(widget.extraValue)} Coins'
                      : '+${formatDoubleWithCommas(widget.extraValue)} Coins',
                          style: TextStyle(fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  )
                ),
              ],
            ) : SizedBox(height: 2),
          ],
        ),
      ),
    );
  }
}