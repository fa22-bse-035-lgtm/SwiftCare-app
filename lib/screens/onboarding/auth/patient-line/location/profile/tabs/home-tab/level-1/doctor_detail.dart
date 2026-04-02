import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:swiftcare/screens/onboarding/auth/patient-line/location/profile/tabs/home-tab/level-1/add-review/add_review.dart';
import 'package:swiftcare/screens/onboarding/auth/patient-line/location/profile/tabs/home-tab/level-1/level-2/book_appointment.dart';
import 'package:swiftcare/services/helper_functions.dart';
import 'package:swiftcare/widgets/category_bars.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swiftcare/services/colors.dart';
import 'package:flutter/material.dart';
import 'package:swiftcare/widgets/favorite_heart.dart';
import 'package:uicons/uicons.dart';
import 'package:url_launcher/url_launcher.dart';

class DoctorDetails extends StatelessWidget {
  final Map<String, dynamic> doc;

  const DoctorDetails({super.key, required this.doc});

  @override
  Widget build(BuildContext context) {
    Future<List<dynamic>> docReviews = HelperFunctions().getdoctorReviews(
      doc["_id"],
    );
    double lng = doc["location"]["coordinates"][0];
    double lat = doc["location"]["coordinates"][1];

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: SafeArea(
          bottom: false,
          child: Container(
            height: 60,
            color: Colors.white,
            padding: const EdgeInsets.only(
              left: 10,
              right: 15,
              top: 12,
              bottom: 10,
            ),
            child: Row(
              children: [
                // Back button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color.fromARGB(255, 193, 193, 193),
                        width: 1.1,
                      ),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                        size: 20,
                      ),
                      splashRadius: 22,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),

                // Title
                const Expanded(
                  child: Center(
                    child: Text(
                      "Doctor Details",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontSize: 18,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),

                // Favorite Heart
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color.fromARGB(255, 193, 193, 193),
                        width: 1.1,
                      ),
                    ),
                    child: FavoriteHeart(doctorId: doc["_id"]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      body: FutureBuilder(
        future: docReviews,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          List<dynamic> reviews = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),

                // ------------------- PROFILE -------------------
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // PHOTO
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage(doc["image"]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),

                    // NAME + SPECIALIZATION + LOCATION
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            doc["name"],
                            style: GoogleFonts.poppins(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),

                          Text(
                            doc["specialization"],
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.black54,
                            ),
                          ),

                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: AppColors.primaryColor,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  doc["location"] is Map
                                      ? (doc["location"]["label"] ?? "")
                                      : doc["location"].toString(),
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                Divider(color: AppColors.divider),
                const SizedBox(height: 15),

                // ------------------- STATS -------------------
                Row(
                  children: [
                    Expanded(
                      child: CategoryBar(
                        name: doc["patients"].toString(),
                        iconPath: "images/patients.png",
                        subtitle: "Patients",
                      ),
                    ),
                    Expanded(
                      child: CategoryBar(
                        name: doc["experience"].toString(),
                        iconPath: "images/briefcase.png",
                        subtitle: "Years Exp.",
                      ),
                    ),
                    Expanded(
                      child: CategoryBar(
                        name: reviews.isEmpty
                            ? "-"
                            : HelperFunctions()
                                  .calculateRating(doc["_id"])
                                  .toStringAsFixed(1),
                        iconPath: "images/star.png",
                        subtitle: "Rating",
                      ),
                    ),
                    Expanded(
                      child: CategoryBar(
                        name: reviews.length.toString(),
                        iconPath: "images/review.png",
                        subtitle: "Reviews",
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // ------------------- ABOUT -------------------
                Text(
                  "About",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  doc["about"],
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 20),

                // ------------------- WORKING HOURS -------------------
                Text(
                  "Working Hours",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Divider(color: AppColors.divider),
                const SizedBox(height: 6),

                /// Dynamic days & hours
                ..._buildDynamicWorkingHours(),

                const SizedBox(height: 21),

                // ------------------- ADDRESS -------------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Address",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "View on Map",
                      style: GoogleFonts.poppins(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    Icon(
                      UIcons.solidRounded.marker,
                      color: AppColors.primaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: () async {
                        final Uri googleMapUrl = Uri.parse(
                          "https://www.google.com/maps/search/?api=1&query=$lat,$lng",
                        );

                        if (await canLaunchUrl(googleMapUrl)) {
                          await launchUrl(googleMapUrl);
                        }
                      },
                      child: Expanded(
                        child: Text(
                          doc["location"]["label"],
                          style: GoogleFonts.poppins(fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                GestureDetector(
                  onTap: () async {
                    final Uri googleMapUrl = Uri.parse(
                      "https://www.google.com/maps/search/?api=1&query=$lat,$lng",
                    );

                    if (await canLaunchUrl(googleMapUrl)) {
                      await launchUrl(googleMapUrl);
                    }
                  },
                  child: Container(
                    height: 160,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: LatLng(lat, lng),
                          zoom: 15,
                        ),
                        markers: {
                          Marker(
                            markerId: const MarkerId("doctorLocation"),
                            position: LatLng(lat, lng),
                          ),
                        },
                        zoomControlsEnabled: false,
                        zoomGesturesEnabled: false,
                        scrollGesturesEnabled: false,
                        tiltGesturesEnabled: false,
                        rotateGesturesEnabled: false,
                        myLocationButtonEnabled: false,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // ------------------- REVIEWS -------------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Reviews",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddDoctorReview(doctor: doc),
                          ),
                        );
                      },
                      child: Text(
                        "Add review",
                        style: GoogleFonts.poppins(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                /// Build review cards dynamically
                ...reviews.map((r) => _buildReviewCard(r)),
                const SizedBox(height: 80),
              ],
            ),
          );
        },
      ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            minimumSize: const Size(double.infinity, 55),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookAppointment(doc: doc),
              ),
            );
          },
          child: Text(
            "Book Appointment",
            style: GoogleFonts.poppins(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  // =============================================================
  // 1. BUILD DYNAMIC WORKING HOURS
  // =============================================================
  List<Widget> _buildDynamicWorkingHours() {
    List<String> days = List<String>.from(doc["availableDays"]);
    List<String> hours = List<String>.from(doc["availableHours"]);

    List<Widget> widgets = [];

    int count = days.length;

    for (int i = 0; i < count; i++) {
      String day = days[i];
      String hour = (i < hours.length) ? hours[i] : "Not Available";

      widgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(day, style: GoogleFonts.poppins(fontSize: 15)),
              Text(
                hour,
                style: GoogleFonts.poppins(fontSize: 15, color: Colors.black54),
              ),
            ],
          ),
        ),
      );
    }

    return widgets;
  }

  // =============================================================
  // 2. DYNAMIC REVIEW CARD
  // =============================================================
  Widget _buildReviewCard(dynamic r) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey[300],
                radius: 24,
                child: Icon(Icons.person),
              ),
              const SizedBox(width: 12),

              // Patient Name
              Expanded(
                child: Text(
                  "Anonymous Patient",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),

              Icon(Icons.star, color: Colors.amber, size: 20),
              const SizedBox(width: 4),
              Text(
                r["rating"].toString(),
                style: GoogleFonts.poppins(fontSize: 14),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            r["comment"],
            style: GoogleFonts.poppins(color: Colors.black87, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
