import 'package:flutter/material.dart';
import 'package:swiftcare/services/colors.dart';

class ExploreTab extends StatelessWidget {
  const ExploreTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.backgroundColor,
        child: const Center(child: Text('Coming Soon...')),
      ),
    );
  }
}
