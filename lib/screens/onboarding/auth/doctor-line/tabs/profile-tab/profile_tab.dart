import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swiftcare/services/colors.dart';
import 'package:swiftcare/services/shared_resource.dart';
import 'package:swiftcare/utils/app_config.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    const primary = AppColors.primaryColor;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,

      body: SafeArea(
        child: ValueListenableBuilder<Map<String, dynamic>>(
          valueListenable: SharedResources.userData,
          builder: (context, userData, child) {
            String name = userData["name"] ?? "Doctor";
            String specialization = userData["specialization"] ?? "Specialist";
            String imagePath = userData["image"] ?? "";
            String imageUrl = AppConfig.getImageUrl(imagePath);

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  /// PROFILE IMAGE
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.blue.shade100,
                        child: ClipOval(
                          child: FadeInImage.assetNetwork(
                            placeholder: "assets/images/Jane.jpg",
                            image: imageUrl,
                            fit: BoxFit.cover,
                            width: 108,
                            height: 108,
                            imageErrorBuilder: (context, error, stackTrace) =>
                                Image.asset(
                              "assets/images/Jane.jpg",
                              fit: BoxFit.cover,
                              width: 108,
                              height: 108,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  /// NAME
                  Text(
                    "Dr. $name",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    specialization,
                    style: GoogleFonts.poppins(
                      color: primary,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// EDIT PROFILE BUTTON
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.edit, size: 18),
                    label: const Text("Edit Profile"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: primary,
                      side: const BorderSide(color: primary),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  /// PRACTICE MANAGEMENT
                  _sectionTitle("PRACTICE MANAGEMENT"),

                  const SizedBox(height: 12),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.access_time,
                                color: primary,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Working Hours",
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    "Configure your availability",
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              "Manage",
                              style: GoogleFonts.poppins(
                                color: primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),
                        const Divider(),
                        const SizedBox(height: 10),

                        ...List.generate(
                          (userData["schedule"]?["availableDays"] as List?)?.length ?? 0,
                          (index) {
                            final schedule = userData["schedule"] ?? {};
                            final days = schedule["availableDays"] as List? ?? [];
                            final hours = schedule["availableHours"] as List? ?? [];

                            String day = days[index];
                            String hourRange = hours.length > index ? hours[index] : "N/A";

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(day, style: GoogleFonts.poppins()),
                                  Text(
                                    hourRange,
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        if ((userData["schedule"]?["availableDays"] as List?)?.isEmpty ?? true)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("No schedule set", style: GoogleFonts.poppins(color: Colors.grey)),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 26),

                  /// ACCOUNT SETTINGS
                  _sectionTitle("ACCOUNT SETTINGS"),

                  const SizedBox(height: 12),

                  _settingsTile(Icons.notifications, "Notifications"),
                  _settingsTile(Icons.security, "Security & Privacy"),
                  _settingsTile(Icons.help_outline, "Help Center"),

                  const SizedBox(height: 20),

                  /// LOGOUT BUTTON
                  GestureDetector(
                    onTap: () {
                      SharedResources().clear();
                      // Navigation to login should be handled here
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: Colors.red.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.logout, color: Colors.red),
                          SizedBox(width: 8),
                          Text(
                            "Logout Account",
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    "SwiftCare Professional v2.4.0",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// SECTION TITLE
  Widget _sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          color: Colors.grey,
          letterSpacing: 1,
        ),
      ),
    );
  }

  /// SETTINGS TILE
  Widget _settingsTile(IconData icon, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[700]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }
}
