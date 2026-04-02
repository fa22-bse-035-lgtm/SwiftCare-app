import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swiftcare/screens/onboarding/auth/patient-line/location/profile/tabs/home-tab/level-1/level-2/level-3/patient_detail.dart';
import 'package:swiftcare/services/colors.dart';
import 'package:swiftcare/services/helper_functions.dart';
import 'package:swiftcare/services/shared_resource.dart';
import 'package:swiftcare/widgets/app_bar.dart';
import 'package:swiftcare/widgets/category_bars.dart';

class BookAppointment extends StatefulWidget {
  final Map<String, dynamic> doc;
  const BookAppointment({super.key, required this.doc});

  @override
  State<BookAppointment> createState() => _BookAppointmentState();
}

class _BookAppointmentState extends State<BookAppointment> {
  int selectedDayIndex = -1;
  int selectedTimeIndex = -1;
  List<Map<String, String>> availableDays = [];
  String? selectedDayIso;
  List<String> availableTimeSlots = [];

  bool _initialized = false;

  // -------------------------------------------------------------------
  // INIT – but do NOT use context here
  // -------------------------------------------------------------------
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      generateAvailableDays();
      _initialized = true;
    }
  }

  // -------------------------------------------------------------------
  // GENERATE NEXT 6 DAYS THAT MATCH DOCTOR'S AVAILABLE WEEKDAYS
  // -------------------------------------------------------------------
  void generateAvailableDays() {
    List<String> docDays = List<String>.from(widget.doc["availableDays"]);
    availableDays.clear();

    for (int i = 0; i < 8; i++) {
      DateTime date = DateTime.now().add(Duration(days: i));
      String weekday = getWeekday(date.weekday);

      if (docDays.contains(weekday)) {
        availableDays.add({
          "fullIso": date.toIso8601String(),
          "label": weekday,
          "date": "${date.day} ${getMonth(date.month)}",
        });
      }
    }

    setState(() {});
  }

  // -------------------------------------------------------------------
  // GENERATE 30-MIN TIME SLOTS BASED ON DOCTOR'S HOURS
  // -------------------------------------------------------------------
  void generateTimeSlots(DateTime day) {
    availableTimeSlots.clear();

    // doctor original days list
    List<String> docDays = List<String>.from(widget.doc["availableDays"]);
    List<String> docHours = List<String>.from(widget.doc["availableHours"]);

    String selectedWeekday = getWeekday(day.weekday);

    // find matching index
    int index = docDays.indexOf(selectedWeekday);

    if (index == -1) {
      setState(() {});
      return; // no schedule for this day
    }

    // get the correct timing for this specific day
    String hours = docHours[index];

    if (!hours.contains("-")) {
      setState(() {});
      return; // invalid format OR day is "Closed"
    }

    List<String> parts = hours.split(" - ");

    DateTime start = parseTime(parts[0], day);
    DateTime end = parseTime(parts[1], day);

    DateTime now = DateTime.now();
    bool isToday = _isSameDate(day, now);

    while (start.isBefore(end)) {
      if (isToday && start.isBefore(now)) {
        start = start.add(const Duration(minutes: 30));
        continue;
      }

      availableTimeSlots.add(formatTimeSafe(start));
      start = start.add(const Duration(minutes: 30));
    }

    setState(() {});
  }

  // -------------------------------------------------------------------
  // HELPERS
  // -------------------------------------------------------------------
  bool _isSameDate(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  String getWeekday(int w) {
    return [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday",
    ][w - 1];
  }

  String getMonth(int m) {
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

  DateTime parseTime(String time, DateTime day) {
    final clean = time.trim().toUpperCase(); // "7:00 PM"

    final parts = clean.split(" ");
    final hm = parts[0].split(":");
    int hour = int.parse(hm[0]);
    int minute = int.parse(hm[1]);

    if (clean.contains("PM") && hour != 12) hour += 12;
    if (clean.contains("AM") && hour == 12) hour = 0;

    return DateTime(day.year, day.month, day.day, hour, minute);
  }

  // Safe formatter without using BuildContext
  String formatTimeSafe(DateTime dt) {
    int h = dt.hour;
    int m = dt.minute;

    String period = h >= 12 ? "PM" : "AM";
    h = h % 12;
    if (h == 0) h = 12;

    String mm = m.toString().padLeft(2, "0");

    return "$h:$mm $period";
  }

  // -------------------------------------------------------------------
  // UI
  // -------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    Future<List<dynamic>> docReviews = HelperFunctions().getdoctorReviews(
      widget.doc["_id"],
    );

    // Use the generated values instead of unavailable widget.doc["availability"]
    List<dynamic> days = availableDays;

    List<dynamic> times = selectedDayIso != null ? availableTimeSlots : [];

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
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage(widget.doc["image"]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.doc["name"],
                          style: GoogleFonts.poppins(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),

                        Text(
                          widget.doc["specialization"],
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.black54,
                          ),
                        ),

                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: AppColors.primaryColor,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                widget.doc["location"],
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
              FutureBuilder(
                future: docReviews,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  List<dynamic> reviews = snapshot.data!;

                  return Row(
                    children: [
                      Expanded(
                        child: CategoryBar(
                          name: widget.doc["patients"],
                          iconPath: "images/patients.png",
                          subtitle: "Patients",
                        ),
                      ),
                      Expanded(
                        child: CategoryBar(
                          name: widget.doc["experience"],
                          iconPath: "images/briefcase.png",
                          subtitle: "Years Exp.",
                        ),
                      ),
                      Expanded(
                        child: CategoryBar(
                          name: reviews.isEmpty
                              ? "-"
                              : HelperFunctions()
                                    .calculateRating(widget.doc["_id"])
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
                "BOOK APPOINTMENT",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                  color: Color.fromARGB(255, 160, 160, 160),
                  fontSize: 12,
                ),
              ),

              const SizedBox(height: 13),

              // ============= DAY SECTION ==================
              Text(
                "Day",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),

              // FIXED OVERFLOW → Made horizontal scrollable
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(days.length, (index) {
                    final item = days[index];
                    final day = item["label"];
                    final date = item["date"];

                    bool isSelected = selectedDayIndex == index;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDayIndex = index;
                          selectedDayIso = item["fullIso"];
                          selectedTimeIndex = -1;

                          generateTimeSlots(DateTime.parse(selectedDayIso!));
                        });
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
                        child: Column(
                          children: [
                            Text(
                              day,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                            ),
                            Text(
                              date,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: isSelected ? Colors.white : Colors.grey,
                              ),
                            ),
                          ],
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

              // Horizontal scrollable time chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(times.length, (index) {
                    final time = times[index];
                    bool isSelected = selectedTimeIndex == index;

                    return GestureDetector(
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
                        child: Text(
                          time,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: isSelected ? Colors.white : Colors.black,
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

      // ----------------- BUTTON -----------------
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
                const SnackBar(content: Text("Please select day & time")),
              );
              return;
            }

            final selectedDay = availableDays[selectedDayIndex];
            final selectedTime = availableTimeSlots[selectedTimeIndex];

            // ApiService().appointments.add({
            //   "doctorId": widget.doc["_id"],
            //   "doctorName": widget.doc["name"],
            //   "dateIso": selectedDay["fullIso"], // full ISO day
            //   "dateLabel": selectedDay["date"], // e.g. "4 Oct"
            //   "weekday": selectedDay["label"], // e.g. "Monday"
            //   "time": selectedTime, // e.g. "7:30 PM"
            //   "timestamp": DateTime.now().toIso8601String(),
            // });

            Map<String, dynamic> appointment = {
              "patientId": SharedResources.userData.value['_id'],
              "doctorId": widget.doc["_id"],
              "doctorName": widget.doc["name"],
              "day": selectedDay["label"], // e.g. "Monday"
              "date": selectedDay["date"], // e.g. "4 Oct"
              "time": selectedTime, // e.g. "7:30 PM"
              "bookingFor": "", // e.g. Self / Someone Else
              "gender": "",
              "age": "",
              "problem": "",
              "amount": widget.doc["consulationFee"], // e.g. 2500
              "status": "", // e.g. Pending
              "fullDateIso": selectedDay["fullIso"], // full ISO day
              "timestamp": DateTime.now().toIso8601String(),
            };

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PatientDetails(appointment: appointment, doctor: widget.doc),
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

  // -------------------------------------------------------------------
  // DAY CHIP
  // -------------------------------------------------------------------
  Widget dayChip({
    required String day,
    required String date,
    bool selected = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? AppColors.primaryColor : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: selected ? AppColors.primaryColor : Colors.grey.shade300,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            day,
            style: GoogleFonts.poppins(
              color: selected ? Colors.white : Colors.black54,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            date,
            style: GoogleFonts.poppins(
              color: selected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------------
  // TIME CHIP
  // -------------------------------------------------------------------
  Widget timeChip({required String time, bool selected = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: selected ? AppColors.primaryColor : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: selected ? AppColors.primaryColor : Colors.grey.shade300,
        ),
      ),
      child: Text(
        time,
        style: GoogleFonts.poppins(
          color: selected ? Colors.white : Colors.black87,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
