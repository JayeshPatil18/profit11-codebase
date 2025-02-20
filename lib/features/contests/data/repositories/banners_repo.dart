import 'package:cloud_firestore/cloud_firestore.dart';

class BannerData {
  static List<String> bannerList = [];

  static Future<void> fetchBannerData() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('banners')
          .doc('bannerdocs')
          .get();

      if (snapshot.exists) {
        var data = snapshot.data() as Map<String, dynamic>;
        bannerList = List<String>.from(data['bannerlist'] ?? []);
      } else {
        throw Exception('Document not found');
      }
    } catch (e) {
      print('Error fetching banner data: $e');
    }
  }
}
