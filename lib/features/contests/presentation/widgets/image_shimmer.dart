import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';

class CustomImageShimmer extends StatelessWidget {
  final String imageUrl;
  final double height;
  final double width;
  final BoxFit fit;
  const CustomImageShimmer({super.key, required this.imageUrl, required this.height, required this.width, required this.fit});

  @override
  Widget build(BuildContext context) {
    return FancyShimmerImage(
      boxFit: fit,
      width: width,
      height: height,
      shimmerBaseColor: Colors.grey[350],
      shimmerHighlightColor: Colors.grey[100],
      imageUrl: imageUrl,
    );
  }
}
