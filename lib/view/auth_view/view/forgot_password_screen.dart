// ignore_for_file: prefer_const_constructors

import 'package:event_app/res/common_widget/RoundTextField.dart';
import 'package:event_app/view/auth_view/controller/forgot_password_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../res/app_colors/App_Colors.dart';
import '../../../res/app_images/App_images.dart';
import '../../../res/common_widget/RoundButton.dart';
import '../../../res/common_widget/custom_app_bar.dart';
import '../../../res/custom_style/custom_size.dart';
import 'otp_screen.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});
  final ForgotPasswordController controller = Get.put(ForgotPasswordController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.bgColor,
        body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Custom AppBar as the first widget
                  CustomAppBar(
                    appBarName: "forgot_password".tr,
                    onTap: () => Get.back(),
                  ),

                  heightBox50,
                  // Expanded widget to make the remaining content scrollable if needed
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
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
                          20.heightBox,
                          SizedBox(
                            width: 330.w,
                            child: Text(
                              'please_enter_your_email_address_which_was_used_to_create_your_account'.tr,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: AppColors.black100,
                              ),
                            ),
                          ),
                          50.heightBox,
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5.0),
                            child: RoundTextField(
                              controller: controller.emailController,
                              hint: 'Enter email address',
                              fillColor: Colors.white,
                              filled: true,
                              prefixIcon: Icon(Icons.email_outlined),
                            ),
                          ),
                          50.heightBox,
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5.w),
                            child: Obx(() => Roundbutton(
                              title: "get_otp".tr,
                              isLoading: controller.isLoading.value,
                              onTap: () {
                                controller.forgotPassword();
                               },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
        )
    );
  }
}