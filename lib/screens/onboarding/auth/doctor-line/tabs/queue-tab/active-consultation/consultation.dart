import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:collection/collection.dart';
import 'package:swiftcare/models/appointment_model.dart';
import 'package:swiftcare/models/patient_model.dart';
import 'package:swiftcare/services/shared_resource.dart';

class ActiveConsultation extends StatefulWidget {
  final Appointment appointment;

  const ActiveConsultation({super.key, required this.appointment});

  @override
  State<ActiveConsultation> createState() => _ActiveConsultationState();
}

class _ActiveConsultationState extends State<ActiveConsultation> {
  late Patient? patient;

  @override
  void initState() {
    super.initState();
    patient = _getPatientInfo(widget.appointment);
  }

  Patient? _getPatientInfo(Appointment appt) {
    return SharedResources.patients.value
        .firstWhereOrNull((p) => p.id == appt.patientId);
  }

  void _completeAndNext() {
    // Current approach manually updates the list and notifies
    // In a future phase, we should move this to a Service.
    final List<Appointment> allAppts = List.from(SharedResources.appointments.value);
    final index = allAppts.indexWhere((a) => a.id == widget.appointment.id);
    
    if (index != -1) {
      allAppts[index] = Appointment(
        id: widget.appointment.id,
        patientId: widget.appointment.patientId,
        doctorId: widget.appointment.doctorId,
        doctorName: widget.appointment.doctorName,
        date: widget.appointment.date,
        time: widget.appointment.time,
        status: "Completed",
        consultationNotes: widget.appointment.consultationNotes,
        amount: widget.appointment.amount,
      );
      SharedResources.appointments.value = allAppts;
    }

    // Fetch next patient
    List<Appointment> docAppts = SharedResources.appointments.value
        .where((a) => a.doctorId == widget.appointment.doctorId && a.status != "Completed")
        .toList();

    if (docAppts.isNotEmpty) {
      Appointment nextAppt = docAppts.first;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ActiveConsultation(appointment: nextAppt),
        ),
      );
    } else {
      // No more patients
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    String name = patient?.name ?? "Unknown";
    String age = patient?.age?.toString() ?? "N/A";
    String gender = patient?.gender ?? "N/A";

    List<String> symptoms = ["General Checkup"]; 

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Active Consultation",
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            const Row(
              children: [
                Icon(Icons.circle, size: 8, color: Colors.green),
                SizedBox(width: 6),
                Text(
                  "LIVE SESSION",
                  style: TextStyle(
                    fontSize: 11,
                    letterSpacing: 1,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              children: [
                Icon(Icons.verified, size: 16, color: Colors.blue),
                SizedBox(width: 6),
                Text(
                  "Draft saved",
                  style: TextStyle(color: Colors.blue),
                ),
              ],
            ),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// PATIENT CARD
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xffE3E8EF)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 32,
                              backgroundImage: NetworkImage(
                                  patient?.image ??
                                      "https://i.pravatar.cc/150?img=12"),
                            ),
                            Positioned(
                              right: -2,
                              bottom: -2,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Icon(
                                  Icons.verified,
                                  size: 16,
                                  color: Colors.blue,
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    name,
                                    style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xffEEF1F5),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      patient != null && patient!.id.length >= 4
                                          ? "#${patient!.id.substring(patient!.id.length - 4)}"
                                          : "#N/A",
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today,
                                      size: 14, color: Colors.grey),
                                  const SizedBox(width: 6),
                                  Text("$age y"),
                                  const SizedBox(width: 12),
                                  const Icon(Icons.male,
                                      size: 16, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text(gender),
                                  const SizedBox(width: 12),
                                  const Icon(Icons.bloodtype,
                                      size: 16, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  const Text("N/A"), // Place holder for blood group
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    const Divider(height: 28),
                    const Text(
                      "CURRENT SYMPTOMS",
                      style: TextStyle(
                        letterSpacing: 1.2,
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: symptoms.map((s) {
                        return SymptomChip(
                          text: s,
                          color: const Color(0xffFFE8D6),
                          textColor: const Color(0xffC2410C),
                        );
                      }).toList(),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 22),

              /// NOTES HEADER
              Row(
                children: [
                  const Icon(Icons.notes, color: Colors.blue),
                  const SizedBox(width: 10),
                  Text(
                    "Consultation Notes",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    "Insert Template",
                    style: GoogleFonts.poppins(color: Colors.blue),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              /// NOTES FIELD
              Container(
                padding: const EdgeInsets.all(14),
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xffE3E8EF)),
                ),
                child: const TextField(
                  maxLines: null,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText:
                        "Start typing patient observations, physical exam results, or history details...",
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// DIAGNOSIS
              Row(
                children: [
                  const Icon(Icons.biotech, color: Colors.blue),
                  const SizedBox(width: 10),
                  Text(
                    "Diagnosis (ICD-10)",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xffE3E8EF)),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    icon: Icon(Icons.search),
                    hintText: "Search diagnosis code or name...",
                    border: InputBorder.none,
                  ),
                ),
              ),

              const SizedBox(height: 28),

              /// ACTION BUTTONS
              Column(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: double.infinity,
                      height: 52,
                      decoration: BoxDecoration(
                        color: const Color(0xffEEF1F5),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: Text(
                          "End Shift",
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    height: 52,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xffD3D9E2)),
                    ),
                    child: Center(
                      child: Text(
                        "Order Lab Tests",
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: _completeAndNext,
                    child: Container(
                      width: double.infinity,
                      height: 54,
                      decoration: BoxDecoration(
                        color: const Color(0xff1E63E9),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: Text(
                          "Complete & Next Patient →",
                          style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20)
            ],
          ),
        ),
      ),
    );
  }
}

class SymptomChip extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;

  const SymptomChip({
    super.key,
    required this.text,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}