import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../res/app_colors/App_Colors.dart';
import '../../../res/common_widget/custom_text.dart';
import '../../../res/custom_style/custom_style.dart';

class PhoneNumberFieldWidget extends StatefulWidget {
  const PhoneNumberFieldWidget({super.key});

  @override
  State<PhoneNumberFieldWidget> createState() => _PhoneNumberFieldWidgetState();
}

class _PhoneNumberFieldWidgetState extends State<PhoneNumberFieldWidget> {
  String _countryFlag = '🇺🇸'; // Default country flag emoji
  String _countryCode = '+1'; // Default country dialing code
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          title: "Phone Number",
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.whiteDarker,
        ),
        SizedBox(height: 8),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                // Open country picker and update flag and code in real-time
                showCountryPicker(
                  context: context,
                  showPhoneCode: true,
                  onSelect: (Country country) {
                    setState(() {
                      _countryFlag = country.flagEmoji;
                      _countryCode = '+${country.phoneCode}';
                    });
                  },
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(1),
                ),
                child: Row(
                  children: [
                    Text(
                      _countryFlag, // Display selected country flag
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(width: 8),
                    Text(
                      _countryCode, // Display selected country dialing code
                      style: GoogleFonts.poppins(fontSize: 16),
                    ),
                    Icon(Icons.arrow_drop_down, color: Colors.grey),
                  ],
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: TextField(
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: '26537 26347',
                  hintStyle: hintStyle,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(1),
                  ),
                  fillColor: AppColors.whiteColor,
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: AppColors.primaryColor, width: 1)),
                  // contentPadding:
                  // EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
