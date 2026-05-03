import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:collection/collection.dart';
import 'package:swiftcare/models/appointment_model.dart';
import 'package:swiftcare/models/patient_model.dart';
import 'package:swiftcare/screens/onboarding/auth/doctor-line/tabs/queue-tab/active-consultation/consultation.dart';
import 'package:swiftcare/services/colors.dart';
import 'package:swiftcare/services/shared_resource.dart';

class QueueTab extends StatelessWidget {
  const QueueTab({super.key});

  @override
  Widget build(BuildContext context) {
    const primary = AppColors.primaryColor;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ValueListenableBuilder<Map<String, dynamic>>(
            valueListenable: SharedResources.userData,
            builder: (context, userData, child) {
              String doctorId = userData["_id"] ?? "";

              return ValueListenableBuilder<List<Appointment>>(
                valueListenable: SharedResources.appointments,
                builder: (context, appointments, child) {
                  // Filter for this doctor
                  List<Appointment> docAppts = appointments.where((a) {
                    return a.doctorId == doctorId;
                  }).toList();

                  // Identify current and remaining
                  Appointment? currentServing;
                  List<Appointment> upcomingAppts = [];

                  if (docAppts.isNotEmpty) {
                    currentServing = docAppts.firstWhereOrNull(
                      (a) => a.status.toLowerCase() != "completed" && a.status.toLowerCase() != "cancelled"
                    );
                    
                    upcomingAppts = docAppts
                        .where((a) => a.id != currentServing?.id && a.status.toLowerCase() != "completed" && a.status.toLowerCase() != "cancelled")
                        .toList();
                  }

                  Patient? getPatientInfo(Appointment appt) {
                    return SharedResources.patients.value
                        .firstWhereOrNull((p) => p.id == appt.patientId);
                  }

                  int remainingCount = upcomingAppts.length;

                  Patient? currentPatient = currentServing != null ? getPatientInfo(currentServing) : null;
                  String currentId = currentPatient != null
                      ? "#${currentPatient.id.length > 4 ? currentPatient.id.substring(currentPatient.id.length - 4) : currentPatient.id}"
                      : "#N/A";
                  String currentName = currentPatient?.name ?? "No Patient";

                  Patient? nextPatient =
                      upcomingAppts.isNotEmpty ? getPatientInfo(upcomingAppts.first) : null;
                  String nextId = nextPatient != null
                      ? "#${nextPatient.id.length > 4 ? nextPatient.id.substring(nextPatient.id.length - 4) : nextPatient.id}"
                      : "#N/A";

                  return Column(
                    children: [
                      const SizedBox(height: 10),

                      /// HEADER
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Live Queue",
                                  style: GoogleFonts.poppins(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  "Main Clinic • Room 04",
                                  style: GoogleFonts.poppins(
                                    color: primary,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: primary.withValues(alpha: 0.12),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.search, color: primary),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      /// CURRENTLY SERVING CARD
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF1E66F5), Color(0xFF1C7BEF)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: primary.withValues(alpha: 0.2),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "CURRENTLY SERVING",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),

                            const SizedBox(height: 18),

                            Text(
                              currentId,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 36,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              currentName,
                              style: GoogleFonts.poppins(
                                color: Colors.white.withValues(alpha: 0.4),
                                fontSize: 18,
                              ),
                            ),

                            const SizedBox(height: 18),

                            Divider(color: Colors.white.withValues(alpha: 0.9)),

                            const SizedBox(height: 12),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "WAITING ROOM",
                                      style: GoogleFonts.poppins(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      "$remainingCount patients remaining",
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.people,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 18),

                      /// CALL NEXT BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.arrow_forward),
                          label: const Text("Call Next Patient"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            disabledBackgroundColor: Colors.grey.shade300,
                            textStyle: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          onPressed: remainingCount > 0
                              ? () {
                                  // Mark current as completed
                                  if (currentServing != null) {
                                      final serving = currentServing;
                                      final List<Appointment> allAppts = List.from(SharedResources.appointments.value);
                                      final index = allAppts.indexWhere((a) => a.id == serving.id);
                                      if (index != -1) {
                                          allAppts[index] = Appointment(
                                              id: serving.id,
                                              patientId: serving.patientId,
                                              doctorId: serving.doctorId,
                                              doctorName: serving.doctorName,
                                              date: serving.date,
                                              time: serving.time,
                                              status: "completed",
                                              consultationNotes: serving.consultationNotes,
                                              amount: serving.amount,
                                          );
                                          SharedResources.appointments.value = allAppts;
                                      }
                                  }

                                  // Navigate to active consultation with next patient
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ActiveConsultation(
                                        appointment: upcomingAppts.first,
                                      ),
                                    ),
                                  );
                                }
                              : null,
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// UPCOMING HEADER
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Upcoming Patients",
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: primary.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              "Next: $nextId",
                              style: GoogleFonts.poppins(
                                color: primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      /// LIST
                      Expanded(
                        child: upcomingAppts.isEmpty
                            ? const Center(child: Text("Queue is empty"))
                            : ListView.builder(
                                itemCount: upcomingAppts.length,
                                itemBuilder: (context, index) {
                                  final appt = upcomingAppts[index];
                                  final pInfo = getPatientInfo(appt);
                                  String pIdToken = pInfo != null
                                      ? "#${pInfo.id.length > 4 ? pInfo.id.substring(pInfo.id.length - 4) : pInfo.id}"
                                      : "#N/A";
                                  String pName = pInfo?.name ?? "Unknown";
                                  String waitTime = appt.time;

                                  return PatientTile(
                                    pIdToken,
                                    pName,
                                    waitTime,
                                    index == 0,
                                  );
                                },
                              ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class PatientTile extends StatelessWidget {
  final String token;
  final String name;
  final String wait;
  final bool highlight;

  const PatientTile(
    this.token,
    this.name,
    this.wait,
    this.highlight, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF1E66F5);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: highlight
                  ? primary.withValues(alpha: 0.1)
                  : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.person, color: highlight ? primary : Colors.grey),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  token,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                "Wait Time / Appt",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              Text(wait, style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }
}