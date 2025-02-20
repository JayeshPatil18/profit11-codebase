import 'package:cloud_firestore/cloud_firestore.dart';

class WithdrawRequestService {
  static Future<bool> addWithdrawalRequest({
    required int amount,
    required Map<String, dynamic> paymentDetails,
    required String userId,
  }) async {
    try {
      // Create a unique document ID based on some combination or let Firestore auto-generate
      String documentId = DateTime.now().toIso8601String().replaceAll(":", "-").replaceAll(".", "-");

      final withdrawalRequest = {
        'withdrawalRequestId': documentId,
        'amount': amount,
        'userId': userId,
        'payment': paymentDetails,
        'paymentType': paymentDetails['type'], // e.g., 'upi_id' or 'bank_account'
        'timestamp': DateTime.now().toString(), // Current date and time
      };

      // Store the request as a document in the 'withdraw_requests' collection
      await FirebaseFirestore.instance
          .collection('withdraw_requests')
          .doc(documentId) // Set custom document ID or let Firestore auto-generate
          .set(withdrawalRequest); // Store as a document

      print("Withdrawal request added successfully with ID: $documentId");
      return true; // Return true on success
    } catch (e) {
      print("Failed to add withdrawal request: $e");
      return false; // Return false on failure
    }
  }
}
