import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_inventory/common/button/button.dart';
import 'package:my_inventory/common/circular_progress/circular_progress.dart';
import 'package:my_inventory/common/text_field/password_text_field.dart';
import 'package:my_inventory/common/text_field/phone_text_field.dart';
import 'package:my_inventory/common/text_field/text_field.dart';
import 'package:my_inventory/features/authentication/login/login_screen.dart';
import 'package:my_inventory/features/authentication/signup/signup_feedback.dart';
import 'package:my_inventory/utils/constants/colors.dart';
import 'package:my_inventory/utils/constants/sizes.dart';
import 'package:my_inventory/utils/helpers/database_helper.dart';
import 'package:my_inventory/utils/helpers/encry_helper.dart';
import 'package:my_inventory/utils/helpers/helper_functions.dart';
import 'package:my_inventory/utils/validators/validation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final passwordController = TextEditingController();
  final bnameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  final bnameFocusNode = FocusNode();
  final phoneFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final emailFocusNode = FocusNode();

  String? passwordError;
  String? nameError;
  String? phoneError;
  String? emailError;
  String errorMessage = '';

  String phoneCode = '';

  bool isLoading = false;
  bool isEnabled = false;

  @override
  void initState() {
    super.initState();

    phoneController.addListener(() {
      validatePhone();
      updateFormState();
    });

    emailController.addListener(() {
      validateEmail();
      updateFormState();
    });

    passwordController.addListener(() {
      validatePassword();
      updateFormState();
    });

    bnameController.addListener(() {
      validateFullname();
      updateFormState();
    });

    phoneFocusNode.addListener(() {
      if (!phoneFocusNode.hasFocus) validatePhone();
    });

    emailFocusNode.addListener(() {
      if (!emailFocusNode.hasFocus) validateEmail();
    });

    passwordFocusNode.addListener(() {
      if (!passwordFocusNode.hasFocus) validatePassword();
    });

    bnameFocusNode.addListener(() {
      if (!bnameFocusNode.hasFocus) validateFullname();
    });
  }

  void validatePhone() {
    final phone = phoneController.text.trim();
    final error = TValidator.validatePhoneNumber(phone);
    setState(() {
      phoneError = error;
    });
  }

  void validateEmail() {
    final email = emailController.text;
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

  void validateFullname() {
    final fullname = bnameController.text;
    final error = TValidator.validateName(fullname);
    setState(() {
      nameError = error;
    });
  }

  void updateFormState() {
    final phone = phoneController.text.trim();
    final email = emailController.text;
    final password = passwordController.text;
    final name = bnameController.text;

    setState(() {
      isEnabled =
          TValidator.validatePhoneNumber(phone) == null &&
          TValidator.validateName(name) == null &&
          TValidator.validateEmail(email) == null &&
          TValidator.validatePassword(password) == null;
    });
  }

  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    phoneFocusNode.dispose();
    passwordFocusNode.dispose();
    bnameController.dispose();
    bnameFocusNode.dispose();
    emailController.dispose();
    emailFocusNode.dispose();
    super.dispose();
  }

  Future<void> loadPhoneCode() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCode = prefs.getString('selectedPhoneCode');
    setState(() {
      phoneCode = savedCode ?? 'No code selected';
    });
  }

  Future<void> registerUser() async {
    FocusScope.of(context).unfocus();
    setState(() {
      isLoading = true;
    });
    String hashedPassword = hashPassword(passwordController.text);
    await loadPhoneCode();
    final fullPhoneNumber = '$phoneCode${phoneController.text}';

    try {
      await dbHelper.registerUser(
        emailController.text,
        hashedPassword,
        bnameController.text,
        fullPhoneNumber,
      );
      setState(() {
        isLoading = false;
      });
      Get.offAll(() => const SignupFeedbackScreen());
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      Get.snackbar(
        'Failed',
        'User already exist!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: TColors.error,
        colorText: TColors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Register',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        centerTitle: true,
        backgroundColor: dark ? TColors.black : TColors.white,
        leading: IconButton(
          icon: Icon(
            Iconsax.arrow_left_2,
            color: dark ? TColors.white : TColors.dark,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create A New Account',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              SizedBox(height: TSizes.sm / 2),
              Text(
                'Let’s Get You Started With Vibe Planner',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              //Fullname Header
              Text(
                'Business Name',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields / 2),
              //Fullname text input
              TextInputField(
                controller: bnameController,
                hintText: 'Enter your business name',
                prefixIcon: Icon(Icons.house),
              ),

              if (nameError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    nameError!,
                    style: Theme.of(
                      context,
                    ).textTheme.labelLarge!.apply(color: TColors.error),
                  ),
                ),

              const SizedBox(height: TSizes.spaceBtwInputFields),

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
              //Phone number Header
              Text(
                'Phone Number',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields / 2),
              //Phone Number
              PhoneTextField(
                hintText: 'Enter your phone number',
                controller: phoneController,
              ),

              if (phoneError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    phoneError!,
                    style: Theme.of(
                      context,
                    ).textTheme.labelLarge!.apply(color: TColors.error),
                  ),
                ),

              const SizedBox(height: TSizes.spaceBtwInputFields),

              //password Header
              Text('Password', style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: TSizes.spaceBtwInputFields / 2),
              //password text input
              PasswordTextField(
                controller: passwordController,
                hintText: 'Enter your password',
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

              const SizedBox(height: TSizes.spaceBtwSections),
              isLoading
                  ? CircularProgress()
                  : RegularButton(
                    text: 'Register Using Password',
                    onPressed: isEnabled ? registerUser : null,
                    enabled: isEnabled,
                  ),
              const SizedBox(height: TSizes.sm),
              Text(
                errorMessage,
                style: Theme.of(
                  context,
                ).textTheme.labelLarge!.apply(color: TColors.error),
              ),

              const SizedBox(height: TSizes.sm),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  GestureDetector(
                    onTap: () => Get.to(() => const LoginScreen()),
                    child: Text(
                      'Login Now',
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
    );
  }
}
