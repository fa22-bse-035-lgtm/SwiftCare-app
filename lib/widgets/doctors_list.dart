import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swiftcare/models/doctor_model.dart';
// import 'package:swiftcare/screens/onboarding/auth/patient-line/location/profile/tabs/home-tab/level-1/doctor_detail.dart';
import 'package:swiftcare/services/colors.dart';
import 'package:swiftcare/services/helper_functions.dart';
import 'package:swiftcare/utils/app_config.dart';
import 'package:swiftcare/widgets/favorite_heart.dart';

class DoctorsList extends StatelessWidget {
  final List<Doctor> doctors;
  const DoctorsList({super.key, required this.doctors});

  @override
  Widget build(BuildContext context) {
    if (doctors.isEmpty) {
      return const Center(child: Text("No doctors available"));
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 10),
      itemCount: doctors.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final doctor = doctors[index];
        return doctorCard(doctor, context);
      },
    );
  }

  Widget doctorCard(Doctor doctor, BuildContext context) {
    final String id = doctor.id;
    final String name = doctor.name;
    final String specialty = doctor.specialization;
    final String image = doctor.image;

    final double reviewsCount = HelperFunctions().reviewsNumber(id);
    final double rating = HelperFunctions().calculateRating(id);

    int stars = rating.isFinite ? rating.round() : 0;

    String imageUrl = AppConfig.getImageUrl(image);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: image.startsWith('assets') 
                    ? Image.asset(
                        image,
                        height: 90,
                        width: 70,
                        fit: BoxFit.cover,
                      )
                    : FadeInImage.assetNetwork(
                        placeholder: 'assets/images/Jane.jpg',
                        image: imageUrl,
                        height: 90,
                        width: 70,
                        fit: BoxFit.cover,
                        imageErrorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/images/Jane.jpg',
                            height: 90,
                            width: 70,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
              ),

              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Verified badge + favorite
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.iconBackgroundColor,
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.verified,
                                color: AppColors.primaryColor,
                                size: 16,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                "Professional Doctor",
                                style: GoogleFonts.poppins(
                                  color: AppColors.primaryColor,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        FavoriteHeart(doctorId: id),
                      ],
                    ),

                    const SizedBox(height: 6),

                    Text(
                      name,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    Text(
                      specialty,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),

                    const SizedBox(height: 6),

                    Row(
                      children: [
                        ...List.generate(
                          stars,
                          (index) => const Icon(
                            Icons.star,
                            size: 14,
                            color: Colors.amber,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          rating.toStringAsFixed(1),
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                        const Spacer(),
                        const Text("|"),
                        const Spacer(),
                        Text(
                          "${reviewsCount.toInt()} Reviews",
                          style: GoogleFonts.poppins(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Appointment button
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (_) => DoctorDetails(doctor: doctor)),
                // );
              },
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFFE8F2FF),
                padding: const EdgeInsets.symmetric(vertical: 9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "Make Appointment",
                style: GoogleFonts.poppins(
                  color: AppColors.primaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
