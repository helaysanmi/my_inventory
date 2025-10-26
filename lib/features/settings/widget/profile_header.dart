import 'package:flutter/material.dart';
import 'package:my_inventory/utils/constants/colors.dart';
import 'package:my_inventory/utils/constants/image_strings.dart';
import 'package:my_inventory/utils/constants/sizes.dart';
import 'package:my_inventory/utils/helpers/helper_functions.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.user});

  final String user;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Row(
      children: [
        Container(
          width: 60,
          height: 60,
          padding: const EdgeInsets.all(TSizes.sm / 2),
          decoration: BoxDecoration(
            color: dark ? TColors.darkerGrey : TColors.grey,
            borderRadius: BorderRadius.circular(100),
          ),
          child: const Center(child: Image(image: AssetImage(TImages.user))),
        ),
        const SizedBox(width: TSizes.sm * 2),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: TSizes.sm),
            GestureDetector(
              onTap: () {},
              child: Text(
                'Profile Details',
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
