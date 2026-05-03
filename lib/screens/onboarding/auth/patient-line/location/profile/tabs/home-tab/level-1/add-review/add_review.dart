import 'package:flutter/material.dart';
import 'package:swiftcare/models/doctor_model.dart';
import 'package:swiftcare/models/review_model.dart';
import 'package:swiftcare/services/api_service.dart';
import 'package:swiftcare/services/shared_resource.dart';
import 'package:swiftcare/utils/app_config.dart';

class AddDoctorReview extends StatefulWidget {
  final Doctor doctor;
  const AddDoctorReview({super.key, required this.doctor});

  @override
  State<AddDoctorReview> createState() => _AddDoctorReview();
}

class _AddDoctorReview extends State<AddDoctorReview> {
  double rating = 0;
  TextEditingController reviewController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String name = widget.doctor.name;
    String imagePath = widget.doctor.image;
    String imageUrl = AppConfig.getImageUrl(imagePath);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ----------------- BACK BUTTON -----------------
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back, size: 28),
                ),
              ),
            ),

            // ----------------- DOCTOR IMAGE + NAME -----------------
            const SizedBox(height: 10),
            CircleAvatar(
              radius: 55,
              backgroundColor: Colors.grey[200],
              child: ClipOval(
                child: imagePath.startsWith('assets')
                    ? Image.asset(
                        imagePath,
                        width: 110,
                        height: 110,
                        fit: BoxFit.cover,
                      )
                    : FadeInImage.assetNetwork(
                        placeholder: 'assets/images/default_doctor.png',
                        image: imageUrl,
                        width: 110,
                        height: 110,
                        fit: BoxFit.cover,
                        imageErrorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/images/default_doctor.png',
                            width: 110,
                            height: 110,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
              ),
            ),
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(Icons.verified, color: Colors.blue, size: 22),
              ],
            ),

            Text(
              widget.doctor.specialization,
              style: const TextStyle(color: Colors.grey, fontSize: 15),
            ),

            const SizedBox(height: 25),

            // ----------------- EXPERIENCE QUESTION -----------------
            Text(
              "How was your experience with\n$name?",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              softWrap: true,
              overflow: TextOverflow.visible,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 25),

            // ----------------- YOUR OVERALL RATING -----------------
            const Text(
              "Your overall rating",
              style: TextStyle(color: Colors.grey, fontSize: 15),
            ),
            const SizedBox(height: 10),

            // ----------------- STAR RATING -----------------
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                (index) => IconButton(
                  icon: Icon(
                    index < rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 34,
                  ),
                  onPressed: () {
                    setState(() {
                      rating = index + 1.0;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ------------ ADD DETAILED REVIEW (COMMENT) TEXT BOX ------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Add detailed review",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),

                  Container(
                    height: 120,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.grey.shade300, width: 1),
                    ),
                    child: TextField(
                      maxLines: 5,
                      controller: reviewController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter here",
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // ----------------- SUBMIT BUTTON -----------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Container(
                width: double.infinity,
                height: 55,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF0F68F4), Color(0xFF0B4FE3)],
                  ),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                  onPressed: () async {
                    final comment = reviewController.text.trim();

                    if (rating == 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please select a rating")),
                      );
                      return;
                    }

                    if (comment.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Please add a short comment about the doctor",
                          ),
                        ),
                      );
                      return;
                    }

                    final String? patientId =
                        SharedResources.userData.value['_id'];
                    if (patientId == null) return;

                    final reviewData = {
                      "doctorId": widget.doctor.id,
                      "patientId": patientId,
                      "rating": rating,
                      "comment": comment,
                    };

                    try {
                      final success = await ApiService().addReview(reviewData);

                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Review added successfully"),
                          ),
                        );

                        // Since we have a typed list now, we should add a Review object
                        final newReview = Review(
                          id: "temp_${DateTime.now().millisecondsSinceEpoch}", // temporary ID until next refresh
                          doctorId: widget.doctor.id,
                          patientId: patientId,
                          rating: rating,
                          comment: comment,
                          createdAt: DateTime.now(),
                        );

                        SharedResources.reviews.value = [
                          ...SharedResources.reviews.value,
                          newReview,
                        ];

                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Failed to add review")),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text("Error: $e")));
                    }
                  },
                  child: const Text(
                    "Submit",
                    style: TextStyle(fontSize: 17, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    reviewController.dispose();
    super.dispose();
  }
}
