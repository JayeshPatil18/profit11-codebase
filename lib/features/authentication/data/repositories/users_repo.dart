import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dalalstreetfantasy/features/contests/data/models/user_item.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:dalalstreetfantasy/constants/cryptography.dart';
import 'package:dalalstreetfantasy/main.dart';
import 'package:dalalstreetfantasy/utils/methods.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../contests/data/models/user.dart';

class UserServicesRepo{

  Future<UserItem> fetchUserFromFirestore(String userId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (!userDoc.exists) {
        throw Exception('User not found');
      }

      // Convert Firestore document data to UserItem using the fromFirestore factory method
      return UserItem.fromFirestore(userDoc.data() as Map<String, dynamic>);
    } catch (e) {
      print('Error fetching user: $e');
      rethrow;
    }
  }

  
  Future<int> isLoginFromAnotherDevice(String deviceId) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('id', isEqualTo: MyApp.loggedInUserId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final userDoc = querySnapshot.docs.first;
        final userItem = UserItem.fromFirestore(userDoc.data());

        if (userItem.status != deviceId) {
          return 1;
        } else {
          return 0;
        }
      }
      return -404;
    } catch (e) {
      print('Error checking user device ID: $e');
      return -1;
    }
  }

  Future<bool> setUserDeviceId(String phoneNo, String deviceId) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('phoneNo', isEqualTo: phoneNo)
          .get();

      if (querySnapshot.docs.isEmpty) {
        print('User not found');
        return false;
      }

      final userRef = querySnapshot.docs.first.reference;

      await userRef.update({
        'status': deviceId,
      });

      return true;
    } catch (e) {
      print('Error updating user device ID: $e');
      return false;
    }
  }

}
