// Custom TextInputFormatter for auto-spacing every 4 digits
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomCardNumberInputFormatterWidget extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text.replaceAll(' ', ''); // Remove any existing spaces
    StringBuffer newText = StringBuffer();

    // Add a space after every 4 digits
    for (int i = 0; i < text.length; i++) {
      if (i % 4 == 0 && i != 0) {
        newText.write(' ');
      }
      newText.write(text[i]);
    }

    // Return the new value with the cursor in the correct position
    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
