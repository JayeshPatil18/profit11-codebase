import 'dart:async';

import 'package:dalalstreetfantasy/constants/color.dart';
import 'package:dalalstreetfantasy/utils/fonts.dart';
import 'package:flutter/material.dart';

class SortCard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SortCardState();
  }
}

class SortCardState extends State<SortCard> {
  int _selectedValue = 1;
  int _closeDelay = 400;

  void _updateSelectedValue(int value) {
    setState(() {
      _selectedValue = value;
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
                Text("Popularity"),
                Radio(
                  value: 1,
                  groupValue: _selectedValue,
                  onChanged: (value) {
                    setState(() {
                      _updateSelectedValue(value!);
                      Timer(Duration(milliseconds: _closeDelay), () {
                        Navigator.pop(context);
                      });
                    });
                  },
                ),
              ],
            ),
          ),
          Container(
            color: AppColors.lightBlackColor,
            height: 1,
          ),
          Container(
            padding: EdgeInsets.only(left: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Alphabetically"),
                Radio(
                  value: 2,
                  groupValue: _selectedValue,
                  onChanged: (value) {
                    setState(() {
                      _updateSelectedValue(value!);
                      Timer(Duration(milliseconds: _closeDelay), () {
                        Navigator.pop(context);
                      });
                    });
                  },
                ),
              ],
            ),
          ),
          Container(
            color: AppColors.lightBlackColor,
            height: 1,
          ),
          Container(
            padding: EdgeInsets.only(left: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Top Gainer"),
                Radio(
                  value: 3,
                  groupValue: _selectedValue,
                  onChanged: (value) {
                    setState(() {
                      _updateSelectedValue(value!);
                      Timer(Duration(milliseconds: _closeDelay), () {
                        Navigator.pop(context);
                      });
                    });
                  },
                ),
              ],
            ),
          ),
          Container(
            color: AppColors.lightBlackColor,
            height: 1,
          ),
          Container(
            padding: EdgeInsets.only(left: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Top Loser"),
                Radio(
                  value: 4,
                  groupValue: _selectedValue,
                  onChanged: (value) {
                    setState(() {
                      _updateSelectedValue(value!);
                      Timer(Duration(milliseconds: _closeDelay), () {
                        Navigator.pop(context);
                      });
                    });
                  },
                ),
              ],
            ),
          ),
          Container(
            color: AppColors.lightBlackColor,
            height: 1,
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: OutlinedButton(
              onPressed: (){
                _updateSelectedValue(1!);
                Timer(Duration(milliseconds: _closeDelay), () {
                  Navigator.pop(context);
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text('Reset', style: MainFonts.hintFieldText()),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void showSortDialog(BuildContext context) {
  showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
      builder: (context) => DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.60,
          maxChildSize: 0.60,
          builder: (context, scrollContoller) => SingleChildScrollView(
            child: SortCard(),
          )));
}