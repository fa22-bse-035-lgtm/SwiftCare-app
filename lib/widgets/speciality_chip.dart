import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swiftcare/services/colors.dart';

class SpecialityChip extends StatefulWidget {
  const SpecialityChip({super.key});

  @override
  State<SpecialityChip> createState() => _SpecialityChipState();
}

class _SpecialityChipState extends State<SpecialityChip> {

  String selectedSpeciality = "Dentist"; // ✅ State variable

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35, // safe height, will not break even if padding changes
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          specialityChip(
            speciality: "Dentist",
            selected: selectedSpeciality == "Dentist",
            onTap: () => setState(() => selectedSpeciality = "Dentist"),
          ),
          specialityChip(
            speciality: "Chiropractor",
            selected: selectedSpeciality == "Chiropractor",
            onTap: () => setState(() => selectedSpeciality = "Chiropractor"),
          ),
          specialityChip(
            speciality: "Cardiology",
            selected: selectedSpeciality == "Cardiology",
            onTap: () => setState(() => selectedSpeciality = "Cardiology"),
          ),
          specialityChip(
            speciality: "Neurology",
            selected: selectedSpeciality == "Neurology",
            onTap: () => setState(() => selectedSpeciality = "Neurology"),
          ),
          specialityChip(
            speciality: "Orthopaedic",
            selected: selectedSpeciality == "Orthopaedic",
            onTap: () => setState(() => selectedSpeciality = "Orthopaedic"),
          ),
        ],
      ),
    );
  }

  Widget specialityChip({
    required String speciality,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: selected ? AppColors.primaryColor : Colors.grey.shade300,
          ),
        ),
        child: Text(
          speciality,
          style: GoogleFonts.poppins(
            color: selected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
