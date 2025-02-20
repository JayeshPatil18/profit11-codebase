import 'dart:async';

import 'package:dalalstreetfantasy/features/contests/presentation/widgets/snackbar.dart';
import 'package:flutter/material.dart';

import '../../../../utils/otp_methods.dart';
import '../../../contests/domain/entities/phone_no_argument.dart';

class OTPResendWidget extends StatefulWidget {
  final String countryCode;
  final String phoneNumber;

  const OTPResendWidget({
    Key? key,
    required this.countryCode,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  _OTPResendWidgetState createState() => _OTPResendWidgetState();
}

class _OTPResendWidgetState extends State<OTPResendWidget> {
  int _secondsRemaining = 30;
  Timer? _timer;
  PhoneAuthManager phoneAuthManager = PhoneAuthManager();

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          _secondsRemaining > 0
              ? "Didn't receive the OTP? Wait $_secondsRemaining seconds"
              : "Didn't receive the OTP?",
          style: TextStyle(color: Colors.black54, fontSize: 14),
          textAlign: TextAlign.center,
        ),
        if (_secondsRemaining == 0)
          TextButton(
            onPressed: () {
              setState(() async {
                _secondsRemaining = 30;
                _startTimer();

                phoneAuthManager.verifyPhoneNumber(context, widget.countryCode, widget.phoneNumber, true);
              });
            },
            child: const Text(
              'Resend',
              style: TextStyle(
                color: Color(0xFF010A23),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }
}
