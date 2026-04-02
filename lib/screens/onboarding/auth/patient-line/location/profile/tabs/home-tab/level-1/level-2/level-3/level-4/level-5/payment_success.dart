import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swiftcare/services/colors.dart';
import 'package:swiftcare/widgets/app_bar.dart';

class PaymentSuccess extends StatelessWidget {
  final Map<String, dynamic> appointment;
  final Map<String, dynamic> doc;

  const PaymentSuccess({
    super.key,
    required this.appointment,
    required this.doc,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(title: "Payment", color: true),

      body: Padding(
        padding: const EdgeInsets.only(left: 25, right: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),

            // Blue Check Circle
            Container(
              height: 110,
              width: 110,
              decoration: const BoxDecoration(
                color: Color(0xFF0A74FF),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 60),
            ),

            const SizedBox(height: 25),

            Text(
              "Payment Successful!",
              style: GoogleFonts.inter(
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              "You have successfully booked appointment with",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 14, color: Colors.black54),
            ),

            const SizedBox(height: 3),

            // DOCTOR NAME (dynamic)
            Text(
              doc["name"] ?? "Doctor",
              style: GoogleFonts.inter(
                fontSize: 15,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 30),

            // Divider
            Container(
              height: 1,
              width: double.infinity,
              color: AppColors.divider,
            ),

            const SizedBox(height: 30),

            // --------------------- APPOINTMENT DETAILS ---------------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.person_outline, color: Colors.blue),
                    const SizedBox(width: 10),
                    // BOOKING FOR (dynamic)
                    Text(
                      appointment["bookingFor"]?.isNotEmpty == true
                          ? appointment["bookingFor"]
                          : "Unknown",
                      style: GoogleFonts.inter(fontSize: 15),
                    ),
                  ],
                ),

                Row(
                  children: [
                    const Icon(Icons.attach_money, color: Colors.blue),
                    const SizedBox(width: 5),
                    // AMOUNT (dynamic)
                    Text(
                      "${appointment["amount"]}",
                      style: GoogleFonts.inter(fontSize: 15),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 25),

            // DATE + TIME ROW
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_month, color: Colors.blue),
                    const SizedBox(width: 10),

                    // DATE (dynamic)
                    Text(
                      appointment["date"] ?? "--",
                      style: GoogleFonts.inter(fontSize: 15),
                    ),
                  ],
                ),

                Row(
                  children: [
                    const Icon(Icons.access_time, color: Colors.blue),
                    const SizedBox(width: 5),

                    // TIME (dynamic)
                    Text(
                      appointment["time"] ?? "--",
                      style: GoogleFonts.inter(fontSize: 15),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 50),

            // --------------------- View Appointment Button ---------------------
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0A74FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                onPressed: () {},
                child: Text(
                  "View Appointment",
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text(
                "Go to Home",
                style: GoogleFonts.inter(
                  fontSize: 15,
                  color: Color(0xFF0A74FF),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
