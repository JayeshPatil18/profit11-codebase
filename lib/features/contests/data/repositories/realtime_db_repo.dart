import 'dart:ffi';

import 'package:firebase_database/firebase_database.dart';
import 'package:dalalstreetfantasy/main.dart';

class RealTimeDbService {

  Future<int> getAndUpdateMaxUserId() async {
    try {
      DatabaseReference databaseReference = FirebaseDatabase.instance.ref('maxuserid');
      DatabaseEvent event = await databaseReference.once();
      int maxUserId = int.parse(event.snapshot.value.toString()) + 1;
      databaseReference.set(maxUserId);
      return maxUserId;
    } catch (error) {
      print('Error fetching MaxUserId data: $error');
      return -1;
    }
  }

  Future<String?> getLeaderboardValue() async {
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref('leaderboard');
    DatabaseEvent event = await databaseReference.once();
    return event.snapshot.value.toString();
  }

  Future<String?> getEmailAddressPattern() async {
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref('emailpatterns');
    DatabaseEvent event = await databaseReference.once();
    return event.snapshot.value.toString();
  }
}
