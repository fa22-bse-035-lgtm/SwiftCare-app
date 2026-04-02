import 'package:flutter/material.dart';
import 'package:swiftcare/services/colors.dart';
import 'package:swiftcare/services/shared_resource.dart';

class PatientsScreen extends StatefulWidget {
  const PatientsScreen({super.key});

  @override
  State<PatientsScreen> createState() => _PatientsScreenState();
}

class _PatientsScreenState extends State<PatientsScreen> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 20),

              /// Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withValues(alpha: .1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.badge,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Text(
                      "Patient Records",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryColor,
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.person_add, color: Colors.white),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// Search Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 6,
                      color: Colors.black.withValues(alpha: .05),
                    ),
                  ],
                ),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value.toLowerCase();
                    });
                  },
                  decoration: const InputDecoration(
                    icon: Icon(Icons.search),
                    hintText: "Search patients by name",
                    border: InputBorder.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// Patient List
              Expanded(
                child: ValueListenableBuilder<Map<String, dynamic>>(
                  valueListenable: SharedResources.userData,
                  builder: (context, userData, child) {
                    String doctorId = userData["_id"] ?? "";

                    return ValueListenableBuilder<List<dynamic>>(
                      valueListenable: SharedResources.appointments,
                      builder: (context, appointments, child) {
                        // Filter for this doctor
                        List<dynamic> docAppts = appointments.where((a) {
                          return a["doctorId"] == doctorId ||
                              (a["doctor"] != null &&
                                  a["doctor"]["_id"] == doctorId);
                        }).toList();

                        Map<String, dynamic>? getPatientInfo(dynamic appt) {
                          if (appt == null) return null;
                          if (appt["patient"] != null && appt["patient"] is Map) {
                            return appt["patient"];
                          }
                          String? pId = appt["patientId"];
                          if (pId != null) {
                            try {
                              return SharedResources.patients.value.firstWhere((p) => p["_id"] == pId);
                            } catch (_) {}
                          }
                          return null;
                        }

                        // Get unique patients by keeping track of patient ids
                        List<Map<String, dynamic>> uniquePatients = [];
                        Set<String> seenIds = {};

                        for (var appt in docAppts) {
                          var pInfo = getPatientInfo(appt);
                          if (pInfo != null) {
                            String pId = pInfo["_id"]?.toString() ?? "unknown";
                            if (!seenIds.contains(pId)) {
                              seenIds.add(pId);

                              String pName = pInfo["name"] ?? "Unknown Patient";
                              if (searchQuery.isNotEmpty &&
                                  !pName.toLowerCase().contains(searchQuery)) {
                                continue;
                              }

                              uniquePatients.add({
                                "name": pName,
                                "id": pId.length >= 4
                                    ? "#${pId.substring(pId.length - 4)}"
                                    : "#$pId",
                                "ageGender":
                                    "${pInfo["age"] ?? "--"}y • ${pInfo["gender"] ?? "Unknown"}",
                                "lastVisit":
                                    appt["date"] ??
                                    appt["createdAt"] ??
                                    "Recent",
                                "note":
                                    appt["reason"] ??
                                    appt["problem"] ??
                                    appt["notes"] ??
                                    "No specific notes provided.",
                                "image": pInfo["image"],
                              });
                            }
                          }
                        }

                        if (uniquePatients.isEmpty) {
                          return const Center(
                            child: Text("No patients found."),
                          );
                        }

                        return ListView.builder(
                          itemCount: uniquePatients.length,
                          itemBuilder: (context, index) {
                            final p = uniquePatients[index];
                            return PatientCard(
                              name: p["name"],
                              id: p["id"],
                              ageGender: p["ageGender"],
                              lastVisit: p["lastVisit"],
                              note: p["note"],
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PatientCard extends StatelessWidget {
  final String name;
  final String id;
  final String ageGender;
  final String lastVisit;
  final String note;

  const PatientCard({
    super.key,
    required this.name,
    required this.id,
    required this.ageGender,
    required this.lastVisit,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(blurRadius: 8, color: Colors.black.withValues(alpha: .05)),
        ],
      ),
      child: Column(
        children: [
          /// Top Row
          Row(
            children: [
              const CircleAvatar(
                radius: 26,
                backgroundColor: Color(0xffE6EEF8),
                child: Icon(Icons.person, color: AppColors.primaryColor),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "ID: $id",
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(ageGender, style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),

          const SizedBox(height: 12),

          /// Last Visit
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withValues(alpha: .1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: AppColors.primaryColor,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "Last Visit: $lastVisit",
                      style: const TextStyle(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// Note
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xffF3F6FB),
              borderRadius: BorderRadius.circular(10),
              border: const Border(
                left: BorderSide(color: AppColors.primaryColor, width: 3),
              ),
            ),
            child: Text(
              "\"$note\"",
              style: const TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
