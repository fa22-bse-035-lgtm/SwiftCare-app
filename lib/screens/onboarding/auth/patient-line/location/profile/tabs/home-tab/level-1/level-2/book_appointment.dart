import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swiftcare/models/doctor_model.dart';
import 'package:swiftcare/models/review_model.dart';
import 'package:swiftcare/models/shift_model.dart';
import 'package:swiftcare/screens/onboarding/auth/patient-line/location/profile/tabs/home-tab/level-1/level-2/level-3/patient_detail.dart';
import 'package:swiftcare/services/api_service.dart';
import 'package:swiftcare/services/colors.dart';
import 'package:swiftcare/services/helper_functions.dart';
import 'package:swiftcare/services/shared_resource.dart';
import 'package:swiftcare/utils/app_config.dart';
import 'package:swiftcare/widgets/app_bar.dart';
import 'package:swiftcare/widgets/category_bars.dart';

class BookAppointment extends StatefulWidget {
  final Doctor doctor;
  const BookAppointment({super.key, required this.doctor});

  @override
  State<BookAppointment> createState() => _BookAppointmentState();
}

class _BookAppointmentState extends State<BookAppointment> {
  int selectedDayIndex = -1;
  int selectedTimeIndex = -1;
  List<Shift> availableShifts = [];
  List<String> availableTimeSlots = [];
  late Future<List<Review>> docReviews;

  bool _loadingShifts = false;
  bool _loadingSlots = false;
  String? _shiftLoadError;
  late final List<String> _candidateDateWindow;

  @override
  void initState() {
    super.initState();
    docReviews = HelperFunctions().getdoctorReviews(widget.doctor.id);
    _candidateDateWindow = _buildCandidateDateWindow(
      availableDays: widget.doctor.availableDays,
      windowDays: 30,
    );
    _loadDoctorShifts();
  }

  List<String> _buildCandidateDateWindow({
    required List<String> availableDays,
    required int windowDays,
  }) {
    final weekdaySet = _parseDoctorWeekdays(availableDays);
    if (weekdaySet.isEmpty) return [];

    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final result = <String>[];

    for (int i = 0; i < windowDays; i++) {
      final date = start.add(Duration(days: i));
      if (!weekdaySet.contains(date.weekday)) continue;
      result.add(_toIsoDate(date));
    }
    return result;
  }

  Set<int> _parseDoctorWeekdays(List<String> availableDays) {
    final map = <String, int>{
      'mon': DateTime.monday,
      'monday': DateTime.monday,
      'tue': DateTime.tuesday,
      'tues': DateTime.tuesday,
      'tuesday': DateTime.tuesday,
      'wed': DateTime.wednesday,
      'wednesday': DateTime.wednesday,
      'thu': DateTime.thursday,
      'thur': DateTime.thursday,
      'thurs': DateTime.thursday,
      'thursday': DateTime.thursday,
      'fri': DateTime.friday,
      'friday': DateTime.friday,
      'sat': DateTime.saturday,
      'saturday': DateTime.saturday,
      'sun': DateTime.sunday,
      'sunday': DateTime.sunday,
    };

    final set = <int>{};
    for (final raw in availableDays) {
      final key = raw.trim().toLowerCase();
      final day = map[key];
      if (day != null) set.add(day);
    }
    return set;
  }

  String _toIsoDate(DateTime dt) {
    return "${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}";
  }

  int _timeToMinutes(String time) {
    final raw = time.trim().toUpperCase();
    final parts = raw.split(' ');
    if (parts.length != 2) return 9999;

    final hm = parts[0].split(':');
    if (hm.length != 2) return 9999;

    int hour = int.tryParse(hm[0]) ?? 0;
    final minute = int.tryParse(hm[1]) ?? 0;
    final period = parts[1];

    if (period == 'PM' && hour != 12) hour += 12;
    if (period == 'AM' && hour == 12) hour = 0;
    return hour * 60 + minute;
  }

  Future<void> _loadDoctorShifts() async {
    setState(() {
      _loadingShifts = true;
      _shiftLoadError = null;
      selectedDayIndex = -1;
      selectedTimeIndex = -1;
      availableTimeSlots = [];
    });

    try {
      final allShifts = await ApiService().getDoctorShifts(widget.doctor.id);

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final candidateSet = _candidateDateWindow.toSet();

      // Use doctor's available weekdays (next 30 days), then keep only real shifts.
      final filtered = allShifts.where((s) {
        if (candidateSet.isNotEmpty && !candidateSet.contains(s.date)) {
          return false;
        }
        final parsedDate = DateTime.tryParse(s.date);
        if (parsedDate == null) return false;
        final shiftDay = DateTime(
          parsedDate.year,
          parsedDate.month,
          parsedDate.day,
        );
        return !shiftDay.isBefore(today);
      }).toList();

      // Keep one shift per date for date-chip UX (earliest start time wins).
      final Map<String, Shift> earliestShiftByDate = {};
      for (final shift in filtered) {
        final existing = earliestShiftByDate[shift.date];
        if (existing == null ||
            _timeToMinutes(shift.startTime) <
                _timeToMinutes(existing.startTime)) {
          earliestShiftByDate[shift.date] = shift;
        }
      }
      final uniqueByDate = earliestShiftByDate.values.toList();

      setState(() {
        availableShifts = uniqueByDate
          ..sort((a, b) {
            final aDate = DateTime.tryParse(a.date);
            final bDate = DateTime.tryParse(b.date);
            if (aDate == null && bDate == null) return 0;
            if (aDate == null) return 1;
            if (bDate == null) return -1;
            return aDate.compareTo(bDate);
          });
        _loadingShifts = false;
      });
    } catch (_) {
      setState(() {
        availableShifts = [];
        _loadingShifts = false;
        _shiftLoadError = "Unable to load shifts right now.";
      });
    }
  }

