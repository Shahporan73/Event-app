// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../res/app_colors/App_Colors.dart';
import '../../../res/app_images/App_images.dart';
import '../../../res/common_widget/RoundButton.dart';
import '../../../res/common_widget/custom_app_bar.dart';
import '../../../res/common_widget/custom_text.dart';
import '../../../res/custom_style/custom_size.dart';
import 'create_new_password_screen.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                CustomAppBar(
                  appBarName: "email_verification".tr,
                  onTap: () => Get.back(),
                ),
                heightBox30,
                Center(
                  child: Container(
                    height: 100.h,
                    width: 100.w,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      AppImages.passwordOutline,
                      scale: 4,
                    ),
                  ),
                ),
                heightBox10,
                CustomText(
                    title: 'please_enter_the_6_digit_code_that_was_sent_to_xyzgmailcom'.tr,
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: AppColors.black100,
                  textAlign: TextAlign.center,
                ),

                heightBox50,
                // OTP Input Fields
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(6, (index) {
                      return SizedBox(
                        width: 40.w, // Adjust for responsiveness
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            counterText: '', // Hide the maxLength counter
                          ),
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                          onChanged: (value) {
                            if (value.isNotEmpty && index < 5) {
                              FocusScope.of(context).nextFocus();
                            } else if (value.isEmpty && index > 0) {
                              FocusScope.of(context).previousFocus();
                            }
                          },
                        ),
                      );
                    }),
                  ),
                ),


                heightBox100,
                Roundbutton(
                  title: "verify_otp".tr,
                  onTap: () {
                    Get.to(
                          () => CreateNewPasswordScreen(),
                      transition: Transition.rightToLeft,
                      duration: Duration(milliseconds: 500),
                    );
                  },
                ),

                20.heightBox,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      title: 'did_not_get_the_otp'.tr,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: AppColors.black100,
                    ),

                    InkWell(
                      onTap: () {

                      },
                      child: CustomText(
                        title: "resent".tr,
                        color: AppColors.primaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                )


              ],
            ),
          ),
        ),
      ),
    );
  }
}