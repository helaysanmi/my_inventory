import 'package:flutter/material.dart';
import 'package:my_inventory/utils/constants/sizes.dart';

class QuantityCard extends StatelessWidget {
  final String title;
  final String count;
  final String countIncrease;
  final Color color;
  final IconData icon;

  const QuantityCard({
    super.key,
    required this.title,
    required this.color,
    required this.count,
    required this.countIncrease,
    required this.icon,
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(icon),
              SizedBox(width: TSizes.sm),
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium!.copyWith(color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                '+$countIncrease',
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Text(
                count,
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
