import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:my_inventory/utils/constants/colors.dart';
import 'package:my_inventory/utils/constants/sizes.dart';
import 'package:my_inventory/utils/helpers/helper_functions.dart';

class TimeTextField extends StatefulWidget {
  const TimeTextField({
    super.key,
    required this.controller,
    required this.hintText,
  });

  final TextEditingController controller;
  final String hintText;

  @override
  State<TimeTextField> createState() => _TimeTextFieldState();
}

class _TimeTextFieldState extends State<TimeTextField> {
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay now = TimeOfDay.now();

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: now,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              dialHandColor: TColors.primary,
              entryModeIconColor: TColors.primary,
              hourMinuteTextColor: TColors.primary,
            ),
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: TColors.primary, // Active color
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final nowDate = DateTime.now();
      final formattedTime = DateFormat('hh:mm a').format(
        DateTime(
          nowDate.year,
          nowDate.month,
          nowDate.day,
          picked.hour,
          picked.minute,
        ),
      );
      setState(() {
        widget.controller.text = formattedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final text =
        widget.controller.text.isEmpty
            ? widget.hintText
            : widget.controller.text;

    return GestureDetector(
      onTap: () => _selectTime(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: TSizes.md),
        height: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(TSizes.cardRadiusSm),
          color:
              dark
                  ? TColors.dark.withOpacity(0.8)
                  : TColors.grey.withOpacity(0.2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium!.apply(
                color:
                    widget.controller.text.isEmpty
                        ? Colors.grey
                        : (dark ? TColors.white : TColors.dark),
              ),
            ),
            const Icon(Iconsax.clock, size: TSizes.lg, color: TColors.darkGrey),
          ],
        ),
      ),
    );
  }
}
