import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UpiLauncher extends StatefulWidget {
  final int amount;

  const UpiLauncher({super.key, required this.amount});

  @override
  _UpiLauncherState createState() => _UpiLauncherState();
}

class _UpiLauncherState extends State<UpiLauncher> {

  // Method to launch UPI URL
  Future<void> _launchUpiUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to launch UPI app.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('UPI Payment')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Construct Paytm UPI payment URL with customized details
                String upiUrl =
                    'paytmmp://pay?pa=sudhanshumitkari@oksbi&pn=Profit11&tn=Test%20UPI&am=${widget.amount}&cu=INR&mc=1234&tr=01234';
                _launchUpiUrl(upiUrl);
              },
              child: const Text('Pay via UPI (Paytm)'),
            ),
            const SizedBox(height: 20), // Add spacing
            ElevatedButton(
              onPressed: () {
                // Construct Paytm UPI mandate URL with customized details
                String mandateUrl =
                    'paytmmp://pay?pa=sudhanshumitkari@oksbi&pn=Profit11&am=${widget.amount}&cu=INR';
                _launchUpiUrl(mandateUrl);
              },
              child: const Text('Create UPI Mandate (Paytm)'),
            ),
          ],
        ),
      ),
    );
  }
}
