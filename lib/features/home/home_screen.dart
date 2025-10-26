import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:my_inventory/common/circular_progress/circular_progress.dart';
import 'package:my_inventory/features/home/widget/overview_card.dart';
import 'package:my_inventory/utils/constants/colors.dart';
import 'package:my_inventory/utils/constants/sizes.dart';
import 'package:my_inventory/utils/helpers/database_helper.dart';
import 'package:my_inventory/utils/helpers/helper_functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int? userId;
  String? businessName;
  final dbHelper = DatabaseHelper.instance;
  var userProductCount = 0.obs;

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

    if (id != null) {
      await fetchUserProductCount(id);
    }
  }

  Future<void> fetchUserProductCount(int userId) async {
    final count = await dbHelper.getUserProductCount(userId.toString());
    userProductCount.value = count;
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.only(left: TSizes.defaultSpace),
          child: CircleAvatar(
            backgroundColor:
                dark
                    ? TColors.dark.withOpacity(0.8)
                    : TColors.grey.withOpacity(0.2),
            child: HeroIcon(HeroIcons.cube, size: 30, color: TColors.primary),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome Back!',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            businessName != null
                ? Text(
                  '$businessName 👋',
                  style: Theme.of(context).textTheme.headlineSmall,
                )
                : CircularProgress(),
          ],
        ),
        backgroundColor: dark ? TColors.black : TColors.white,

        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: TSizes.defaultSpace),
            child: Icon(Iconsax.notification),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Stock Overview',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge!.apply(fontWeightDelta: 2),
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),
              Obx(
                () => Row(
                  children: [
                    Expanded(
                      child: OverviewCard(
                        title: 'Products',
                        amount: '${userProductCount.value}',
                        color: const Color.fromARGB(255, 240, 64, 108),
                        icon: Iconsax.document,
                      ),
                    ),
                    const SizedBox(width: TSizes.spaceBtwItems),

                    Expanded(
                      child: OverviewCard(
                        title: 'Total Sales',
                        amount: '0',
                        color: const Color.fromARGB(255, 238, 104, 137),
                        icon: Iconsax.chart_success,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: TSizes.spaceBtwItems),

              Row(
                children: [
                  Expanded(
                    child: OverviewCard(
                      amountCat: true,
                      title: 'Revenue',
                      amount: '0.00',
                      color: const Color.fromARGB(255, 44, 122, 89),
                      icon: Iconsax.dollar_circle,
                    ),
                  ),
                  const SizedBox(width: TSizes.spaceBtwItems),

                  Expanded(
                    child: OverviewCard(
                      title: 'Returns',
                      amount: '0',
                      color: TColors.primary,
                      icon: Iconsax.arrow_circle_left,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: TSizes.spaceBtwInputFields),
              Text(
                'Recent Transactions',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge!.apply(fontWeightDelta: 2),
              ),

              Center(
                child: Lottie.asset('assets/json/empty.json', height: 200),
              ),

              Center(
                child: Text(
                  'No transaction found!',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
