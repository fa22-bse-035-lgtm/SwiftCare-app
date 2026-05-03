import 'package:swiftcare/screens/onboarding/auth/patient-line/location/profile/tabs/home-tab/level-1/add-review/add_review.dart';
import 'package:swiftcare/screens/onboarding/auth/patient-line/location/profile/tabs/home-tab/level-1/level-2/book_appointment.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swiftcare/models/doctor_model.dart';
import 'package:swiftcare/models/review_model.dart';
import 'package:swiftcare/services/colors.dart';
import 'package:swiftcare/services/helper_functions.dart';
import 'package:swiftcare/widgets/category_bars.dart';
import 'package:swiftcare/widgets/favorite_heart.dart';
import 'package:swiftcare/services/shared_resource.dart';
import 'package:swiftcare/utils/app_config.dart';
import 'package:swiftcare/widgets/map_preview.dart';
import 'package:uicons/uicons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:collection/collection.dart';

class DoctorDetails extends StatelessWidget {
  final Doctor doctor;

  const DoctorDetails({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    Future<List<Review>> docReviews = HelperFunctions().getdoctorReviews(
      doctor.id,
    );
    double lng = doctor.location.longitude;
    double lat = doctor.location.latitude;

    String imagePath = doctor.image;
    String imageUrl = AppConfig.getImageUrl(imagePath);

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
                    child: FavoriteHeart(doctorId: doctor.id),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      body: FutureBuilder<List<Review>>(
        future: docReviews,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error loading reviews: ${snapshot.error}",
                style: GoogleFonts.poppins(color: Colors.red, fontSize: 14),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const SizedBox.shrink();
          }

          List<Review> reviews = snapshot.data ?? [];

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
                    ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: imagePath.startsWith('assets')
                          ? Image.asset(
                              imagePath,
                              height: 80,
                              width: 80,
                              fit: BoxFit.cover,
                            )
                          : FadeInImage.assetNetwork(
                              placeholder: 'assets/images/Jane.jpg',
                              image: imageUrl,
                              height: 80,
                              width: 80,
                              fit: BoxFit.cover,
                              imageErrorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/images/Jane.jpg',
                                  height: 80,
                                  width: 80,
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                    ),
                    const SizedBox(width: 14),

                    // NAME + SPECIALIZATION + LOCATION
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            doctor.name,
                            style: GoogleFonts.poppins(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),

                          Text(
                            doctor.specialization,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.black54,
                            ),
                          ),

                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: AppColors.primaryColor,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  doctor.location.label,
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
                        name: doctor.patients.toString(),
                        iconPath: "images/patients.png",
                        subtitle: "Patients",
                      ),
                    ),
                    Expanded(
                      child: CategoryBar(
                        name: doctor.experience.toString(),
                        iconPath: "images/briefcase.png",
                        subtitle: "Years Exp.",
                      ),
                    ),
                    Expanded(
                      child: CategoryBar(
                        name: reviews.isEmpty
                            ? "-"
                            : HelperFunctions()
                                  .calculateRating(doctor.id)
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
                  doctor.about,
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
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          final Uri googleMapUrl = Uri.parse(
                            "https://www.google.com/maps/search/?api=1&query=$lat,$lng",
                          );

                          if (await canLaunchUrl(googleMapUrl)) {
                            await launchUrl(googleMapUrl);
                          }
                        },
                        child: Text(
                          doctor.location.label,
                          style: GoogleFonts.poppins(fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                MapPreview(lat: lat, lng: lng),
                
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
                            builder: (context) =>
                                AddDoctorReview(doctor: doctor),
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
                builder: (context) => BookAppointment(doctor: doctor),
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
    List<String> days = doctor.availableDays;
    List<String> hours = doctor.availableHours;

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
  Widget _buildReviewCard(Review r) {
    final patient = SharedResources.patients.value.firstWhereOrNull(
      (p) => p.id == r.patientId,
    );
    final String pName = patient?.name ?? "Anonymous Patient";
    final String pImage = patient?.image ?? "";
    final String pImageUrl = AppConfig.getImageUrl(pImage);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey[200],
                radius: 24,
                child: ClipOval(
                  child: pImage.isNotEmpty
                      ? FadeInImage.assetNetwork(
                          placeholder: 'assets/images/Jane.jpg',
                          image: pImageUrl,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                          imageErrorBuilder: (_, __, ___) =>
                              const Icon(Icons.person, color: Colors.grey),
                        )
                      : const Icon(Icons.person, color: Colors.grey),
                ),
              ),
              const SizedBox(width: 12),

              // Patient Name
              Expanded(
                child: Text(
                  pName,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),

              const Icon(Icons.star, color: Colors.amber, size: 16),
              const SizedBox(width: 4),
              Text(
                r.rating.toString(),
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            r.comment,
            style: GoogleFonts.poppins(color: Colors.black87, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
