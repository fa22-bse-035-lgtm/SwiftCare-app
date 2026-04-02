import 'package:swiftcare/screens/onboarding/auth/patient-line/location/profile/tabs/bookings-tab/booking_tab.dart';
import 'package:swiftcare/screens/onboarding/auth/patient-line/location/profile/tabs/location-tab/location_tab.dart';
import 'package:swiftcare/screens/onboarding/auth/patient-line/location/profile/tabs/profile-tab/profile_tab.dart';
import 'package:swiftcare/screens/onboarding/auth/patient-line/location/profile/tabs/home-tab/home_tab.dart';
import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';
import 'package:swiftcare/widgets/navigation_provider.dart';
import 'package:swiftcare/services/colors.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:uicons/uicons.dart';

class PatientNavBar extends StatelessWidget {
  const PatientNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final nav = Provider.of<NavigationProvider>(context);

    final screens = [
      HomeTab(),
      const ExploreTab(),
      BookingTab(),
      const ProfileTab(),
    ];

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: IndexedStack(index: nav.selectedIndex, children: screens),

      bottomNavigationBar: WaterDropNavBar(
        bottomPadding: 17,
        inactiveIconColor: const Color.fromARGB(255, 187, 187, 187),
        iconSize: 24,
        backgroundColor: Colors.white,
        waterDropColor: AppColors.primaryColor,
        onItemSelected: (i) => nav.setSelectedIndex(i),
        selectedIndex: nav.selectedIndex,
        barItems: [
          BarItem(
            filledIcon: UIcons.solidStraight.home,
            outlinedIcon: UIcons.regularRounded.home,
          ),
          BarItem(
            filledIcon: UIcons.solidRounded.marker,
            outlinedIcon: UIcons.regularRounded.marker,
          ),
          BarItem(
            filledIcon: UIcons.solidRounded.calendar,
            outlinedIcon: UIcons.regularRounded.calendar,
          ),
          BarItem(
            filledIcon: UIcons.solidRounded.user,
            outlinedIcon: UIcons.regularRounded.user,
          ),
        ],
      ),
    );
  }
}
