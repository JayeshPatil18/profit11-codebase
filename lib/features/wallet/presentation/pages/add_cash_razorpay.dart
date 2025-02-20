import 'package:dalalstreetfantasy/constants/color.dart';
import 'package:dalalstreetfantasy/features/contests/presentation/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../../../constants/values.dart';
import '../../../../utils/method1.dart';
import '../../domain/repository/razorpay_services.dart';

class AddCashRazorpay extends StatefulWidget {
  final double walletBalance;

  const AddCashRazorpay({super.key, required this.walletBalance});

  @override
  _AddCashRazorpayState createState() => _AddCashRazorpayState();
}

class _AddCashRazorpayState extends State<AddCashRazorpay> {
  int amount = 0;
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    mySnackBarShow(context, 'Payment Successful');
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    mySnackBarShow(context, 'Error: ${response.message}');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    mySnackBarShow(context, 'External Wallet: ${response.walletName}');
  }

  @override
  void dispose() {
    super.dispose();

    try{
      _razorpay.clear(); // Removes all listeners
    }catch(e){
      print(e);
    }
  }

  TextEditingController amountController = TextEditingController(text: "₹50");

  // Method to update amount value and ensure rupee symbol is added
  void updateAmount({int? addAmount}) {
    String currentText = amountController.text.replaceAll("₹", "");
    int currentAmount = int.tryParse(currentText) ?? 0;

    if (addAmount != null) {
      // Add specified amount to the current amount
      currentAmount += addAmount;
    }

    setState(() {
      // Update the controller with the rupee symbol prefixed
      amountController.value = TextEditingValue(
        text: "₹$currentAmount",
        selection: TextSelection.collapsed(offset: "₹$currentAmount".length),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor30,
        title: Text("Add Cash"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  "Current balance",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  "₹${formatDoubleWithCommas(widget.walletBalance)}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),

          // TextField to show and update the amount with rupee symbol
          TextField(
            controller: amountController,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
            onChanged: (value) {
              updateAmount(); // Ensure rupee symbol is prefixed on change
            },
          ),
          Text(
            "ADD CASH",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
          SizedBox(height: 20),

          // Buttons for adding fixed amounts
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildAmountButton(100),
              SizedBox(width: 10),
              _buildAmountButton(200),
              SizedBox(width: 10),
              _buildAmountButton(300),
            ],
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: FloatingActionButton.extended(
                onPressed: () async {
                  amount = int.parse(amountController.text.trim().substring(1));
                  if (amount != 0) {
                    RazorpayService razorpayService = RazorpayService();
                    String? orderId =
                    await razorpayService.createOrder(amount); // Amount in INR
                    if (orderId != null) {
                      print(
                          'Order created successfully with Order ID: $orderId');

                      var options = {
                        'key': razorPaykeyId,
                        'amount': amount * 100,
                        'currency': 'INR',
                        'name': 'Profit11 Private Limited',
                        'description': 'Adding Amount to Account',
                        'order_id': orderId,
                        'prefill': {
                          'contact': '9000090000',
                          'email': 'razorpay@example.com',
                        },
                        'theme': {
                          'color': '#020A24',
                        },
                      };

                      try {
                        _razorpay.open(options);
                      } catch (e) {
                        debugPrint('Error: $e');
                      }
                    } else {
                      mySnackBarShow(context, 'Enter Cash Amount');
                    }
                  }
                },
                label: Text(
                  amountController.text == "₹0" || amountController.text == "₹"
                      ? 'Add Cash'
                      : 'Proceed with ${amountController.text}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16, // Font size according to the image
                    fontWeight:
                    FontWeight.w600, // Font weight according to the image
                  ),
                ),
                backgroundColor: amountController.text == "₹0"
                    ? Colors.grey.shade600
                    : AppColors.primaryColor30,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget for the amount buttons
  Widget _buildAmountButton(int amount) {
    return ElevatedButton(
      onPressed: () => updateAmount(addAmount: amount),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: AppColors.primaryColor30),
        ),
        primary: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      child: Text(
        "₹$amount +",
        style: TextStyle(
            color: AppColors.primaryColor30,
            fontSize: 16,
            fontWeight: FontWeight.w500),
      ),
    );
  }
}
