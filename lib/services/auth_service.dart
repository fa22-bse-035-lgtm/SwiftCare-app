import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:swiftcare/services/api_service.dart';
import 'package:swiftcare/services/shared_resource.dart';

class AuthService {
  AuthService._internal();
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;

  // ---------------- SIMPLE LOGIN ----------------
  Future<void> signIn(String email, String password) async {
    final res = await ApiService().request(
      '/auth/login',
      method: 'POST',
      body: {'email': email, 'password': password},
      requiresAuth: false,
    );

    if (res.statusCode != 200) {
      throw Exception(ApiService().getErrorMessage(res));
    }

    final data = jsonDecode(res.body);
    await SharedResources().saveAuthData(
      userId: data['userId']?.toString() ?? '',
      userRole: data['role']?.toString() ?? 'patient',
      accessToken: data['accessToken']?.toString() ?? '',
      refreshToken: data['refreshToken']?.toString() ?? '',
    );

    await ApiService().getUserData();
    await ApiService().getDataFromApi();
  }

  // ---------------- PATIENT SIGNUP ----------------
  Future<void> signUp(String email, String password) async {
    final res = await ApiService().request(
      '/auth/signup',
      method: 'POST',
      body: {
        'roleHint': 'patient',
        'email': email,
        'password': password,
      },
      requiresAuth: false,
    );

    if (res.statusCode != 201 && res.statusCode != 200) {
      throw Exception(ApiService().getErrorMessage(res));
    }

    final data = jsonDecode(res.body);
    await SharedResources().saveAuthData(
      userId: data['userId']?.toString() ?? '',
      userRole: data['role']?.toString() ?? 'patient',
      accessToken: data['accessToken']?.toString() ?? '',
      refreshToken: data['refreshToken']?.toString() ?? '',
    );
    await ApiService().getUserData();
    await ApiService().getDataFromApi();
  }

  // ---------------- GOOGLE LOGIN ----------------
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  bool _googleInitialized = false;

  Future<void> _initGoogle() async {
    if (_googleInitialized) return;

    await _googleSignIn.initialize(
      clientId:
          '911635912176-1mmkg505cf2pr2c68scrc2ogkh62kgv8.apps.googleusercontent.com',
      serverClientId:
          '911635912176-t8efg19lbiutmekenbod4m270bog3ni2.apps.googleusercontent.com',
    );

    _googleInitialized = true;
  }

  Future<void> signInWithGoogle() async {
    await _initGoogle();

    try {
      final GoogleSignInAccount account = await _googleSignIn.authenticate();
      final idToken = account.authentication.idToken;

      if (idToken == null) {
        throw Exception('Google ID token missing');
      }

      final res = await ApiService().request(
        '/auth/google',
        method: 'POST',
        body: {'idToken': idToken, 'roleHint': 'patient'},
        requiresAuth: false,
      );

      if (res.statusCode != 200) {
        throw Exception(ApiService().getErrorMessage(res));
      }
      
      final data = jsonDecode(res.body);
      await SharedResources().saveAuthData(
        userId: data['userId']?.toString() ?? '',
        userRole: data['role']?.toString() ?? 'patient',
        accessToken: data['accessToken']?.toString() ?? '',
        refreshToken: data['refreshToken']?.toString() ?? '',
      );

      await ApiService().getUserData();
      await ApiService().getDataFromApi();
    } catch (e) {
      throw Exception('Google login failed: $e');
    }
  }

  Future<void> signOut() async {
    await SharedResources().clear();
  }
}
