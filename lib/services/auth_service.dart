import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:swiftcare/services/api_service.dart';
import 'package:swiftcare/services/shared_resource.dart';

class AuthService {
  AuthService._internal();
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;

  static const String baseUrl = ApiService.baseUrl;

  // ---------------- SIMPLE LOGIN ----------------
  Future<void> signIn(String email, String password) async {
    final res = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (res.statusCode != 200) {
      throw Exception(jsonDecode(res.body)['error'] ?? 'Login failed');
    }

    final data = jsonDecode(res.body);
    await SharedResources().saveAuthData(
      userId: data['userId'],
      userRole: data['role'],
      accessToken: data['accessToken'],
      refreshToken: data['refreshToken'],
    );

    await ApiService().getUserData();
    await ApiService().getDataFromApi();
  }

  // ---------------- PATIENT SIGNUP ----------------
  Future<void> signUp(String email, String password) async {
    final res = await http.post(
      Uri.parse('$baseUrl/auth/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'roleHint': 'patient',
        'email': email,
        'password': password,
      }),
    );

    if (res.statusCode != 201 && res.statusCode != 200) {
      throw Exception('Failed to sign up');
    }

    final patient = jsonDecode(res.body);
    print(patient);
    await SharedResources().saveAuthData(
      userId: patient['userId'],
      userRole: 'patient',
      accessToken: patient['accessToken'],
      refreshToken: patient['refreshToken'],
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

      final res = await http.post(
        Uri.parse('$baseUrl/auth/google'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'idToken': idToken, 'roleHint': 'patient'}),
      );

      if (res.statusCode != 200) {
        throw Exception(jsonDecode(res.body)['error'] ?? 'Google login failed');
      }
      await ApiService().getUserData();
      await ApiService().getDataFromApi();
    } catch (e) {
      throw Exception('Google login failed: $e');
    }
  }

  Future<void> signOut() async {
    SharedResources().clear();
  }
}
