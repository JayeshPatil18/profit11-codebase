import 'dart:async';

import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Timer to auto-change pages every second
  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Stack(
          children: [
            // Background image
            Container(
              height: double.infinity,
              width: double.infinity,
              child: Image.asset(
                'assets/images/background.png',
                fit: BoxFit.cover, // Ensures the image covers the entire screen
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 80),
                  // Logo
                  Container(
                      width: 180,
                      child: Image.asset('assets/logo/name.png', color: Colors.white)),
                  const SizedBox(height: 60),
                  // PageView for changing content
                  SizedBox(
                    height: 340,
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (int page) {
                        setState(() {
                          _currentPage = page;
                        });
                      },
                      children: [
                        // Page 1
                        Container(
                          margin: EdgeInsets.only(left: 30, right: 30),
                          padding: EdgeInsets.only(bottom: 10, left: 20, right: 20),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.8)
                            )
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/welcome1.png',
                                height: 150,
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Portfolio Challenge League',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Welcome to Profit11, where you can trade virtually, learn about the stock market, and win real cash prizes!',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 30, right: 30),
                          padding: EdgeInsets.only(bottom: 10, left: 20, right: 20),
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: Colors.grey.withOpacity(0.8)
                              )
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/welcome2.png',
                                height: 150,
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Create Portfolios and Win',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Create your own virtual portfolios, participate in exciting contests, and stand a chance to win real cash prizes on Profit11!',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 30, right: 30),
                          padding: EdgeInsets.only(bottom: 10, left: 20, right: 20),
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: Colors.grey.withOpacity(0.8)
                              )
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/welcome3.png',
                                height: 150,
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Less risk, High Rewards',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Create your virtual portfolios with less risk and high rewards, and compete to win real cash prizes on Profit11!',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Dots indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      3,
                          (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? Colors.white
                              : Colors.white24,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 80),
                  // Next button
                  Container(
                    width: double.infinity, // Adjust width
                    height: 40, // Adjust height
                    margin: EdgeInsets.only(left: 60, right: 60),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue, Colors.indigo], // Gradient colors
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(25), // Rounded edges
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2), // Shadow color
                          blurRadius: 4,
                          offset: Offset(2, 2), // Shadow position
                        ),
                      ],
                    ),
                    child: TextButton(
                      onPressed: () {
                        if(_currentPage == 2) {
                          Navigator.pushNamed(context, 'signin');
                        }
                        // Change to the next page on button press
                        if (_currentPage < 2) {
                          _currentPage++;
                        } else {
                          _currentPage = 0; // Reset to first page
                        }
                        _pageController.animateToPage(
                          _currentPage,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          _currentPage == 2 ? 'Get Stared' : 'Next',
                          style: TextStyle(
                            color: Colors.white, // Text color
                            fontSize: 18, // Font size
                            fontWeight: FontWeight.bold, // Font weight
                            shadows: [
                              Shadow(
                                blurRadius: 2,
                                color: Colors.black.withOpacity(0.3), // Text shadow
                                offset: Offset(1, 1),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}