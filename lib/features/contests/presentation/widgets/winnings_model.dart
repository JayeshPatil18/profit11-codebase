import 'package:dalalstreetfantasy/features/contests/presentation/widgets/line.dart';
import 'package:flutter/material.dart';
import '../../../../constants/color.dart';
import '../../../../utils/method1.dart';

class WinningsWidget extends StatelessWidget {
  final int price;
  final int rank;

  const WinningsWidget({super.key,
    required this.price,
    required this.rank,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
          color: AppColors.backgroundColor60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  // For 1st, 2nd, and 3rd ranks, show the icon with text on top
                  if (rank == 1 || rank == 2 || rank == 3)
                    Stack(
                      alignment: Alignment.center, // Align the text in the center of the icon
                      children: [
                        // Display the rank-specific crown icon
                        if (rank == 1)
                          ImageIcon(
                            AssetImage('assets/icons/gold.png'),
                            color: AppColors.goldColor,
                            size: 35,
                          )
                        else if (rank == 2)
                          ImageIcon(
                            AssetImage('assets/icons/silver.png'),
                            color: AppColors.silverColor,
                            size: 35,
                          )
                        else if (rank == 3)
                            ImageIcon(
                              AssetImage('assets/icons/bronze.png'),
                              color: AppColors.bronzeColor,
                              size: 35,
                            ),

                        // Overlay the rank number on top of the crown icon
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(top: 4),
                          child: Text(
                            '$rank',
                            style: TextStyle(
                              color: AppColors.backgroundColor60,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ), // Customize this style for visibility
                          ),
                        ),
                      ],
                    )
                  else
                  // Display the rank text with a hashtag for ranks other than 1, 2, 3
                    Row(
                      children: [
                        SizedBox(width: 10),
                        Text(
                          '${rank}',
                          style: TextStyle(
                            color: AppColors.textColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 10), // Add space between the text and the following content if needed
                      ],
                    ),
                ],
              ),
              Row(
                children: [
                  Container(
                      height: 16,
                      width: 16,
                      child: Image.asset('assets/icons/coin.png')),
                  SizedBox(width: 4),
                  Text('${formatDoubleWithCommas(price.toDouble())}', style: TextStyle(
                    color: AppColors.textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  )),
                ],
              ),
            ],
          ),
        ),
        Line()
      ],
    );
  }

  // Example text style for rank in the blue header
  TextStyle textStyleHeader() {
    return TextStyle(
      fontSize: 18,
      color: Colors.white, // White text on blue background
      fontWeight: FontWeight.bold,
    );
  }

  // Example text style for leader text
  TextStyle textStyleLeader({double fontSize = 16, Color color = AppColors.textColor}) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
    );
  }

  // Example text style for smaller description text
  TextStyle textStyleMinDesc() {
    return TextStyle(
      fontSize: 12,
      color: AppColors.textColor,
    );
  }
}