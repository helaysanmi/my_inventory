import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_inventory/features/authentication/login/login_screen.dart';
import 'package:my_inventory/features/settings/widget/category.dart';
import 'package:my_inventory/features/settings/widget/category_container.dart';
import 'package:my_inventory/features/settings/widget/profile_header.dart';
import 'package:my_inventory/utils/constants/colors.dart';
import 'package:my_inventory/utils/constants/sizes.dart';
import 'package:my_inventory/utils/helpers/helper_functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int? userId;
  String? businessName;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('userId');
    final name = prefs.getString('businessName');

    if (mounted) {
      setState(() {
        userId = id;
        businessName = name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Settings',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          centerTitle: true,
          backgroundColor: dark ? TColors.black : TColors.white,
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              ProfileHeader(user: businessName ?? ''),
              const SizedBox(height: TSizes.spaceBtwSections),
              ProfileContainer(
                content: Column(
                  children: [
                    CategoryDetails(
                      text: 'Term of Use',
                      color: TColors.primary,
                      icon: Iconsax.logout,
                      onTap: () {},
                    ),
                    const SizedBox(height: TSizes.sm),
                    Divider(thickness: 2),
                    const SizedBox(height: TSizes.sm),
                    CategoryDetails(
                      text: 'Log Out',
                      color: TColors.error,
                      icon: Iconsax.logout,
                      onTap: () {
                        _showLogoutDialog(context);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text(
              "Confirm Logout",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            content: Text(
              "Are you sure you want to log out?",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(
                  "Cancel",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              TextButton(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.clear();
                  Get.offAll(() => const LoginScreen());
                },
                child: Text(
                  'Logout',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge!.apply(color: TColors.error),
                ),
              ),
            ],
          ),
    );
  }
}
