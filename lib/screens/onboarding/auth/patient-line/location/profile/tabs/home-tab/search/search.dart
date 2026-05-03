import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swiftcare/models/doctor_model.dart';
import 'package:swiftcare/screens/onboarding/auth/patient-line/location/profile/tabs/home-tab/level-1/doctor_detail.dart';
import 'package:swiftcare/services/shared_resource.dart';
import 'package:swiftcare/utils/app_config.dart';

class SearchDoctors extends StatefulWidget {
  const SearchDoctors({super.key});

  @override
  State<SearchDoctors> createState() => _SearchDoctorsState();
}

class _SearchDoctorsState extends State<SearchDoctors> {
  final TextEditingController _searchController = TextEditingController();

  List<Doctor> _searchResults = [];

  void _searchDoctors(String query) {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    final doctors = SharedResources.doctors.value;

    // Break query into individual keywords
    final keywords = query.toLowerCase().trim().split(RegExp(r'\s+'));

    final results = doctors.where((doc) {
      final name = doc.name.toLowerCase();
      final specialization = doc.specialization.toLowerCase();

      final searchableText = "$name $specialization";

      // Check if ALL keywords exist in the searchable text
      return keywords.every((keyword) => searchableText.contains(keyword));
    }).toList();

    setState(() {
      _searchResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 227, 227, 227),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),

            /// Search Bar
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 249, 249, 249),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 26),
                    child: TextField(
                      controller: _searchController,
                      style: GoogleFonts.poppins(fontSize: 15),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Find Doctors...',
                        hintStyle: GoogleFonts.poppins(
                          color: const Color.fromARGB(255, 182, 182, 182),
                        ),
                      ),
                      autofocus: true,
                      onChanged: _searchDoctors,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            /// Results
            Expanded(child: DoctorResults(searchResults: _searchResults)),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class DoctorResults extends StatelessWidget {
  final List<Doctor> searchResults;

  const DoctorResults({super.key, required this.searchResults});

  @override
  Widget build(BuildContext context) {
    if (searchResults.isEmpty) {
      return const Center(
        child: Text('No doctors found.', style: TextStyle(fontSize: 16)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        final doctor = searchResults[index];

        String imagePath = doctor.image;
        String imageUrl = AppConfig.getImageUrl(imagePath);

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DoctorDetails(doctor: doctor),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.grey[200],
                  child: ClipOval(
                    child: imagePath.startsWith('assets')
                        ? Image.asset(
                            imagePath,
                            width: 56,
                            height: 56,
                            fit: BoxFit.cover,
                          )
                        : FadeInImage.assetNetwork(
                            placeholder: 'assets/images/default_doctor.png',
                            image: imageUrl,
                            width: 56,
                            height: 56,
                            fit: BoxFit.cover,
                            imageErrorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/images/default_doctor.png',
                                width: 56,
                                height: 56,
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctor.name,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        doctor.specialization,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
