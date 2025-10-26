import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_inventory/common/button/button.dart';
import 'package:my_inventory/common/circular_progress/circular_progress.dart';
import 'package:my_inventory/common/text_field/text_field.dart';
import 'package:my_inventory/features/products/model/product_model.dart';
import 'package:my_inventory/utils/constants/colors.dart';
import 'package:my_inventory/utils/constants/sizes.dart';
import 'package:my_inventory/utils/helpers/database_helper.dart';
import 'package:my_inventory/utils/helpers/helper_functions.dart';
import 'package:my_inventory/utils/validators/validation.dart';

class AddNewProduct extends StatefulWidget {
  final int? userId;
  final int? productQuantity;
  final String? productImage;
  final String? productName;
  final double? productAmount;
  final String? addedBy;

  const AddNewProduct({
    super.key,
    this.userId,
    this.productQuantity,
    this.productImage,
    this.productName,
    this.productAmount,
    this.addedBy,
  });

  @override
  State<AddNewProduct> createState() => _AddNewProductState();
}

class _AddNewProductState extends State<AddNewProduct> {
  late TextEditingController productNameController;
  late TextEditingController productQuantityController;
  late TextEditingController productAmountController;
  late TextEditingController productImageController;

  final productNameFocusNode = FocusNode();
  final productQuantityFocusNode = FocusNode();
  final productAmountFocusNode = FocusNode();

  String? productNameError;
  String? productQuantityError;
  String? productAmountError;

  bool isLoading = false;
  bool isEnabled = false;

  @override
  void initState() {
    super.initState();
    productQuantityController = TextEditingController(
      text:
          widget.productQuantity != null
              ? widget.productQuantity.toString()
              : '',
    );
    productAmountController = TextEditingController(
      text: widget.productAmount != null ? widget.productAmount.toString() : '',
    );
    productNameController = TextEditingController(
      text: widget.productName ?? '',
    );
    productImageController = TextEditingController(
      text: widget.productImage ?? '',
    );

    productQuantityController.addListener(() {
      validateProductQuantity();
      updateFormState();
    });

    productAmountController.addListener(() {
      validateProductAmount();
      updateFormState();
    });

    productNameController.addListener(() {
      validateProductName();
      updateFormState();
    });

    productQuantityFocusNode.addListener(() {
      if (!productQuantityFocusNode.hasFocus) validateProductQuantity();
    });

    productAmountFocusNode.addListener(() {
      if (!productAmountFocusNode.hasFocus) validateProductAmount();
    });

    productNameFocusNode.addListener(() {
      if (!productNameFocusNode.hasFocus) validateProductName();
    });
  }

  void validateProductQuantity() {
    final quantity = productQuantityController.text;
    final error = TValidator.validateProductQuantity(quantity);
    setState(() {
      productQuantityError = error;
    });
  }

  void validateProductAmount() {
    final amount = productAmountController.text;
    final error = TValidator.validateProductAmount(amount);
    setState(() {
      productAmountError = error;
    });
  }

  void validateProductName() {
    final name = productNameController.text;
    final error = TValidator.validateProductName(name);
    setState(() {
      productNameError = error;
    });
  }

  void updateFormState() {
    final name = productNameController.text;
    final amount = productAmountController.text;
    final quantity = productQuantityController.text;

    setState(() {
      isEnabled =
          TValidator.validateProductName(name) == null &&
          TValidator.validateProductAmount(amount) == null &&
          TValidator.validateProductQuantity(quantity) == null;
    });
  }

  @override
  void dispose() {
    productAmountController.dispose();
    productNameController.dispose();
    productQuantityController.dispose();
    productAmountFocusNode.dispose();
    productNameFocusNode.dispose();
    productQuantityFocusNode.dispose();
    super.dispose();
  }

  //String? selectedImagePath;

