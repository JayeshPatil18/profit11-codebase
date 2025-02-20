import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:dalalstreetfantasy/constants/color.dart';

class Line extends StatelessWidget {
  final double height;
  final Color color;

  Line({this.height = 0.3, this.color = AppColors.lightBlackColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      height: height,
    );
  }
}