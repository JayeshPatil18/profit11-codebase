import 'package:dalalstreetfantasy/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginMethods{
  static Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(MyApp.LOGIN_KEY) ?? false;
  }

  static Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(MyApp.LOGIN_USERID_KEY);
  }

  static Future<void> setUserId(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(MyApp.LOGIN_USERID_KEY, userId);
  }

  static Future<void> setUserIdVariable(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    MyApp.loggedInUserId = prefs.getString(MyApp.LOGIN_USERID_KEY)!;
  }

  static Future<void> setLoginStatus(bool status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(MyApp.LOGIN_KEY, status);
  }
}