import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:dalalstreetfantasy/constants/icon_size.dart';
import 'package:dalalstreetfantasy/features/contests/presentation/provider/bottom_nav_bar.dart';

import '../../../../constants/color.dart';

List<Widget> bottomNavIcons = [
  Consumer<BottomNavigationProvider>(
    builder: ((context, value, child) {
      return Container(
        color: Colors.transparent,
      padding: EdgeInsets.all(16),
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              height: 18, width: 18,
              child: Image.asset('assets/icons/home.png', color: value.currentIndex == 0 ? AppColors.secondaryColor10 : Colors.white.withOpacity(0.8))),
          SizedBox(height: 6),
          Text('Home', style: TextStyle(fontSize: 12, color: value.currentIndex == 0 ? AppColors.secondaryColor10 : Colors.white.withOpacity(0.8)))
        ],
      ));
    }),
  ),

  Consumer<BottomNavigationProvider>(
    builder: ((context, value, child) {
      return Container(
        color: Colors.transparent,
      padding: EdgeInsets.all(16),
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              height: 18, width: 18,
              child: Image.asset('assets/icons/search.png', color: value.currentIndex == 1 ? AppColors.secondaryColor10 : Colors.white.withOpacity(0.8))),
          SizedBox(height: 6),
          Text('My Contests', style: TextStyle(fontSize: 12, color: value.currentIndex == 1 ? AppColors.secondaryColor10 : Colors.white.withOpacity(0.8)))
        ],
      ));
    }),
  ),

Consumer<BottomNavigationProvider>(
    builder: ((context, value, child) {
      return Container(
        color: Colors.transparent,
      padding: EdgeInsets.all(16),
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              height: 18, width: 18,
              child: Image.asset('assets/icons/activity.png', color: value.currentIndex == 2 ? AppColors.secondaryColor10 : Colors.white.withOpacity(0.8))),
          SizedBox(height: 6),
          Text('Rank', style: TextStyle(fontSize: 12, color: value.currentIndex == 2 ? AppColors.secondaryColor10 : Colors.white.withOpacity(0.8)))
        ],
      ));
    }),
  ),

Consumer<BottomNavigationProvider>(
    builder: ((context, value, child) {
      return Container(
        color: Colors.transparent,
      padding: EdgeInsets.all(16),
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              height: 18, width: 18,
              child: Image.asset('assets/icons/user.png', color: value.currentIndex == 3 ? AppColors.secondaryColor10 : Colors.white.withOpacity(0.8))),
          SizedBox(height: 6),
          Text('Profile', style: TextStyle(fontSize: 12, color: value.currentIndex == 3 ? AppColors.secondaryColor10 : Colors.white.withOpacity(0.8)))
        ],
      ));
    }),
  ),
];