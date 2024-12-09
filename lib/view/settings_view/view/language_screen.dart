// ignore_for_file: prefer_const_constructors

import 'package:event_app/data/token_manager/local_storage.dart';
import 'package:event_app/res/app_colors/App_Colors.dart';
import 'package:event_app/res/common_widget/custom_app_bar.dart';
import 'package:event_app/res/custom_style/custom_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  _LanguageScreenState createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String _selectedLanguage = 'en'; // Default language (English)

  @override
  void initState() {
    super.initState();
    // Load saved language from local storage
    _selectedLanguage = LocalStorage.getData(key: "language") ?? 'en';
  }

  void _changeLanguage(String languageCode) {
    setState(() {
      _selectedLanguage = languageCode;
      LocalStorage.saveData(key: "language", data: languageCode); // Save language
      Get.updateLocale(Locale(languageCode)); // Update locale
      print('Language changed to: $languageCode'); // Debug log
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Custom AppBar

              CustomAppBar(
                  appBarName: 'change_language'.tr,
                  onTap: () {
                    Get.back();
                  },
              ),

              heightBox30,
              Text(
                'choose_your_preferred_language'.tr, // Translated subtitle
                style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 20),

              // English RadioListTile
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: RadioListTile<String>(
                  value: 'en',
                  groupValue: _selectedLanguage,
                  onChanged: (value) {
                    _changeLanguage(value!);
                    print(_selectedLanguage);
                  },
                  title: Text(
                    'English',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: _selectedLanguage == 'en' ? AppColors.primaryColor : Colors.black,
                    ),
                  ),
                  activeColor: Color(0xffEB2926), // Set active color
                ),
              ),

              SizedBox(height: 10),

              // French RadioListTile
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: RadioListTile<String>(
                  value: 'es',
                  groupValue: _selectedLanguage,
                  onChanged: (value) {
                    _changeLanguage(value!);
                    print(_selectedLanguage);
                  },
                  title: Text(
                    'Spanish',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: _selectedLanguage == 'es' ? AppColors.primaryColor : Colors.black,
                    ),
                  ),
                  activeColor: AppColors.primaryColor, // Set active color
                ),
              ),

              // Spacer and Save Button
              Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back(); // Close the screen after saving
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppColors.primaryColor, // Set button background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'save'.tr, // Translated "Save" button
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
