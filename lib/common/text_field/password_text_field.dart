import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_inventory/utils/constants/colors.dart';
import 'package:my_inventory/utils/constants/sizes.dart';
import 'package:my_inventory/utils/helpers/helper_functions.dart';

class PasswordTextField extends StatefulWidget {
  const PasswordTextField({
    super.key,
    required this.controller,
    this.hintText = 'Enter your password',
    this.focusNode,
  });

  final TextEditingController controller;
  final String? hintText;
  final FocusNode? focusNode;

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      obscureText: _obscureText,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 20.0,
          horizontal: 16.0,
        ),
        prefixIcon: const Icon(Iconsax.password_check5),
        border: InputBorder.none,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color:
                dark
                    ? TColors.dark.withOpacity(0.8)
                    : TColors.grey.withOpacity(0.2),
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(TSizes.cardRadiusSm),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: TColors.primary.withOpacity(0.5),
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(TSizes.cardRadiusSm),
        ),
        filled: true,
        fillColor:
            dark
                ? TColors.dark.withOpacity(0.8)
                : TColors.grey.withOpacity(0.2),
        hintText: widget.hintText,
        hintStyle: Theme.of(
          context,
        ).textTheme.bodyMedium!.apply(color: TColors.darkGrey),
        suffixIcon: IconButton(
          icon: Icon(_obscureText ? Iconsax.eye_slash : Iconsax.eye),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
      ),
    );
  }
}
