import 'package:dalalstreetfantasy/constants/color.dart';
import 'package:dalalstreetfantasy/features/contests/presentation/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/repository/payment_details.dart';

class AddBankDetailsPage extends StatefulWidget {
  @override
  _AddBankDetailsPageState createState() => _AddBankDetailsPageState();
}

class _AddBankDetailsPageState extends State<AddBankDetailsPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for the input fields
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _accountNumberController = TextEditingController();
  final TextEditingController _ifscCodeController = TextEditingController();

  bool _isLoading = false;

  // Method to add bank details to Firestore
  Future<void> _addBankDetails() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final addPaymentMethod = AddPaymentMethod();

        await addPaymentMethod.addPaymentMethod(
          type: 'bank_account',
          details: {
            'bankName': _bankNameController.text.trim(),
            'accountNumber': _accountNumberController.text.trim(),
            'ifscCode': _ifscCodeController.text.trim(),
          },
          isDefault: false, // Default to false unless explicitly set
        );

        Future.delayed(Duration(seconds: 2), () {
          // Close the bottom sheet after the delay
          Navigator.pop(context);

          // Show success message and navigate back
          mySnackBarShow(context, 'Bank details added successfully!');
        });
      } catch (e) {
        mySnackBarShow(context, 'Failed to add bank details: $e');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Bank Details'),
        backgroundColor: AppColors.primaryColor30,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _bankNameController,
                decoration: InputDecoration(
                  labelText: 'Bank Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter the bank name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _accountNumberController,
                decoration: InputDecoration(
                  labelText: 'Account Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter the account number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ifscCodeController,
                decoration: InputDecoration(
                  labelText: 'IFSC Code',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter the IFSC code';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: _addBankDetails,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor30,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Add Bank Details',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
