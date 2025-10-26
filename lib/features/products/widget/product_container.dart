import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_inventory/features/products/product_details.dart';
import 'package:my_inventory/utils/constants/colors.dart';
import 'package:my_inventory/utils/constants/image_strings.dart';
import 'package:my_inventory/utils/constants/sizes.dart';
import 'package:my_inventory/utils/helpers/helper_functions.dart';

class ProductContainer extends StatelessWidget {
  const ProductContainer({
    super.key,
    required this.productAmount,
    required this.productQuantity,
    required this.productName,
    required this.productImage,
    required this.productId,
    required this.addedBy,
    required this.userId,
  });

  final double productAmount;
  final int productQuantity;
  final String productName;
  final String productImage;
  final int productId;
  final String addedBy;
  final int userId;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return GestureDetector(
      onTap:
          () => Get.to(
            () => ProductDetailsScreen(
              productId: productId,
              productQuantity: productQuantity,
              productImage: productImage,
              productName: productName,
              productAmount: productAmount,
              addedBy: addedBy,
              userId: userId,
            ),
          ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(TSizes.cardRadiusSm),
          color:
              dark
                  ? TColors.dark.withOpacity(0.8)
                  : TColors.grey.withOpacity(0.2),
        ),
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace / 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    padding: const EdgeInsets.all(TSizes.sm / 2),
                    decoration: BoxDecoration(
                      color:
                          dark
                              ? TColors.darkerGrey.withOpacity(0.3)
                              : TColors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(TSizes.cardRadiusSm),
                    ),
                    child:
                        productImage != ''
                            ? Image.file(
                              File(productImage),
                              fit: BoxFit.cover,
                              width: 50,
                              height: 50,
                            )
                            : Icon(Iconsax.box),
                  ),
                  const SizedBox(width: TSizes.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          productName,
                          style: Theme.of(context).textTheme.labelMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: TSizes.sm),
                        Text(
                          '$productQuantity QTY',
                          style: Theme.of(context).textTheme.labelSmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: TSizes.sm * 2),
                  Row(
                    children: [
                      Image.asset(
                        TImages.naira,
                        height: 25,
                        color: dark ? TColors.white : TColors.dark,
                      ),
                      Text(
                        '$productAmount',
                        style: Theme.of(context).textTheme.bodyLarge!.apply(
                          color: dark ? TColors.grey : TColors.darkGrey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
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
