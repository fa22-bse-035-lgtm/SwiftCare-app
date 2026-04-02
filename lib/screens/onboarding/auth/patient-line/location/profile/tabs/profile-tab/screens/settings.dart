import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swiftcare/services/colors.dart';
import 'package:swiftcare/widgets/app_bar.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(color: true, title: "Settings"),

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            _buildSettingsItem(
              icon: Icons.person_outline,
              title: "Notification Settings",
            ),
            _divider(),
            _buildSettingsItem(
              icon: Icons.vpn_key_outlined,
              title: "Password Manager",
            ),
            _divider(),
            _buildSettingsItem(
              icon: Icons.delete_outline,
              title: "Delete Account",
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider() {
    return Padding(
      padding: const EdgeInsets.only(left: 55),
      child: Divider(color: AppColors.divider, height: 1),
    );
  }

  Widget _buildSettingsItem({required IconData icon, required String title}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryColor, size: 22),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black45),
        ],
      ),
    );
  }
}
