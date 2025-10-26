import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:my_inventory/common/button/button.dart';
import 'package:my_inventory/features/authentication/login/login_screen.dart';
import 'package:my_inventory/utils/constants/sizes.dart';

class SignupFeedbackScreen extends StatelessWidget {
  const SignupFeedbackScreen({super.key});

  Future<void> onExplore() async {
    Get.to(() => LoginScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Success',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 24),
                    Transform.scale(
                      scale: 2.5,
                      child: Lottie.asset(
                        'assets/json/successful.json',
                        height: 200,
                        width: 200,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
              RegularButton(
                text: 'Login & Explore',
                onPressed: onExplore,
                enabled: true,
              ),
              const SizedBox(height: TSizes.defaultSpace),
            ],
          ),
        ),
      ),
    );
  }
}
