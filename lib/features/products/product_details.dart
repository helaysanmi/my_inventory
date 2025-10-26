import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_inventory/common/button/button.dart';
import 'package:my_inventory/features/products/update_product.dart';
import 'package:my_inventory/navigation_menu.dart';
import 'package:my_inventory/utils/constants/colors.dart';
import 'package:my_inventory/utils/constants/image_strings.dart';
import 'package:my_inventory/utils/constants/sizes.dart';
import 'package:my_inventory/utils/helpers/database_helper.dart';
import 'package:my_inventory/utils/helpers/helper_functions.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({
    super.key,
    required this.productId,
    required this.productQuantity,
    required this.productImage,
    required this.productName,
    required this.productAmount,
    required this.addedBy,
    required this.userId,
  });

  final int productId;
  final int userId;
  final int productQuantity;
  final String productImage;
  final String productName;
  final double productAmount;
  final String addedBy;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          widget.productName,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: TColors.primary),
                borderRadius: BorderRadius.circular(8),
              ),
              child:
                  widget.productImage != ''
                      ? Image.file(
                        File(widget.productImage),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 200,
                      )
                      : Icon(Iconsax.box),
            ),

            const SizedBox(height: TSizes.spaceBtwInputFields),

            Row(
              children: [
                Text(
                  'Product ID: ',
                  style: Theme.of(
                    context,
                  ).textTheme.headlineSmall!.apply(fontWeightDelta: 2),
                ),
                Expanded(
                  child: Text(
                    widget.productId.toString(),
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: TSizes.spaceBtwInputFields),
            Row(
              children: [
                Text(
                  'Product Name: ',
                  style: Theme.of(
                    context,
                  ).textTheme.headlineSmall!.apply(fontWeightDelta: 2),
                ),
                Expanded(
                  child: Text(
                    widget.productName,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: TSizes.spaceBtwInputFields),
            Row(
              children: [
                Text(
                  'Product Amount: ',
                  style: Theme.of(
                    context,
                  ).textTheme.headlineSmall!.apply(fontWeightDelta: 2),
                ),
                Image.asset(
                  TImages.naira,
                  height: 25,
                  color: dark ? TColors.white : TColors.dark,
                ),
                Expanded(
                  child: Text(
                    widget.productAmount.toString(),
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: TSizes.spaceBtwInputFields),
            Row(
              children: [
                Text(
                  'Product Quantity: ',
                  style: Theme.of(
                    context,
                  ).textTheme.headlineSmall!.apply(fontWeightDelta: 2),
                ),
                Expanded(
                  child: Text(
                    widget.productQuantity.toString(),
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: TSizes.spaceBtwSections),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: RegularButton(
                    text: 'Update',
                    icon: Icons.update,
                    onPressed: () async {
                      await Get.to(
                        () => UpdateProduct(
                          productImage: widget.productImage,
                          productAmount: widget.productAmount,
                          productQuantity: widget.productQuantity,
                          productName: widget.productName,
                          productId: widget.productId,
                          userId: widget.userId,
                          addedBy: widget.addedBy,
                        ),
                      );
                    },
                    enabled: true,
                    textColor: TColors.white,
                  ),
                ),
                SizedBox(width: TSizes.spaceBtwItems),
                Expanded(
                  child: RegularButton(
                    text: 'Delete',
                    icon: Icons.delete,
                    onPressed: () {
                      _showDeleteConfirmationDialog(context, widget.productId);
                    },
                    enabled: true,
                    textColor: TColors.white,
                    backgroundColor: deleteGradient,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, int productId) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text(
              "Delete Product",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            content: Text(
              "Are you sure you want to delete this product?",
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
                  final rowsDeleted = await DatabaseHelper.instance
                      .deleteProduct(productId);

                  // Navigator.of(context).pop(rowsDeleted > 0);
                  Navigator.pop(ctx);

                  if (rowsDeleted > 0) {
                    Get.snackbar(
                      'Success',
                      'Product deleted successfully!',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: TColors.success,
                      colorText: TColors.white,
                    );

                    final NavigationController controller = Get.find();
                    controller.selectedIndex.value = 1;
                    Get.until((route) => route.isFirst);
                  } else {
                    Get.snackbar(
                      'Failed',
                      'Failed to delete product!',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: TColors.error,
                      colorText: TColors.white,
                    );
                  }
                },
                child: Text(
                  'OK',
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
