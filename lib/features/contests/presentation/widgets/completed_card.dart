
import 'package:dalalstreetfantasy/utils/method1.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../constants/color.dart';
import '../../../../main.dart';
import '../../../../utils/contest_timer.dart';
import '../../../../utils/portfolio_method.dart';
import '../../data/models/leauge_item.dart';
import '../../domain/services/firestore_service.dart';
import '../pages/view_contest.dart';
import 'custom_flag.dart';
import 'line.dart';

class CompletedCard extends StatefulWidget {
  final LeagueItem league;
  final String btnLabel;
  final double cardWidth;
  final bool onHome;

  CompletedCard({
    required this.league,
    required this.btnLabel,
    required this.cardWidth,
    required this.onHome,
  });

  @override
  State<CompletedCard> createState() => _CompletedCardState();
}

class _CompletedCardState extends State<CompletedCard> {
  late ContestTimer _contestTimer;

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

    String dateLabel = getTimeLabel(widget.league.startTime.toString());

    // Fetch user rank and prize
    final result = getUserResult(widget.league.leagueResult, MyApp.loggedInUserId);
    final userRank = result['rank'];
    final userPrize = result['prize'];

    return GestureDetector(
      onTap: () async{
        await fetchUsers();

        if(userRank != -1){
          Navigator.pushNamed(
            context,
            'view_contest',
            arguments: {
              'league': widget.league,
              'rank': userRank,
              'prize': userPrize,
            },
          );
        }
      },
      child: Container(
        margin: widget.onHome
            ? const EdgeInsets.only(right: 20)
            : const EdgeInsets.only(bottom: 25),
        width: widget.cardWidth,
        height: 134,
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
              margin: EdgeInsets.only(left: 16, bottom: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
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
                      Text(
                        'Ended',
                        style: TextStyle(
                          color: Color(0xFFF11212),
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        dateLabel,
                        style: TextStyle(
                          color: Color(0xFF000000),
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                          margin: EdgeInsets.only(top: 10),
                          child: userRank == -1 ? Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.grey.shade100,
                            child: RibbonFlagWidget(color: Colors.grey.shade300, text: '', width: 42, height:24),
                          ) : RibbonFlagWidget(color: userPrize > 0 ? Colors.green : Colors.red, text: '#${userRank}', width: 42, height:24)),
                      SizedBox(height: 20),
                      Container(
                        margin: EdgeInsets.only(right: 16),
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
                        child: Text(
                          widget.btnLabel,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Spacer(),
            SizedBox(height: 4),
            Line(),
            userRank == -1
                ? Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 18),
                width: double.infinity,
                height: 30,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.grey.withOpacity(0.2),
                      Colors.grey.withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 18,
                      width: 18,
                      color: Colors.white,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: Container(
                        width: 100,
                        height: 12,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 12,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            )
                : Container(
              padding: EdgeInsets.symmetric(horizontal: 18),
              width: double.infinity,
              height: 30,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    userPrize > 0 ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                    userPrize > 0 ? Colors.green.withOpacity(0.05) : Colors.red.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    userRank == -1
                        ? ''
                        : userPrize > 0
                        ? '🎉  You have Earned!'
                        : '😞  You have lost!',
                    style: TextStyle(
                      color: userPrize > 0 ? AppColors.secondaryColor10 : Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                          height: 16,
                          width: 16,
                          child: Image.asset('assets/icons/coin.png')),
                      SizedBox(width: 4),
                      Text(
                        userRank == -1
                            ? ''
                            : '${formatDoubleWithCommas(userPrize)}',
                        style: TextStyle(
                          color: userPrize > 0 ? AppColors.secondaryColor10 : Colors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  String getTimeLabel(String startTimeStr) {
    try {
      // Parse the start time string to DateTime
      final startTime = DateTime.parse(startTimeStr);

      // Format the date as 'day/month/year'
      return '${startTime.day}/${startTime.month}/${startTime.year}';
    } catch (e) {
      // Handle invalid date strings
      return '-';
    }
  }
}