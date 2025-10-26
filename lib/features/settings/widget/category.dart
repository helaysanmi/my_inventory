import 'package:flutter/material.dart';
import 'package:my_inventory/utils/constants/colors.dart';
import 'package:my_inventory/utils/constants/sizes.dart';
import 'package:my_inventory/utils/helpers/helper_functions.dart';

class CategoryDetails extends StatelessWidget {
  const CategoryDetails({
    super.key,
    required this.text,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  final String text;
  final Color color;
  final IconData icon;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            padding: const EdgeInsets.all(TSizes.sm / 2),
            decoration: BoxDecoration(
              color:
                  dark
                      ? TColors.darkerGrey.withOpacity(0.3)
                      : TColors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: TSizes.sm * 2),
          Flexible(
            fit: FlexFit.loose,
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
