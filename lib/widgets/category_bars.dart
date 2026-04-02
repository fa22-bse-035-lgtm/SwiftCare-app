import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swiftcare/services/colors.dart';

class CategoryBar extends StatelessWidget {
  final String name;
  final String iconPath;
  final String? subtitle; // OPTIONAL subtitle

  const CategoryBar({
    super.key,
    required this.name,
    required this.iconPath,
    this.subtitle, // optional parameter
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Icon circle
        Container(
          height: 57,
          width: 57,
          decoration: BoxDecoration(
            color: AppColors.iconBackgroundColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Image.asset(
              iconPath,
              height: 32,
              width: 32,
              fit: BoxFit.contain,
              color: AppColors.primaryColor,
            ),
          ),
        ),

        const SizedBox(height: 4),

        // Main category text
        SizedBox(
          width: 80,
          child: Column(
            children: [
              Text(
                name.length > 10 ? "${name.substring(0, 8)}.." : name,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 11.5,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),

              // Subtitle (only visible if provided)
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
