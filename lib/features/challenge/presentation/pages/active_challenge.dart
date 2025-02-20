import 'package:flutter/material.dart';

import '../../../contests/data/models/leauge_item.dart';

class ActiveChallengeView extends StatelessWidget {
  final LeagueItem league;

  ActiveChallengeView({required this.league});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Active Challenge'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Participants (${league.currentParticipants}/${league.maxParticipants})",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: league.usersJoined.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text("User ${league.usersJoined[index]}"),
                    subtitle: Text("Rank: ${index + 1}"),
                    trailing: Text(
                      "Portfolio Value: ₹${league.winnings[index]['portfolioValue'].toStringAsFixed(2)}",
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // End challenge logic or navigation
              },
              child: Text("End Challenge"),
            ),
          ],
        ),
      ),
    );
  }
}
