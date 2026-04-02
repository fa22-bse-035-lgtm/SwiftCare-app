import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Single Source of Truth for the SwiftCare application.
/// 
/// State Management Pattern:
/// Instead of heavily relying on MultiProvider hierarchies, this application
/// primarily uses static `ValueNotifier` instances. UI components MUST wrap
/// themselves in a `ValueListenableBuilder` listening to these notifiers 
/// to rebuild reactively when data changes.
class SharedResources {
  SharedResources._internal();
  static final SharedResources _instance = SharedResources._internal();
  factory SharedResources() => _instance;

  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  
  /// Global user profile data. UI must use `ValueListenableBuilder` to react.
  static final ValueNotifier<Map<String, dynamic>> userData = ValueNotifier({});

  // ---------------- DATA ----------------
  static final ValueNotifier<List<dynamic>> doctors = ValueNotifier([]);
  static final ValueNotifier<List<dynamic>> patients = ValueNotifier([]);
  static final ValueNotifier<List<String>> favorites = ValueNotifier([]);
  static final ValueNotifier<List<dynamic>> reviews = ValueNotifier([]);
  static final ValueNotifier<List<dynamic>> appointments = ValueNotifier([]);

  // Keys
  static const String _keyUserId = 'userId';
  static const String _keyUserRole = 'userRole';
  static const String _keyAccessToken = 'accessToken';
  static const String _keyRefreshToken = 'refreshToken';

  // ---------------- SAVE ----------------

  Future<void> saveAuthData({
    required String userId,
    required String userRole,
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(key: _keyUserId, value: userId);
    await _storage.write(key: _keyUserRole, value: userRole);
    await _storage.write(key: _keyAccessToken, value: accessToken);
    await _storage.write(key: _keyRefreshToken, value: refreshToken);
  }

  Future<void> saveAccessToken(String token) async {
    await _storage.write(key: _keyAccessToken, value: token);
  }

  // ---------------- READ ----------------

  Future<String?> getUserId() async {
    return await _storage.read(key: _keyUserId);
  }

  Future<String?> getUserRole() async {
    return await _storage.read(key: _keyUserRole);
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: _keyAccessToken);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _keyRefreshToken);
  }

  // ---------------- STATUS ----------------

  Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  // ---------------- CLEAR ----------------

  Future<void> clear() async {
    await _storage.delete(key: _keyUserId);
    await _storage.delete(key: _keyUserRole);
    await _storage.delete(key: _keyAccessToken);
    await _storage.delete(key: _keyRefreshToken);
  }
}