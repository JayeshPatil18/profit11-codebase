import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ImageStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  static List<Map<String, String>> _stockLogos = [];
  static List<Color> _colors = [
    Colors.green, // Stock up
    Colors.red,   // Stock down
    Colors.blue,   // Stable/high-performing
    Colors.orange, // Moderate change
    Colors.purple, // Recovery phase
    Colors.pink,   // High volatility
    Colors.teal,   // Steady growth
    Colors.brown,  // Low-growth
  ];

  static List<Map<String, String>> get stockLogos => _stockLogos;
  static List<Color> get colors => _colors;

  Future<void> fetchAllImages(String folderPath) async {
    try {
      final ListResult result = await _storage.ref(folderPath).listAll();
      _stockLogos.clear();
      for (var ref in result.items) {
        final String symbol = ref.name.split('.').first.toUpperCase();
        final String url = await ref.getDownloadURL();
        _stockLogos.add({
          "symbol": symbol,
          "url": url,
        });
      }
    } catch (e) {
      print("Error fetching images: $e");
    }
  }

  static String getUrlForSymbol(String symbol) {
    final Map<String, String> stockLogo = _stockLogos.firstWhere(
          (item) => item['symbol'] == symbol,
      orElse: () => <String, String>{}, // Return an empty map instead of null
    );
    return stockLogo['url'] ?? ''; // Return an empty string if the URL is null
  }


}