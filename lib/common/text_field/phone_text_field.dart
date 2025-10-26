import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_inventory/common/text_field/model/callcode_model.dart';
import 'package:my_inventory/common/text_field/service/callcode_loader.dart';
import 'package:my_inventory/utils/constants/colors.dart';
import 'package:my_inventory/utils/constants/sizes.dart';
import 'package:my_inventory/utils/helpers/helper_functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PhoneTextField extends StatefulWidget {
  const PhoneTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.enabled = true,
    this.focusNode,
  });

  final String hintText;
  final TextEditingController controller;
  final bool? enabled;
  final FocusNode? focusNode;

  @override
  State<PhoneTextField> createState() => _PhoneTextFieldState();
}

class _PhoneTextFieldState extends State<PhoneTextField> {
  String selectedPhoneCode = '+234'; // Default phone code
  late List<CallcodeModel> callCodes;

  @override
  void initState() {
    super.initState();
    loadCallCodes();
  }

  Future<void> loadCallCodes() async {
    callCodes = await CallcodeLoader.loadCallcode(
      context,
      "assets/json/phone_country_code.json",
    );
    callCodes.sort((a, b) => a.countryEn.compareTo(b.countryEn));
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedPhoneCode = prefs.getString('selectedPhoneCode') ?? '+234';
    });

    if (!prefs.containsKey('selectedPhoneCode')) {
      await prefs.setString('selectedPhoneCode', selectedPhoneCode);
    }
  }

  Future<void> savePhoneCode() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedPhoneCode', selectedPhoneCode);
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Row(
      children: [
        GestureDetector(
          onTap: () => _showPhoneCodeDropdown(context),
          child: Container(
            padding: EdgeInsets.all(TSizes.sm),
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(TSizes.cardRadiusSm),
              color:
                  dark
                      ? TColors.dark.withOpacity(0.8)
                      : TColors.grey.withOpacity(0.2),
            ),
            child: Row(
              children: [
                Text(selectedPhoneCode),
                SizedBox(width: 5),
                Icon(Iconsax.arrow_down_1, size: TSizes.md),
              ],
            ),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            keyboardType: TextInputType.phone,
            focusNode: widget.focusNode,
            enabled: widget.enabled,
            controller: widget.controller,
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
              hintText: widget.hintText,
              hintStyle: Theme.of(
                context,
              ).textTheme.bodyMedium!.apply(color: TColors.darkGrey),
            ),
          ),
        ),
      ],
    );
  }

  void _showPhoneCodeDropdown(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        final dark = THelperFunctions.isDarkMode(context);

        final TextEditingController searchController = TextEditingController();
        List<CallcodeModel> filteredCallCodes = callCodes;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter modalSetState) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TSizes.defaultSpace,
                    vertical: TSizes.sm,
                  ),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search by country or code',
                      hintStyle: Theme.of(
                        context,
                      ).textTheme.bodyMedium!.apply(color: TColors.darkGrey),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: TColors.primary.withOpacity(0.5),
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(
                          TSizes.cardRadiusSm,
                        ),
                      ),
                      filled: true,
                      fillColor:
                          dark
                              ? TColors.dark.withOpacity(0.8)
                              : TColors.grey.withOpacity(0.2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(TSizes.fontSizeMd),
                      ),
                    ),
                    onChanged: (query) {
                      // Update the filtered list dynamically
                      modalSetState(() {
                        filteredCallCodes =
                            callCodes.where((callCode) {
                              final country = callCode.countryEn.toLowerCase();
                              final phoneCode = callCode.phoneCode.toString();
                              return country.contains(query.toLowerCase()) ||
                                  phoneCode.contains(query.toLowerCase());
                            }).toList();
                      });
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredCallCodes.length,
                    itemBuilder: (context, index) {
                      final callCode = filteredCallCodes[index];
                      return ListTile(
                        leading: Container(
                          padding: EdgeInsets.all(TSizes.sm),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              TSizes.cardRadiusSm,
                            ),
                            color:
                                dark
                                    ? TColors.dark.withOpacity(0.8)
                                    : TColors.grey.withOpacity(0.2),
                          ),
                          child: Text(
                            '+${callCode.phoneCode}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                        title: Text(callCode.countryEn),
                        onTap: () async {
                          setState(() {
                            selectedPhoneCode = '+${callCode.phoneCode}';
                          });
                          await savePhoneCode(); // Save phone code on selection
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
