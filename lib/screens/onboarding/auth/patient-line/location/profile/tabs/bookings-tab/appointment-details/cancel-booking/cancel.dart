import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swiftcare/services/colors.dart';
import 'package:swiftcare/widgets/app_bar.dart';

class CancelBookingScreen extends StatefulWidget {
  const CancelBookingScreen({super.key});

  @override
  State<CancelBookingScreen> createState() => _CancelBookingScreenState();
}

class _CancelBookingScreenState extends State<CancelBookingScreen> {
  String selectedReason = "Schedule Change";
  final TextEditingController otherCtrl = TextEditingController();

  final List<String> reasons = [
    "Schedule Change",
    "Weather conditions",
    "Unexpected Work",
    "Childcare Issue",
    "Travel Delays",
    "Other",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(color: true, title: "Cancel Booking"),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              Text(
                "Please select the reason for cancellations:",
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
              ),

              const SizedBox(height: 20),

              // Radio Buttons
              RadioGroup<String>(
                groupValue: selectedReason,
                onChanged: (val) {
                  if (val != null) {
                    setState(() => selectedReason = val);
                  }
                },
                child: Column(
                  children: reasons.map((r) {
                    return InkWell(
                      onTap: () {
                        setState(() => selectedReason = r);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            Radio<String>(value: r, activeColor: Colors.blue),
                            const SizedBox(width: 8),
                            Text(r, style: GoogleFonts.poppins(fontSize: 14)),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 10),
              Container(height: 1, color: Colors.black12),
              const SizedBox(height: 20),

              // Other Reason TextField
              Text(
                "Other",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black12),
                ),
                child: TextField(
                  controller: otherCtrl,
                  maxLines: null,
                  expands: true,
                  decoration: InputDecoration(
                    hintText: "Enter your Reason",
                    hintStyle: GoogleFonts.poppins(color: Colors.black45),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            minimumSize: Size(double.infinity, 55),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          onPressed: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => PatientDetails()),
            // );
          },
          child: Text(
            "Cancel Appointment",
            style: GoogleFonts.poppins(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
