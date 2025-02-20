import 'dart:async';
import 'dart:convert';

import 'package:dalalstreetfantasy/features/contests/data/models/user_item.dart';
import 'package:http/http.dart' as http;
import 'package:country_code_picker/country_code_picker.dart';
import 'package:email_otp/email_otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:dalalstreetfantasy/features/authentication/data/repositories/users_repo.dart';
import 'package:dalalstreetfantasy/features/authentication/presentation/pages/signin.dart';
import 'package:dalalstreetfantasy/features/contests/data/repositories/realtime_db_repo.dart';
import 'package:dalalstreetfantasy/features/contests/presentation/widgets/snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../constants/boarder.dart';
import '../../../../constants/color.dart';
import '../../../../constants/cryptography.dart';
import '../../../../constants/cursor.dart';
import '../../../../constants/elevation.dart';
import '../../../../constants/values.dart';
import '../../../../main.dart';
import '../../../../utils/fonts.dart';
import '../../../../utils/methods.dart';
import '../../../../utils/otp_methods.dart';
import '../../../contests/data/models/user.dart';
import '../../../contests/domain/entities/phone_no_argument.dart';
import '../../../contests/domain/entities/verify_arguments.dart';
import '../../../contests/presentation/widgets/shadow.dart';
import '../../../contests/presentation/widgets/sort_card.dart';
import '../widgets/choose_gender.dart';
import '../widgets/resend_otp.dart';

class VerifyPhoneNo extends StatefulWidget {
  static String gender = '';
  static String username = '';
  final String phoneNo;
  final String countryCode;

  const VerifyPhoneNo(
      {super.key, required this.phoneNo, required this.countryCode});

  @override
  _VerifyPhoneNoState createState() => _VerifyPhoneNoState();
}

class _VerifyPhoneNoState extends State<VerifyPhoneNo> {
  PhoneAuthManager phoneAuthManager = PhoneAuthManager();

  TextEditingController _fieldOne = TextEditingController();
  TextEditingController _fieldTwo = TextEditingController();
  TextEditingController _fieldThree = TextEditingController();
  TextEditingController _fieldFour = TextEditingController();
  TextEditingController _fieldFive = TextEditingController();
  TextEditingController _fieldSix = TextEditingController();

  FocusNode _focusFieldOne = FocusNode();
  FocusNode _focusFieldTwo = FocusNode();
  FocusNode _focusFieldThree = FocusNode();
  FocusNode _focusFieldFour = FocusNode();
  FocusNode _focusFieldFive = FocusNode();
  FocusNode _focusFieldSix = FocusNode();

  int codeCount = 0;

  String getOtpCode() {
    return _fieldOne.text +
        _fieldTwo.text +
        _fieldThree.text +
        _fieldFour.text +
        _fieldFive.text +
        _fieldSix.text;
  }

  final FocusNode _focusCodeNode = FocusNode();
  bool _hasCodeFocus = false;

