import 'package:dalalstreetfantasy/main.dart';
import 'package:flutter/material.dart';

import '../../../../constants/color.dart';
import '../../../../utils/method1.dart';
import '../../../contests/presentation/widgets/snackbar.dart';
import '../../domain/repository/payment_details.dart';
import '../../domain/repository/withdraw_request_services.dart';

class WithdrawCashPage extends StatefulWidget {
  final double walletBalance;


  const WithdrawCashPage({super.key, required this.walletBalance});

  @override
  _WithdrawCashPageState createState() => _WithdrawCashPageState();
}

class _WithdrawCashPageState extends State<WithdrawCashPage> {
  int amount = 0;
  TextEditingController amountController = TextEditingController(text: "50");
  bool showAllPaymentDetails = false;

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
        text: "$currentAmount",
        selection: TextSelection.collapsed(offset: "$currentAmount".length),
      );
    });
  }

  String? selectedMethod;
  Map<String, dynamic>? selectedPaymentDetails;
  TextEditingController upiController = TextEditingController();

  // Fetch payment details method
  Future<List<Map<String, dynamic>>> fetchPaymentDetails() async {
    AddPaymentMethod addPaymentMethod = AddPaymentMethod();
    try {
      // Fetch payment details from the repository
      final paymentDetails = await addPaymentMethod.getPaymentDetails(MyApp.loggedInUserId);

      return paymentDetails;
    } catch (e) {
      print('Error fetching payment details: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor30,
        title: Text("Widthdraw"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 100),
        child: Column(
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
                  child: Row(
                    children: [
                      Container(
                          height: 21,
                          width: 21,
                          child: Image.asset('assets/icons/coin.png')),
                      SizedBox(width: 4),
                      Text(
                        "${formatDoubleWithCommas(widget.walletBalance)}",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 40),

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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    height: 21,
                    width: 21,
                    child: Image.asset('assets/icons/coin.png')),
                SizedBox(width: 6),
                Text(
                  "REDEEM",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Use FutureBuilder to fetch payment details
                  FutureBuilder<List<Map<String, dynamic>>>(
                    future: fetchPaymentDetails(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                            margin: EdgeInsets.only(top: 100),
                            child: Center(child: CircularProgressIndicator())); // Show loading while fetching
                      } else if (snapshot.hasError) {
                        return Text('Error fetching payment details');
                      } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {

                        // Display list of payment details
                        List<Map<String, dynamic>> paymentDetails = snapshot.data!;

                        // Determine how many items to show based on the toggle state
                        final displayedDetails = showAllPaymentDetails
                            ? paymentDetails
                            : paymentDetails.take(1).toList();

                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Send winnings to",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                // See More/See Less button
                                if (paymentDetails.length > 1)
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        showAllPaymentDetails =
                                        !showAllPaymentDetails;
                                      });
                                    },
                                    child: Text(
                                      showAllPaymentDetails
                                          ? "See Less"
                                          : "See More",
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey),
                                    ),
                                  ),
                              ],
                            ),
                            Column(
                              children: displayedDetails.map((payment) {
                                if (payment['type'] == 'upi_id') {
                                  // UPI Card
                                  return Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    elevation: 2,
                                    child: ListTile(
                                      leading: Image.asset(
                                        'assets/icons/upi.png',
                                        height: 40,
                                        width: 40,
                                      ),
                                      title: Text(
                                        "UPI",
                                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                                      ),
                                      subtitle: Text(
                                        payment['details'] != null && payment['details']['upi_id'] != null
                                            ? payment['details']['upi_id']
                                            : "No UPI ID",
                                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                                      ),
                                      trailing: Radio<String>(
                                        value: payment['paymentMethodId'],
                                        groupValue: selectedMethod,
                                        onChanged: (value) {
                                          setState(() {
                                            selectedMethod = value;
                                            selectedPaymentDetails = payment;
                                          });
                                        },
                                      ),
                                    ),
                                  );
                                } else if (payment['type'] == 'bank_account') {
                                  // Bank Account Card
                                  return Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    elevation: 2,
                                    child: Container(
                                      padding: EdgeInsets.only(top: 10, bottom: 10),
                                      child: ListTile(
                                        leading: Image.asset(
                                          'assets/icons/bank.png',
                                          height: 30,
                                          width: 30,
                                        ),
                                        title: Text(
                                          "${payment['details']['bankName'] ?? 'No bank name'}",
                                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Account Number: ${payment['details']['accountNumber'] ?? 'No account number'}",
                                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                                            ),
                                            Text(
                                              "IFSC Code: ${payment['details']['ifscCode'] ?? 'No IFSC code'}",
                                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                                            ),
                                          ],
                                        ),
                                        trailing: Radio<String>(
                                          value: payment['paymentMethodId'],
                                          groupValue: selectedMethod,
                                          onChanged: (value) {
                                            setState(() {
                                              selectedMethod = value;
                                              selectedPaymentDetails = payment;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  return SizedBox(); // Handle unexpected types gracefully
                                }
                              }).toList(),
                            ),
                          ],
                        );
                      } else {
                        return SizedBox();
                      }
                    },
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    "Add withdrawal method",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // Add UPI option
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 2,
                    child: ListTile(
                      leading: Image.asset(
                        'assets/icons/upi.png',
                        height: 40,
                        width: 40,
                      ),
                      title: const Text("UPI", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
                      subtitle: const Text("Enter UPI ID for instant transfer", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400)),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        showAddUpiBottomSheet(context);
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Add Bank Account option
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 2,
                    child: ListTile(
                      leading: Image.asset(
                        'assets/icons/bank.png',
                        height: 25,
                        width: 25,
                      ),
                      title: const Text("Bank Account", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
                      subtitle: const Text("Enter bank details for instant transfer", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400)),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.pushNamed(context, 'add_bank_details');
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: FloatingActionButton.extended(
                onPressed: () {
                  amount = int.parse(amountController.text.trim());

                  if (amount < 10) {
                    mySnackBarShow(context, "Amount must be ₹10 or more.");
                    return;
                  }

                  if (selectedPaymentDetails == null ||
                      !(selectedPaymentDetails!['type'] == 'upi_id' || selectedPaymentDetails!['type'] == 'bank_account')) {
                    mySnackBarShow(context, "Please select a valid payment method (UPI or Bank Account).");
                    return;
                  }

                  print("##" + selectedPaymentDetails.toString());

                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true, // Allows the bottom sheet to expand
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                    ),
                    builder: (BuildContext context) {
                      return DraggableScrollableSheet(
                        expand: false,
                        initialChildSize: 0.5,
                        minChildSize: 0.4,
                        maxChildSize: 0.8,
                        builder: (BuildContext context, ScrollController scrollController) {
                          return SingleChildScrollView(
                            controller: scrollController,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Center(
                                    child: Container(
                                      width: 50,
                                      height: 5,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Center(
                                    child: Text(
                                      "Confirm Withdrawal",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Divider(color: Colors.grey[300], thickness: 1),
                                  SizedBox(height: 16),
                                  Text(
                                    "You are about to withdraw:",
                                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "₹$amount",
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green[700],
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    "Using Payment Method:",
                                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                                  ),
                                  SizedBox(height: 8),
                                  Container(
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.grey[300]!),
                                    ),
                                    child: Row(
                                      children: [
                                        selectedPaymentDetails!['type'] == 'upi_id' ? Image.asset('assets/icons/upi.png', width: 30, height: 30) : Image.asset('assets/icons/bank.png', width: 20, height: 20),
                                        SizedBox(width: 15),
                                        Expanded(
                                          child: selectedPaymentDetails!['type'] == 'upi_id' ? Text(
                                            "UPI ID: ${selectedPaymentDetails!['details']['upi_id']}",
                                            style: TextStyle(fontSize: 16),
                                          ) : Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Bank Name: ${selectedPaymentDetails!['details']['bankName'] ?? '-'}",
                                                  style: TextStyle(fontSize: 14),
                                                ),
                                                Text(
                                                  "Account Number: ${selectedPaymentDetails!['details']['accountNumber'] ?? '-'}",
                                                  style: TextStyle(fontSize: 14),
                                                ),
                                                Text(
                                                  "IFSC Code: ${selectedPaymentDetails!['details']['ifscCode'] ?? '-'}",
                                                  style: TextStyle(fontSize: 14),
                                                ),
                                              ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  SizedBox(height: 24),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context), // Close the sheet
                                        child: Text(
                                          "Cancel",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          // Navigator.pop(context); // Close the sheet

                                          // Call the service to add the withdrawal request
                                          bool success = await WithdrawRequestService.addWithdrawalRequest(
                                            amount: amount,
                                            paymentDetails: selectedPaymentDetails!,
                                            userId: MyApp.loggedInUserId, // Replace with actual userId
                                          );

                                          // Show a confirmation message based on success or failure
                                          if (success) {
                                            // mySnackBarShow(context, 'Withdrawal request submitted successfully!');

                                            Navigator.pushNamed(context, 'withdraw_request_sent', arguments: {
                                            'amount': amount
                                            });
                                          } else {
                                            mySnackBarShow(context, 'Failed to submit withdrawal request.');
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.black,
                                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                        ),
                                        child: Text(
                                          "Confirm",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
                label: Text(
                  amountController.text == "0"
                      ? 'Add Cash'
                      : 'Proceed with ${amountController.text}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16, // Font size according to the image
                    fontWeight: FontWeight.w600, // Font weight according to the image
                  ),
                ),
                backgroundColor: amountController.text == "0"
                    ? Colors.grey.shade600
                    : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
  void showAddUpiBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allow the bottom sheet to adapt to content size
      builder: (context) {
        return Container(
          height: 600,
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title of the Bottom Sheet
              Text(
                "Enter UPI ID",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),

              // TextField for UPI ID input
              TextField(
                controller: upiController,
                decoration: InputDecoration(
                  labelText: "UPI ID",
                  border: OutlineInputBorder(),
                  hintText: "example@upi",
                ),
              ),
              SizedBox(height: 20),

              // Save button
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        String upiId = upiController.text.trim();

                        // Basic validation for UPI ID format (you can enhance this)
                        if (upiId.isNotEmpty && upiId.contains('@')) {
                          // Do something with the UPI ID (e.g., save it)

                          final addPaymentMethod = AddPaymentMethod();

                          await addPaymentMethod.addPaymentMethod(
                            type: 'upi_id',
                            details: {
                              'upi_id': upiId,
                            },
                            isDefault: false, // Default to false unless explicitly set
                          );

                          Navigator.pop(context);
                          mySnackBarShow(context, "UPI ID saved successfully!");
                        } else {
                          mySnackBarShow(context, "Please enter a valid UPI ID.");
                        }
                      },
                      child: Text("Save UPI ID"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
