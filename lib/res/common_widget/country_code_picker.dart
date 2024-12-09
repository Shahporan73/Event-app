// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'custom_text.dart';

class CountryCodePicker extends StatefulWidget {
  const CountryCodePicker({super.key});

  @override
  State<CountryCodePicker> createState() => _CountryCodePickerState();
}

class _CountryCodePickerState extends State<CountryCodePicker> {


  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {}); // Triggers rebuild on focus change
    });
  }

  @override
  void dispose() {
    _focusNode.dispose(); // Clean up the focus node
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Contact Field
        CustomText(
          title: "Contact",
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: Colors.black,
        ),

        SizedBox(height: 10.h),

        GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(_focusNode); // Focus the container when tapped
          },
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(
                color: _focusNode.hasFocus ? Colors.red : Color(0xffcacaca), // Change the entire section's border to red when focused
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Material(
              color: Colors.transparent,
              child: InternationalPhoneNumberInput(
                focusNode: _focusNode, // Assign the FocusNode here
                inputBorder: InputBorder.none, // Remove internal borders to avoid conflicts
                onInputChanged: (PhoneNumber number) {
                  print(number.phoneNumber);
                },
                selectorConfig: SelectorConfig(
                  selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                  useEmoji: true,
                ),
                ignoreBlank: false,
                autoValidateMode: AutovalidateMode.disabled,
                selectorTextStyle: TextStyle(
                  color: _focusNode.hasFocus ? Colors.red : Colors.black, // Apply red color to the country selector when focused
                ),
                initialValue: PhoneNumber(isoCode: 'BD'),
                formatInput: true,
                inputDecoration: InputDecoration(
                  hintText: 'Enter your number',
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                  ),
                  border: InputBorder.none, // No inner border
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ),
        )


      ],
    );
  }
}

