import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../../../constants/color.dart';

void mySnackBarShow(BuildContext context, String text) {
  late AnimatedSnackBar snackBar;

  snackBar = AnimatedSnackBar(
    duration: const Duration(seconds: 5),
    builder: (context) {
      return Dismissible(
        key: const ValueKey('snack_bar'),
        direction: DismissDirection.horizontal,
        onDismissed: (direction) {
          snackBar.remove(); // Trigger the built-in dismissal animation
        },
        child: AnimatedContainer(
          duration: const Duration(seconds: 4),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.only(left: 18, right: 18, top: 14, bottom: 14),
          decoration: BoxDecoration(
            color: AppColors.primaryColor30,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    color: AppColors.backgroundColor60,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              GestureDetector(
                onTap: () {
                  snackBar.remove(); // Trigger the built-in dismissal animation
                },
                child: Icon(
                  Icons.cancel_outlined,
                  color: AppColors.backgroundColor60,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      );
    },
    mobileSnackBarPosition: MobileSnackBarPosition.top,
  );

  snackBar.show(context);
}
