import 'package:flutter/material.dart';
import '../../../../constants/color.dart';

import '../../../../utils/method1.dart';
import 'line.dart';

class LeagueCard extends StatefulWidget {
  final double prizePool;
  final double entryFee;
  final int spotsLeft;
  final int totalSpots;
  final double firstPrize;

  const LeagueCard({
    super.key,
    required this.prizePool,
    required this.entryFee,
    required this.spotsLeft,
    required this.totalSpots,
    required this.firstPrize,
  });

  @override
  State<LeagueCard> createState() => _LeagueCardState();
}

class _LeagueCardState extends State<LeagueCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Prize Pool Header
              Container(
                padding: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 12),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.check_circle_rounded,
                              color: Colors.green,
                              size: 12,
                            ),
                            SizedBox(width: 10),
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
                      ],
                    ),
                    SizedBox(height: 5),

                    // Prize and Entry Fee
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                                height: 21,
                                width: 21,
                                child: Image.asset('assets/icons/coin.png')),
                            SizedBox(width: 4),
                            Text(
                              '${formatDoubleWithCommas(widget.prizePool)}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          alignment: Alignment.topRight,
                          padding:
                              EdgeInsets.symmetric(horizontal: 18, vertical: 6),
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
                            child: Row(
                              children: [
                                widget.entryFee == 0
                                    ? SizedBox() : Container(
                                    height: 16,
                                    width: 16,
                                    child: Image.asset('assets/icons/coin.png')),
                                SizedBox(width: 4),
                                Text(
                                  widget.entryFee == 0
                                      ? 'Free'
                                      : '${formatDoubleWithCommas(widget.entryFee)}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 14),

                    // Spots Left and Total Spots
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${widget.totalSpots} Spots',
                          style: TextStyle(fontSize: 11, color: Colors.grey[600], fontWeight: FontWeight.w400),
                        ),
                        Text(
                          '${widget.spotsLeft} Left',
                          style: TextStyle(fontSize: 11, color: Colors.grey[600], fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),

                    SizedBox(height: 8),

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
                          widthFactor: (widget.totalSpots - widget.spotsLeft) /
                              widget.totalSpots, // Calculate filled progress
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

              // Spacer(),
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
                            height: 16,
                            width: 16,
                            child: Image.asset('assets/icons/medal.png')),
                        SizedBox(width: 5),
                        Text(
                          '₹${formatDoubleWithCommas(widget.firstPrize)}',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
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
        SizedBox(height: 25)
      ],
    );
  }
}
