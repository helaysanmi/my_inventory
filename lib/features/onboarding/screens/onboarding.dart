import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_inventory/features/onboarding/controllers/onboarding_controller.dart';
import 'package:my_inventory/features/onboarding/screens/widget/onboarding_dot_navigation.dart';
import 'package:my_inventory/features/onboarding/screens/widget/onboarding_next_page.dart';
import 'package:my_inventory/features/onboarding/screens/widget/onboarding_page.dart';
import 'package:my_inventory/features/onboarding/screens/widget/onboarding_skip%20copy.dart';
import 'package:my_inventory/utils/constants/colors.dart';
import 'package:my_inventory/utils/constants/image_strings.dart';
import 'package:my_inventory/utils/constants/text_strings.dart';
import 'package:my_inventory/utils/helpers/helper_functions.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnBoardingController());
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: dark ? TColors.black : TColors.white,
        actions: [OnBoardingSkipC()],
      ),
      body: Stack(
        children: [
          //Horizontal Scrolable pages
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.updatePageIndicator,
            children: const [
              OnBoardingPage(
                image: TImages.onBoardingImage1,
                title: TTexts.onBoardingTitle1,
                subTitle: TTexts.onBoardingSubTitle1,
              ),
              OnBoardingPage(
                image: TImages.onBoardingImage2,
                title: TTexts.onBoardingTitle2,
                subTitle: TTexts.onBoardingSubTitle2,
              ),
              OnBoardingPage(
                image: TImages.onBoardingImage3,
                title: TTexts.onBoardingTitle3,
                subTitle: TTexts.onBoardingSubTitle3,
              ),
            ],
          ),

          // Skip Button
          // const OnBoardingSkip(),

          //Dot Navigation SmoothPageIndicator
          const OnBoardingDotNavigation(),

          //Circular Button
          const OnBoardingNextButton(),
        ],
      ),
    );
  }
}
