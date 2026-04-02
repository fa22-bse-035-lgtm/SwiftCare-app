import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:swiftcare/services/colors.dart';
import 'package:swiftcare/services/shared_resource.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    const primary = AppColors.primaryColor;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: ValueListenableBuilder<Map<String, dynamic>>(
          valueListenable: SharedResources.userData,
          builder: (context, userData, child) {
            String name = userData["name"] ?? "Doctor";
            String specialization = userData["specialization"] ?? "Specialist";
            String imagePath = userData["image"] ?? "images/Jane.jpg";
            String imageUrl =
                "http://swiftcare.up.railway.app/${imagePath.replaceAll("\\", "/")}";
            String todayDate = DateFormat('EEEE, MMM d').format(DateTime.now());

            return ValueListenableBuilder<List<dynamic>>(
              valueListenable: SharedResources.appointments,
              builder: (context, appointments, child) {
                String doctorId = userData["_id"] ?? "";
                List<dynamic> doctorAppts = appointments.where((a) {
                  return a["doctorId"] == doctorId ||
                      (a["doctor"] != null && a["doctor"]["_id"] == doctorId);
                }).toList();

                int totalToday = doctorAppts.length;
                int completed =
                    doctorAppts.where((a) => a["status"] == "completed").length;
                int remaining = totalToday - completed;

                Map<String, dynamic>? getPatientInfo(dynamic appt) {
                  if (appt == null) return null;
                  if (appt["patient"] != null && appt["patient"] is Map) {
                    return appt["patient"];
                  }
                  String? pId = appt["patientId"];
                  if (pId != null) {
                    try {
                      return SharedResources.patients.value
                          .firstWhere((p) => p["_id"] == pId);
                    } catch (_) {}
                  }
                  return null;
                }

                Map<String, dynamic>? upcomingAppt;
                Map<String, dynamic>? upcomingPatient;
                if (doctorAppts.isNotEmpty) {
                  upcomingAppt = doctorAppts.firstWhere(
                      (a) => a["status"] != "completed",
                      orElse: () => doctorAppts.first);
                  upcomingPatient = getPatientInfo(upcomingAppt);
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),

                      /// HEADER
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 26,
                            backgroundImage: NetworkImage(imageUrl),
                            onBackgroundImageError: (_, __) =>
                                const AssetImage("assets/images/Jane.jpg"),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Good Morning, $name",
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  "$todayDate • $specialization",
                                  style: GoogleFonts.poppins(
                                    color: Colors.grey,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              shape: BoxShape.circle,
                            ),
                            child: Stack(
                              children: const [
                                Icon(Icons.notifications_none),
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: CircleAvatar(
                                    radius: 4,
                                    backgroundColor: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      /// STATUS CARD
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF3FA),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: Colors.blue.shade100),
                        ),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              radius: 6,
                              backgroundColor: Colors.grey,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Current Status: ",
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        "Offline",
                                        style: GoogleFonts.poppins(
                                          fontStyle: FontStyle.italic,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "You are currently not accepting patients.",
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Switch(value: false, onChanged: (value) {}),
                          ],
                        ),
                      ),

                      const SizedBox(height: 22),

                      /// START SHIFT BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.play_circle_fill),
                          label: const Text("START SHIFT"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primary,
                            foregroundColor: Colors.white,
                            textStyle: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () {},
                        ),
                      ),

                      const SizedBox(height: 24),

                      /// DAILY OVERVIEW
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "DAILY OVERVIEW",
                          style: GoogleFonts.poppins(
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      /// STATS CARDS
                      _overviewCard(
                        icon: Icons.calendar_today,
                        iconColor: primary,
                        value: totalToday.toString(),
                        label: "Total Appointments",
                        iconBg: primary.withValues(alpha: 0.1),
                      ),

                      _overviewCard(
                        icon: Icons.check_circle,
                        iconColor: Colors.green,
                        value: completed.toString(),
                        label: "Patients Completed",
                        iconBg: Colors.green.withValues(alpha: 0.1),
                      ),

                      _overviewCard(
                        icon: Icons.assignment,
                        iconColor: Colors.orange,
                        value: remaining.toString(),
                        label: "Patients Remaining",
                        iconBg: Colors.orange.withValues(alpha: 0.1),
                      ),

                      const SizedBox(height: 18),

                      /// UPCOMING PATIENT CARD
                      if (upcomingAppt != null && upcomingAppt["status"] != "completed")
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Upcoming Patient",
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    "View Queue",
                                    style: GoogleFonts.poppins(
                                      color: primary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF5F6FA),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  children: [
                                    const CircleAvatar(
                                      radius: 24,
                                      backgroundColor: Colors.blueGrey,
                                      child: Icon(
                                        Icons.person,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            upcomingPatient?["name"] ??
                                                upcomingAppt["patientName"] ??
                                                "Unknown",
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            "Scheduled: ${upcomingAppt["time"] ?? "N/A"}",
                                            style: GoogleFonts.poppins(
                                              fontSize: 13,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Icon(Icons.chevron_right),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                      const SizedBox(height: 20),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _overviewCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String value,
    required String label,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(label, style: GoogleFonts.poppins(color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}