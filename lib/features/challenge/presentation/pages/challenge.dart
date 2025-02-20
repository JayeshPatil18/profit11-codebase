import 'package:flutter/material.dart';

import '../../../contests/data/models/leauge_item.dart';
import 'create_challenge.dart';

class ChallengesPage extends StatelessWidget {
  final List<Map<String, dynamic>> demoLeaguesJson;

  ChallengesPage({required this.demoLeaguesJson});

  List<LeagueItem> parseDemoData() {
    return demoLeaguesJson.map((data) => LeagueItem.fromFirestore(data)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final leagues = parseDemoData();

    return Scaffold(
      appBar: AppBar(
        title: Text('Challenges'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateChallengePage()),
              );
            },
          ),
        ],
      ),
      body: leagues.isEmpty
          ? Center(child: Text("No challenges available."))
          : ListView.builder(
        itemCount: leagues.length,
        itemBuilder: (context, index) {
          final challenge = leagues[index];
          return Card(
            child: ListTile(
              leading: Image.network(challenge.logoUrl, width: 50, height: 50),
              title: Text("Entry Fee: ₹${challenge.entryFee.toStringAsFixed(2)}"),
              subtitle: Text(
                "Start Time: ${challenge.startTime}\nParticipants: ${challenge.currentParticipants}/${challenge.maxParticipants}",
              ),
              trailing: ElevatedButton(
                onPressed: challenge.currentParticipants < challenge.maxParticipants
                    ? () {
                  // Handle accepting the challenge here
                }
                    : null,
                child: Text("Join"),
              ),
            ),
          );
        },
      ),
    );
  }
}
