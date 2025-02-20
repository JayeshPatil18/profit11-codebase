import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dalalstreetfantasy/constants/color.dart';
import 'package:dalalstreetfantasy/utils/fonts.dart';

import '../../../../constants/boarder.dart';
import '../../../../constants/values.dart';
import '../pages/home.dart';
import 'shadow.dart';

class SortCard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SortCardState();
  }
}

class SortCardState extends State<SortCard> {
  void updateSelectedValue(String value) {
    setState(() {
      HomePage.selectedSort = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10, right: 20, left: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                    onTap: () {
                      updateSelectedValue('date_des');
                      Timer(Duration(milliseconds: AppValues.closeDelay), () {
                        Navigator.pop(context);
                      });
                    },
                    child: Text("Newest Uploads")),
                Radio(
                  value: 'date_des',
                  groupValue: HomePage.selectedSort,
                  onChanged: (value) {
                    updateSelectedValue(value!);
                    Timer(Duration(milliseconds: AppValues.closeDelay), () {
                      Navigator.pop(context);
                    });
                  },
                ),
              ],
            ),
          ),
          Container(
            color: AppColors.iconColor,
            height: 1,
          ),
          Container(
            padding: EdgeInsets.only(left: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                    onTap: () {
                      updateSelectedValue('date_asc');
                      Timer(Duration(milliseconds: AppValues.closeDelay), () {
                        Navigator.pop(context);
                      });
                    },
                    child: Text("Oldest Uploads")),
                Radio(
                  value: 'date_asc',
                  groupValue: HomePage.selectedSort,
                  onChanged: (value) {
                    updateSelectedValue(value!);
                    Timer(Duration(milliseconds: AppValues.closeDelay), () {
                      Navigator.pop(context);
                    });
                  },
                ),
              ],
            ),
          ),
          Container(
            color: AppColors.iconColor,
            height: 1,
          ),
          Container(
            padding: EdgeInsets.only(left: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                    onTap: () {
                      updateSelectedValue('rate_des');
                      Timer(Duration(milliseconds: AppValues.closeDelay), () {
                        Navigator.pop(context);
                      });
                    },
                    child: Text("Highest Rating")),
                Radio(
                  value: 'rate_des',
                  groupValue: HomePage.selectedSort,
                  onChanged: (value) {
                    updateSelectedValue(value!);
                    Timer(Duration(milliseconds: AppValues.closeDelay), () {
                      Navigator.pop(context);
                    });
                  },
                ),
              ],
            ),
          ),
          Container(
            color: AppColors.iconColor,
            height: 1,
          ),
          Container(
            padding: EdgeInsets.only(left: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                    onTap: () {
                      updateSelectedValue('rate_asc');
                      Timer(Duration(milliseconds: AppValues.closeDelay), () {
                        Navigator.pop(context);
                      });
                    },
                    child: Text("Lowest Rating")),
                Radio(
                  value: 'rate_asc',
                  groupValue: HomePage.selectedSort,
                  onChanged: (value) {
                    updateSelectedValue(value!);
                    Timer(Duration(milliseconds: AppValues.closeDelay), () {
                      Navigator.pop(context);
                    });
                  },
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              updateSelectedValue('date_des');
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
                color: AppColors.primaryColor30,
                borderRadius: BorderRadius.circular(AppBoarderRadius.filterRadius
                ),
              ),
              padding: EdgeInsets.only(top: 10, bottom: 10, left: 11, right: 11),
              child: Icon(Icons.restart_alt_outlined, color: AppColors.textColor),
            ),
          ),
        ],
      ),
    );
  }
}