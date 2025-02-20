
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dalalstreetfantasy/main.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

import '../models/user_item.dart';

Stream<UserItem> getUserStream(String userId) {
  return FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .snapshots()
      .map((snapshot) {
    final data = snapshot.data()!;
    return UserItem.fromFirestore(data);
  });
}

Future<UserItem> getUserItem(String userId) async {
  final snapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .get();
  final data = snapshot.data()!;
  return UserItem.fromFirestore(data);
}
