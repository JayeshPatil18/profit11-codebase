import 'package:flutter/material.dart';

import '../../../../constants/color.dart';
import 'image_shimmer.dart';

class UserRankWidget extends StatelessWidget {
  final String name;
  final String username;
  final String avatar;
  final double skillScore;
  final bool isUser;
  final int rank;

  UserRankWidget({
    required this.name,
    required this.username,
    required this.avatar,
    required this.skillScore,
    required this.isUser,
    required this.rank,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: isUser ? AppColors.secondaryColor10 : AppColors.backgroundColor60,
            borderRadius: BorderRadius.circular(10.0),
            border: isUser ? null : Border.all(
              color: AppColors.lightBlackColor.withOpacity(0.18),
              width: 0.9,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.15),
                spreadRadius: 2,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          padding: EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 12),
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (rank == 1)
                    ImageIcon(
                      AssetImage('assets/icons/gold.png'),
                      color: AppColors.goldColor,
                      size: 25,
                    )
                  else if (rank == 2)
                    ImageIcon(
                      AssetImage('assets/icons/silver.png'),
                      color: AppColors.silverColor,
                      size: 25,
                    )
                  else if (rank == 3)
                      ImageIcon(
                        AssetImage('assets/icons/bronze.png'),
                        color: AppColors.bronzeColor,
                        size: 25,
                      )
                    else
                      SizedBox(width: 25,),
                  SizedBox(height: 4),
                  Text('#$rank', style: TextStyle(
                    color: isUser ? AppColors.backgroundColor60 : AppColors.textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  )),
                ],
              ),
              SizedBox(width: 14),
              Container(
                width: 42,
                height: 42,
                margin: EdgeInsets.only(right: 14),
                child: avatar == 'null' || avatar.isEmpty
                    ? CircleAvatar(
                  backgroundColor:
                  isUser ? AppColors.backgroundColor60.withOpacity(0.4) : Colors.grey.withOpacity(0.2),
                  radius: 15,
                  child: Icon(
                    Icons.person,
                    color: AppColors.primaryColor30.withOpacity(0.2),
                    size: 25,
                  ),
                )
                    : CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 15,
                  child: ClipOval(
                    child: CustomImageShimmer(
                        imageUrl: avatar,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: textStyleLeader()),
                    const SizedBox(height: 2),
                    Text(username, style: textStyleMinDesc()),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('Skill Score', style: TextStyle(
                    color: isUser ? AppColors.backgroundColor60 : AppColors.textColor,
                    fontSize: 10,
                  )),
                  const SizedBox(height: 2),
                  Text(skillScore.toString(), style: TextStyle(
                    color: isUser ? AppColors.backgroundColor60 : AppColors.textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  )),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 14),
      ],
    );
  }

  TextStyle textStyleLeader() {
    return TextStyle(
      color: isUser ? AppColors.backgroundColor60 : AppColors.textColor,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    );
  }

  TextStyle textStyleMinDesc() {
    return TextStyle(
      color: isUser ? AppColors.backgroundColor60.withOpacity(0.8) : AppColors.textColor.withOpacity(0.5),
      fontSize: 12,
    );
  }
}
