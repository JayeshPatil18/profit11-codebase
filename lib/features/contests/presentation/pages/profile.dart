import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

import '../../../../utils/methods.dart';
import '../../../../constants/color.dart';
import '../../../../utils/fonts.dart';
import '../../../../utils/method1.dart';
import '../../data/models/user_item.dart';
import '../provider/bottom_nav_bar.dart';
import '../widgets/circular_percentage_user.dart';
import '../widgets/dialog_box.dart';
import '../widgets/image_shimmer.dart';
import '../widgets/snackbar.dart';

class ProfilePage extends StatefulWidget {
  final UserItem userItem;

  const ProfilePage({super.key, required this.userItem});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        // Makes the status bar background transparent
        statusBarIconBrightness: Brightness.light, // White icons
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        // Makes the status bar background transparent
        statusBarIconBrightness: Brightness.dark, // White icons
      ),
    );
  }

  int countTotalWins(List<Map<String, dynamic>> joinedContests) {
    // Filter the list where prize is greater than zero and count the wins
    return joinedContests.where((contest) => contest['prize'] > 0).length;
  }

  String _getCaption(double ratio) {
    if (ratio >= 90) {
      return "You're ahead of 91% of traders—an elite performer!";
    } else if (ratio >= 70) {
      return "Impressive! Outclassing ${ratio.toInt()}% of traders!";
    } else if (ratio >= 50) {
      return "Great work! Outperforming ${ratio.toInt()}% of participants!";
    } else if (ratio >= 30) {
      return "You're ahead of ${ratio.toInt()}%—keep aiming higher!";
    } else {
      return "You're ahead of ${ratio.toInt()}%—the journey starts now!";
    }
  }

  @override
  Widget build(BuildContext context) {
    double performanceRatio = widget.userItem.joinedContests.isNotEmpty
        ? (countTotalWins(widget.userItem.joinedContests) / widget.userItem.joinedContests.length) * 100
        : 0.0;

    Map<String, dynamic> badge = getBadge(widget.userItem.skillScore.toInt());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor60,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header section with title and icons
            Container(
              padding: EdgeInsets.only(top: 40),
              decoration: BoxDecoration(
                color: AppColors.primaryColor30,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(40),
                  bottomLeft: Radius.circular(40),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(
                        left: 20, right: 20, top: 20, bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.arrow_back_ios_new_rounded,
                                color: AppColors.backgroundColor60, size: 22)),
                        SizedBox(width: 16),
                        Text('Profile',
                            style: MainFonts.pageTitleText(
                                color: AppColors.backgroundColor60,
                                fontSize: 22)),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  // Profile Picture and Badge
                  Container(
                    padding: EdgeInsets.all(2), // Padding for outer border
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.secondaryColor10,
                        // Border color as per the image
                        width: 3.0,
                      ),
                    ),
                    child: (widget.userItem.profileUrl == "" ||
                            widget.userItem.profileUrl == "null")
                        ? CircleAvatar(
                            radius: 40, // Adjust the radius for size
                            backgroundColor: Colors.grey[300],
                            child: Icon(
                              Icons.person,
                              size: 55,
                              color: Colors.white,
                            ),
                          )
                        : CircleAvatar(
                            radius: 40, // Adjust the radius for size
                            backgroundColor: Colors.grey[300],
                            backgroundImage:
                                NetworkImage(widget.userItem.profileUrl),
                            child: ClipOval(
                                child: CustomImageShimmer(
                                    imageUrl: widget.userItem.profileUrl,
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.cover))),
                  ),
                  // Username and Followers
                  const SizedBox(height: 14),
                  Text(
                    widget.userItem.fullName,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.backgroundColor60,
                    ),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '@${widget.userItem.username}',
                        style: TextStyle(
                            color: AppColors.transparentComponentColor),
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 14,
                      ),
                    ],
                  ),
                  SizedBox(height: 80),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.all(16),
              margin: EdgeInsets.only(left: 20, right: 20),
              transform: Matrix4.translationValues(0.0, -50.0, 0.0),
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Your information',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14, // Reduced font size
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(badge['badgePath'], height: 40 , width: 40),
                      SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            badge['levelName'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18, // Reduced font size
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            'Skill Score: ${widget.userItem.skillScore.toStringAsFixed(2)}',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13), // Reduced font size
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      5,
                      (index) => Container(
                        width: 50,
                        padding: EdgeInsets.symmetric(vertical: 2),
                        decoration: BoxDecoration(
                          color: index < badge['level']
                              ? AppColors.secondaryColor10
                              : AppColors.secondaryColor10.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w400,
                              color: index < badge['level']
                                  ? AppColors.backgroundColor60
                                  : AppColors.textColor.withOpacity(0.5)),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 2.2,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.leaderboard_rounded,
                                color: AppColors.primaryColor30, size: 26),
                            // Reduced icon size
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.userItem.rank == -1 ? '-' : '#${widget.userItem.rank}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18), // Reduced font size
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Overall Rank',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                  // Reduced font size
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.account_balance_wallet_rounded,
                              color: AppColors.primaryColor30, size: 26),
                          // Reduced icon size
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '₹${formatDoubleWithCommas(widget.userItem.netWorth)}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18), // Reduced font size
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Net Worth',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 12),
                                // Reduced font size
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 2.2,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.emoji_events_outlined,
                                color: AppColors.primaryColor30, size: 26),
                            // Reduced icon size
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.userItem.joinedContests.length
                                      .toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18), // Reduced font size
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Total Contests',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                  // Reduced font size
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.emoji_events_rounded,
                              color: AppColors.primaryColor30, size: 26),
                          // Reduced icon size
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                countTotalWins(widget.userItem.joinedContests)
                                    .toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18), // Reduced font size
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Won Contests',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 12),
                                // Reduced font size
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(left: 20, right: 20),
              padding: const EdgeInsets.all(20),
              transform: Matrix4.translationValues(0.0, -30.0, 0.0),
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
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Your Performance',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14, // Reduced font size
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _getCaption(performanceRatio),
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10), // Reduced font size
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: AppColors.secondaryColor10
                                        .withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(10)),
                                height: 8,
                                width: 8,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Total Contests Joined',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 10), // Reduced font size
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: AppColors.secondaryColor10,
                                    borderRadius: BorderRadius.circular(10)),
                                height: 8,
                                width: 8,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Won Contests',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 10), // Reduced font size
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  ContestProgressIndicator(
                    totalContests: widget.userItem.joinedContests.isEmpty ? 1 : widget.userItem.joinedContests.length.toDouble(),
                    totalWins: countTotalWins(widget.userItem.joinedContests) == 0 ? 0.01 : countTotalWins(widget.userItem.joinedContests).toDouble(),
                  ),
                ],
              ),
            ),
            Consumer<BottomNavigationProvider>(
                builder: ((context, value, child) {
              return Container(
                transform: Matrix4.translationValues(0.0, -20.0, 0.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.userItem.achievements.isNotEmpty ? Column(
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 16, left: 30, right: 30),
                          child: Text('Achievements',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14)),
                        ),
                        SizedBox(height: 14),
                        Container(
                          height: 35, // Adjust height to fit single line
                          child: ListView.builder(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            scrollDirection: Axis.horizontal,
                            physics: BouncingScrollPhysics(),
                            itemCount: widget.userItem.achievements.length,
                            itemBuilder: (context, index) {
                              final achievements = widget.userItem.achievements;
                              return Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: _buildAchievementBadge(achievements[index]),
                              );
                            },
                          )
                        ),
                      ],
                    ) : SizedBox(),
                        SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.only(left: 30, right: 30),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Recommended Leagues for You',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14)),
                          SizedBox(height: 10),
                          Text(
                              'Join leagues tailored to your skill level and win big!'),
                          SizedBox(height: 10),
                          ElevatedButton(
                              onPressed: () {
                                // Remove all backtrack pages
                                Navigator.popUntil(
                                    context, (route) => route.isFirst);

                                Navigator.pushReplacementNamed(
                                    context, 'landing');

                                value.updateIndex(0);
                              },
                              child: Text('Explore Leagues')),
                          SizedBox(height: 10),
                          Container(
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return CustomDialogBox(
                                            title: Text(
                                              'Are you sure?',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            content: Text(
                                              '    You will be logout from this device.',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(fontSize: 14),
                                            ),
                                            textButton1: TextButton(
                                              child: Text('Logout'),
                                              onPressed: () {
                                                Navigator.pop(context, 'OK');

                                                clearSharedPrefs();
                                                Navigator.of(context).popUntil(
                                                        (route) => route.isFirst);
                                                Navigator.of(context)
                                                    .pushReplacementNamed(
                                                    'signin');
                                                mySnackBarShow(context,
                                                    'Successfully logged out.');
                                              },
                                            ),
                                            textButton2: TextButton(
                                              child: Text('Cancel'),
                                              onPressed: () {
                                                Navigator.pop(
                                                    context, 'Cancel');
                                              },
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(top: 40),
                                      width: 140,
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.only(
                                          top: 10,
                                          bottom: 14,
                                          left: 14,
                                          right: 10),
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryColor30,
                                        borderRadius: BorderRadius.circular(8),
                                        // boxShadow: [
                                        //   BoxShadow(
                                        //     color: Colors.grey.withOpacity(0.3),
                                        //     spreadRadius: 2,
                                        //     blurRadius: 4,
                                        //     offset: Offset(0, 2),
                                        //   )
                                        // ],
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Logout',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            }))
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementBadge(String label) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        margin: EdgeInsets.only(right: 6),
        decoration: BoxDecoration(
          color: AppColors.primaryColor30.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
              color: AppColors.primaryColor30,
              fontWeight: FontWeight.bold,
              fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String description;

  const InfoTile({
    Key? key,
    required this.icon,
    required this.label,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.transparentComponentColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Icon(icon, size: 25, color: Colors.black),
              SizedBox(height: 15),
              Text(
                label,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                description,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


Map<String, dynamic> getBadge(int skillScore) {
  if (skillScore <= 100) {
    return {
      "badgePath": "assets/badges/badge0.png",
      "levelName": "Beginner",
      "level": 1
    };
  } else if (skillScore <= 200) {
    return {
      "badgePath": "assets/badges/badge1.png",
      "levelName": "Rising Star",
      "level": 2
    };
  } else if (skillScore <= 300) {
    return {
      "badgePath": "assets/badges/badge2.png",
      "levelName": "Achiever",
      "level": 3
    };
  } else if (skillScore <= 400) {
    return {
      "badgePath": "assets/badges/badge3.png",
      "levelName": "Expert",
      "level": 4
    };
  } else {
    return {
      "badgePath": "assets/badges/badge4.png",
      "levelName": "Master",
      "level": 5
    };
  }
}
