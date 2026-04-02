import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swiftcare/services/api_service.dart';
import 'package:swiftcare/services/colors.dart';
import 'dart:convert';
import 'package:swiftcare/services/stripe_service.dart';

class PaymentButton extends StatefulWidget {
  final int amount;
  final VoidCallback onSuccess;

  const PaymentButton({
    super.key,
    required this.amount,
    required this.onSuccess,
  });

  @override
  State<PaymentButton> createState() => _PaymentButtonState();
}

class _PaymentButtonState extends State<PaymentButton> {
  bool loading = false;

  @override
  void initState() {
    super.initState();
    StripeService.init(
      "pk_test_51T0Ro5CkWOavCMvfEk37QcFSZvYJQwhkxl1u4ocesV6QPVjDl6Peznx3ssLbs0MYfCON6aPVMnbYY5d5jRHzSunF00WMs3a8Fs",
    );
  }

  Future<void> makePayment() async {
    try {
      setState(() => loading = true);

      final response = await ApiService().request(
        '/payment/create-intent',
        method: 'POST',
        body: {"amount": widget.amount},
        requiresAuth: true,
      );

      final data = jsonDecode(response.body);
      String clientSecret = data["clientSecret"];

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: "SwiftCare",
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      widget.onSuccess();
    } catch (e) {
      print("Stripe Error: $e");
      if(mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Payment Failed")));
      }
    } finally {
      if(mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: loading ? null : makePayment,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        minimumSize: const Size(double.infinity, 55),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      child: loading
          ? const CircularProgressIndicator(color: Colors.white)
          : Text(
              "Pay Now",
              style: GoogleFonts.poppins(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
    );
  }
}
