import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';

import '../../../../constants/color.dart';
import '../../../../utils/contest_timer.dart';
import '../../../../utils/method1.dart';
import 'line.dart';

class ContestCard extends StatefulWidget {
  final double prizePool;
  final double firstPrize;
  final String contestName;
  final String startTime;
  final String endTime;
  final String logoUrl;

  ContestCard({
    required this.prizePool,
    required this.firstPrize,
    required this.contestName,
    required this.startTime,
    required this.endTime,
    required this.logoUrl,
  });

  @override
  _ContestCardState createState() => _ContestCardState();
}

class _ContestCardState extends State<ContestCard> {
  late ContestTimer _contestTimer;

  @override
  void initState() {
    super.initState();
    // Initialize _contestTimer right away
    _contestTimer = ContestTimer(
      startTime: widget.startTime,
      endTime: widget.endTime,
    );
  }

  @override
  void dispose() {
    _contestTimer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Now _contestTimer is guaranteed to be initialized before use
    return Column(
      children: [
        Container(
          height: 140,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.check_circle_rounded,
                              color: Colors.green,
                              size: 12,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Prize Pool',
                              style: TextStyle(
                                color: Color(0xFF8E8E8E),
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Container(
                                height: 21,
                                width: 21,
                                child: Image.asset('assets/icons/coin.png')),
                            SizedBox(width: 4),
                            Text(
                              '${formatDoubleWithCommas(widget.prizePool)}',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 16),
                        Container(
                            height: 24, width: 55, child: Image.network(widget.logoUrl)),
                        SizedBox(height: 10),
                        ValueListenableBuilder<String>(
                          valueListenable: _contestTimer.timeLeftNotifier,
                          builder: (context, timeLeft, child) {

                            return Text(
                              timeLeft,
                              style: TextStyle(
                                color: Color(0xFFF11212),
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 10),
                        ValueListenableBuilder<String>(
                          valueListenable: _contestTimer.currentTimeNotifier,
                          builder: (context, currentTime, child) {
                            String label = getTimeLabel(currentTime, widget.startTime);

                            return Text(
                              label,
                              style: TextStyle(
                                color: Color(0xFF000000),
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 10),
                      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                      decoration: BoxDecoration(
                        color: Color(0xFF010A23),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'ENTER',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Line(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 18),
                width: double.infinity,
                height: 30,
                decoration: BoxDecoration(
                  color: AppColors.transparentComponentColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                ),
                child: Row(
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 16,
                          width: 16,
                          child: Image.asset('assets/icons/medal.png'),
                        ),
                        SizedBox(width: 5),
                        Row(
                          children: [
                            Container(
                                height: 21,
                                width: 21,
                                child: Image.asset('assets/icons/coin.png')),
                            SizedBox(width: 4),
                            Text(
                              '${formatDoubleWithCommas(widget.firstPrize)}',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 20),
                        height: 15,
                        child: Marquee(
                          text: widget.contestName,
                          style: TextStyle(
                            color: Color(0xFF007BFF),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
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
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 18),
      ],
    );
  }

  String getTimeLabel(String currentTimeStr, String startTimeStr) {
    // Parse strings to DateTime
    try {
      final currentTime = DateTime.parse(currentTimeStr);
      final startTime = DateTime.parse(startTimeStr);

      // Reset time components to compare just the dates
      final now = DateTime(currentTime.year, currentTime.month, currentTime.day);
      final start = DateTime(startTime.year, startTime.month, startTime.day);

      // Calculate the difference in days
      final difference = start.difference(now).inDays;

      if (difference == 0) {
        return 'Today';
      } else if (difference == 1) {
        return 'Tomorrow';
      } else {
        // Format the date
        return '${startTime.day}/${startTime.month}/${startTime.year}';
      }
    } catch (e) {
      // Handle invalid date strings
      return '-';
    }
  }

}