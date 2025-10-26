import 'package:flutter/material.dart';
import 'package:my_inventory/utils/constants/colors.dart';
import 'package:my_inventory/utils/constants/sizes.dart';
import 'package:my_inventory/utils/helpers/helper_functions.dart';

class TextInputField extends StatelessWidget {
  const TextInputField({
    super.key,
    required this.hintText,
    this.prefixIcon,
    required this.controller,
    this.enabled = true,
    this.textInputType,
    this.maxLines = 1,
    this.onTap,
    this.maxLength,
    this.counterText,
    this.focusNode,
    this.expands = false,
    this.minLines = 1,
    this.textAlignVertical,
  });

  final String hintText;
  final Icon? prefixIcon;
  final TextEditingController controller;
  final bool? enabled;
  final TextInputType? textInputType;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final String? counterText;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final bool expands;
  final TextAlignVertical? textAlignVertical;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return GestureDetector(
      onTap: onTap,
      child: TextFormField(
        expands: expands,
        focusNode: focusNode,
        maxLines: maxLines,
        maxLength: maxLength,
        keyboardType: textInputType,
        minLines: minLines,
        enabled: enabled,
        textAlignVertical: textAlignVertical,
        controller: controller,
        // inputFormatters: [
        //   FilteringTextInputFormatter.deny(RegExp(r'\n')),
        // ],
        // textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 20.0,
            horizontal: 16.0,
          ),
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
          prefixIcon: prefixIcon,
          hintText: hintText,
          hintStyle: Theme.of(
            context,
          ).textTheme.bodyMedium!.apply(color: TColors.darkGrey),
        ),
      ),
    );
  }
}
