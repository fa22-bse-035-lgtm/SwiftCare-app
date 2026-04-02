import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swiftcare/screens/onboarding/auth/patient-line/location/profile/tabs/bookings-tab/appointment-details/booking_details.dart';
import 'package:swiftcare/services/colors.dart';
import 'package:swiftcare/services/helper_functions.dart';
import 'package:swiftcare/services/shared_resource.dart';

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
          ValueListenableBuilder<List<dynamic>>(
            valueListenable: SharedResources.appointments,
            builder: (context, appointments, _) {
              return _upcomingBookings(appointments);
            },
          ),
          const Center(child: Text("No completed bookings")),
          const Center(child: Text("No cancelled bookings")),
        ],
      ),
    );
  }

  // UPCOMING BOOKINGS LIST
  Widget _upcomingBookings(List<dynamic> data) {
    // appointments list coming from API
    final List<dynamic> appts = data;

    if (appts.isEmpty) {
      return const Center(child: Text("No upcoming bookings"));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: appts.length,
      itemBuilder: (context, index) {
        final appt = appts[index];

        return bookingCard(
          date: "${appt["date"]} - ${appt["time"]}",
          doctorId: appt["doctorId"] ?? "null",
          doctorName: appt["doctorName"] ?? "Unknown Doctor",
          location: "Clinic", // because API does not send clinic location
          // bookingId: "#${appt["_id"]}",
          bookingId: "SC-Fa2324",
          doctorImage: "assets/images/Jane.jpg", // image from assets
          appt: appt,
        );
      },
    );
  }

  // BOOKING CARD WIDGET
  Widget bookingCard({
    required String date,
    required String doctorId,
    required String doctorName,
    required String location,
    required String bookingId,
    required String doctorImage,
    required dynamic appt,
  }) {
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
                child: Image.asset(
                  doctorImage,
                  height: 70,
                  width: 70,
                  fit: BoxFit.cover,
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
                Map<String, dynamic> doc = HelperFunctions().getDoctorById(
                  doctorId,
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        AppointmentDetails(appointment: appt, doctor: doc),
                  ),
                );
              },
              child: const Text("View Appointment"),
            ),
          ),
        ],
      ),
    );
  }
}