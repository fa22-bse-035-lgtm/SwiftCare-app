import 'package:flutter/material.dart';
import 'package:swiftcare/models/doctor_model.dart';
import 'package:swiftcare/services/colors.dart';
import 'package:swiftcare/services/shared_resource.dart';
import 'package:swiftcare/widgets/app_bar.dart';
import 'package:swiftcare/widgets/doctors_list.dart';
import 'package:uicons/uicons.dart';

class Favorites extends StatelessWidget {
  const Favorites({super.key});

  List<Doctor> get _favoriteDoctors {
    final List<String> favIds = SharedResources.favorites.value;
    return SharedResources.doctors.value.where((doc) {
      return favIds.contains(doc.id);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(
        title: "Favorites",
        color: true,
        rightIcon2: UIcons.regularRounded.search,
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 25, right: 25),
        child: ValueListenableBuilder<List<String>>(
          valueListenable: SharedResources.favorites,
          builder: (context, _, __) {
            return SingleChildScrollView(
              child: DoctorsList(doctors: _favoriteDoctors),
            );
          },
        ),
      ),
    );
  }
}
