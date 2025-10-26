import 'package:flutter/material.dart';
import 'package:my_inventory/utils/constants/colors.dart';
import 'package:my_inventory/utils/constants/sizes.dart';
import 'package:my_inventory/utils/helpers/helper_functions.dart';

class ProfileContainer extends StatelessWidget {
  const ProfileContainer({super.key, required this.content});

  final Widget content;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Container(
      decoration: BoxDecoration(
        color:
            dark
                ? TColors.dark.withOpacity(0.8)
                : TColors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
      ),
      child: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace / 1.5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [content],
        ),
      ),
    );
  }
}
