import 'package:flutter/material.dart';
import 'package:swiftcare/services/colors.dart';
import 'package:swiftcare/widgets/app_bar.dart';

class Filter extends StatefulWidget {
  const Filter({super.key});

  @override
  State<Filter> createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  // Specialty Selection
  int specialtyIndex = 0;
  final specialties = ["All", "General", "Dentist", "Orthopedic"];

  // Reviews
  int selectedReview = 0;
  final reviewTexts = [
    "4.5 and above",
    "4.0 - 4.5",
    "3.5 - 4.0",
    "3.0 - 3.5",
    "2.5 - 3.0",
  ];

  // Distance slider
  RangeValues distance = const RangeValues(7, 100);

  // Instant book
  bool instantBook = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,

      appBar: CustomAppBar(title: "Filter", color: true),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            // SPECIALTY TITLE
            const Text(
              "Specialty",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),

            // SPECIALTY FILTER CHIPS
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List.generate(specialties.length, (index) {
                bool isSelected = specialtyIndex == index;
                return GestureDetector(
                  onTap: () => setState(() => specialtyIndex = index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      specialties[index],
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 28),

            // REVIEWS
            const Text(
              "Reviews",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),

            RadioGroup<int>(
              groupValue: selectedReview,
              onChanged: (val) {
                if (val != null) {
                  setState(() => selectedReview = val);
                }
              },
              child: Column(
                children: List.generate(reviewTexts.length, (index) {
                  return Row(
                    children: [
                      // Stars
                      Row(
                        children: List.generate(
                          5,
                          (i) => const Icon(
                            Icons.star,
                            color: Colors.orange,
                            size: 26,
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: Text(
                          reviewTexts[index],
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),

                      Radio<int>(value: index),
                    ],
                  );
                }),
              ),
            ),

            const SizedBox(height: 28),

            // DISTANCE
            const Text(
              "Distance (km)",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            RangeSlider(
              values: distance,
              min: 0,
              max: 150,
              activeColor: Colors.blue,
              divisions: 10,
              labels: RangeLabels(
                distance.start.round().toString(),
                distance.end.round().toString(),
              ),
              onChanged: (value) {
                setState(() => distance = value);
              },
            ),

            // Distance markers
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("7"),
                Text("22"),
                Text("50"),
                Text("100"),
                Text("150+"),
              ],
            ),

            const SizedBox(height: 28),
          ],
        ),
      ),

      // BOTTOM BUTTONS
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: Color(0xFF1E90FF)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Reset Filter",
                  style: TextStyle(color: Color(0xFF1E90FF)),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: const Color(0xFF1E90FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Apply",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
