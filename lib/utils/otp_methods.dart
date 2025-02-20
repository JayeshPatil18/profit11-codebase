import 'dart:convert';

import 'package:dalalstreetfantasy/features/contests/presentation/widgets/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../features/authentication/data/repositories/users_repo.dart';
import '../features/contests/data/models/user_item.dart';
import '../features/contests/domain/entities/phone_no_argument.dart';
import '../main.dart';
import 'methods.dart';

class PhoneAuthManager {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static String? _verificationId;

  void verifyPhoneNumber(BuildContext context, String countryCode, String phoneNumber, bool isResendOTP) async {

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: (countryCode + phoneNumber),
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-retrieve or instant verification
          await _auth.signInWithCredential(credential);
          mySnackBarShow(context, 'Phone number automatically verified');
        },
        verificationFailed: (FirebaseAuthException e) {
          mySnackBarShow(context, 'Verification failed: ${e.message}');
        },
        codeSent: (String verificationId, int? resendToken) {
            _verificationId = verificationId;
          mySnackBarShow(context, 'OTP sent to $phoneNumber');

            if(!isResendOTP) {
              Future.delayed(const Duration(milliseconds: 300), () {
                Navigator.of(context).pushNamed('verifyphone',
                    arguments:
                    PhoneNoArguments(phoneNumber, countryCode));
              });
            }
        },
        codeAutoRetrievalTimeout: (String verificationId) {
            _verificationId = verificationId;
        },
      );
    } catch (e) {
      mySnackBarShow(context, 'Failed to verify phone number: $e');
    }
  }

  void signInWithOTP(BuildContext context, String otp, String countryCode, String phoneNumber) async {

    if (_verificationId != null) {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp,
      );

      try {
        await _auth.signInWithCredential(credential);
        UsersRepo usersRepo = UsersRepo();
        Map<String, dynamic> result = await usersRepo
            .getUserData(countryCode + phoneNumber);

        if (result['status'] == 'found') {
          UserItem user = result['user'];

          UserServicesRepo usersRepo = UserServicesRepo();
          String deviceId = await getUniqueDeviceId();
          bool status = await usersRepo.setUserDeviceId(countryCode + phoneNumber, deviceId);

          if(status){
            SharedPreferences prefs =
            await SharedPreferences.getInstance();
            await prefs.setString(MyApp.LOGIN_USERID_KEY, user.userId);
            await prefs.setBool(MyApp.LOGIN_KEY, true);

            FocusScope.of(context).unfocus();
            mySnackBarShow(context, 'Logged in successfully!');

            Future.delayed(const Duration(milliseconds: 200), () {
              // Remove all backtrack pages
              Navigator.popUntil(context, (route) => route.isFirst);

              Navigator.pushReplacementNamed(context, 'landing');
            });
          } else {
            mySnackBarShow(context, 'Something went wrong!');
          }
        } else if (result['status'] == 'not_found') {
          print('User not found.');

          FocusScope.of(context).unfocus();
          Future.delayed(const Duration(milliseconds: 300), () {
            // Remove all backtrack pages
            Navigator.popUntil(context, (route) => route.isFirst);

            Navigator.of(context).pushReplacementNamed('signup',
                arguments: PhoneNoArguments(
                    phoneNumber, countryCode));
          });
        } else {
          print(
              'An error occurred while retrieving user credentials.');
          mySnackBarShow(context, 'Something went wrong.');
        }
      } catch (e) {
        mySnackBarShow(context, 'Failed to sign in: $e');
      }
    } else {
      mySnackBarShow(context, 'Verification ID is null, retry verification');
    }
  }

  }
