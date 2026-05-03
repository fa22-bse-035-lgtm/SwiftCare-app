import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:swiftcare/models/appointment_model.dart';
import 'package:swiftcare/models/doctor_model.dart';
import 'package:swiftcare/models/patient_model.dart';
import 'package:swiftcare/models/review_model.dart';
import 'package:swiftcare/models/shift_model.dart';
import 'package:swiftcare/services/helper_functions.dart';
import 'package:swiftcare/services/shared_resource.dart';
import 'package:swiftcare/utils/app_config.dart';

class ApiService {
  // ---------------- SINGLETON ----------------
  ApiService._internal();
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  // ---------------- BACKEND LINK ----------------
  static final String baseUrl = AppConfig.baseUrl;

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
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    http.Response response;
    try {
      response = await _sendRequest(url, method, headers, body);

      // Handle 401 Unauthorized - Refresh once
      if (requiresAuth && response.statusCode == 401) {
        final bool refreshed = await _refreshToken();
        if (refreshed) {
          final newToken = await SharedResources().getAccessToken();
          if (newToken != null) {
            headers['Authorization'] = 'Bearer $newToken';
            response = await _sendRequest(url, method, headers, body);
          }
        } else {
          // If refresh fails, clear resources (log out)
          await SharedResources().clear();
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
      case 'PATCH':
        return await http.patch(url, headers: headers, body: bodyStr);
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
      // Playbook: POST /auth/refresh - Token from header or cookie
      final res = await http.post(
        Uri.parse('$baseUrl/auth/refresh'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $refreshToken', // Playbook header option
        },
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data['accessToken'] != null) {
          await SharedResources().saveAccessToken(data['accessToken']);
          if (data['refreshToken'] != null) {
            await SharedResources().saveRefreshToken(data['refreshToken']);
          }
          return true;
        }
      }
    } catch (_) {}
    return false;
  }

  // ---------------- STANDARDIZED ERROR PARSER ----------------
  String getErrorMessage(http.Response response) {
    try {
      final data = jsonDecode(response.body);
      return data['error'] ?? data['message'] ?? 'An unknown error occurred (Status: ${response.statusCode})';
    } catch (_) {
      return 'Server error (Status: ${response.statusCode})';
    }
  }

  // ---------------- CORE DATA SYNC ----------------
  Future<void> getDataFromApi() async {
    // All these are protected in BACKEND_MAP.md
    final res = await request('/patients', requiresAuth: true);
    if (res.statusCode == 200) {
      final List<dynamic> data = json.decode(res.body);
      SharedResources.patients.value = data.map((json) => Patient.fromJson(json)).toList();
    }

    final res2 = await request('/doctors', requiresAuth: false); // Doctors are public
    if (res2.statusCode == 200) {
      final List<dynamic> data = json.decode(res2.body);
      SharedResources.doctors.value = data.map((json) => Doctor.fromJson(json)).toList();
    }

    final res3 = await request('/appointments', requiresAuth: true);
    if (res3.statusCode == 200) {
      // Playbook: paginated response for /appointments
      final Map<String, dynamic> data = json.decode(res3.body);
      final List<dynamic> items = data['items'] ?? [];
      SharedResources.appointments.value = items.map((json) => Appointment.fromJson(json)).toList();
    }

    final res4 = await request('/reviews', requiresAuth: false); // Reviews are public
    if (res4.statusCode == 200) {
      // Playbook: paginated response for /reviews
      final Map<String, dynamic> data = json.decode(res4.body);
      final List<dynamic> items = data['items'] ?? [];
      SharedResources.reviews.value = items.map((json) => Review.fromJson(json)).toList();
    }

    final res5 = await request('/shifts', requiresAuth: true);
    if (res5.statusCode == 200) {
      final dynamic data = json.decode(res5.body);
      final List<dynamic> items = data is List
          ? data
          : (data is Map<String, dynamic> ? (data['items'] ?? []) : []);
      SharedResources.shifts.value = items.map((json) => Shift.fromJson(json)).toList();
    }

    HelperFunctions().getFavoriteDoctors();
  }

  Future<dynamic> getUserData() async {
    final userData = SharedResources.userData;
    if (userData.value.isEmpty) {
      // Playbook: POST /api/user/profile requires no body (identity from JWT)
      final res = await request('/api/user/profile', method: 'POST', body: null, requiresAuth: true);

      if (res.statusCode != 200) {
        throw Exception(getErrorMessage(res));
      }
      SharedResources.userData.value = jsonDecode(res.body);
    }
    return userData.value;
  }

  Future<Map<String, dynamic>> updatePatientProfile({
    required String name,
    required String phone,
    required String locationLabel,
    required List<double> coordinates,
    required String age,
    required String gender,
  }) async {
    String patientId = SharedResources.userData.value["_id"];
    
    final body = {
      "name": name,
      "phone": phone,
      "age": age,
      "gender": gender,
      "location": {
        "label": locationLabel,
        "geo": {
          "type": "Point",
          "coordinates": coordinates,
        }
      },
    };

    // Playbook: PUT /patients/:id is self/admin authorized
    final response = await request('/patients/$patientId', method: 'PUT', body: body, requiresAuth: true);
    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      SharedResources.userData.value = data;
      // Sync local list
      final current = List<Patient>.from(SharedResources.patients.value);
      final index = current.indexWhere((p) => p.id == patientId);
      if (index != -1) {
        current[index] = Patient.fromJson(data);
        SharedResources.patients.value = current;
      }
      return data;
    } else {
      throw Exception(getErrorMessage(response));
    }
  }

  Future<void> toggleFavorite(String patientID, String doctorID) async {
    final res = await request('/api/user/toggle-favorite', method: 'POST', body: {
      'patientId': patientID,
      'doctorId': doctorID
    }, requiresAuth: true);
    
    if (res.statusCode != 200) {
      throw Exception(getErrorMessage(res));
    }
    await getDataFromApi();
  }

  Future<bool> createAppointment(Map<String, dynamic> appointment) async {
    try {
      final response = await request('/appointments', method: 'POST', body: appointment, requiresAuth: true);
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  Future<List<Shift>> getDoctorShifts(String doctorId) async {
    final res = await request('/appointments/doctor/$doctorId', requiresAuth: true);
    if (res.statusCode == 200) {
      final dynamic data = json.decode(res.body);
      final List<dynamic> items = data is List
          ? data
          : (data is Map<String, dynamic> ? (data['items'] ?? data['shifts'] ?? []) : []);
      return items
          .whereType<Map<String, dynamic>>()
          .map(Shift.fromJson)
          .toList();
    }
    return [];
  }

  Future<List<String>> getAvailableSlots({
    required String doctorId,
    required String date,
    required String shiftId,
  }) async {
    final query =
        '/appointments/available-slots?doctorId=$doctorId&date=$date&shiftId=$shiftId';
    final res = await request(query, requiresAuth: true);
    if (res.statusCode == 200) {
      final dynamic data = json.decode(res.body);
      final List<dynamic> slots = data is List
          ? data
          : (data is Map<String, dynamic>
              ? (data['freeSlots'] ?? data['slots'] ?? [])
              : []);
      return slots.map((e) => e.toString()).toList();
    }
    return [];
  }

  Future<bool> addReview(Map<String, dynamic> review) async {
    try {
      final response = await request('/reviews', method: 'POST', body: review, requiresAuth: false);
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }
}
