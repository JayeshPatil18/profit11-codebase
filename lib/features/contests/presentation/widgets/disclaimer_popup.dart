import 'package:dalalstreetfantasy/features/contests/presentation/widgets/snackbar.dart';
import 'package:flutter/material.dart';

void showDisclaimerDialog(BuildContext context) {
  String errorMessage = ''; // Variable to hold the error message

  showDialog(
    context: context,
    barrierDismissible: false, // Prevent dismissing the dialog without action
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async {
          // Prevent closing the dialog when back button is pressed
          return false;
        },
        child: StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Center(
                child: Text(
                  'Financial Content Disclaimer',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              content: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: 300, // Set a maximum height for the dialog
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Divider(color: Colors.grey.shade300),
                            Text(
                              'The content provided on Profit11 is for informational purposes only and does not constitute financial advice, endorsement, analysis, or recommendations.',
                              style: TextStyle(
                                fontSize: 14,
                                height: 1.5,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Key Points:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 5),
                            _buildBulletPoint(
                              'The content is primarily market-generated and reflects personal opinions of community members.',
                            ),
                            _buildBulletPoint(
                              'We strongly advise users to consult qualified financial advisors before making decisions.',
                            ),
                            _buildBulletPoint(
                              'Profit11 does not guarantee the accuracy, timeliness, or completeness of any information.',
                            ),
                            _buildBulletPoint(
                              'Avoid strategies promising unrealistically high returns or sounding too good to be true.',
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Please ensure any financial decision aligns with your personal financial situation, goals, and risk tolerance. Profit11 is not liable for any losses or damages arising from user actions.',
                              style: TextStyle(
                                fontSize: 14,
                                height: 1.5,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'For more details, please read our Content Policy and Terms of Use.',
                              style: TextStyle(
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                                color: Colors.blueAccent,
                              ),
                            ),
                            if (errorMessage.isNotEmpty) ...[
                              SizedBox(height: 10),
                              Text(
                                errorMessage,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],

                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, 'privacy');
                          },
                          child: Text(
                            'Privacy Policies',
                            style: TextStyle(
                              fontSize: 9,
                              decoration: TextDecoration.underline,
                              color: Colors
                                  .blue, // Optional: For emphasis
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, 'terms');
                          },
                          child: Text(
                            'Terms & Conditions',
                            style: TextStyle(
                              fontSize: 9,
                              decoration: TextDecoration.underline,
                              color: Colors
                                  .blue, // Optional: For emphasis
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, 'refund');
                          },
                          child: Text(
                            'Refund Policy',
                            style: TextStyle(
                              fontSize: 9,
                              decoration: TextDecoration.underline,
                              color: Colors
                                  .blue, // Optional: For emphasis
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                // TextButton(
                //   onPressed: () {
                //     setState(() {
                //       errorMessage = 'You must accept the disclaimer to proceed.';
                //     });
                //   },
                //   child: Text(
                //     'Decline',
                //     style: TextStyle(color: Colors.red),
                //   ),
                // ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Perform action if accepted
                    mySnackBarShow(context, 'Welcome to Profit11!');
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green, // Button color
                  ),
                  child: Text('Accept'),
                ),
              ],
            );
          },
        ),
      );
    },
  );
}

// Helper method for bullet points
Widget _buildBulletPoint(String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 3.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('• ', style: TextStyle(fontSize: 14, color: Colors.black87)),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 14, height: 1.5, color: Colors.black87),
          ),
        ),
      ],
    ),
  );
}
