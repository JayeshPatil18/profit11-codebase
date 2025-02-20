import 'package:dalalstreetfantasy/constants/color.dart';
import 'package:flutter/material.dart';

class RibbonFlagPainter extends CustomPainter {
  final String text;
  final Color color;

  RibbonFlagPainter(this.text, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.7)
      ..style = PaintingStyle.fill;

    // Draw the main flag shape
    final path = Path();
    path.moveTo(size.height / 2, 0); // Start point (left-cut triangle tip)
    path.lineTo(size.width, 0); // Top-right
    path.lineTo(size.width, size.height); // Bottom-right
    path.lineTo(size.height / 2, size.height); // Bottom-left (align with triangle cut)
    path.lineTo(0, size.height / 2); // Triangle cut tip
    path.close();

    canvas.drawPath(path, paint);

    // Draw the text at the center of the shape
    final textStyle = TextStyle(
      color: Colors.white,
      fontSize: 12,
      fontWeight: FontWeight.w500,
    );

    final textSpan = TextSpan(text: text, style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );

    final offset = Offset((size.width - textPainter.width) / 2, (size.height - textPainter.height) / 2);
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class RibbonFlagWidget extends StatelessWidget {
  final double width;
  final double height;
  final String text;
  final Color color;

  const RibbonFlagWidget({this.width = 150, this.height = 50, this.text = '', this.color = Colors.green, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, height),
      painter: RibbonFlagPainter(text, color),
    );
  }
}