  TextEditingController codeController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _validateInput(String? input, int index) {
    switch (index) {
      case 0:
        if (input == null || input.isEmpty) {
          return 'Field empty';
        } else if (!isNumeric(input) || input.length != 6) {
          return 'Invalid Code';
        }
        break;

      default:
        return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _focusCodeNode.addListener(() {
      setState(() {
        _hasCodeFocus = _focusCodeNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool isLoading = false;

  setIsLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  incrementCodeCount() {
    setState(() {
      codeCount++;
    });
  }

  decrementCodeCount() {
    setState(() {
      codeCount--;
    });
  }

  void _focusOnFirstEmptyField() {
    // Check for empty fields and focus on the first one
    if (_fieldOne.text.isEmpty) {
      FocusScope.of(context).requestFocus(_focusFieldOne);
    } else if (_fieldTwo.text.isEmpty) {
      FocusScope.of(context).requestFocus(_focusFieldTwo);
    } else if (_fieldThree.text.isEmpty) {
      FocusScope.of(context).requestFocus(_focusFieldThree);
    } else if (_fieldFour.text.isEmpty) {
      FocusScope.of(context).requestFocus(_focusFieldFour);
    } else if (_fieldFive.text.isEmpty) {
      FocusScope.of(context).requestFocus(_focusFieldFive);
    } else if (_fieldSix.text.isEmpty) {
      FocusScope.of(context).requestFocus(_focusFieldSix);
    }
  }

  @override
  Widget build(BuildContext context) {
    _focusOnFirstEmptyField();

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
        child: Container(
          height: 50,
          width: double.infinity,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: codeCount >= 6
                    ? AppColors.primaryColor30
                    : Colors.grey.shade500,
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppBoarderRadius.buttonRadius)),
                elevation: AppElevations.buttonElev,
              ),
              onPressed: () async {
                FocusScope.of(context).unfocus();

               
              },
              child: isLoading == false
                  ? Text('Verify',
                      style: AuthFonts.authButtonText(
                          color: codeCount >= 6
                              ? AppColors.backgroundColor60
                              : AppColors.lightTextColor))
                  : SizedBox(
                      width: 30,
                      height: 30,
                      child: Center(
                          child: CircularProgressIndicator(
                              strokeWidth: AppValues.progresBarWidth,
                              color: AppColors.backgroundColor60)))),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 120),
                Container(
                  width: double.infinity,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Verify Phone\nNumber',
                    style: AuthFonts.authTitleText(),
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OtpInput(
                        index: 1,
                        controller: _fieldOne,
                        focusNode: _focusFieldOne,
                        autoFocus: true,
                        onChanged: (value) {
                          if (value.isEmpty) {
                            decrementCodeCount();
                          } else {
                            incrementCodeCount();
                          }
                        },
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      OtpInput(
                        index: 2,
                        controller: _fieldTwo,
                        focusNode: _focusFieldTwo,
                        autoFocus: true,
                        onChanged: (value) {
                          if (value.isEmpty) {
                            decrementCodeCount();
                          } else {
                            incrementCodeCount();
                          }
                        },
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      OtpInput(
                        index: 3,
                        controller: _fieldThree,
                        focusNode: _focusFieldThree,
                        autoFocus: true,
                        onChanged: (value) {
                          if (value.isEmpty) {
                            decrementCodeCount();
                          } else {
                            incrementCodeCount();
                          }
                        },
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      OtpInput(
                        index: 4,
                        controller: _fieldFour,
                        focusNode: _focusFieldFour,
                        autoFocus: true,
                        onChanged: (value) {
                          if (value.isEmpty) {
                            decrementCodeCount();
                          } else {
                            incrementCodeCount();
                          }
                        },
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      OtpInput(
                        index: 5,
                        controller: _fieldFive,
                        focusNode: _focusFieldFive,
                        autoFocus: true,
                        onChanged: (value) {
                          if (value.isEmpty) {
                            decrementCodeCount();
                          } else {
                            incrementCodeCount();
                          }
                        },
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      OtpInput(
                        index: 6,
                        controller: _fieldSix,
                        focusNode: _focusFieldSix,
                        autoFocus: false,
                        onChanged: (value) {
                          if (value.isEmpty) {
                            decrementCodeCount();
                          } else {
                            incrementCodeCount();
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                OTPResendWidget(
                  countryCode: widget.countryCode,
                  phoneNumber: widget.phoneNo,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showCredentialsConfirm(
      BuildContext context, int length, String email) async {
    showModalBottomSheet(
        isDismissible: false,
        enableDrag: false,
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: false,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (context) => Container(
              decoration: BoxDecoration(color: AppColors.backgroundColor60),
              child: DraggableScrollableSheet(
                  expand: false,
                  initialChildSize: 0.82,
                  maxChildSize: 0.82,
                  builder: (context, scrollContoller) =>
                      ChooseGender(email: email, length: length)),
            )).whenComplete(() async {
      var isLoggedIn = await checkLoginStatus();
      if (isLoggedIn) {
        FocusScope.of(context).unfocus();
        Future.delayed(const Duration(milliseconds: 200), () {
          // Remove all backtrack pages
          Navigator.popUntil(context, (route) => route.isFirst);

          Navigator.of(context).pushReplacementNamed('landing');
        });
      }
    });
  }

  Future<bool> verifyOtp(String countryCode, String phoneNumber, String otp, BuildContext context) async {
    final String url = 'https://verify.twilio.com/v2/Services/$serviceSid/VerificationCheck';

    try {

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Basic ' + base64Encode(utf8.encode('$accountSid:$authToken')),
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'To': countryCode + phoneNumber,
          'Code': otp,
        },
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        if (responseBody['status'] == 'approved') {

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
            mySnackBarShow(context, 'User not found.');

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

          return true;
        } else {
          mySnackBarShow(context, 'Invalid OTP. Please try again.');
          return false;
        }
      } else {
        mySnackBarShow(context, 'Failed to verify OTP: ${response.body}');
        return false;
      }
    } catch (e) {
      mySnackBarShow(context, 'Error verifying OTP: $e');
      return false;
    }
  }

}

class OtpInput extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool autoFocus;
  final Function(String)? onChanged;
  final int index;

  const OtpInput({
    Key? key,
    required this.index,
    required this.controller,
    required this.focusNode,
    required this.autoFocus,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 45,
      child: Center(
        child: TextField(
          autofocus: true,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          controller: controller,
          focusNode: focusNode,
          maxLength: 1,
          cursorColor: Theme.of(context).primaryColor,
          decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.primaryColor30.withOpacity(0.07),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      AppBoarderRadius.textFieldRadius),
                  borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      AppBoarderRadius.textFieldRadius),
                  borderSide: BorderSide(
                      width: AppBoarderWidth.textFieldWidth,
                      color: AppColors.secondaryColor10)),
              counterText: '',
              hintStyle: TextStyle(color: Colors.black, fontSize: 16.0)),
          onChanged: (value) {
            if (onChanged != null) {
              onChanged!(value);
            }
            if (value.length == 1 && index != 6) {
              FocusScope.of(context).nextFocus();
            }
          },
        ),
      ),
    );
  }
}
