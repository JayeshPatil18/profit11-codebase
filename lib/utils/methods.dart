import 'dart:io';
import 'dart:math';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dalalstreetfantasy/features/authentication/data/repositories/users_repo.dart';
import 'package:dalalstreetfantasy/features/contests/presentation/widgets/bottom_sheet.dart';
import 'package:dalalstreetfantasy/features/contests/presentation/widgets/snackbar.dart';
import 'package:dalalstreetfantasy/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../features/contests/domain/entities/id_argument.dart';
import '../features/contests/domain/entities/user.dart';

String getDepartmentFromEmail(String emailAddress){

  if(emailAddress.isEmpty || emailAddress == null){
    return '';
  }

  String emailFirstPart = emailAddress.split('@')[0];
  String department = '';

  for (int i = emailFirstPart.length - 1; i >= 0; i--) {
    if(emailFirstPart[i] == '.'){
      break;
    }
    department = emailFirstPart[i] + department;
  }
  return department;
}

Future<List<String>> getUsernameList() async {
  UsersRepo usersRepo = UsersRepo();
  List<Map<String, dynamic>> data = await usersRepo.getUserCredentials();
  List<User> usersList = data
      .map((userData) => User.fromMap(userData))
      .toList();
  List<String> usernames = [];

  for (User user in usersList) {
    usernames.add(user.username);
  }

  return usernames;
}

Future<List<int>> getUserIdList() async {
  UsersRepo usersRepo = UsersRepo();
  List<Map<String, dynamic>> data = await usersRepo.getUserCredentials();
  List<User> usersList = data
      .map((userData) => User.fromMap(userData))
      .toList();
  List<int> userIds = [];

  for (User user in usersList) {
    userIds.add(user.uid);
  }

  return userIds;
}

navigateToUserProfile(BuildContext context, int userId) async{
  List<int> userIds = await getUserIdList();
  if(userIds.contains(userId)){
    Navigator.pushNamed(context, 'view_profile', arguments: IdArguments(userId));
  } else{
    // Show Message User not exist
  }
}

int getRandomNumber(int maxRange) {
  return Random().nextInt(maxRange);
}

getAllImageURLs() async {

  try {
    firebase_storage.ListResult result = await firebase_storage
        .FirebaseStorage.instance
        .ref().child('profile_icons').listAll();

    for (firebase_storage.Reference ref in result.items) {
      String url = await firebase_storage.FirebaseStorage.instance
          .ref(ref.fullPath)
          .getDownloadURL();

      if(!(MyApp.profileIconList.contains(url))){
        MyApp.profileIconList.add(url);
      }
    }
  } catch (e) {
    print("Error fetching image URLs: $e");
  }
}


Future<String> getUniqueDeviceId() async {
  String uniqueDeviceId = '';

  var deviceInfo = DeviceInfoPlugin();

  if (Platform.isIOS) { // import 'dart:io'
    var iosDeviceInfo = await deviceInfo.iosInfo;
    uniqueDeviceId = '${iosDeviceInfo.name}:${iosDeviceInfo.identifierForVendor}'; // unique ID on iOS
  } else if(Platform.isAndroid) {
    var androidDeviceInfo = await deviceInfo.androidInfo;
    uniqueDeviceId = '${androidDeviceInfo.device}:${androidDeviceInfo.id}' ; // unique ID on Android
  }

  return uniqueDeviceId;

}

String suffixOfNumber(int number) {
  if (number % 100 >= 11 && number % 100 <= 13) {
    return '$number' + 'th';
  }

  switch (number % 10) {
    case 1:
      return '$number' + 'st';
    case 2:
      return '$number' + 'nd';
    case 3:
      return '$number' + 'rd';
    default:
      return '$number' + 'th';
  }
}

void openBottomSheet(BuildContext context, int index) {
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.80,
            maxChildSize: 0.90,
            minChildSize: 0.70,
            builder: (context, scrollContoller) => SingleChildScrollView(
              controller: scrollContoller,
              child: SelectBottomSheet(index: index),
            ),
          ));
}

bool isNumeric(String s) {
  if (s == null) {
    return false;
  }
  return double.tryParse(s) != null;
}

bool doesNotContainSpaces(String input) {
  return !input.contains(' ');
}

int getMaxRId(List<Map<String, dynamic>> data) {
  return data.map((item) => item['rid'] as int).reduce((a, b) => a > b ? a : b);
}

int getMaxUId(List<Map<String, dynamic>> data) {
  if(data.isEmpty){
    return 0;
  }
  return data.map((item) => item['userid'] as int).reduce((a, b) => a > b ? a : b);
}

// Check login status on app start
Future<bool> checkLoginStatus() async {
  bool isLoggedIn = false;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getBool(MyApp.LOGIN_KEY) != null) {
    isLoggedIn = prefs.getBool(MyApp.LOGIN_KEY)!;
  }

  return isLoggedIn;
}

// Update login status
Future<void> updateLoginStatus(bool status) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool(MyApp.LOGIN_KEY, status);
}

// Update login status
Future<void> loginDetails(String uId, String username) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setStringList(MyApp.LOGIN_USERID_KEY, [uId, username]);
}

// get login status
Future<List<String>?> getLoginDetails() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? loginDetails = prefs.getStringList(MyApp.LOGIN_USERID_KEY);
  return loginDetails;
}

// Update login status
Future<void> clearSharedPrefs() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.clear();
}

bool hastextoverflow(
    String text,
    TextStyle style,
    {double minwidth = 0,
      double maxwidth = double.infinity,
      int maxlines = 7
    }) {
  final TextPainter textpainter = TextPainter(
    text: TextSpan(text: text, style: style),
    maxLines: maxlines,
    textDirection: TextDirection.ltr,
  )..layout(minWidth: minwidth, maxWidth: maxwidth);
  return textpainter.didExceedMaxLines;
}

String timePassed(DateTime datetime, {bool full = true}) {
  DateTime now = DateTime.now();
  DateTime ago = datetime;
  Duration dur = now.difference(ago);
  int days = dur.inDays;
  int years = (days / 365).toInt();
  int months =  ((days - (years * 365)) / 30).toInt();
  int weeks = ((days - (years * 365 + months * 30)) / 7).toInt();
  int rdays = days - (years * 365 + months * 30 + weeks * 7).toInt();
  int hours = (dur.inHours % 24).toInt();
  int minutes = (dur.inMinutes % 60).toInt();
  int seconds = (dur.inSeconds % 60).toInt();
  var diff = {
    "d":rdays,
    "w":weeks,
    "m":months,
    "y":years,
    "s":seconds,
    "i":minutes,
    "h":hours
  };

  Map str = {
    'y':'year',
    'm':'month',
    'w':'week',
    'd':'day',
    'h':'hour',
    'i':'minute',
    's':'second',
  };

  str.forEach((k, v){
    if (diff[k]! > 0) {
      str[k] = diff[k].toString()  +  ' ' + v.toString() +  (diff[k]! > 1 ? 's' : '');
    } else {
      str[k] = "";
    }
  });
  str.removeWhere((index, ele)=>ele == "");
  List<String> tlist = [];
  str.forEach((k, v){
    tlist.add(v);
  });
  if(full){
    return str.length > 0?tlist.join(", ") + " ago":"Just Now";
  }else{
    return str.length > 0?tlist[0] + " ago":"Just Now";
  }
}

extension DoubleFormatting on double {
  double fixedTwoDecimals() {
    return double.parse(toStringAsFixed(2));
  }
}