import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swiftcare/models/doctor_model.dart';
import 'package:swiftcare/services/colors.dart';
import 'package:swiftcare/services/socket_service.dart';
import 'package:swiftcare/utils/app_config.dart';
import 'package:swiftcare/widgets/app_bar.dart';

class LiveQueue extends StatefulWidget {
  final Doctor doctor;
  final String shiftId;
  final int queueNumber;

  const LiveQueue({
    super.key,
    required this.doctor,
    required this.shiftId,
    required this.queueNumber,
  });

  @override
  State<LiveQueue> createState() => _LiveQueueState();
}

class _LiveQueueState extends State<LiveQueue> {
  final SocketService socketService = SocketService();
  int currentServing = 0;
  late ImageProvider _avatarImage;

  @override
  void initState() {
    super.initState();
    _initAvatarImage();
    socketService.connect();
    socketService.joinQueueRoom(widget.shiftId);
    socketService.listenQueueUpdates((data) {
      if (mounted) {
        setState(() {
          currentServing = data["currentServing"];
        });
      }
    });
  }

  void _initAvatarImage() {
    String imagePath = widget.doctor.image;
    if (imagePath.startsWith('assets')) {
      _avatarImage = AssetImage(imagePath);
    } else {
      _avatarImage = NetworkImage(AppConfig.getImageUrl(imagePath));
    }
  }

  @override
  void dispose() {
    socketService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int patientsAhead = widget.queueNumber - currentServing;
    if (patientsAhead < 0) patientsAhead = 0;
    int waitMinutes = patientsAhead * 5;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,

      appBar: const CustomAppBar(color: true, title: "Live Queue"),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// STATUS CARD
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  /// Blue Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 28),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF1E66F5), Color(0xFF1CB5E0)],
                      ),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                    ),
                    child: Column(
                      children: const [
                        Icon(
                          Icons.person_pin_circle,
                          color: Colors.white,
                          size: 36,
                        ),
                        SizedBox(height: 6),
                        Text(
                          "Current Status",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "You are #${widget.queueNumber}",
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor.withValues(alpha: .15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                "LIVE",
                                style: GoogleFonts.poppins(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              color: AppColors.primaryColor,
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "Approx. $waitMinutes minutes wait",
                              style: GoogleFonts.poppins(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        Row(
                          children: [
                            const Icon(
                              Icons.local_hospital,
                              size: 18,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "Doctor seeing Patient #$currentServing",
                              style: GoogleFonts.poppins(
                                color: Colors.grey[700],
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// QUEUE PROGRESS
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Queue Progress",
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "$currentServing/${widget.queueNumber}",
                        style: GoogleFonts.poppins(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: widget.queueNumber > 0 ? currentServing / widget.queueNumber : 0,
                      minHeight: 10,
                      backgroundColor: Colors.grey.shade300,
                      color: AppColors.primaryColor,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      const Icon(Icons.check_circle, color: AppColors.primaryColor, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        patientsAhead <= 1 ? "Almost there! You’re next in line." : "Tracking your turn live.",
                        style: GoogleFonts.poppins(fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            /// ATTENDING DOCTOR
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Attending Doctor",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),

            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundImage: _avatarImage,
                    onBackgroundImageError: (_, __) {
                      setState(() {
                        _avatarImage = const AssetImage("assets/images/Jane.jpg");
                      });
                    },
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.doctor.name,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          widget.doctor.specialization,
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

            const SizedBox(height: 18),

            /// LIVE UPDATES HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Live Updates",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Text(
                  "Refreshed just now",
                  style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),

            const SizedBox(height: 10),

            /// UPDATE CARD
            _updateCard(
              "Patient #$currentServing called to Consultation Room",
              "Just now",
              isPrimary: true,
            ),

            _updateCard("Clinic is operating normally", "Today"),

            _updateCard("Your check-in confirmed", "Earlier"),
          ],
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
          onPressed: (){},
          child: Text(
            "Get notified when It's your turn",
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _updateCard(String text, String time, {bool isPrimary = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: isPrimary
            ? const Border(left: BorderSide(color: Color(0xFF1E66F5), width: 4))
            : null,
      ),
      child: Row(
        children: [
          const Icon(
            Icons.circle,
            size: 8,
            color: AppColors.primaryColor,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(text, style: GoogleFonts.poppins(fontSize: 14)),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}