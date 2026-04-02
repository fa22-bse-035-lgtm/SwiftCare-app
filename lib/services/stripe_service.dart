import 'package:flutter_stripe/flutter_stripe.dart';

class StripeService {
  static bool _initialized = false;

  static void init(String publishableKey) {
    if (!_initialized) {
      Stripe.publishableKey = publishableKey;
      _initialized = true;
    }
  }
}