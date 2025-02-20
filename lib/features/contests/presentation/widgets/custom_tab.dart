import 'package:flutter/material.dart';

class CustomTab extends StatelessWidget {
  final String icon;
  final String label;

  CustomTab({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 6),
        Image.asset(icon, width: 20),
        SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 9)),
        SizedBox(height: 4),
      ],
    );
  }
}