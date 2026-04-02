import 'package:flutter/material.dart';
import 'package:swiftcare/screens/onboarding/auth/patient-line/location/profile/tabs/profile-tab/screens/favorites.dart';
import 'package:swiftcare/screens/onboarding/auth/patient-line/location/profile/tabs/profile-tab/screens/privacy_policy.dart';
import 'package:swiftcare/screens/onboarding/auth/patient-line/location/profile/tabs/profile-tab/screens/settings.dart';
import 'package:swiftcare/screens/onboarding/auth/patient-line/location/profile/tabs/profile-tab/screens/update_profile.dart';
import 'package:swiftcare/services/auth_service.dart';
import 'package:swiftcare/services/colors.dart';
import 'package:swiftcare/services/shared_resource.dart';
import 'package:uicons/uicons.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,

      // APPBAR
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          "Profile",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.black,
            fontSize: 18,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // PROFILE PHOTO + EDIT BUTTON
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 55,
                  backgroundImage: AssetImage("assets/images/Jane.jpg"),
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(6),
                  child: const Icon(Icons.edit, color: Colors.white, size: 20),
                ),
              ],
            ),

            const SizedBox(height: 14),

            ValueListenableBuilder<Map<String, dynamic>>(
              valueListenable: SharedResources.userData,
              builder: (context, user, _) {
                return Text(
                  user["name"] ?? "",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                );
              },
            ),

            const SizedBox(height: 25),

            // MENU LIST
            buildMenuItem(
              icon: UIcons.regularRounded.user,
              title: "Your profile",
              onTap: () {
                dynamic user = SharedResources.userData.value;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdateProfile(currUser: user),
                  ),
                );
              },
            ),
            buildMenuItem(
              icon: UIcons.regularRounded.heart,
              title: "Favourite",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Favorites()),
                );
              },
            ),
            buildMenuItem(
              icon: UIcons.regularRounded.settings,
              title: "Settings",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
            ),
            buildMenuItem(
              icon: UIcons.regularRounded.question_square,
              title: "Help Center",
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => const HelpCenter(),
                //   ),
                // );
              },
            ),
            buildMenuItem(
              icon: UIcons.regularRounded.shield_check,
              title: "Privacy Policy",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PrivacyPolicyScreen(),
                  ),
                );
              },
            ),
            buildMenuItem(
              icon: UIcons.regularRounded.sign_out_alt,
              title: "Log out",
              onTap: () async {
                final shouldLogout = await showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Confirm Logout"),
                      content: const Text("Are you sure you want to logout?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                          child: const Text(
                            "Logout",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    );
                  },
                );

                if (shouldLogout == true) {
                  await AuthService().signOut();

                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/signin', // replace with your login route
                    (route) => false,
                  );
                }
              },
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // MENU ROW WIDGET
  Widget buildMenuItem({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
  }) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(icon, color: AppColors.primaryColor, size: 21),
          title: Text(title, style: GoogleFonts.poppins(fontSize: 15)),
          trailing: Icon(
            Icons.arrow_forward_ios_outlined,
            size: 16,
            color: AppColors.primaryColor,
          ),
          onTap: onTap,
        ),
        const Divider(height: 1),
      ],
    );
  }
}
