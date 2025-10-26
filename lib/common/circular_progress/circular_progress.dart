import 'package:flutter/material.dart';
import '../../utils/constants/colors.dart';

class CircularProgress extends StatelessWidget {
  const CircularProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        height: 30,
        width: 30,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(TColors.primary),
        ),
      ),
    );
  }
}
