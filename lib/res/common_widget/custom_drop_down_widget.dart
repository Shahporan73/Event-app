// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:event_app/res/app_colors/App_Colors.dart';
import 'package:flutter/material.dart';

class CustomDropDownWidget extends StatelessWidget {
  final String selectedValue;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String hintText;

  CustomDropDownWidget({
    required this.selectedValue,
    required this.items,
    required this.onChanged,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    // Check if the selectedValue is in the items list
    if (!items.contains(selectedValue) && selectedValue.isNotEmpty) {
      // Optional: you can log an error or handle this case
      print("Warning: selectedValue '$selectedValue' is not in the items list.");
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: AppColors.blackColor, width: 1.0),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<String>(
        value: items.isEmpty || !items.contains(selectedValue) ? null : selectedValue, // Handle empty or invalid selected value
        hint: Text(hintText),
        underline: SizedBox(),
        onChanged: onChanged,
        items: items
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        isExpanded: true,
        style: TextStyle(
          color: Colors.black,
          fontSize: 14,
        ),
        icon: Icon(
          Icons.arrow_drop_down,
          color: Colors.black,
        ),
        dropdownColor: AppColors.whiteColor,
      ),
    );
  }
}
