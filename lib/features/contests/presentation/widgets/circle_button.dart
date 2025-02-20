import 'package:flutter/material.dart';
import 'package:dalalstreetfantasy/constants/color.dart';
import 'package:dalalstreetfantasy/constants/shadow_color.dart';
import 'package:dalalstreetfantasy/features/contests/presentation/widgets/shadow.dart';

class CircleIconContainer extends StatelessWidget {
  final Widget icon;
  final Color containerColor;
  final double containerSize;

  CircleIconContainer({
    required this.icon,
    this.containerColor = AppColors.secondaryColor10,
    this.containerSize = 30.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: containerSize,
      height: containerSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: containerColor, // Change this to the desired background color
        boxShadow: ContainerShadow.boxShadow
      ),
      child: Center(
        child: icon,
      ),
    );
  }
}