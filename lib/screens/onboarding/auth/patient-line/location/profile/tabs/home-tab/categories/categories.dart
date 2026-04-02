import 'package:flutter/material.dart';
import 'package:swiftcare/services/colors.dart';
import 'package:swiftcare/widgets/app_bar.dart';
import 'package:swiftcare/widgets/category_bars.dart';

class Categories extends StatelessWidget {
  const Categories({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Categories',
        color: true,
      ),
      body: Container(
        color: AppColors.backgroundColor,
        padding: const EdgeInsets.only(left: 25, right: 25),
        child: Column(
          children: [
            SizedBox(height: 10),
            
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
            
            SizedBox(height: 24),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: CategoryBar(
                    name: "Orthopaedic",
                    iconPath: "assets/images/tooth.png",
                  ),
                ),
                Expanded(
                  child: CategoryBar(
                    name: "Gastroen",
                    iconPath: "assets/images/heart.png",
                  ),
                ),
                Expanded(
                  child: CategoryBar(
                    name: "Rhinology",
                    iconPath: "assets/images/ear.png",
                  ),
                ),
                Expanded(
                  child: CategoryBar(
                    name: "Utologist",
                    iconPath: "assets/images/brain.png",
                  ),
                ),
              ],
            ),
      
            SizedBox(height: 24),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: CategoryBar(
                    name: "General",
                    iconPath: "assets/images/tooth.png",
                  ),
                ),
                Expanded(
                  child: CategoryBar(
                    name: "Herbal",
                    iconPath: "assets/images/heart.png",
                  ),
                ),
                Expanded(
                  child: CategoryBar(
                    name: "Intestine",
                    iconPath: "assets/images/ear.png",
                  ),
                ),
                Expanded(
                  child: CategoryBar(
                    name: "Radiology",
                    iconPath: "assets/images/brain.png",
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}