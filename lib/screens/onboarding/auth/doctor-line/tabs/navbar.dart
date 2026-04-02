import 'package:swiftcare/screens/onboarding/auth/doctor-line/tabs/home-tab/home_tab.dart';
import 'package:swiftcare/screens/onboarding/auth/doctor-line/tabs/patients-tab/patients_tab.dart';
import 'package:swiftcare/screens/onboarding/auth/doctor-line/tabs/profile-tab/profile_tab.dart';
import 'package:swiftcare/screens/onboarding/auth/doctor-line/tabs/queue-tab/queue_tab.dart';
import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';
import 'package:swiftcare/widgets/navigation_provider.dart';
import 'package:swiftcare/services/colors.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:uicons/uicons.dart';

class DoctorNavBar extends StatelessWidget {
  const DoctorNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final nav = Provider.of<NavigationProvider>(context);

    final screens = [
      HomeTab(),
      const QueueTab(),
      const PatientsScreen(),
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
            filledIcon: UIcons.solidRounded.users,
            outlinedIcon: UIcons.regularRounded.users,
          ),
          BarItem(
            filledIcon: UIcons.solidRounded.list,
            outlinedIcon: UIcons.regularRounded.list,
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
