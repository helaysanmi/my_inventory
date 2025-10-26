import 'package:flutter/material.dart';
import 'package:my_inventory/utils/constants/colors.dart';
import 'package:my_inventory/utils/helpers/helper_functions.dart';

showSnackBar(BuildContext context, String text) {
  final dark = THelperFunctions.isDarkMode(context);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall!.apply(
          color: dark ? TColors.dark : TColors.white,
        ),
      ),
      backgroundColor: dark ? TColors.white : TColors.dark,
      closeIconColor: dark ? TColors.dark : TColors.white,
      showCloseIcon: true,
    ),
  );
}
