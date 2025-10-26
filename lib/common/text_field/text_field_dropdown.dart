import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_inventory/utils/constants/colors.dart';
import 'package:my_inventory/utils/constants/sizes.dart';
import 'package:my_inventory/utils/helpers/helper_functions.dart';

class TextFieldDropdown extends StatefulWidget {
  const TextFieldDropdown({
    super.key,
    required this.controller,
    required this.hintText,
    required this.options,
  });

  final TextEditingController controller;
  final String hintText;
  final List<String> options;

  @override
  State<TextFieldDropdown> createState() => _TextFieldDropdownState();
}

class _TextFieldDropdownState extends State<TextFieldDropdown> {
  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final text =
        widget.controller.text.isEmpty
            ? widget.hintText
            : widget.controller.text;

    return GestureDetector(
      onTap: () => _showDropdown(context),
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
              style: Theme.of(context).textTheme.bodyLarge!.apply(
                color:
                    widget.controller.text.isEmpty
                        ? Colors.grey
                        : (dark ? Colors.white : Colors.black),
              ),
            ),
            const Icon(
              Iconsax.arrow_down_1,
              size: TSizes.lg,
              color: TColors.darkGrey,
            ),
          ],
        ),
      ),
    );
  }

  void _showDropdown(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(TSizes.fontSizeMd),
        ),
      ),
      builder: (BuildContext context) {
        final TextEditingController searchController = TextEditingController();
        List<String> filteredOptions = widget.options;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter modalSetState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(TSizes.md),
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        hintText: 'Search options...',
                        hintStyle: Theme.of(
                          context,
                        ).textTheme.bodyMedium!.apply(color: TColors.darkGrey),
                        filled: true,
                        fillColor:
                            dark
                                ? TColors.dark.withOpacity(0.8)
                                : TColors.grey.withOpacity(0.2),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: TColors.primary.withOpacity(0.5),
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(
                            TSizes.fontSizeMd,
                          ),
                        ),
                      ),
                      onChanged: (query) {
                        modalSetState(() {
                          filteredOptions =
                              widget.options
                                  .where(
                                    (option) => option.toLowerCase().contains(
                                      query.toLowerCase(),
                                    ),
                                  )
                                  .toList();
                        });
                      },
                    ),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.5,
                    ),
                    child: ListView(
                      shrinkWrap: true,
                      children:
                          filteredOptions.map((String option) {
                            return ListTile(
                              title: Text(
                                option,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              onTap: () {
                                widget.controller.text = option;
                                setState(() {});
                                Navigator.pop(context);
                              },
                            );
                          }).toList(),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
