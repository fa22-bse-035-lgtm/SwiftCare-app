import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swiftcare/models/appointment_model.dart';
import 'package:swiftcare/models/doctor_model.dart';
import 'package:swiftcare/services/api_service.dart';
import 'package:swiftcare/services/colors.dart';
import 'package:swiftcare/services/shared_resource.dart';
import 'package:swiftcare/utils/app_config.dart';
import 'package:swiftcare/widgets/app_bar.dart';
import 'package:swiftcare/widgets/payment_button.dart';
import 'level-5/payment_success.dart';

class ReviewSummary extends StatelessWidget {
  final Map<String, dynamic> appointment;
  final Doctor doctor;

  const ReviewSummary({
    super.key,
    required this.appointment,
    required this.doctor,
  });

  @override
  Widget build(BuildContext context) {
    String imagePath = doctor.image;
    String imageUrl = AppConfig.getImageUrl(imagePath);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,

      appBar: const CustomAppBar(title: "Review Summary", color: true),

      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 25, right: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            // -------------------- DOCTOR PROFILE --------------------
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // IMAGE
                ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: imagePath.startsWith('assets') 
                      ? Image.asset(
                          imagePath,
                          height: 80,
                          width: 80,
                          fit: BoxFit.cover,
                        )
                      : FadeInImage.assetNetwork(
                          placeholder: 'assets/images/Jane.jpg',
                          image: imageUrl,
                          height: 80,
                          width: 80,
                          fit: BoxFit.cover,
                          imageErrorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/images/Jane.jpg',
                              height: 80,
                              width: 80,
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                ),
                const SizedBox(width: 14),

                // NAME / SPECIALIZATION / LOCATION
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctor.name,
                        style: GoogleFonts.poppins(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),

                      Text(
                        doctor.specialization,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 6),

                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: AppColors.primaryColor,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              doctor.location.label,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            Divider(color: AppColors.divider),
            const SizedBox(height: 10),

            // -------------------- APPOINTMENT DETAILS --------------------
            buildRow(
              "Date & Hour",
              "${appointment["date"]} | ${appointment["time"]}",
            ),

            buildRow("Booking For", appointment["bookingFor"]),
            buildRow("Gender", appointment["gender"]),
            buildRow("Age", appointment["age"]),
            buildRow("Problem", appointment["problem"]),

            Divider(color: AppColors.divider, height: 30),

            // -------------------- PAYMENT DETAILS --------------------
            buildRow("Consultation Fee", "${appointment["amount"]}"),
            buildRow("Duration", "30 minutes approx"),

            const SizedBox(height: 4),

            buildRow("Total", "${appointment["amount"]}", isBold: true),

            const SizedBox(height: 40),
          ],
        ),
      ),

      // -------------------- PAY BUTTON --------------------
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: PaymentButton(
          amount: appointment["amount"],
          onSuccess: () async {
            bool status = await ApiService().createAppointment(appointment);
            if (status == true) {
              // Create Appointment model from the map and add it to SharedResources
              final newAppt = Appointment(
                  id: "temp_${DateTime.now().millisecondsSinceEpoch}",
                  patientId: appointment["patientId"],
                  doctorId: appointment["doctorId"],
                  doctorName: appointment["doctorName"],
                  date: appointment["date"],
                  time: appointment["time"],
                  status: "Scheduled",
                  consultationNotes: appointment["consultationNotes"],
                  amount: appointment["amount"],
              );

              SharedResources.appointments.value = [
                ...SharedResources.appointments.value,
                newAppt,
              ];
              
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      PaymentSuccess(doctor: doctor, appointment: appointment),
                ),
              );
            } else {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text("Payment Failed")));
            }
          },
        ),
      ),
    );
  }

  // -------------------- REUSABLE ROW --------------------
  Widget buildRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: GoogleFonts.poppins(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
