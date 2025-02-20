
import 'package:flutter/material.dart';

import '../../../../constants/color.dart';
import '../../../../utils/contest_timer.dart';
import '../../../../utils/method1.dart';
import '../../../../utils/portfolio_method.dart';
import '../../data/models/leauge_item.dart';
import 'line.dart';

class UpComingCard extends StatefulWidget {
  final LeagueItem league;
  final String btnLabel;
  final VoidCallback onTimerEnd;

  UpComingCard({
    required this.league,
    required this.btnLabel,
    required this.onTimerEnd
  });

  @override
  State<UpComingCard> createState() => _UpComingCardState();
}

class _UpComingCardState extends State<UpComingCard> {
  late ContestTimer _contestTimer;

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

  @override
  void initState() {
    super.initState();
    // Initialize _contestTimer right away
    _contestTimer = ContestTimer(
      startTime: widget.league.startTime,
      endTime: widget.league.endTime,
    );
  }

  @override
  void dispose() {
    _contestTimer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async{
        await fetchUsers();
        Navigator.pushNamed(
          context,
          'view_contest',
          arguments: {
            'league': widget.league,
            'rank': -1,
            'prize': 0.0,
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 25),
        height: 160,
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
                      SizedBox(height: 16),
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
                            '${formatDoubleWithCommas(widget.league.totalPrizePool)}',
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 16),
                      Container(
                          height: 24, width: 55, child: Image.network(widget.league.logoUrl)),
                      SizedBox(height: 10),
                      ValueListenableBuilder<String>(
                        valueListenable: _contestTimer.timeLeftNotifier,
                        builder: (context, timeLeft, child) {

                          if (timeLeft == "0s") {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              widget.onTimerEnd();
                            });
                          }

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
                      SizedBox(height: 4),
                      ValueListenableBuilder<String>(
                        valueListenable: _contestTimer.currentTimeNotifier,
                        builder: (context, currentTime, child) {
                          String label = getTimeLabel(currentTime, widget.league.startTime);

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
                        widget.btnLabel,
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
            SizedBox(height: 4),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(height: 5),

                  // Spots Left and Total Spots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${formatDoubleWithCommas(widget.league.maxParticipants.toDouble())} Spots',
                        style: TextStyle(fontSize: 11, color: Colors.grey[600], fontWeight: FontWeight.w400),
                      ),
                      Text(
                        '${formatDoubleWithCommas((widget.league.maxParticipants - widget.league.usersJoined.length).toDouble())} Left',
                        style: TextStyle(fontSize: 11, color: Colors.grey[600], fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),

                  SizedBox(height: 10),

                  Stack(
                    children: [
                      Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: (widget.league.maxParticipants - (widget.league.maxParticipants - widget.league.usersJoined.length)) / widget.league.maxParticipants, // Calculate filled progress
                        child: Container(
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ],
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                          height: 16, width: 16,
                          child: Image.asset('assets/icons/medal.png')),
                      SizedBox(width: 5),
                      Row(
                        children: [
                          Container(
                              height: 16,
                              width: 16,
                              child: Image.asset('assets/icons/coin.png')),
                          SizedBox(width: 4),
                          Text(
                            '${formatDoubleWithCommas(widget.league.firstPrize)}',
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
                  Text(
                    'All the best !',
                    style: TextStyle(
                      color: Color(0xFF007BFF),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}