// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:event_app/view/auth_view/controller/otp_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../res/app_colors/App_Colors.dart';
import '../../../res/app_images/App_images.dart';
import '../../../res/common_widget/RoundButton.dart';
import '../../../res/common_widget/custom_app_bar.dart';
import '../../../res/common_widget/custom_text.dart';
import '../../../res/custom_style/custom_size.dart';

class OtpScreen extends StatelessWidget {
  final String email;
  OtpScreen({super.key, required this.email});

  final OtpController controller = Get.put(OtpController());

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
                  title: 'please_enter_the_6_digit_code_that_was_sent_to'.tr + ' $email',
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
                          controller:controller.otpControllers[index], // Using individual controllers
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
                    String otp = controller.otpControllers.map((e) => e.text).join(); // Concatenate OTP from each controller
                    if (otp.length == 6) {
                      // Implement OTP verification logic here (call API or service)
                      controller.otpSubmitted();
                    } else {
                      Get.snackbar("Error", "Please enter the full OTP", snackPosition: SnackPosition.BOTTOM);
                    }
                  },
                ),

                20.heightBox,
                Obx(() => controller.secondsRemaining.value == 0
                    ? Roundbutton(
                  padding_vertical: 6,
                  borderRadius: 4,
                  buttonColor: Colors.red.shade50,
                  titleColor: Colors.black,
                  title: "resend_otp".tr,
                  onTap: () {
                    controller.resendOtp();  // Call resend OTP function
                  },
                )
                    : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      title: "resend_code_in".tr,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: Colors.black,
                    ),
                    widthBox5,
                    CustomText(
                      title: "${controller.secondsRemaining.value}",
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: AppColors.secondaryColor,
                    ),
                    CustomText(
                      title: "s".tr,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ],
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
