import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../../../../constants/color.dart';
import '../../../../main.dart';
import '../../../../utils/portfolio_method.dart';
import '../../data/models/leauge_item.dart';
import 'completed_card.dart';

class CompletedContests extends StatelessWidget {
  final Axis scrollDirection;
  final bool onHome;
  final double cardWidth;
  final Function(bool)? onLeaguesFound;

  const CompletedContests({
    Key? key,
    this.scrollDirection = Axis.vertical,
    this.onHome = false,
    required this.cardWidth,
    this.onLeaguesFound,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('leagues')
          .where('usersJoined', arrayContains: MyApp.loggedInUserId)
          .orderBy('endTime', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return onHome
              ? SizedBox()
              : Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          List<LeagueItem> leaguesList = snapshot.data!.docs
              .map((doc) =>
                  LeagueItem.fromFirestore(doc.data() as Map<String, dynamic>))
              .toList();

          DateTime now = DateTime.now();
          String formattedTime =
              DateFormat("yyyy-MM-dd HH:mm:ssssss").format(now);

          List<LeagueItem> completedLeagues = leaguesList.where((league) {
            return formattedTime.compareTo(league.endTime.toString()) > 0;
          }).toList();

          if (completedLeagues.isEmpty) {
            onLeaguesFound?.call(false);
            return Center(
                child: Text('No Completed Contest Found',
                    style: TextStyle(color: AppColors.lightBlackColor)));
          }

          onLeaguesFound?.call(true);

          return ListView.builder(
            padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: !onHome ? 20 : 8,
                bottom: !onHome ? 80 : 10),
            itemCount: completedLeagues.length,
            scrollDirection: scrollDirection,
            itemBuilder: (context, index) {
              LeagueItem league = completedLeagues[index];

              DateTime now = DateTime.now();
              String formattedTime =
                  DateFormat("yyyy-MM-dd HH:mm:ssssss").format(now);

              if (formattedTime.compareTo(league.endTime.toString()) > 0) {
                return CompletedCard(
                    league: league,
                    btnLabel: 'Results',
                    cardWidth: cardWidth,
                    onHome: onHome);
              } else {
                return SizedBox.shrink();
              }
            },
          );
        } else {
          onLeaguesFound?.call(false);
          return Center(child: Text('No Leagues Found'));
        }
      },
    );
  }
}
