import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:my_inventory/common/circular_progress/circular_progress.dart';
import 'package:my_inventory/features/products/add_new_product.dart';
import 'package:my_inventory/features/products/model/product_model.dart';
import 'package:my_inventory/features/products/widget/product_container.dart';
import 'package:my_inventory/utils/constants/colors.dart';
import 'package:my_inventory/utils/constants/sizes.dart';
import 'package:my_inventory/utils/helpers/database_helper.dart';
import 'package:my_inventory/utils/helpers/helper_functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List<ProductModel> productList = [];

  bool isLoading = false;
  bool isFetching = false;
  int? userId;
  String? businessName;
  @override
  void initState() {
    super.initState();
    _loadUserDetails();
  }

  Future<void> _loadUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('userId');
      businessName = prefs.getString('businessName');
    });

    if (userId != null) {
      _fetchProductFromLocalServer();
    }
  }

  Future<void> _fetchProductFromLocalServer() async {
    if (userId == null) return;

    try {
      setState(() => isFetching = true);
      final products = await DatabaseHelper.instance.getProductsByUser(userId!);

      setState(() {
        productList = products;
        isFetching = false;
      });
    } catch (e) {
      debugPrint('Error fetching products: $e');
      setState(() => isFetching = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Products',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        centerTitle: true,
        backgroundColor: dark ? TColors.black : TColors.white,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child:
                isLoading
                    ? const Center(child: CircularProgress())
                    : productList.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                      onRefresh: _fetchProductFromLocalServer,
                      child: ListView.builder(
                        itemCount: productList.length,
                        itemBuilder: (context, index) {
                          final item = productList[index];
                          return Padding(
                            padding: const EdgeInsets.only(
                              bottom: TSizes.spaceBtwItems,
                            ),
                            child: ProductContainer(
                              productAmount: item.productAmount,
                              productQuantity: item.productQuantity,
                              productName: item.productName,
                              productImage: item.productImage,
                              productId: item.productId!,
                              addedBy: item.addedBy,
                              userId: item.userId,
                            ),
                          );
                        },
                      ),
                    ),
          ),

          Positioned(
            bottom: TSizes.defaultSpace,
            right: TSizes.defaultSpace,
            child: GestureDetector(
              onTap: () async {
                await Get.to(
                  () => AddNewProduct(userId: userId, addedBy: businessName),
                );
                _fetchProductFromLocalServer();
              },
              child: Container(
                height: 60,

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  gradient: const LinearGradient(
                    colors: [TColors.primary, TColors.secondary],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(TSizes.spaceBtwItems),
                  child: Row(
                    children: [
                      Text(
                        'Add Product',
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium!.apply(color: TColors.white),
                      ),
                      Icon(Iconsax.add, size: 32, color: TColors.white),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset('assets/json/empty.json', height: 200),
            const SizedBox(height: TSizes.spaceBtwItems),
            Text(
              'No product found!',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: TSizes.defaultSpace * 2),
          ],
        ),
      ),
    );
  }
}
