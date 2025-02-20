import 'package:dalalstreetfantasy/main.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddPaymentMethod {
  // Method to add a payment method to Firestore
  Future<void> addPaymentMethod({
    required String type,
    required Map<String, String> details,
    bool isDefault = false,
  }) async {
    try {

      final userId = MyApp.loggedInUserId;

      // Reference to the `payment_details` collection
      final paymentDetailsRef =
      FirebaseFirestore.instance.collection('payment_details');

      // Create a new document ID for the payment method
      final paymentMethodId = paymentDetailsRef.doc().id;

      // Add the payment method to the `payment_details` collection
      await paymentDetailsRef.doc(paymentMethodId).set({
        'paymentMethodId': paymentMethodId, // Include the document ID in the document
        'userId': userId,                  // Reference to the user
        'type': type,                      // Payment type (e.g., UPI, Bank)
        'details': details,                // Payment details (e.g., UPI ID, account details)
        'isDefault': isDefault,            // Default status
        'createdAt': DateTime.now().toString(), // Timestamp for when it was added
      });

      // If the payment method is set as default, update the user's main document
      if (isDefault) {
        final userDocRef =
        FirebaseFirestore.instance.collection('users').doc(userId);

        await userDocRef.update({
          'defaultPaymentMethod': {
            'paymentMethodId': paymentMethodId,
            'type': type,
            'details': details,
          }
        });
      }

      print("Payment method added successfully to `payment_details` collection");
    } catch (e) {
      print("Failed to add payment method: $e");
      throw e;
    }
  }

  Future<List<Map<String, dynamic>>> getPaymentDetails(String userId) async {
    try {
      // Fetch the documents from the payment_details collection where userId matches
      final querySnapshot = await FirebaseFirestore.instance
          .collection('payment_details')
          .where('userId', isEqualTo: userId)
          .get();

      // Convert the query snapshot to a list of maps
      List<Map<String, dynamic>> paymentDetailsList = [];
      for (var doc in querySnapshot.docs) {
        paymentDetailsList.add(doc.data() as Map<String, dynamic>);
      }

      return paymentDetailsList;
    } catch (e) {
      print("Error fetching payment details: $e");
      return [];
    }
  }
}