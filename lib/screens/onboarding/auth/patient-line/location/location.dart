import 'package:flutter/material.dart';
import 'package:swiftcare/widgets/app_bar.dart';

class Location extends StatelessWidget {
  const Location({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Doctor Details',
        color: true,
        rightIcon1: Icons.check,
        rightIcon2: Icons.abc,
      ),
      body: const Center(child: Text('Permit Location Page Content')),
    );
  }
}
