import 'package:http/http.dart' as http;
import 'package:swiftcare/services/api_service.dart';

class DoctorService {
  static const String baseUrl = ApiService.baseUrl;

  static Future<void> startShift(String doctorId) async {
    await http.post(
      Uri.parse("$baseUrl/api/queue/start-shift/$doctorId"),
    );
  }

  static Future<void> endShift(String doctorId) async {
    await http.post(
      Uri.parse("$baseUrl/api/queue/end-shift/$doctorId"),
    );
  }

  static Future<void> callNext(String doctorId) async {
    await http.post(
      Uri.parse("$baseUrl/api/queue/call-next/$doctorId"),
    );
  }

  static Future<void> completeConsultation(String appointmentId) async {
    await http.post(
      Uri.parse("$baseUrl/api/appointments/complete/$appointmentId"),
    );
  }
}