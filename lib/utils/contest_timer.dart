import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ContestTimer {
  final String startTime;
  final String endTime;
  late DateTime parsedStartTime;
  late DateTime parsedEndTime;
  Timer? _timer;
  ValueNotifier<String> statusNotifier = ValueNotifier<String>('');
  ValueNotifier<String> timeLeftNotifier = ValueNotifier<String>('');
  ValueNotifier<String> currentTimeNotifier = ValueNotifier<String>('');

  ContestTimer({
    required this.startTime,
    required this.endTime,
  }) {
    parsedStartTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(startTime, true).toLocal();
    parsedEndTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(endTime, true).toLocal();
    _startTimer();
  }

  void _startTimer() {
    _updateTime();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _updateTime();
      currentTimeNotifier.value = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    });
  }

  void _updateTime() {
    final now = DateTime.now().toUtc().add(Duration(hours: 5, minutes: 30)); // Get the current time in IST
    final isUpcoming = now.isBefore(parsedStartTime);
    final isOngoing = now.isAfter(parsedStartTime) && now.isBefore(parsedEndTime);

    if (isUpcoming) {
      statusNotifier.value = 'Upcoming';
      timeLeftNotifier.value = _getTimeDifference(now, parsedStartTime);
    } else if (isOngoing) {
      statusNotifier.value = 'Ongoing';
      timeLeftNotifier.value = _getTimeDifference(now, parsedEndTime);
    } else {
      statusNotifier.value = 'Completed';
      timeLeftNotifier.value = 'Ended';
      _timer?.cancel();
    }
  }

  String _getTimeDifference(DateTime now, DateTime futureDate) {
    final duration = futureDate.difference(now);
    if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes % 60}m ${duration.inSeconds % 60}s';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m ${duration.inSeconds % 60}s';
    } else {
      return '${duration.inSeconds}s';
    }
  }

  void dispose() {
    _timer?.cancel();
    statusNotifier.dispose();
    timeLeftNotifier.dispose();
    currentTimeNotifier.dispose();
  }
}
