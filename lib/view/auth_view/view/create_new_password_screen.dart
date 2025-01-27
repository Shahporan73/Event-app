// ignore_for_file: prefer_const_constructors

import 'package:event_app/res/app_colors/App_Colors.dart';
import 'package:event_app/view/auth_view/controller/reset_password_controller.dart';
import 'package:event_app/view/auth_view/view/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../res/app_images/App_images.dart';
import '../../../res/common_widget/RoundButton.dart';
import '../../../res/common_widget/custom_app_bar.dart';
import '../../../res/custom_style/custom_size.dart';

class CreateNewPasswordScreen extends StatelessWidget {
  CreateNewPasswordScreen({super.key});

  final ResetPasswordController controller = Get.put(ResetPasswordController());

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
                Obx(() => TextField(
                  controller: controller.newPasswordController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isNewPasswordVisible.value ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        controller.toggleNewPasswordVisibility();
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
                  obscureText: !controller.isNewPasswordVisible.value,
                ),),
                SizedBox(height: 15.h),
                // Confirm password field
                Obx(() => TextField(
                  controller: controller.confirmPasswordController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isConfirmPasswordVisible.value ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        controller.toggleConfirmPasswordVisibility();
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
                  obscureText: !controller.isConfirmPasswordVisible.value,
                ),),

                heightBox30,
                Obx(() => Roundbutton(
                  isLoading: controller.isLoading.value,
                  title: "save".tr,
                  onTap: () {
                    controller.resetPassword();
                  },
                ),),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
