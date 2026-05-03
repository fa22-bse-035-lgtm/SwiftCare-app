import 'dart:io';
import 'package:flutter/foundation.dart';

class AppConfig {
  /// The base URL for the backend API.
  /// Defaults to localhost:3000 but resolves to platform-correct IP address
  /// for emulators (e.g., 10.0.2.2 for Android).
  static String get baseUrl {
    // Check if a custom environment variable is provided (e.g. --dart-define=API_URL=https://api.example.com)
    return 'http://localhost:3000';
    const envUrl = String.fromEnvironment('API_URL');
    if (envUrl.isNotEmpty) return envUrl;

    if (kIsWeb) {
      return 'https://swiftcare.up.railway.app';
    }

    // Default to localhost, but adjust for emulators
    if (Platform.isAndroid) {
      return 'https://swiftcare.up.railway.app';
    } else {
      // iOS / MacOS / Others
      return 'https://swiftcare.up.railway.app';
    }
  }

  /// Sanitizes an image path to ensure it follows the format for our server.
  static String getImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return '';
    }
    if (imagePath.startsWith('http')) {
      return imagePath;
    }
    // Normalize backslashes (common in some Node.js systems) and join with baseUrl
    return '$baseUrl/${imagePath.replaceAll("\\", "/")}';
  }
}
