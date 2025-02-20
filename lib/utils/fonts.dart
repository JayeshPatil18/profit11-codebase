import 'package:flutter/material.dart';
import 'package:dalalstreetfantasy/constants/color.dart';
import 'package:dalalstreetfantasy/constants/shadow_color.dart';
import 'package:dalalstreetfantasy/features/contests/presentation/widgets/shadow.dart';

// In use
class NotificationFonts {
  static TextStyle messageText({Color color = AppColors.textColor, double fontSize = 17.0}) {
    return TextStyle(
        fontSize: fontSize, fontWeight: FontWeight.w400, color: AppColors.textColor);
  }

  static TextStyle agoText() {
    return TextStyle(
        fontSize: 10, fontWeight: FontWeight.w400, color: AppColors.textColor);
  }
}

// In use
class ViewReviewFonts {
  static TextStyle titleText({Color color = AppColors.textColor}) {
    return TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: color);
  }

  static TextStyle subTitleText({double fontSize = 17.0}) {
    return TextStyle(
        fontSize: fontSize, fontWeight: FontWeight.w400, color: AppColors.textColor);
  }

  static TextStyle contentLabelText({Color color = AppColors.textColor}) {
    return TextStyle(
        fontSize: 17, fontWeight: FontWeight.w600, color: AppColors.textColor);
  }

  static TextStyle reviewUserText({Color color = AppColors.textColor}) {
    return TextStyle(
        fontSize: 17, fontWeight: FontWeight.w500, color: AppColors.textColor);
  }

  static TextStyle contentText({Color color = AppColors.textColor}) {
    return const TextStyle(fontSize: 17, color: AppColors.textColor);
  }
}

// In use
class ProfileUserFonts {
  static TextStyle nameText() {
    return TextStyle(
        fontSize: 25, fontWeight: FontWeight.w500, color: AppColors.textColor);
  }

  static TextStyle usernameText() {
    return TextStyle(
        fontSize: 18, fontWeight: FontWeight.w500, color: AppColors.textColor);
  }

  static TextStyle userSubText() {
    return TextStyle(
        fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textColor);
  }

  static TextStyle userValueText() {
    return TextStyle(
        fontSize: 20, fontWeight: FontWeight.w500, color: AppColors.textColor);
  }

  static TextStyle userBioText() {
    return TextStyle(
        fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.bioTextColor);
  }

  static TextStyle editText() {
    return TextStyle(
        fontSize: 15, fontWeight: FontWeight.w400, color: AppColors.textColor);
  }
}

class UserModelFonts {
  static TextStyle userRankingTitle() {
    return TextStyle(
        fontSize: 22, fontWeight: FontWeight.w500, color: AppColors.textColor);
  }

  static TextStyle userRankingSubTitle() {
    return TextStyle(
        fontSize: 15, fontWeight: FontWeight.w400, color: AppColors.textColor);
  }
}

// In use
class ReviewModelFonts {
  static TextStyle dateReview({
    Color color = AppColors.textColor,
    BoxShadow boxShadow = const BoxShadow(
      offset: Offset(0, 0),
      blurRadius: 0,
      color: Colors.transparent,
    ),
  }) {
    return TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        color: color,
        shadows: [boxShadow]);
  }

  static TextStyle reviewSubTitle({
    Color color = AppColors.textColor,
    BoxShadow boxShadow = const BoxShadow(
      offset: Offset(0, 0),
      blurRadius: 0,
      color: Colors.transparent,
    ),
  }) {
    return TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: color,
        shadows: [boxShadow]);
  }

  static reviewTitle({
    Color color = AppColors.textColor,
    BoxShadow boxShadow = const BoxShadow(
      offset: Offset(0, 0),
      blurRadius: 0,
      color: Colors.transparent,
    ),
  }) {
    return TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: color,
        shadows: [boxShadow]);
  }

  static TextStyle subReviewPrice({
    Color color = AppColors.textColor,
    BoxShadow boxShadow = const BoxShadow(
      offset: Offset(0, 0),
      blurRadius: 0,
      color: Colors.transparent,
    ),
  }) {
    return TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: color,
        shadows: [boxShadow]);
  }
}

// In use
class MainFonts {

  static TextStyle searchText({Color color = AppColors.bioTextColor, double size = 18, FontWeight weight = FontWeight.w400}) {
    return TextStyle(
        fontSize: size, fontWeight: weight, color: color);
  }

  static TextStyle uploadButtonText({double size = 22, FontWeight weight = FontWeight.w500}) {
    return TextStyle(
        fontSize: size, fontWeight: weight, color: AppColors.textColor);
  }

  static TextStyle lableText({Color color = AppColors.textColor, double fontSize = 18, FontWeight weight = FontWeight.w500}) {
    return TextStyle(
        fontSize: fontSize, fontWeight: weight, color: color);
  }

  static TextStyle suggestionText({Color color = AppColors.textColor}) {
    return TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: color);
  }

  static TextStyle pageTitleText({color = AppColors.textColor, double fontSize = 25, FontWeight weight = FontWeight.w600}) {
    return TextStyle(
        fontSize: fontSize, fontWeight: weight, color: color);
  }

  static TextStyle pageBigTitleText() {
    return const TextStyle(
        fontSize: 36, fontWeight: FontWeight.w600, color: AppColors.textColor);
  }

  static TextStyle filterText({Color color = AppColors.primaryColor30}) {
    return TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: color);
  }

  static TextStyle hintFieldText({double size = 18, Color color = AppColors.lightTextColor}) {
    return TextStyle(fontSize: 18, color: color);
  }

  static TextStyle textFieldText({double size = 19}) {
    return TextStyle(fontSize: size, color: AppColors.textColor);
  }

  static TextStyle postMainText({double size = 18, Color color = AppColors.textColor}) {
    return TextStyle(fontSize: size, fontWeight: FontWeight.w300, color: color);
  }

  static TextStyle settingLabel({Color color = AppColors.textColor}) {
    return TextStyle(fontSize: 18, color: color);
  }

  static miniText({double fontSize = 12, Color color = AppColors.textColor, weight = FontWeight.w400}) {
    return TextStyle(fontSize: fontSize, fontWeight: weight, color: color);
  }
}

// In use
class AuthFonts {
  static authTitleText({double fontSize = 28, Color color = AppColors.primaryColor30}) {
    return TextStyle(
        fontSize: fontSize, fontWeight: FontWeight.w600, color: color);
  }

  static authSmallLabelText({double fontSize = 12, Color color = AppColors.lightBlackColor}) {
    return TextStyle(
        fontSize: fontSize, fontWeight: FontWeight.w400, color: color);
  }

  static TextStyle authTextField({FontWeight weight = FontWeight.w400, Color color = AppColors.textColor}) {
    return TextStyle(fontSize: 16, color: color, fontWeight: weight);
  }

  static TextStyle authCountryCodeTextField({FontWeight weight = FontWeight.w400, Color color = AppColors.textColor}) {
    return TextStyle(fontSize: 16, color: color, fontWeight: weight);
  }

  static TextStyle authHintTextField({FontWeight weight = FontWeight.w400, Color color = AppColors.lightBlackColor}) {
    return TextStyle(fontSize: 15, color: color, fontWeight: weight);
  }

  static TextStyle authButtonText({FontWeight weight = FontWeight.w500, Color color = AppColors.backgroundColor60}) {
    return TextStyle(fontSize: 18, fontWeight: weight, color: color);
  }
}
