// ignore_for_file: prefer_const_constructors

import 'package:event_app/res/app_colors/App_Colors.dart';
import 'package:event_app/view/auth_view/view/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../res/app_images/App_images.dart';
import '../../../res/common_widget/RoundButton.dart';
import '../../../res/common_widget/custom_app_bar.dart';
import '../../../res/custom_style/custom_size.dart';

class CreateNewPasswordScreen extends StatefulWidget {
  const CreateNewPasswordScreen({super.key});

  @override
  State<CreateNewPasswordScreen> createState() => _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen> {
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: SingleChildScrollView( // Added this to make the content scrollable
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Ensure proper alignment
              children: [
                CustomAppBar(
                  appBarName: 'create_new_password'.tr,
                ),
                heightBox50,
                Center(
                  child: Container(
                    height: 100.h,
                    width: 100.w,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      AppImages.createNewPassword,
                      scale: 4,
                    ),
                  ),
                ),
                20.heightBox,
                SizedBox(
                  width: 330.w,
                  child: Text(
                    'please_create_and_enter_a_new_password_for_your_account'.tr,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.black100,
                    ),
                  ),
                ),
                heightBox30,
                // New password field
                TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isNewPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isNewPasswordVisible = !_isNewPasswordVisible;
                        });
                      },
                    ),
                    labelText: 'new_password'.tr,
                    filled: true,
                    fillColor: Colors.white,
                    labelStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  obscureText: !_isNewPasswordVisible,
                ),
                SizedBox(height: 15.h),
                // Confirm password field
                TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                        });
                      },
                    ),
                    labelText: 'confirm_password'.tr,
                    filled: true,
                    fillColor: Colors.white,
                    labelStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  obscureText: !_isConfirmPasswordVisible,
                ),
                heightBox30,
                Roundbutton(
                  title: "save".tr,
                  onTap: () {
                    Get.to(
                            ()=>SignInScreen(),
                        transition: Transition.rightToLeft,
                        duration: Duration(seconds: 1)
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}