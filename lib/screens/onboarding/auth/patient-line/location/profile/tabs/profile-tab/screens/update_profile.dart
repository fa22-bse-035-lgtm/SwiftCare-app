import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swiftcare/services/api_service.dart';
import 'package:swiftcare/services/colors.dart';
import 'package:swiftcare/widgets/app_bar.dart';

class UpdateProfile extends StatefulWidget {
  final dynamic currUser;
  const UpdateProfile({super.key, this.currUser});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController locationController;
  late TextEditingController ageController;

  String selectedGender = "";

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.currUser["name"] ?? "");

    phoneController = TextEditingController(
      text: widget.currUser["phone"] ?? "",
    );

    locationController = TextEditingController(
      text: widget.currUser["location"]["label"] ?? "",
    );

    ageController = TextEditingController(
      text: widget.currUser["age"]?.toString() ?? "",
    );

    selectedGender = widget.currUser["gender"] ?? "Male";
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    locationController.dispose();
    ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,

      appBar: CustomAppBar(color: true, title: "Your Profile"),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// PROFILE AVATAR
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                const CircleAvatar(
                  radius: 55,
                  backgroundImage: AssetImage("assets/images/Jane.jpg"),
                ),
                Container(
                  height: 36,
                  width: 36,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryColor,
                  ),
                  child: const Icon(Icons.edit, color: Colors.white, size: 20),
                ),
              ],
            ),

            const SizedBox(height: 30),

            /// NAME
            _label("Name"),
            _textField(controller: nameController),

            const SizedBox(height: 18),

            /// PHONE
            _label("Contact Number"),
            _textField(controller: phoneController),

            const SizedBox(height: 18),

            /// LOCATION
            _label("Location"),
            _textField(controller: locationController),

            const SizedBox(height: 18),

            /// AGE
            _label("Age"),
            _textField(controller: ageController, isNumber: true),

            const SizedBox(height: 18),

            /// GENDER
            _label("Gender"),

            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: _boxDecoration(),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedGender,
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded),
                  items: ["Male", "Female", "Other"]
                      .map(
                        (gender) => DropdownMenuItem(
                          value: gender,
                          child: Text(
                            gender,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedGender = value!;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 40),

            /// UPDATE BUTTON
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  ApiService().updatePatientProfile(
                    name: nameController.text,
                    phone: phoneController.text,
                    locationLabel: locationController.text,
                    coordinates: widget.currUser.location["coordinates"],
                    age: ageController.text,
                    gender: selectedGender,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Profile Updated Successfully"),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  "Update Profile",
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    bool isNumber = false,
  }) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: _boxDecoration(),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
        decoration: const InputDecoration(border: InputBorder.none),
      ),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: const Color.fromARGB(255, 225, 225, 225)),
    );
  }
}
