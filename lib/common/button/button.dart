import 'package:flutter/material.dart';
import 'package:my_inventory/utils/constants/colors.dart';
import 'package:my_inventory/utils/helpers/helper_functions.dart';

class RegularButton extends StatelessWidget {
  const RegularButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.enabled = false,
    this.textColor = TColors.white,
    this.icon,
    this.backgroundColor,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool enabled;
  final Color? textColor;
  final IconData? icon;
  final LinearGradient? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = enabled && onPressed != null;
    final dark = THelperFunctions.isDarkMode(context);
    final gradient = backgroundColor ?? buttonGradient;

    return GestureDetector(
      onTap: isEnabled ? onPressed : null,
      child: Container(
        width: double.infinity,
        height: 60,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: isEnabled ? gradient : null,
          color:
              isEnabled
                  ? null
                  : dark
                  ? TColors.darkerGrey
                  : TColors.buttonDisabled,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: Theme.of(
                context,
              ).textTheme.titleLarge!.copyWith(color: textColor),
            ),
            if (icon != null) ...[
              const SizedBox(width: 10),
              Icon(icon, color: textColor),
            ],
          ],
        ),
      ),
    );
  }
}
