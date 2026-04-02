import 'dart:convert';
import 'package:swiftcare/services/api_service.dart';

class DoctorService {
  
  /// Starts a shift using the shiftId corresponding to the backend Queue API.
  static Future<void> startShift(String shiftId) async {
    final res = await ApiService().request(
      '/queue/start-shift',
      method: 'POST',
      body: {"shiftId": shiftId},
      requiresAuth: true,
    );
    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception(jsonDecode(res.body)['error'] ?? 'Failed to start shift');
    }
  }

  /// Ends a shift.
  static Future<void> endShift(String shiftId) async {
    final res = await ApiService().request(
      '/queue/end-shift',
      method: 'POST',
      body: {"shiftId": shiftId},
      requiresAuth: true,
    );
    if (res.statusCode != 200) {
      throw Exception(jsonDecode(res.body)['error'] ?? 'Failed to end shift');
    }
  }

  /// Calls the next patient in the queue.
  static Future<void> callNext(String shiftId) async {
    final res = await ApiService().request(
      '/queue/next',
      method: 'POST',
      body: {"shiftId": shiftId},
      requiresAuth: true,
    );
    if (res.statusCode != 200) {
      throw Exception(jsonDecode(res.body)['error'] ?? 'Failed to call next patient');
    }
  }

  /// Completes a consultation (updates appointment status).
  static Future<void> completeConsultation(String appointmentId, {String? notes}) async {
    final body = {
      "status": "Completed",
      if (notes != null) "consultationNotes": notes,
    };
    
    final res = await ApiService().request(
      '/appointments/$appointmentId/status',
      method: 'PUT',
      body: body,
      requiresAuth: true,
    );
    
    if (res.statusCode != 200) {
      throw Exception(jsonDecode(res.body)['error'] ?? 'Failed to complete consultation');
    }
  }
}