import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:my_inventory/features/home/home_screen.dart';
import 'package:my_inventory/features/products/products_screen.dart';
import 'package:my_inventory/features/settings/settings_screen.dart';
import 'package:my_inventory/utils/constants/colors.dart';
import 'package:my_inventory/utils/constants/sizes.dart';
import 'package:my_inventory/utils/helpers/helper_functions.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    final dark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
      bottomNavigationBar: Obx(
        () => Container(
          padding: const EdgeInsets.symmetric(vertical: TSizes.defaultSpace),
          decoration: BoxDecoration(
            color: dark ? TColors.dark : TColors.navLBackground,
            border: const Border(
              top: BorderSide(color: Colors.black12, width: 0.5),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(controller.items.length, (index) {
              final item = controller.items[index];
              final isSelected = controller.selectedIndex.value == index;

              return GestureDetector(
                onTap: () => controller.selectedIndex.value = index,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration:
                      isSelected
                          ? BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: const LinearGradient(
                              colors: [TColors.primary, TColors.secondary],
                            ),
                          )
                          : null,
                  child: Row(
                    children: [
                      HeroIcon(
                        item.icon,
                        style:
                            isSelected
                                ? HeroIconStyle.solid
                                : HeroIconStyle.outline,
                        color:
                            isSelected
                                ? Colors.white
                                : dark
                                ? TColors.grey
                                : TColors.inactive,
                      ),
                      if (isSelected)
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            item.label,
                            style: Theme.of(
                              context,
                            ).textTheme.labelLarge!.apply(color: TColors.white),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class NavigationItem {
  final String label;
  final HeroIcons icon;
  final Widget screen;

  NavigationItem({
    required this.label,
    required this.icon,
    required this.screen,
  });
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final items = [
    NavigationItem(
      label: 'Home',
      icon: HeroIcons.home,
      screen: const HomeScreen(),
    ),
    NavigationItem(
      label: 'Products',
      icon: HeroIcons.cube,
      screen: ProductsScreen(),
    ),
    NavigationItem(
      label: 'Settings',
      icon: HeroIcons.cog6Tooth,
      screen: SettingsScreen(),
    ),
  ];

  List<Widget> get screens => items.map((e) => e.screen).toList();
}
