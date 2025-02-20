import 'package:dalalstreetfantasy/features/contests/presentation/widgets/line.dart';
import 'package:flutter/material.dart';
import '../../../../constants/color.dart';
import '../../../../utils/method1.dart';
import 'image_shimmer.dart';

class UserContestRankWidget extends StatelessWidget {
  final String name;
  final String avatar;
  final double portfolioReturns;
  final int rank;
  final bool isUser;

  UserContestRankWidget({
    required this.name,
    required this.avatar,
    required this.portfolioReturns,
    required this.rank,
    required this.isUser,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
          color: isUser
              ? AppColors.secondaryColor10
              : AppColors.backgroundColor60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      child: avatar == 'null' || avatar.isEmpty
                          ? CircleAvatar(
                              backgroundColor: isUser ? Colors.white.withOpacity(0.4): Colors.grey.withOpacity(0.2),
                              radius: 15,
                              child: Icon(
                                Icons.person,
                                color:
                                    AppColors.primaryColor30.withOpacity(0.3),
                                size: 20,
                              ),
                            )
                          : CircleAvatar(
                          radius: 15, // Adjust the radius for size
                          backgroundColor: Colors.grey[300],
                          backgroundImage:
                          NetworkImage(avatar),
                          child: ClipOval(
                              child: CustomImageShimmer(
                                  imageUrl: avatar,
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.cover))),
                    ),
                    SizedBox(width: 15),
                    Text(name, style: textStyleLeader()),
                  ],
                ),
              ),
              Text('${formatDoubleWithCommas(portfolioReturns)}%',
                  style: textStyleLeader()),
              SizedBox(width: 70),
              Text('#$rank', style: textStyleLeader()),
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
  TextStyle textStyleLeader() {
    return TextStyle(
      color: isUser ? AppColors.backgroundColor60 : AppColors.textColor,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    );
  }

  // Example text style for smaller description text
  TextStyle textStyleMinDesc() {
    return TextStyle(
      fontSize: 12,
      color: isUser ? AppColors.backgroundColor60 : AppColors.textColor,
    );
  }
}
