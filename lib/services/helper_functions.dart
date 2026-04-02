import 'package:swiftcare/services/shared_resource.dart';

class HelperFunctions {
  // ---------------- SINGLETON ----------------
  HelperFunctions._internal();
  static final HelperFunctions _instance = HelperFunctions._internal();
  factory HelperFunctions() => _instance;

  Future<List<dynamic>> getdoctorReviews(String id) async {
    List<dynamic> reviews = SharedResources.reviews.value;
    List<dynamic> docReviews = [];
    for (var r in reviews) {
      if (r["doctorId"] == id) {
        docReviews.add(r);
      }
    }
    return docReviews;
  }

  double reviewsNumber(String id) {
    List<dynamic> reviews = SharedResources.reviews.value;
    return reviews.where((r) => r["doctorId"] == id).length.toDouble();
  }

  double calculateRating(String id) {
    double total = 0;
    List<dynamic> reviews = SharedResources.reviews.value;

    for (var r in reviews) {
      if (r["doctorId"] == id) {
        // FIX: safely convert string or num to double
        final raw = r["rating"];

        double value;

        if (raw is num) {
          value = raw.toDouble();
        } else if (raw is String) {
          value = double.tryParse(raw) ?? 0.0;
        } else {
          value = 0.0;
        }

        total += value;
      }
    }

    return total;
  }

  void getFavoriteDoctors() {
    final String? patientId = SharedResources.userData.value['_id'];

    final patient = SharedResources.patients.value.firstWhere(
      (p) => p is Map && p['_id'] == patientId,
      orElse: () => SharedResources.userData.value,
    );

    final List<dynamic> favorites = (patient as Map)['favorites'] ?? [];

    SharedResources.favorites.value = favorites
        .map<String>((id) => id.toString())
        .toList();
  }

  Map<String, dynamic> getDoctorById(String doctorId) {
    final doctors = SharedResources.doctors.value;
    Map<String, dynamic> doc = {};
    try {
      return doctors.firstWhere((doc) => doc["_id"].toString() == doctorId);
    } catch (e) {
      print("Doctor not found");
      return doc;
    }
  }
}
