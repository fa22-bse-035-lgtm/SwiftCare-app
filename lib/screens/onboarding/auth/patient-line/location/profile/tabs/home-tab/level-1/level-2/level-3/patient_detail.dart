import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:swiftcare/screens/onboarding/auth/patient-line/location/profile/tabs/home-tab/level-1/level-2/level-3/level-4/review_summary.dart';
import 'package:swiftcare/services/colors.dart';
import 'package:swiftcare/widgets/app_bar.dart';

class PatientDetails extends StatelessWidget {
  final Map<String, dynamic> appointment;
  final Map<String, dynamic> doctor;

  PatientDetails({super.key, required this.appointment, required this.doctor});

  // Controllers
  final TextEditingController ageController = TextEditingController();
  final TextEditingController problemController = TextEditingController();

  // ValueNotifiers instead of StatefulWidget
  final ValueNotifier<String> bookingFor = ValueNotifier("Self");
  final ValueNotifier<String> gender = ValueNotifier("Male");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,

      appBar: const CustomAppBar(title: "Patient Details", color: true),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            minimumSize: const Size(double.infinity, 55),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          onPressed: () {
            // Validation
            if (ageController.text.isEmpty ||
                problemController.text.isEmpty ||
                bookingFor.value.isEmpty ||
                gender.value.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Fill all fields before continuing"),
                ),
              );
              return;
            }

            // Update appointment object
            appointment["bookingFor"] = bookingFor.value;
            appointment["gender"] = gender.value;
            appointment["age"] = ageController.text.trim();
            appointment["problem"] = problemController.text.trim();

            // Next screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReviewSummary(appointment: appointment, doc: doctor),
              ),
            );
          },
          child: Text(
            "Next",
            style: GoogleFonts.poppins(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 25, right: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 22),

              _title("Booking for"),
              const SizedBox(height: 4),
              ValueListenableBuilder(
                valueListenable: bookingFor,
                builder: (_, value, _) {
                  return _dropdown(
                    value: value,
                    items: ["Self", "Someone Else"],
                    onChanged: (v) => bookingFor.value = v!,
                  );
                },
              ),

              const SizedBox(height: 20),

              _title("Gender"),
              const SizedBox(height: 4),
              ValueListenableBuilder(
                valueListenable: gender,
                builder: (_, value, _) {
                  return _dropdown(
                    value: value,
                    items: ["Male", "Female", "Other"],
                    onChanged: (v) => gender.value = v!,
                  );
                },
              ),

              const SizedBox(height: 20),

              _title("Your Age"),
              const SizedBox(height: 4),
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: TextField(
                  controller: ageController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: GoogleFonts.poppins(fontSize: 14),
                  decoration: const InputDecoration(
                    hintText: "Enter age (e.g. 25)",
                    border: InputBorder.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              _title("Write Your Problem"),
              const SizedBox(height: 5),

              // Problem Text Field (max 20 words)
              Container(
                height: 150,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F8F8),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: TextField(
                  controller: problemController,
                  maxLines: 6,
                  style: GoogleFonts.poppins(),
                  onChanged: (text) {
                    List<String> words = text.trim().split(RegExp(r"\s+"));
                    if (words.length > 20) {
                      // Remove extra words
                      words = words.sublist(0, 20);
                      problemController.text = words.join(" ");

                      // Move cursor to end
                      problemController.selection = TextSelection.fromPosition(
                        TextPosition(offset: problemController.text.length),
                      );

                      // Show warning
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Maximum 20 words allowed"),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    }
                  },
                  decoration: InputDecoration(
                    hintText: "Mention your problem in few words",
                    hintStyle: GoogleFonts.poppins(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Dropdown widget
  Widget _dropdown({
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: value,
        icon: const Icon(Icons.keyboard_arrow_down_rounded),
        isExpanded: true,
        items: items
            .map(
              (e) => DropdownMenuItem(
                value: e,
                child: Text(e, style: GoogleFonts.poppins(fontSize: 14)),
              ),
            )
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _title(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
    );
  }
}
