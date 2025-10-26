import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_inventory/common/button/button.dart';
import 'package:my_inventory/common/circular_progress/circular_progress.dart';
import 'package:my_inventory/common/text_field/password_text_field.dart';
import 'package:my_inventory/common/text_field/text_field.dart';
import 'package:my_inventory/features/authentication/signup/signup_screen.dart';
import 'package:my_inventory/navigation_menu.dart';
import 'package:my_inventory/utils/constants/colors.dart';
import 'package:my_inventory/utils/constants/sizes.dart';
import 'package:my_inventory/utils/helpers/database_helper.dart';
import 'package:my_inventory/utils/helpers/encry_helper.dart';
import 'package:my_inventory/utils/helpers/helper_functions.dart';
import 'package:my_inventory/utils/validators/validation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  String? emailError;
  String? passwordError;

  bool isLoading = false;
  bool isEnabled = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    emailController.addListener(() {
      validateEmail();
      updateFormState();
    });

    passwordController.addListener(() {
      validatePassword();
      updateFormState();
    });

    emailFocusNode.addListener(() {
      if (!emailFocusNode.hasFocus) validateEmail();
    });

    passwordFocusNode.addListener(() {
      if (!passwordFocusNode.hasFocus) validatePassword();
    });
  }

  void validateEmail() {
    final email = emailController.text.trim();
    final error = TValidator.validateEmail(email);
    setState(() {
      emailError = error;
    });
  }

  void validatePassword() {
    final password = passwordController.text;
    final error = TValidator.validatePassword(password);
    setState(() {
      passwordError = error;
    });
  }

  void updateFormState() {
    final email = emailController.text.trim();
    final password = passwordController.text;

    setState(() {
      isEnabled =
          TValidator.validateEmail(email) == null &&
          TValidator.validatePassword(password) == null;
    });
  }

  final dbHelper = DatabaseHelper.instance;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> login() async {
    FocusScope.of(context).unfocus();
    setState(() {
      isLoading = true;
    });
    String hashedPassword = hashPassword(passwordController.text);
    try {
      final user = await dbHelper.loginUser(
        emailController.text,
        hashedPassword,
      );

      if (user != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('userId', user['id']);
        await prefs.setString('email', user['email']);
        await prefs.setString('businessName', user['businessName']);
        await prefs.setString('phoneNumber', user['phoneNumber']);
        await prefs.setBool('isLoggedIn', true);
        setState(() {
          isLoading = false;
        });
        Get.offAll(() => const NavigationMenu());
      } else {
        setState(() {
          isLoading = false;
        });
        Get.snackbar(
          'Failed',
          'Invalid email or password. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: TColors.error,
          colorText: TColors.white,
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      Get.snackbar(
        'Failed',
        'Failed to Login User!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: TColors.error,
        colorText: TColors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(
              'Login',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            centerTitle: true,
            backgroundColor: dark ? TColors.black : TColors.white,
          ),
          body: Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Well, Look Who’s Back!👋',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  SizedBox(height: TSizes.sm / 2),
                  Text(
                    'Let’s get you right where you left off.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),
                  //email Header
                  Text('Email', style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: TSizes.spaceBtwInputFields / 2),
                  //Fullname text input
                  TextInputField(
                    controller: emailController,
                    hintText: 'Enter your email address',
                    prefixIcon: Icon(Icons.mail),
                  ),

                  if (emailError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        emailError!,
                        style: Theme.of(
                          context,
                        ).textTheme.labelLarge!.apply(color: TColors.error),
                      ),
                    ),
                  const SizedBox(height: TSizes.spaceBtwInputFields),
                  //password Header
                  Text(
                    'Password',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: TSizes.spaceBtwInputFields / 2),
                  //password text input
                  PasswordTextField(
                    controller: passwordController,
                    hintText: 'Enter your password',
                    focusNode: passwordFocusNode,
                  ),

                  if (passwordError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        passwordError!,
                        style: Theme.of(
                          context,
                        ).textTheme.labelLarge!.apply(color: TColors.error),
                      ),
                    ),
                  const SizedBox(height: TSizes.sm),

                  const SizedBox(height: TSizes.spaceBtwSections),
                  isLoading
                      ? CircularProgress()
                      : RegularButton(
                        text: 'Sign In Using Password',
                        onPressed: isEnabled ? login : null,
                        enabled: isEnabled,
                      ),

                  const SizedBox(height: TSizes.spaceBtwSections),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'New To My Inventory? ',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      GestureDetector(
                        onTap: () => Get.to(() => const SignupScreen()),
                        child: Text(
                          'Register Now',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyLarge!.apply(color: TColors.primary),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
