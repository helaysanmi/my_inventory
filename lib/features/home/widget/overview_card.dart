import 'package:flutter/material.dart';
import 'package:my_inventory/utils/constants/colors.dart';
import 'package:my_inventory/utils/constants/image_strings.dart';
import 'package:my_inventory/utils/constants/sizes.dart';

class OverviewCard extends StatelessWidget {
  final String title;
  final String amount;
  final Color color;
  final IconData icon;
  final bool? amountCat;

  const OverviewCard({
    super.key,
    required this.title,
    required this.amount,
    required this.color,
    required this.icon,
    this.amountCat = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon),

          const SizedBox(height: TSizes.spaceBtwInputFields),
          Row(
            children: [
              amountCat == true
                  ? Image.asset(TImages.naira, height: 25, color: TColors.white)
                  : const SizedBox.shrink(),
              Text(
                amount,
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: TColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: TSizes.sm),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium!.copyWith(color: TColors.white),
          ),
        ],
      ),
    );
  }
}
