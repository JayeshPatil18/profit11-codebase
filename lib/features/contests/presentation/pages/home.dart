import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../../main.dart';
import '../../data/models/leauge_item.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showCompletedContestList = false;

  @override
  void initState() {
    super.initState();
    _checkCompletedContests();
  }

  void _checkCompletedContests() {
    FirebaseFirestore.instance
        .collection('leagues')
        .where('usersJoined', arrayContains: MyApp.loggedInUserId)
        .get()
        .then((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        DateTime now = DateTime.now();
        showCompletedContestList = snapshot.docs.any((doc) =>
            now.isAfter(DateTime.parse(doc['endTime'].toString())));
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          if (showCompletedContestList) Text("Completed Contests Available"),
          Expanded(
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('stocks')
                  .doc('stocksdoc')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.exists) {
                  return Text("Stock Data Available");
                }
                return Text("No Data");
              },
            ),
          ),
        ],
      ),
    );
  }
}