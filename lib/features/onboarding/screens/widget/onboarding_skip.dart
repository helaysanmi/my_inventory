import 'package:flutter/material.dart';
import 'package:my_inventory/features/onboarding/controllers/onboarding_controller.dart';
import 'package:my_inventory/utils/constants/colors.dart';
import 'package:my_inventory/utils/constants/sizes.dart';
import 'package:my_inventory/utils/helpers/helper_functions.dart';

class OnBoardingSkip extends StatelessWidget {
  const OnBoardingSkip({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Positioned(
      //top: TDeviceUtils.getAppBarHeight(),
      right: TSizes.defaultSpace,
      child: Container(
        width: 65.0,
        height: 40.0,
        decoration: BoxDecoration(
          color:
              dark
                  ? TColors.dark.withOpacity(0.8)
                  : TColors.grey.withOpacity(0.3), // Transparent background
          borderRadius: BorderRadius.circular(40.0),
          border: Border.all(
            color: dark ? TColors.darkerGrey : TColors.grey,
            width: 2.0,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 1.0, vertical: 1.0),
        child: TextButton(
          onPressed: () => OnBoardingController.instance.skipPage(),
          child: Text(
            'Skip',
            style: TextStyle(color: dark ? TColors.textWhite : TColors.dark),
          ),
        ),
      ),
    );
  }
}
