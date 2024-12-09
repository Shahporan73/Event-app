// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../app_colors/App_Colors.dart';

class RoundTextField extends StatelessWidget {
  final String hint;
  final TextEditingController? controller;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color focusColor;
  final VoidCallback? onTap;
  final Function(String)? onChanged;
  final TextInputType? keyboardType;
  final int? maxLine;
  final TextAlign textAlign;
  final bool readOnly;
  final TextStyle? style;
  final bool obscureText;
  final String obscuringCharacter;
  final Function(String?)? onSaved;
  final double borderRadius;
  final Color borderColor;
  final double borderWidth;
  final bool? filled;
  final Color fillColor;
  final double focusBorderRadius;
  final double focusBorderWidth;
  final String? errorText; // For manual validation
  final String? Function(String?)? validator; // Added for form validation

  const RoundTextField({
    super.key,
    required this.hint,
    this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.focusColor = AppColors.primaryColor,
    this.onTap,
    this.onChanged,
    this.keyboardType,
    this.maxLine = 1,
    this.readOnly = false,
    this.obscureText = false,
    this.textAlign = TextAlign.start,
    this.obscuringCharacter = '•',
    this.style,
    this.onSaved,
    this.borderRadius = 1,
    this.focusBorderRadius = 1,
    this.borderColor = Colors.grey,
    this.borderWidth = 0.5,
    this.filled = false,
    this.fillColor = const Color(0xffFFFFFF),
    this.focusBorderWidth = 1,
    this.errorText, // For validation messages
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        filled: filled,
        fillColor: fillColor,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: focusColor, width: focusBorderWidth),
          borderRadius: BorderRadius.circular(focusBorderRadius),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(width: borderWidth, color: borderColor),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        errorText: errorText, // Error message if present
      ),
      onTap: onTap,
      onChanged: onChanged,
      keyboardType: keyboardType,
      maxLines: maxLine,
      textAlign: textAlign,
      readOnly: readOnly,
      style: style,
      obscureText: obscureText,
      obscuringCharacter: obscuringCharacter,
      onSaved: onSaved,
      validator: validator, // Form validation logic
    );
  }
}
