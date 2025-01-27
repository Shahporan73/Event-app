// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_field, prefer_final_fields

import 'package:event_app/res/common_widget/custom_app_bar.dart';
import 'package:event_app/res/common_widget/custom_text.dart';
import 'package:event_app/res/custom_style/custom_size.dart';
import 'package:event_app/view/settings_view/view/change_password_screen.dart';
import 'package:event_app/view/settings_view/view/language_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../res/app_colors/App_Colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedLanguage = "English";
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAppBar(
                  appBarName: "settings".tr,
                  onTap: () => Get.back(),
                ),


                heightBox20,
                ListTile(
                  leading: Icon(Icons.language_outlined, color: AppColors.primaryColor,),
                  title: CustomText(
                      title: "change_language".tr,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: AppColors.blackColor
                  ),
                  trailing: Icon(Icons.navigate_next, color: AppColors.blackColor,),
                  onTap: () {
                    Get.to(
                          () => LanguageScreen(),
                      fullscreenDialog: true,
                      transition: Transition.rightToLeft,
                      duration: Duration(milliseconds: 400),
                    );
                  },
                ),

                ListTile(
                  leading: Icon(Icons.lock, color: AppColors.primaryColor,),
                  title: CustomText(
                      title: "change_password".tr,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: AppColors.blackColor
                  ),
                  trailing: Icon(Icons.navigate_next, color: AppColors.blackColor,),
                  onTap: () {
                    Get.to(
                          () => ChangePasswordScreen(),
                      fullscreenDialog: true,
                      transition: Transition.rightToLeft,
                      duration: Duration(milliseconds: 500),
                    );
                  },
                ),

                ListTile(
                  leading: Icon(Icons.delete, color: Colors.red,),
                  title: CustomText(
                      title: "delete_account".tr,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.red
                  ),
                  onTap: () {
                    showDeleteAccountDialog(context);
                  },
                ),


              ],
            ),
          ),
        ),
      ),
    );
  }

  void showDeleteAccountDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Delete Account",
      transitionDuration: Duration(milliseconds: 300), // Animation duration
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.red, size: 40),
                SizedBox(height: 20),
                Text(
                  "delete_account".tr,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    decoration: TextDecoration.none,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "are_you_sure_you_want_to_delete_your_account".tr,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.black54,
                    decoration: TextDecoration.none,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close dialog
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "cancel".tr,
                        style: GoogleFonts.poppins(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Perform delete account action here
                        Navigator.of(context).pop(); // Close dialog
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "delete".tr,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedValue = Curves.easeInOut.transform(animation.value) - 1;
        return Transform.translate(
          offset: Offset(0, curvedValue * -50),
          child: Opacity(
            opacity: animation.value,
            child: child,
          ),
        );
      },
    );
  }

}