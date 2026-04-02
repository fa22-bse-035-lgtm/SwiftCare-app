import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:swiftcare/services/helper_functions.dart';
import 'package:swiftcare/services/shared_resource.dart';

class ApiService {
  // ---------------- SINGLETON ----------------
  ApiService._internal();
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  // ---------------- BACKEND LINK ----------------
  // static const String baseUrl = 'https://8df2-2400-adc5-177-d700-4d56-c0c1-8394-d955.ngrok-free.app';
  // static const String baseUrl = 'https://swiftcare.up.railway.app';
  static const String baseUrl = 'http://localhost:3000';

  // ---------------- HTTP INTERCEPTOR ----------------
  Future<http.Response> request(
    String endpoint, {
    String method = 'GET',
    Map<String, dynamic>? body,
    bool requiresAuth = true,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = {'Content-Type': 'application/json'};

    if (requiresAuth) {
      final token = await SharedResources().getAccessToken();
      if (token != null) headers['Authorization'] = 'Bearer $token';
    }

    http.Response response;
    try {
      response = await _sendRequest(url, method, headers, body);

      if (requiresAuth && response.statusCode == 401) {
        // Attempt token refresh
        final bool refreshed = await _refreshToken();
        if (refreshed) {
          final newToken = await SharedResources().getAccessToken();
          if (newToken != null) headers['Authorization'] = 'Bearer $newToken';
          response = await _sendRequest(url, method, headers, body);
        } else {
          await SharedResources().clear();
          // Ideally push to login screen, handled by UI listening to auth state or ValueListenableBuilder
        }
      }
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<http.Response> _sendRequest(
      Uri url, String method, Map<String, String> headers, Map<String, dynamic>? body) async {
    final bodyStr = body != null ? jsonEncode(body) : null;
    switch (method.toUpperCase()) {
      case 'POST':
        return await http.post(url, headers: headers, body: bodyStr);
      case 'PUT':
        return await http.put(url, headers: headers, body: bodyStr);
      case 'DELETE':
        return await http.delete(url, headers: headers, body: bodyStr);
      case 'GET':
      default:
        return await http.get(url, headers: headers);
    }
  }

  Future<bool> _refreshToken() async {
    final refreshToken = await SharedResources().getRefreshToken();
    if (refreshToken == null) return false;

    try {
      final res = await http.post(
        Uri.parse('$baseUrl/auth/refresh'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refreshToken': refreshToken}),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data['accessToken'] != null) {
          await SharedResources().saveAccessToken(data['accessToken']);
          return true;
        }
      }
    } catch (_) {}
    return false;
  }

  // ---------------- FUNCTIONS ----------------
  Future<void> getDataFromApi() async {
    final res = await request('/patients', requiresAuth: false);
    if (res.statusCode == 200) SharedResources.patients.value = json.decode(res.body);

    final res2 = await request('/doctors', requiresAuth: false);
    if (res2.statusCode == 200) SharedResources.doctors.value = json.decode(res2.body);

    final res3 = await request('/appointments', requiresAuth: false);
    if (res3.statusCode == 200) SharedResources.appointments.value = json.decode(res3.body);

    final res4 = await request('/reviews', requiresAuth: false);
    if (res4.statusCode == 200) SharedResources.reviews.value = json.decode(res4.body);

    HelperFunctions().getFavoriteDoctors();
  }

  Future<dynamic> getUserData() async {
    String? userId = await SharedResources().getUserId();
    String? userRole = await SharedResources().getUserRole();
    final userData = SharedResources.userData;

    if (userId == null || userRole == null) {
      throw Exception('User ID or Role not found');
    }
    if (userData.value.isEmpty) {
      final res = await request('/api/user/profile', method: 'POST', body: {
        'userId': userId,
        'role': userRole
      }, requiresAuth: false);

      if (res.statusCode != 200) {
        throw Exception(jsonDecode(res.body)['error'] ?? 'Failed to get user data');
      }
      SharedResources.userData.value = jsonDecode(res.body);
    }
    return userData.value;
  }

  Future<Map<String, dynamic>> updatePatientProfile({
    required String name,
    required String phone,
    required String locationLabel,
    required List<double> coordinates, // [lng, lat]
    required String age,
    required String gender,
  }) async {
    String patientId = SharedResources.userData.value["_id"];
    
    final body = {
      "name": name,
      "phone": phone,
      "age": age,
      "gender": gender,
      "location": {"label": locationLabel, "coordinates": coordinates},
    };

    final response = await request('/patients/$patientId', method: 'PUT', body: body, requiresAuth: false);
    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      SharedResources.userData.value = data;
      final List<dynamic> current = List.from(SharedResources.patients.value);
      final index = current.indexWhere((p) => p["_id"] == patientId);

      if (index != -1) {
        current[index] = data;
        SharedResources.patients.value = current;
      }
      return data;
    } else {
      throw Exception(data["error"] ?? "Failed to update profile");
    }
  }

  Future<void> toggleFavorite(String patientID, String doctorID) async {
    final res = await request('/api/user/toggle-favorite', method: 'POST', body: {
      'patientId': patientID,
      'doctorId': doctorID
    }, requiresAuth: true);
    
    if (res.statusCode != 200) {
      throw Exception(jsonDecode(res.body)['error'] ?? 'Failed to toggle favorite');
    }
    await getDataFromApi();
  }

  Future<bool> createAppointment(Map<String, dynamic> appointment) async {
    try {
      final response = await request('/appointments', method: 'POST', body: appointment, requiresAuth: true);
      if (response.statusCode == 200 || response.statusCode == 201) return true;
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> addReview(Map<String, dynamic> review) async {
    try {
      final response = await request('/reviews', method: 'POST', body: review, requiresAuth: true);
      if (response.statusCode == 200 || response.statusCode == 201) return true;
      return false;
    } catch (e) {
      return false;
    }
  }
}
