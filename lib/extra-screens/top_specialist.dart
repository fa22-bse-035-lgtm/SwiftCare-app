import 'package:flutter/material.dart';
import 'package:swiftcare/services/colors.dart';
import 'package:swiftcare/widgets/app_bar.dart';
import 'package:swiftcare/widgets/speciality_chip.dart';
import 'package:uicons/uicons.dart';

class TopSpecialist extends StatelessWidget {
  const TopSpecialist({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(
        title: "Top Specialist",
        color: true,
        rightIcon2: UIcons.regularRounded.search,
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 25, right: 25),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 15),
              SpecialityChip(),
              // DoctorsList(),
            ],
          ),
        ),
      ),
    );
  }

  
}
