import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:my_inventory/utils/constants/colors.dart';
import 'package:my_inventory/utils/constants/sizes.dart';

class TStatusBottomSheet extends StatelessWidget {
  final bool isSuccess;
  final String title;
  final String message;
  final VoidCallback onPressed;
  final bool? isDismissible;
  final bool? enableDrag;

  const TStatusBottomSheet({
    super.key,
    required this.isSuccess,
    required this.title,
    required this.message,
    required this.onPressed,
    this.isDismissible = true,
    this.enableDrag = true,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSuccess ? TColors.success : TColors.error;
    final icon =
        isSuccess ? 'assets/json/successful.json' : 'assets/json/error.json';

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 24,
        left: 16,
        right: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //Icon(icon, color: color, size: 60),
          Transform.scale(
            scale: isSuccess ? 2.5 : 1.5,
            child: Lottie.asset(
              icon,
              height: 100,
              width: 100,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: TSizes.spaceBtwSections),

          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onPressed();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: TColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
            ),
            child: Text(
              isSuccess ? 'Continue' : 'Close',
              style: Theme.of(
                context,
              ).textTheme.titleLarge!.copyWith(color: TColors.white),
            ),
          ),
          const SizedBox(height: TSizes.defaultSpace),
        ],
      ),
    );
  }
}

void showStatusBottomSheet({
  required BuildContext context,
  required bool isSuccess,
  required String title,
  required String message,
  required VoidCallback onPressed,
  required bool isDismissible,
  required bool enableDrag,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder:
        (_) => TStatusBottomSheet(
          isSuccess: isSuccess,
          title: title,
          message: message,
          onPressed: onPressed,
          enableDrag: enableDrag,
          isDismissible: isDismissible,
        ),
  );
}
