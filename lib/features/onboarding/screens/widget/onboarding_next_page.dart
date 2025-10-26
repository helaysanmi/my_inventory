import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_inventory/features/onboarding/controllers/onboarding_controller.dart';
import 'package:my_inventory/utils/constants/colors.dart';
import 'package:my_inventory/utils/constants/sizes.dart';
import 'package:my_inventory/utils/device/device_utility.dart';
import 'package:my_inventory/utils/helpers/helper_functions.dart';

class OnBoardingNextButton extends StatelessWidget {
  const OnBoardingNextButton({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Positioned(
      right: TSizes.defaultSpace,
      bottom: TDeviceUtils.getBottomNavigationBarHeight(),
      child: ElevatedButton(
        onPressed: () => OnBoardingController.instance.nextPage(),
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          backgroundColor: dark ? TColors.white : TColors.primary,
          elevation: 0,
          side: BorderSide.none,
        ),
        child: Icon(
          Iconsax.arrow_right_3,
          color: dark ? TColors.primary : TColors.white,
        ),
      ),
    );
  }
}
