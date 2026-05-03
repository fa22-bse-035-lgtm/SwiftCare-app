import 'package:swiftcare/models/doctor_model.dart';
import 'package:swiftcare/models/patient_model.dart';
import 'package:swiftcare/models/review_model.dart';
import 'package:swiftcare/services/shared_resource.dart';

class HelperFunctions {
  // ---------------- SINGLETON ----------------
  HelperFunctions._internal();
  static final HelperFunctions _instance = HelperFunctions._internal();
  factory HelperFunctions() => _instance;

  Future<List<Review>> getdoctorReviews(String id) async {
    List<Review> reviews = SharedResources.reviews.value;
    return reviews.where((r) => r.doctorId == id).toList();
  }

  double reviewsNumber(String id) {
    return SharedResources.reviews.value.where((r) => r.doctorId == id).length.toDouble();
  }

  double calculateRating(String id) {
    List<Review> docReviews = SharedResources.reviews.value.where((r) => r.doctorId == id).toList();
    if (docReviews.isEmpty) return 0.0;

    double total = docReviews.fold(0.0, (sum, r) => sum + r.rating);
    return total / docReviews.length;
  }

  void getFavoriteDoctors() {
    final String? patientId = SharedResources.userData.value['_id'];
    if (patientId == null) return;

    // Find the patient in the typed list
    final List<Patient> patients = SharedResources.patients.value;
    Patient? patient;
    try {
      patient = patients.firstWhere((p) => p.id == patientId);
    } catch (_) {
      // If not in the list, maybe it's just the current user
      // For now, if we can't find it in the list, we don't update favorites
      return;
    }

    SharedResources.favorites.value = List<String>.from(patient.favorites);
  }

  Doctor? getDoctorById(String doctorId) {
    try {
      return SharedResources.doctors.value.firstWhere((doc) => doc.id == doctorId);
    } catch (e) {
      print("Doctor not found: $doctorId");
      return null;
    }
  }
}
