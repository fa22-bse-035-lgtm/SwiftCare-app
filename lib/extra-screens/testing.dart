// import 'package:flutter/material.dart';
// import '../services/api_service.dart'; // adjust path

// class DoctorsPatientsScreen extends StatefulWidget {
//   const DoctorsPatientsScreen({super.key});

//   @override
//   State<DoctorsPatientsScreen> createState() => _DoctorsPatientsScreenState();
// }

// class _DoctorsPatientsScreenState extends State<DoctorsPatientsScreen> {
//   late Future<List<dynamic>> doctorsFuture;
//   late Future<List<dynamic>> patientsFuture;

//   @override
//   void initState() {
//     super.initState();
//     doctorsFuture = ApiService.getDoctors();
//     patientsFuture = ApiService.getPatients();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Doctors & Patients"),
//         backgroundColor: Colors.blue,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // -------------------- DOCTORS --------------------
//             const Text(
//               "Doctors",
//               style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),

//             FutureBuilder<List<dynamic>>(
//               future: doctorsFuture,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(
//                     child: Padding(
//                       padding: EdgeInsets.all(20),
//                       child: CircularProgressIndicator(),
//                     ),
//                   );
//                 }

//                 if (snapshot.hasError) {
//                   return Text("Error: ${snapshot.error}");
//                 }

//                 final doctors = snapshot.data ?? [];

//                 return ListView.builder(
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemCount: doctors.length,
//                   itemBuilder: (context, index) {
//                     final doctor = doctors[index];
//                     return Card(
//                       elevation: 2,
//                       margin: const EdgeInsets.symmetric(vertical: 6),
//                       child: ListTile(
//                         leading: const Icon(Icons.medical_services, color: Colors.blue),
//                         title: Text(doctor["name"] ?? "Unknown"),
//                         subtitle: Text(doctor["speciality"] ?? ""),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),

//             const SizedBox(height: 25),

//             // -------------------- PATIENTS --------------------
//             const Text(
//               "Patients",
//               style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),

//             FutureBuilder<List<dynamic>>(
//               future: patientsFuture,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(
//                     child: Padding(
//                       padding: EdgeInsets.all(20),
//                       child: CircularProgressIndicator(),
//                     ),
//                   );
//                 }

//                 if (snapshot.hasError) {
//                   return Text("Error: ${snapshot.error}");
//                 }

//                 final patients = snapshot.data ?? [];

//                 return ListView.builder(
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemCount: patients.length,
//                   itemBuilder: (context, index) {
//                     final patient = patients[index];
//                     return Card(
//                       elevation: 2,
//                       margin: const EdgeInsets.symmetric(vertical: 6),
//                       child: ListTile(
//                         leading: const Icon(Icons.person, color: Colors.green),
//                         title: Text(patient["name"] ?? "Unknown"),
//                         subtitle: Text(patient["location"] ?? ""),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