  Future<void> _selectMedia() async {
    final ImagePicker picker = ImagePicker();

    await showModalBottomSheet(
      context: context,
      builder:
          (_) => SafeArea(
            child: Wrap(
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Take a photo'),
                  onTap: () async {
                    final pickedFile = await picker.pickImage(
                      source: ImageSource.camera,
                    );
                    if (pickedFile != null) {
                      setState(() {
                        productImageController.text = pickedFile.path;
                      });
                    }
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Choose from gallery'),
                  onTap: () async {
                    final pickedFile = await picker.pickImage(
                      source: ImageSource.gallery,
                    );
                    if (pickedFile != null) {
                      setState(() {
                        productImageController.text = pickedFile.path;
                      });
                    }
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
    );
  }

  void _clearImage() {
    setState(() {
      productImageController.clear();
    });
  }

  Future<void> _saveProduct() async {
    setState(() {
      isLoading = true;
    });
    try {
      final product = ProductModel(
        userId: int.parse(widget.userId.toString()),
        productName: productNameController.text.trim(),
        productQuantity: int.parse(productQuantityController.text),
        productAmount: double.parse(productAmountController.text),
        productImage: productImageController.text,
        addedBy: widget.addedBy ?? 'Unknown',
      );

      await DatabaseHelper.instance.insertProduct(product);

      setState(() {
        isLoading = false;
      });

      Get.back();

      Get.snackbar(
        'Success',
        'Product added successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: TColors.success,
        colorText: TColors.white,
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      Get.snackbar(
        'Error',
        'Failed to save product: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: TColors.error,
        colorText: TColors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final String imagePath = productImageController.text;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Add Product',
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
              GestureDetector(
                onTap: _selectMedia,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: TColors.primary),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child:
                      imagePath.isEmpty
                          ? const Center(
                            child: Text(
                              'Tap to select or capture product image',
                            ),
                          )
                          : Stack(
                            alignment: Alignment.topRight,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  TSizes.borderRadiusMd,
                                ),
                                child: Image.file(
                                  File(imagePath),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 200,
                                ),
                              ),
                              Positioned(
                                right: 8,
                                top: 8,
                                child: GestureDetector(
                                  onTap: _clearImage,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: TColors.error,
                                      borderRadius: BorderRadius.circular(
                                        TSizes.borderRadiusMd,
                                      ),
                                    ),
                                    padding: const EdgeInsets.all(TSizes.sm),
                                    child: Text(
                                      'Delete',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge!
                                          .apply(color: TColors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                ),
              ),
              SizedBox(height: TSizes.spaceBtwInputFields),
              Text(
                'Product Name',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields / 2),
              TextInputField(
                controller: productNameController,
                hintText: 'Enter product name',
              ),
              const SizedBox(height: TSizes.sm),
              if (productNameError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    productNameError!,
                    style: Theme.of(
                      context,
                    ).textTheme.labelLarge!.apply(color: TColors.error),
                  ),
                ),

              SizedBox(height: TSizes.spaceBtwInputFields),
              Text(
                'Product Amount',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields / 2),
              TextInputField(
                controller: productAmountController,
                hintText: 'Enter product amount',
                textInputType: TextInputType.number,
              ),
              const SizedBox(height: TSizes.sm),
              if (productAmountError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    productAmountError!,
                    style: Theme.of(
                      context,
                    ).textTheme.labelLarge!.apply(color: TColors.error),
                  ),
                ),
              SizedBox(height: TSizes.spaceBtwInputFields),
              Text(
                'Product Quantity',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields / 2),
              TextInputField(
                controller: productQuantityController,
                hintText: 'Enter product quantity',
                textInputType: TextInputType.number,
              ),
              const SizedBox(height: TSizes.sm),
              if (productQuantityError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    productQuantityError!,
                    style: Theme.of(
                      context,
                    ).textTheme.labelLarge!.apply(color: TColors.error),
                  ),
                ),
              SizedBox(height: TSizes.spaceBtwSections),
              isLoading
                  ? CircularProgress()
                  : RegularButton(
                    text: 'Add Product',

                    onPressed: isEnabled ? _saveProduct : null,
                    enabled: isEnabled,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
