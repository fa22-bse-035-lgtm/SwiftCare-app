import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:swiftcare/screens/onboarding/auth/patient-line/location/permit.dart';
import 'package:uicons/uicons.dart';
import 'package:swiftcare/services/auth_service.dart';
import 'package:swiftcare/services/colors.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool showPassword = false;
  bool _agreed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "Create Account",
                    style: GoogleFonts.poppins(
                      fontSize: 24, // smaller
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                Center(
                  child: Text(
                    "Fill your information below or register\nwith your social account",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: Colors.black54,
                      fontSize: 13,
                    ), // smaller
                  ),
                ),
                const SizedBox(height: 40),

                // EMAIL LABEL
                Text(
                  "Email",
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ), // smaller
                ),
                const SizedBox(height: 3),

                // EMAIL FIELD
                SizedBox(
                  height: 42,
                  child: TextField(
                    controller: emailController,
                    style: GoogleFonts.poppins(fontSize: 15),
                    decoration: InputDecoration(
                      hintText: "example@gmail.com",
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 13.8,
                        color: const Color.fromARGB(255, 172, 172, 172),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 12,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFB0BEC5)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Color(0xFF90A4AE),
                          width: 1.5,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // PASSWORD LABEL
                Text(
                  "Password",
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ), // smaller
                ),
                const SizedBox(height: 3),

                // PASSWORD FIELD WITH EYE ICON
                SizedBox(
                  height: 42,
                  child: TextField(
                    controller: passwordController,
                    obscureText: !showPassword,
                    style: GoogleFonts.poppins(fontSize: 15),
                    decoration: InputDecoration(
                      hintText: "********",
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 13.8,
                        color: const Color.fromARGB(255, 172, 172, 172),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 12,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFB0BEC5)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Color(0xFF90A4AE),
                          width: 1.5,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          showPassword
                              ? UIcons.regularStraight.eye
                              : UIcons.regularStraight.crossed_eye,
                          color: AppColors.primaryColor,
                        ),
                        onPressed: () {
                          setState(() {
                            showPassword = !showPassword;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),

                // Terms & Conditions Checkbox
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min, // shrink Row to fit content
                  children: [
                    StatefulBuilder(
                      builder: (context, setStateSB) {
                        return Checkbox(
                          value: _agreed,
                          onChanged: (val) {
                            _agreed = val ?? false;
                            setStateSB(() {});
                          },
                          activeColor: AppColors.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          materialTapTargetSize: MaterialTapTargetSize
                              .shrinkWrap, // remove default padding
                        );
                      },
                    ),
                    Text(
                      "Agree with ",
                      style: GoogleFonts.poppins(fontSize: 13),
                    ),
                    GestureDetector(
                      onTap: () {
                        // handle tap
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: AppColors.primaryColor,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Text(
                          "Terms and condition",
                          style: GoogleFonts.poppins(
                            color: AppColors.primaryColor,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      String email = emailController.text.trim();
                      String password = passwordController.text.trim();

                      if (email.isEmpty || password.isEmpty) {
                        showMessage("Error", "All fields are required.");
                        return;
                      }

                      if (!_agreed) {
                        showMessage(
                          "Error",
                          "You must agree to Terms & Conditions.",
                        );
                        return;
                      }

                      if (!email.contains("@") || !email.contains(".")) {
                        showMessage("Error", "Enter a valid email address.");
                        return;
                      }

                      if (password.length < 6) {
                        showMessage(
                          "Error",
                          "Password must be at least 6 characters.",
                        );
                        return;
                      }

                      // loading popup
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) =>
                            const Center(child: CircularProgressIndicator()),
                      );

                      try {
                        await AuthService().signUp(email, password);

                        if (!context.mounted) return;
                        Navigator.pop(context); // close loader

                        if (!context.mounted) return;

                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (_) => const Permit()),
                        // );
                      } catch (e) {
                        Navigator.pop(context);
                        showError(e.toString());
                      }
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 11),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(29),
                      ),
                    ),
                    child: Text(
                      "Sign Up",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                // --- Social sign in section ---
                const SizedBox(height: 30),
                Row(
                  children: [
                    const Expanded(
                      child: Divider(
                        color: AppColors.divider,
                        thickness: 1,
                        endIndent: 12,
                      ),
                    ),
                    Text(
                      'or sign up with',
                      style: GoogleFonts.poppins(
                        color: Colors.grey,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const Expanded(
                      child: Divider(
                        color: AppColors.divider,
                        thickness: 1,
                        indent: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _SocialIconButton(
                      icon: UIcons.brands.google,
                      color: Colors.red,
                      onTap: () async {
                        try {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );

                          await AuthService().signInWithGoogle();

                          if (!context.mounted) return;
                          Navigator.pop(context); // close loader
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(builder: (_) => const Permit()),
                          // );
                        } catch (e) {
                          Navigator.pop(context);
                          showError(e.toString().replaceAll("Exception: ", ""));
                        }
                      },
                    ),
                    const SizedBox(width: 18),
                    _SocialIconButton(
                      icon: UIcons.brands.facebook,
                      color: Colors.blue,
                      onTap: () {},
                    ),
                    const SizedBox(width: 18),
                    _SocialIconButton(
                      icon: UIcons.brands.twitter,
                      color: Colors.black,
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Navigate to sign in screen
                          Navigator.pushNamed(context, '/signin');
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: AppColors.primaryColor,
                                width: 1,
                              ),
                            ),
                          ),
                          child: Text(
                            "Sign In",
                            style: GoogleFonts.poppins(
                              color: AppColors.primaryColor,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showMessage(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void showError(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}

// Social icon button widget
class _SocialIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _SocialIconButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300, width: 1.5),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(child: Icon(icon, color: color, size: 21)),
      ),
    );
  }
}
