import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:dalalstreetfantasy/constants/values.dart';
import 'package:dalalstreetfantasy/features/contests/presentation/widgets/snackbar.dart';
import 'package:dalalstreetfantasy/utils/methods.dart';
import 'package:url_launcher/url_launcher.dart';

String formatDoubleWithCommas(double value, {removeZeros = true}) {
  final format = NumberFormat("#,##,##0.00", "en_IN");
  String formattedValue = removeZeros ? format.format(value).replaceFirst('.00', '') : format.format(value);

  return formattedValue;
}

String formatDateTime(String dateTimeStr){

  // Time and Date Ago
  String timeAgo = timePassed(DateTime.parse(dateTimeStr), full: false);

  // Direct Date Code
  // DateTime dateTime = DateTime.parse(dateTimeStr);
  // String formattedDateTime = DateFormat.jm().add_yMMMd().format(dateTime);

  return timeAgo;
}

Future<void> launchDeveloperURL(BuildContext context) async {
  final Uri uri = Uri(scheme: "https", host: "linktr.ee", path: "/jayeshpatil.dev");
  if(!await launchUrl(
    uri,
    mode: LaunchMode.externalApplication,
  )) {
    mySnackBarShow(context, 'Unable to show info.');
  }
}