  Future<void> _fetchSlots(Shift shift) async {
    setState(() {
      _loadingSlots = true;
      availableTimeSlots = [];
      selectedTimeIndex = -1;
    });

    try {
      final slots = await ApiService().getAvailableSlots(
        doctorId: widget.doctor.id,
        date: shift.date,
        shiftId: shift.id,
      );
      setState(() {
        availableTimeSlots = slots;
        _loadingSlots = false;
      });
    } catch (e) {
      setState(() => _loadingSlots = false);
    }
  }

  String _formatDateLabel(String isoDate) {
    // isoDate format: YYYY-MM-DD
    try {
      final date = DateTime.parse(isoDate);
      return "${date.day} ${_getMonth(date.month)}";
    } catch (_) {
      return isoDate;
    }
  }

  String _getMonth(int m) {
    return [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ][m - 1];
  }

  @override
  Widget build(BuildContext context) {
    List<Shift> shifts = availableShifts;
    List<String> times = availableTimeSlots;

    String imagePath = widget.doctor.image;
    String imageUrl = AppConfig.getImageUrl(imagePath);

    return Scaffold(
      appBar: const CustomAppBar(title: "Book Appointment", color: true),
      backgroundColor: AppColors.backgroundColor,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              // ------------------- PROFILE -------------------
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.doctor.name,
                          style: GoogleFonts.poppins(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),

                        Text(
                          widget.doctor.specialization,
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
                                widget.doctor.location.label,
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
              const SizedBox(height: 15),

              // ------------------- STATS -------------------
              FutureBuilder<List<Review>>(
                future: docReviews,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        "Error loading reviews: ${snapshot.error}",
                        style: GoogleFonts.poppins(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    );
                  }

                  if (!snapshot.hasData) {
                    return const SizedBox.shrink();
                  }

                  List<Review> reviews = snapshot.data ?? [];

                  return Row(
                    children: [
                      Expanded(
                        child: CategoryBar(
                          name: widget.doctor.patients.toString(),
                          iconPath: "images/patients.png",
                          subtitle: "Patients",
                        ),
                      ),
                      Expanded(
                        child: CategoryBar(
                          name: widget.doctor.experience.toString(),
                          iconPath: "images/briefcase.png",
                          subtitle: "Years Exp.",
                        ),
                      ),
                      Expanded(
                        child: CategoryBar(
                          name: reviews.isEmpty
                              ? "-"
                              : HelperFunctions()
                                    .calculateRating(widget.doctor.id)
                                    .toStringAsFixed(1),
                          iconPath: "images/star.png",
                          subtitle: "Rating",
                        ),
                      ),
                      Expanded(
                        child: CategoryBar(
                          name: reviews.length.toString(),
                          iconPath: "images/review.png",
                          subtitle: "Reviews",
                        ),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 30),

              const Text(
                "DOCTOR'S SHIFT",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                  color: Color.fromARGB(255, 160, 160, 160),
                  fontSize: 12,
                ),
              ),

              const SizedBox(height: 13),

              // ============= DATE SECTION ==================
              Text(
                "Date",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),

              _loadingShifts
                  ? const Center(child: CircularProgressIndicator())
                  : _shiftLoadError != null
                  ? Text(
                      _shiftLoadError!,
                      style: GoogleFonts.poppins(color: Colors.red),
                    )
                  : shifts.isEmpty
                  ? Text(
                      "No upcoming shifts for this doctor.",
                      style: GoogleFonts.poppins(color: Colors.grey),
                    )
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(shifts.length, (index) {
                          final shift = shifts[index];
                          final label = _formatDateLabel(shift.date);

                          bool isSelected = selectedDayIndex == index;

                          return SizedBox(
                            width: 120,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedDayIndex = index;
                                });
                                _fetchSlots(shift);
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 12),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primaryColor
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primaryColor
                                        : Colors.grey.shade300,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    label,
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),

              const SizedBox(height: 20),

              // ============= TIME SECTION ==================
              Text(
                "Time",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),

              _loadingSlots
                  ? const Center(child: CircularProgressIndicator())
                  : times.isEmpty
                  ? Text(
                      selectedDayIndex == -1
                          ? "Select a date first"
                          : "No slots available",
                      style: GoogleFonts.poppins(color: Colors.grey),
                    )
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(times.length, (index) {
                          final time = times[index];
                          bool isSelected = selectedTimeIndex == index;

                          return SizedBox(
                            width: 117,
                            child: GestureDetector(
                              onTap: () {
                                setState(() => selectedTimeIndex = index);
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 12),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primaryColor
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primaryColor
                                        : Colors.grey.shade300,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    time,
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),

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
            if (selectedDayIndex == -1 || selectedTimeIndex == -1) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Please select date & time")),
              );
              return;
            }

            final selectedShift = availableShifts[selectedDayIndex];
            final selectedTime = availableTimeSlots[selectedTimeIndex];

            // Build appointment map for next screen (Parity with backend Appointment model)
            Map<String, dynamic> appointment = {
              "patientId": SharedResources.userData.value['_id'],
              "doctorId": widget.doctor.id,
              "doctorName": widget.doctor.name,
              "shiftId": selectedShift.id,
              "date": selectedShift.date,
              "time": selectedTime,
              "amount": widget.doctor.consultationFee,
              "consultationNotes":
                  "", // Will be filled as 'problem' in PatientDetails
              "bookingFor": "Self",
              "gender": "Male",
              "age": "",
              "problem": "",
              "status": "pending",
            };

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PatientDetails(
                  appointment: appointment,
                  doctor: widget.doctor,
                ),
              ),
            );
          },

          child: Text(
            "Make Appointment",
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
