import 'package:dalalstreetfantasy/constants/color.dart';
import 'package:dalalstreetfantasy/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebCashFreeGateway extends StatefulWidget {
  final int amount;
  final String customerId;
  final String customerName;
  final String customerEmail;
  final String customerPhone;

  const WebCashFreeGateway({
    Key? key,
    required this.amount,
    required this.customerId,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
  }) : super(key: key);

  @override
  _WebCashFreeGatewayState createState() => _WebCashFreeGatewayState();
}

class _WebCashFreeGatewayState extends State<WebCashFreeGateway> {
  late WebViewController controller;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Handle loading progress
          },
          onPageStarted: (String url) {
            // Handle page start
          },
          onPageFinished: (String url) {
            // Handle page finish
          },
          onWebResourceError: (WebResourceError error) {
            // Handle error
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://profit11.in/')) {
              return NavigationDecision.prevent;
            }
            if (request.url.startsWith('intent://') || request.url.contains('external-app')) {
              // Pop the current page when redirecting to another app
              Navigator.pop(context);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(_buildUrlWithQueryParams());

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light, // Light icons
      ),
    );
  }

  Uri _buildUrlWithQueryParams() {
    return Uri.parse("https://www.profit11.in/payment.html?customerId=${widget.customerId}&customerName=${widget.customerName}&customerEmail=${widget.customerEmail}&customerPhone=${widget.customerPhone}&amount=${widget.amount}");
  }

  @override
  void dispose() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark, // Dark icons
      ),
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paymentGatewayColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: WebViewWidget(controller: controller),
            ),
          ],
        ),
      ),
    );
  }
}
