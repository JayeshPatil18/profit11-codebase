import 'package:dalalstreetfantasy/features/contests/presentation/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../../constants/color.dart';

class ContestProgressIndicator extends StatelessWidget {
  final double totalContests;
  final double totalWins;

  ContestProgressIndicator({required this.totalContests, required this.totalWins});

  @override
  Widget build(BuildContext context) {
    double winPercentage = totalContests > 0 ? totalWins / totalContests : 0;

    return CircularPercentIndicator(
      radius: 60.0,
      // Increased radius for a more balanced look
      lineWidth: 12.0,
      // Slightly increased line width for visibility
      animation: true,
      animationDuration: 1200,
      // Smooth animation speed
      percent: winPercentage,
      center: Text(
        "${(winPercentage * 100).toStringAsFixed(1)}%",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18, // Slightly larger for better readability
          color: AppColors.secondaryColor10, // Center text color
        ),
      ),
      circularStrokeCap: CircularStrokeCap.round,
      // Rounded edges for a smoother look
      backgroundColor:
      AppColors.secondaryColor10.withOpacity(0.2),
      // Soft background color
      linearGradient: LinearGradient(
        // Gradient color for progress
        colors: [
          AppColors.secondaryColor10,
          AppColors.secondaryColor10
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      progressColor: null,
      // Set to null to enable gradient
      animateFromLastPercent:
      true, // Smooth transition when updating the percent
    );
  }
}
