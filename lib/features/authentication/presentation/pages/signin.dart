import 'dart:async';
import 'dart:convert';

import 'package:dalalstreetfantasy/utils/otp_methods.dart';
import 'package:http/http.dart' as http;
import 'package:country_code_picker/country_code_picker.dart';
import 'package:dalalstreetfantasy/features/authentication/presentation/pages/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:dalalstreetfantasy/constants/color.dart';
import 'package:dalalstreetfantasy/constants/elevation.dart';
import 'package:dalalstreetfantasy/constants/values.dart';
import 'package:dalalstreetfantasy/features/contests/presentation/widgets/snackbar.dart';
import 'package:email_otp/email_otp.dart';
import 'package:dalalstreetfantasy/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../constants/boarder.dart';
import '../../../../constants/cursor.dart';
import '../../../../utils/fonts.dart';
import '../../../../utils/methods.dart';
import '../../../contests/domain/entities/phone_no_argument.dart';
import '../../../contests/domain/entities/verify_arguments.dart';
import '../../../contests/presentation/widgets/shadow.dart';
import '../../data/repositories/users_repo.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  PhoneAuthManager phoneAuthManager = PhoneAuthManager();

  final FocusNode _focusPhoneNoNode = FocusNode();
  bool _hasPhoneNoFocus = false;

  TextEditingController phoneNoController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String countryCode = "+91";


  String? _validateInput(String? input, int index) {
    if(input != null){
      input = input.trim();
    }

    switch (index) {
      case 0:
        if (input == null || input.isEmpty) {
          return 'Enter phone number';
        } else if (!isNumeric(input) || input.length != 10) {
          return 'Invalid phone number';
        }
        break;

      default:
        return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _focusPhoneNoNode.addListener(() {
      setState(() {
        _hasPhoneNoFocus = _focusPhoneNoNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
          margin: const EdgeInsets.only(left: 20, right: 20, top: 6),
        child: Container(
          height: 50,
          width: double.infinity,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: (isChecked && phoneNoController.text.trim().isNotEmpty) ? AppColors.primaryColor30 : Colors.grey.shade500,
                shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(AppBoarderRadius.buttonRadius)),
                elevation: AppElevations.buttonElev,
              ),
              onPressed: () async {
                FocusScope.of(context).unfocus();

                if(!isLoading && isChecked && phoneNoController.text.trim().isNotEmpty){
                  setIsLoading(true);

                  bool isValid = _formKey.currentState!.validate();
                  if (isValid) {
                    // sendOtp(countryCode, phoneNoController.text.trim(), context);
                    phoneAuthManager.verifyPhoneNumber(context, countryCode, phoneNoController.text.trim(), false);
                  }

                  Future.delayed(const Duration(seconds: 15), () {
                    setIsLoading(false);
                  });
                }
              },
              child: isLoading == false ? Text('Continue', style: AuthFonts.authButtonText(color: (isChecked && phoneNoController.text.trim().isNotEmpty) ? AppColors.backgroundColor60 : AppColors.lightTextColor)) : SizedBox(
                  width: 30,
                  height: 30,
                  child: Center(
                      child: CircularProgressIndicator(
                          strokeWidth:
                          AppValues.progresBarWidth,
                          color:
                          AppColors.backgroundColor60)))),
        ),
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () async{
                    // Store userId as security token in shared preferences
                    // SharedPreferences prefs = await SharedPreferences.getInstance();
                    // await prefs.setString(MyApp.LOGIN_USERID_KEY, "-1");
                    // await prefs.setBool(MyApp.LOGIN_KEY, true);

                    MyApp.loggedInUserId = "-1";

                    // Remove all backtrack pages
                    Navigator.popUntil(context, (route) => route.isFirst);

                    Navigator.of(context).pushReplacementNamed('landing');
                  },
                  child: Container(
                      margin: EdgeInsets.only(top: 60, right: 20),
                      width: double.infinity,
                      child: Text('Skip', textAlign: TextAlign.end, style: TextStyle(color: Colors.grey, fontSize: 16))),
                ),
                SizedBox(height: 80), // For spacing from the top
                Container(
                  width: double.infinity,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Login/Register',
                    style: AuthFonts.authTitleText(),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 40),
                Container(
                  child: TextFormField(
                    maxLength: 10,
                    controller: phoneNoController,
                    validator: ((value) {
                      return _validateInput(value, 0);
                    }),
                    onChanged: (value){
                      setState(() {

                      });
                    },
                    style: AuthFonts.authTextField(),
                    keyboardType: TextInputType.number,
                    focusNode: _focusPhoneNoNode,
                    cursorHeight: TextCursorHeight.cursorHeight,
                    decoration: InputDecoration(
                      prefixIcon: CountryCodePicker(
                        textStyle: AuthFonts.authCountryCodeTextField(),
                        onChanged: ((value) {
                          countryCode = value.dialCode.toString();
                        }),
                        initialSelection: '+91',
                        favorite: ['+91', 'IND'],
                        showFlagDialog: true,
                        showFlagMain: false,
                        alignLeft: false,
                      ),
                      contentPadding: EdgeInsets.only(
                          top: 16, bottom: 16, left: 20, right: 20),
                      fillColor: AppColors.primaryColor30.withOpacity(0.07),
                      filled: true,
                      hintText: 'Enter phone number',
                      hintStyle: AuthFonts.authHintTextField(),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              AppBoarderRadius.textFieldRadius),
                          borderSide: BorderSide.none),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              AppBoarderRadius.textFieldRadius),
                          borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              AppBoarderRadius.textFieldRadius),
                          borderSide: BorderSide(
                              width: AppBoarderWidth.textFieldWidth,
                              color:
                              AppColors.secondaryColor10)),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              AppBoarderRadius.textFieldRadius),
                          borderSide: BorderSide(
                              width: AppBoarderWidth.textFieldWidth,
                              color: AppBoarderColor.errorColor)),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Transform.scale(
                      scale: 0.8,
                      child: Checkbox(
                        value: isChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked = value!;
                          });
                        },
                        activeColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isChecked = !isChecked;
                        });
                      },
                      child: Text(
                        'I confirm that I am over 18 years old.',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          height: 0,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> sendOtp(String countryCode, String phoneNo, BuildContext context) async {
    final String url =
        'https://verify.twilio.com/v2/Services/$serviceSid/Verifications';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Basic ' + base64Encode(utf8.encode('$accountSid:$authToken')),
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'To': countryCode + phoneNo,
          'Channel': 'sms',  // or 'call' for a voice OTP
        },
      );

      if (response.statusCode == 201) {
        mySnackBarShow(context, 'OTP sent to ${countryCode + phoneNo}');
        Future.delayed(const Duration(milliseconds: 300), () {
          Navigator.of(context).pushNamed('verifyphone',
              arguments:
              PhoneNoArguments(phoneNo, countryCode));
        });
        print('OTP sent successfully');
        return true;
      } else {
        mySnackBarShow(context, 'Failed to send OTP: ${response.body}');
        print('Failed to send OTP: ${response.body}');
        return false;
      }
    } catch (e) {
      mySnackBarShow(context, 'Error sending OTP: $e');
      print('Error sending OTP: $e');
      return false;
    }
  }

  bool isLoading = false;

  setIsLoading(bool isLoadingVal) {
    setState(() {
      isLoading = isLoadingVal;
    });
  }
}
