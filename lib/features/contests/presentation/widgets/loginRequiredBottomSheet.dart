import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dalalstreetfantasy/constants/color.dart';
import 'package:dalalstreetfantasy/utils/fonts.dart';

import '../../../../constants/boarder.dart';
import '../../../../constants/elevation.dart';
import '../../../../constants/values.dart';
import '../../../../utils/methods.dart';
import '../pages/home.dart';
import 'circle_button.dart';
import 'shadow.dart';

class LoginRequired extends StatefulWidget {
  const LoginRequired({super.key});

  @override
  State<StatefulWidget> createState() {
    return LoginRequiredState();
  }
}

class LoginRequiredState extends State<LoginRequired> {
  void updateSelectedValue(String value) {
    setState(() {
      HomePage.selectedSort = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 30, bottom: 40, right: 50, left: 50),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'Login Required !',
            style: MainFonts.pageTitleText(fontSize: 20),
          ),
          SizedBox(height: 50),
          Container(
            width: double.infinity, // Adjust width
            height: 40, // Adjust height
            margin: EdgeInsets.only(left: 20, right: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.indigo], // Gradient colors
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(25), // Rounded edges
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2), // Shadow color
                  blurRadius: 4,
                  offset: Offset(2, 2), // Shadow position
                ),
              ],
            ),
            child: TextButton(
                onPressed: () {
                  Timer(Duration(milliseconds: AppValues.closeDelay), () {

                    _navigateToLoginPage(context);
                  });
                },
                child: Text('Login',
                    style: AuthFonts.authButtonText())),
          ),
          SizedBox(height: 30),
          GestureDetector(
            onTap: () {
              Timer(Duration(milliseconds: AppValues.closeDelay), () {
                Navigator.pop(context);
              });
            },
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color(0xffffffff),
                    offset: Offset(-6, -6),
                    blurRadius: 10,
                    spreadRadius: 0.0,
                  ),
                  BoxShadow(
                    color: Color(0x224e4e4e),
                    offset: Offset(6, 6),
                    blurRadius: 10,
                    spreadRadius: 0.0,
                  ),
                ],
                borderRadius: BorderRadius.circular(AppBoarderRadius.filterRadius
                ),
              ),
              padding: EdgeInsets.only(top: 10, bottom: 10, left: 11, right: 11),
              child: Icon(Icons.close_rounded, color: AppColors.textColor),
            ),
          ),
        ],
      ),
    );
  }

  void showLoginRequiredDialog(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: false,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (context) =>
            DraggableScrollableSheet(
                expand: false,
                initialChildSize: 0.60,
                maxChildSize: 0.60,
                builder: (context, scrollContoller) =>
                    SingleChildScrollView(
                      child: LoginRequired(),
                    )));
  }

  void _navigateToLoginPage(BuildContext context) {
    clearSharedPrefs();
    Navigator.of(context).popUntil(
            (route) => route.isFirst);
    Navigator.of(context)
        .pushReplacementNamed(
        'signin');
  }
}