import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swiftcare/screens/onboarding/auth/sign_in.dart';
import 'package:swiftcare/utils/app_theme.dart';
import 'widgets/navigation_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await dotenv.load(fileName: ".env");

  // final token = dotenv.env['MAPBOX_TOKEN'];

  // if (token == null || token.isEmpty) {
  //   throw Exception("MAPBOX_TOKEN is missing in .env file");
  // }

  // MapboxOptions.setAccessToken(token);
  runApp(
    ChangeNotifierProvider(
      create: (context) => NavigationProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SwiftCare',
      theme: AppTheme.lightTheme,
      home: const SignIn(),
    );
  }
}
