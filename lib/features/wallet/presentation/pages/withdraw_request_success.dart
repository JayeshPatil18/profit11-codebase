import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WithdrawalRequestConfirmationPage extends StatefulWidget {
  final int amount;

  const WithdrawalRequestConfirmationPage({Key? key, required this.amount})
      : super(key: key);

  @override
  State<WithdrawalRequestConfirmationPage> createState() => _WithdrawalRequestConfirmationPageState();
}

class _WithdrawalRequestConfirmationPageState extends State<WithdrawalRequestConfirmationPage> with TickerProviderStateMixin{

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController
    _controller = AnimationController(
      vsync: this,       // Provide TickerProvider
      duration: const Duration(seconds: 3),  // Set duration as per your animation
    );

    // Start the animation automatically and stop it when done
    _controller.forward().whenComplete(() {
      _controller.stop();
    });

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.of(context).pushReplacementNamed('landing');
    });
  }

  @override
  void dispose() {
    _controller.dispose();  // Dispose the controller when not needed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Lottie.asset(
                  'assets/animation/check.json',
                  controller: _controller,
                  width: 110,
                  height: 110,
                  onLoaded: (composition) {
                    // Set the composition on the controller and play the animation
                    _controller.duration = composition.duration;
                    _controller.forward();
                  }),
              SizedBox(height: 40),
              Text('Withdrawal Request Sent!', style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              )),
              SizedBox(height: 10),
              Text('Your withdrawal of ₹${widget.amount} is in process.\nThe amount will be credited to your account soon.', style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey
              ), textAlign: TextAlign.center)
            ],
          ),
        ),
      ),
    );
  }
}
