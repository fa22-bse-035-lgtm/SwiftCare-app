import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:collection/collection.dart';
import 'package:swiftcare/models/appointment_model.dart';
import 'package:swiftcare/models/doctor_model.dart';
import 'package:swiftcare/screens/onboarding/auth/patient-line/location/profile/tabs/bookings-tab/appointment-details/booking_details.dart';
import 'package:swiftcare/services/colors.dart';
import 'package:swiftcare/services/shared_resource.dart';
import 'package:swiftcare/utils/app_config.dart';

class BookingTab extends StatefulWidget {
  const BookingTab({super.key});

  @override
  State<BookingTab> createState() => _BookingTabState();
}

class _BookingTabState extends State<BookingTab>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,

      // APP BAR
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          "My Bookings",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),

        // TAB BAR
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Column(
            children: [
              TabBar(
                controller: tabController,
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.blue,
                indicatorWeight: 3,
                labelStyle: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                tabs: const [
                  Tab(text: "Upcoming"),
                  Tab(text: "Completed"),
                  Tab(text: "Cancelled"),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),

      body: TabBarView(
        controller: tabController,
        children: [
          ValueListenableBuilder<List<Appointment>>(
            valueListenable: SharedResources.appointments,
            builder: (context, appointments, _) {
              return _bookingsList(appointments, "Upcoming");
            },
          ),
          ValueListenableBuilder<List<Appointment>>(
            valueListenable: SharedResources.appointments,
            builder: (context, appointments, _) {
              return _bookingsList(appointments, "Completed");
            },
          ),
          ValueListenableBuilder<List<Appointment>>(
            valueListenable: SharedResources.appointments,
            builder: (context, appointments, _) {
              return _bookingsList(appointments, "Cancelled");
            },
          ),
        ],
      ),
    );
  }

  // BOOKINGS LIST BUILDER
  Widget _bookingsList(List<Appointment> data, String type) {
    final String? patientId = SharedResources.userData.value['_id'];
    List<Appointment> appts;

    if (type == "Upcoming") {
      appts = data
          .where((a) =>
              a.patientId == patientId &&
              a.status != "Completed" &&
              a.status != "Cancelled")
          .toList();
    } else if (type == "Completed") {
      appts = data
          .where((a) => a.patientId == patientId && a.status == "Completed")
          .toList();
    } else {
      // Cancelled
      appts = data
          .where((a) => a.patientId == patientId && a.status == "Cancelled")
          .toList();
    }

    if (appts.isEmpty) {
      return Center(child: Text("No $type bookings"));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: appts.length,
      itemBuilder: (context, index) {
        final appt = appts[index];
        final doctor = SharedResources.doctors.value
            .firstWhereOrNull((d) => d.id == appt.doctorId);

        return bookingCard(
          context: context,
          date: "${appt.date} | ${appt.time}",
          doctorId: appt.doctorId,
          doctorName: doctor?.name ?? "Unknown Doctor",
          location: doctor?.location.label ?? "Clinic",
          bookingId: appt.id.length > 8
              ? "SC-${appt.id.substring(appt.id.length - 6).toUpperCase()}"
              : "SC-${appt.id.toUpperCase()}",
          doctorImage: doctor?.image ?? "assets/images/Jane.jpg",
          appt: appt,
          doctor: doctor,
        );
      },
    );
  }

  // BOOKING CARD WIDGET
  Widget bookingCard({
    required BuildContext context,
    required String date,
    required String doctorId,
    required String doctorName,
    required String location,
    required String bookingId,
    required String doctorImage,
    required Appointment appt,
    required Doctor? doctor,
  }) {
    String imageUrl = AppConfig.getImageUrl(doctorImage);

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // DATE
          Text(
            date,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 10),
          const Divider(height: 1, color: Color.fromARGB(255, 234, 234, 234)),
          const SizedBox(height: 15),

          // DOCTOR DETAILS
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: doctorImage.startsWith('assets')
                    ? Image.asset(
                        doctorImage,
                        height: 70,
                        width: 70,
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        imageUrl,
                        height: 70,
                        width: 70,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Image.asset(
                          "assets/images/Jane.jpg",
                          height: 70,
                          width: 70,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctorName,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: AppColors.primaryColor,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            location,
                            softWrap: true,
                            overflow: TextOverflow.visible,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.badge_outlined,
                          size: 16,
                          color: AppColors.primaryColor,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            "Booking ID: $bookingId",
                            softWrap: true,
                            overflow: TextOverflow.visible,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w500,
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

          const SizedBox(height: 15),
          const Divider(height: 1, color: Color.fromARGB(255, 234, 234, 234)),
          const SizedBox(height: 15),

          // BUTTONS
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryColor,
                side: BorderSide(
                  color: AppColors.primaryColor.withValues(alpha: .4),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () {
                if (doctor != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          AppointmentDetails(appointment: appt, doctor: doctor),
                    ),
                  );
                }
              },
              child: const Text("View Appointment"),
            ),
          ),
        ],
      ),
    );
  }
}