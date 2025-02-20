import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../main.dart';
import '../models/upload_portfolio.dart';

class PortfolioService {
  final FirebaseFirestore _firestore;

  PortfolioService(this._firestore);

  // Helper method to update user's joinedContests array
  Future<void> _updateUserJoinedContests(UploadPortfolio uploadPortfolio, String portfolioId) async {
    try {
      // Construct the contest entry
      final contestEntry = {
        'leagueId': uploadPortfolio.leagueId,
        'id': portfolioId,
        'rank': 0, // Placeholder rank until updated (this can be updated later)
        'prize': 0, // Placeholder prize until updated
        'returns': uploadPortfolio.initialPortfolioValue, // Assuming initial value
        'isPrizeCollected': false, // Default prize collection status
      };

      // Update the user's document to include this contest in their joinedContests array
      await _firestore.collection('users').doc(MyApp.loggedInUserId).update({
        'joinedContests': FieldValue.arrayUnion([contestEntry]),
      });

      print('User joinedContests updated successfully.');
    } catch (error) {
      print('Error updating joinedContests: $error');
      throw Exception('Failed to update joinedContests');
    }
  }
}
