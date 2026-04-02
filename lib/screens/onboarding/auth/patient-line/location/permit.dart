import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swiftcare/screens/onboarding/auth/patient-line/location/profile/complete_profile.dart';
import 'package:swiftcare/services/colors.dart';
import 'package:swiftcare/services/location_service.dart';
import 'package:swiftcare/services/shared_resource.dart';
import 'package:uicons/uicons.dart';

class Permit extends StatelessWidget {
  const Permit({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  border: Border.all(
                    color: const Color.fromARGB(
                      0,
                      33,
                      149,
                      243,
                    ), // border color
                    width: 2, // border width
                  ),
                  borderRadius: BorderRadius.circular(
                    100,
                  ), // <-- makes rounded corners
                ),
                child: Icon(
                  UIcons.regularStraight.marker,
                  size: 44,
                  color: AppColors.primaryColor,
                ),
              ),

              SizedBox(height: 30),

              Text(
                'What is Your Location?',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 12),

              Text(
                'We need to know your location in order\n to suggest nearby services.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Color.fromARGB(255, 128, 128, 128),
                ),
              ),

              SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      Position? position =
                          await LocationService.getCurrentLocation();

                      final double lat = position!.latitude;
                      final double lng = position.longitude;
                      List<double> coordinates = [lng, lat];

                      dynamic currUser = SharedResources.userData.value;

                      String email = currUser["credentials"]["email"];

                      print(email);
                      print(coordinates);

                      if (email.isNotEmpty && coordinates != []) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CompleteProfilePage(
                              email: email,
                              coordinates: coordinates,
                            ),
                          ),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(e.toString())));
                    }
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(29),
                    ),
                  ),
                  child: Text(
                    "Allow Location Access",
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
