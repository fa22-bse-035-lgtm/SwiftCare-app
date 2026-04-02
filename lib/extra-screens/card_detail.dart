// import 'package:swiftcare/screens/onboarding/auth/location/tabs/home-tab/level-1/level-2/level-3/level-4/4.review_summary.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:swiftcare/services/colors.dart';
// import 'package:swiftcare/services/shared_resource.dart';
// import 'package:swiftcare/services/stripe_service.dart';
// import 'package:swiftcare/widgets/app_bar.dart';

// class CardDetail extends StatefulWidget {
//   final Map<String, dynamic> appointment;

//   const CardDetail({super.key, required this.appointment});

//   @override
//   State<CardDetail> createState() => _CardDetailState();
// }

// class _CardDetailState extends State<CardDetail> {
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController numberController = TextEditingController();
//   final TextEditingController expiryController = TextEditingController();
//   final TextEditingController cvvController = TextEditingController();

//   bool loading = false;

//   @override
//   void initState() {
//     super.initState();
//     StripeService.init(
//       "pk_test_51T0Ro5CkWOavCMvfEk37QcFSZvYJQwhkxl1u4ocesV6QPVjDl6Peznx3ssLbs0MYfCON6aPVMnbYY5d5jRHzSunF00WMs3a8Fs",
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.backgroundColor,
//       appBar: CustomAppBar(title: "Card Details", color: true),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.only(left: 25, right: 25),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(height: 10),
//             // CREDIT CARD PREVIEW (UNCHANGED)
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(16),
//                 gradient: const LinearGradient(
//                   colors: [Color(0xFF3B82F6), Color(0xFF1E40AF)],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Align(
//                     alignment: Alignment.topRight,
//                     child: Image.asset("assets/images/visa.png", width: 60),
//                   ),
//                   const SizedBox(height: 28),
//                   Text(
//                     "0123 4567 8912 3456",
//                     style: GoogleFonts.poppins(
//                       fontSize: 20,
//                       color: Colors.white,
//                       letterSpacing: 2,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Card holder name",
//                             style: GoogleFonts.poppins(
//                               color: Colors.white70,
//                               fontSize: 12,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             "John Doe",
//                             style: GoogleFonts.poppins(color: Colors.white),
//                           ),
//                         ],
//                       ),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Expiry date",
//                             style: GoogleFonts.poppins(
//                               color: Colors.white70,
//                               fontSize: 12,
//                             ),
//                           ),
//                           SizedBox(height: 4),
//                           Text(
//                             "02/30",
//                             style: GoogleFonts.poppins(color: Colors.white),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 25),
//             // FORM FIELDS (UNCHANGED)
//             Text("Card Holder Name", style: GoogleFonts.poppins()),
//             const SizedBox(height: 6),
//             TextField(
//               controller: nameController,
//               decoration: inputDecoration(),
//             ),
//             const SizedBox(height: 20),
//             Text("Card Number", style: GoogleFonts.poppins()),
//             const SizedBox(height: 6),
//             TextField(
//               controller: numberController,
//               keyboardType: TextInputType.number,
//               decoration: inputDecoration(),
//             ),
//             const SizedBox(height: 20),
//             Row(
//               children: [
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("Expiry Date", style: GoogleFonts.poppins()),
//                       const SizedBox(height: 6),
//                       TextField(
//                         controller: expiryController,
//                         keyboardType: TextInputType.datetime,
//                         decoration: inputDecoration(),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("CVV", style: GoogleFonts.poppins()),
//                       const SizedBox(height: 6),
//                       TextField(
//                         controller: cvvController,
//                         keyboardType: TextInputType.number,
//                         decoration: inputDecoration(),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 40),
//           ],
//         ),
//       ),
//       bottomNavigationBar: Container(
//         padding: EdgeInsets.all(16),
//         child: ElevatedButton(
//           style: ElevatedButton.styleFrom(
//             backgroundColor: AppColors.primaryColor,
//             minimumSize: Size(double.infinity, 55),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(14),
//             ),
//           ),
//           onPressed: loading
//               ? null
//               : () async {
//                   Map<String, dynamic> card = {
//                     "cardHolder": nameController.text.trim(),
//                     "cardNumber": numberController.text.trim(),
//                     "expiry": expiryController.text.trim(),
//                     "cvv": cvvController.text.trim(),
//                   };

//                   if (card.values.any((e) => e.isEmpty)) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(content: Text("Please fill all fields")),
//                     );
//                     return;
//                   }

//                   try {
//                     setState(() {
//                       loading = true;
//                     });

//                     await StripeService.processPayment(
//                       cardHolder: card["cardHolder"],
//                       cardNumber: card["cardNumber"],
//                       expiry: card["expiry"],
//                       cvv: card["cvv"],
//                       amount: 500, // cents
//                     );

//                     // Proceed to next screen
//                     Map<String, dynamic> doctor = {};
//                     for (var doc in SharedResources.doctors.value) {
//                       if (doc["_id"] == widget.appointment["doctorId"]) {
//                         doctor = doc;
//                       }
//                     }

//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => ReviewSummary(
//                           doc: doctor,
//                           appointment: widget.appointment,
//                           card: card,
//                         ),
//                       ),
//                     );
//                   } catch (e) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text("❌ Payment Failed: $e")),
//                     );
//                   } finally {
//                     setState(() {
//                       loading = false;
//                     });
//                   }
//                 },
//           child: Text(
//             "Next",
//             style: GoogleFonts.poppins(
//               fontSize: 17,
//               fontWeight: FontWeight.w600,
//               color: Colors.white,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   InputDecoration inputDecoration() {
//     return InputDecoration(
//       filled: true,
//       fillColor: Colors.white,
//       contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
//       isDense: true,
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(10),
//         borderSide: const BorderSide(
//           color: Color.fromARGB(255, 206, 206, 206),
//           width: 1,
//         ),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(10),
//         borderSide: const BorderSide(
//           color: Color.fromARGB(255, 206, 206, 206),
//           width: 1,
//         ),
//       ),
//     );
//   }
// }
