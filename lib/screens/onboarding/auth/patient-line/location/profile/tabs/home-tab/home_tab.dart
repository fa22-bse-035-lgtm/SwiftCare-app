import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swiftcare/screens/onboarding/auth/patient-line/location/profile/tabs/home-tab/categories/categories.dart';
import 'package:swiftcare/screens/onboarding/auth/patient-line/location/profile/tabs/home-tab/filter/filter.dart';
import 'package:swiftcare/services/shared_resource.dart';
import 'package:swiftcare/widgets/category_bars.dart';
import 'package:swiftcare/widgets/doctors_list.dart';
import 'package:uicons/uicons.dart';
import 'package:swiftcare/services/colors.dart';

class HomeTab extends StatelessWidget {
  HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.only(left: 25, right: 25),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Search Bar and Filter Button
              Row(
                children: [
                  // Search Bar
                  Expanded(
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color.fromARGB(255, 230, 230, 230),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            UIcons.regularRounded.search,
                            color: AppColors.primaryColor,
                            size: 20,
                          ),

                          const SizedBox(width: 10),

                          Text(
                            "Search",
                            style: GoogleFonts.poppins(
                              color: Colors.grey[500],
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Filter Button
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Filter(),
                          ),
                        );
                      },
                      icon: Icon(
                        UIcons.regularStraight.filter,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Top Specialists and view all Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Doctor Specialties",
                    style: GoogleFonts.poppins(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Categories()),
                      );
                    },
                    style: ButtonStyle(
                      padding: WidgetStateProperty.all(EdgeInsets.zero),
                      minimumSize: WidgetStateProperty.all(Size.zero),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      overlayColor: WidgetStateProperty.all(Colors.transparent),
                    ),
                    child: Text(
                      "See All",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Category Bars
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: CategoryBar(
                      name: "Dentist",
                      iconPath: "assets/images/tooth.png",
                    ),
                  ),
                  Expanded(
                    child: CategoryBar(
                      name: "Cardiology",
                      iconPath: "assets/images/heart.png",
                    ),
                  ),
                  Expanded(
                    child: CategoryBar(
                      name: "Ontology",
                      iconPath: "assets/images/ear.png",
                    ),
                  ),
                  Expanded(
                    child: CategoryBar(
                      name: "Neurology",
                      iconPath: "assets/images/brain.png",
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Top Specialists and view all Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Top Specialists",
                    style: GoogleFonts.poppins(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      padding: WidgetStateProperty.all(EdgeInsets.zero),
                      minimumSize: WidgetStateProperty.all(Size.zero),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      overlayColor: WidgetStateProperty.all(Colors.transparent),
                    ),
                    child: Text(
                      "See All",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),

              // Doctor Cards — rebuilds automatically when doctors list changes
              ValueListenableBuilder<List<dynamic>>(
                valueListenable: SharedResources.doctors,
                builder: (context, doctors, _) {
                  return DoctorsList(doctors: doctors);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
