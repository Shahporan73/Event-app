// ignore_for_file: prefer_const_constructors

import 'package:event_app/res/custom_style/custom_size.dart';
import 'package:event_app/view/auth_view/controller/sign_in_controller.dart';
import 'package:event_app/view/auth_view/view/forgot_password_screen.dart';
import 'package:event_app/view/auth_view/view/sign_up_screen.dart';
import 'package:event_app/view/home_view/view/home.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../res/app_colors/App_Colors.dart';
import '../../../res/app_images/App_images.dart';
import '../../../res/common_widget/RoundButton.dart';
import '../../../res/common_widget/custom_app_bar.dart';
import '../../../res/common_widget/custom_text.dart';
import '../widget/or_continue_with.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  final SignInController controller = Get.put(SignInController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xffffffff), Color(0xff00BDCA)],
                  // transform: GradientRotation(3.14 / 2),
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              child: Text(
                'welcome_to_way_places'.tr,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff000000),
                ),
              ),
            ),



            Padding(
              padding: EdgeInsets.all(16.w),
              child:   // Logo and title
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Center(
                    child: Image.asset(
                      AppImages.appLogo,
                      width: 180,
                    ),
                  ),
                  heightBox20,


                  Obx(
                        () => Form(
                        key: controller.loginKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // email field
                            // Email field
                            CustomText(
                              title: "email".tr,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: AppColors.black33,
                            ),
                            heightBox8,
                            TextFormField(
                              controller: controller.emailController,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.email_outlined),
                                hintText: 'Enter your email',
                                hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                errorText: controller.email.value.isNotEmpty
                                    ? controller.email.value
                                    : null,
                              ),
                              keyboardType: TextInputType.emailAddress,
                            ),
                            SizedBox(height: 15.h),
                            // Password field with toggle
                            CustomText(
                              title: "password".tr,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: AppColors.black33,
                            ),
                            heightBox8,
                            TextFormField(
                              controller: controller.passwordController,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.lock),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    controller.isPasswordVisible.value
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    controller.togglePasswordVisibility();
                                  },
                                ),
                                hintText: '**********',
                                hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                errorText: controller.password.value.isNotEmpty
                                    ? controller.password.value
                                    : null,
                              ),
                              obscureText: !controller.isPasswordVisible.value,
                            ),
                            heightBox20,
                            Row(
                              children: [
                                Checkbox(
                                  value: controller.isChecked.value,
                                  onChanged: (bool? value) {
                                    controller.isChecked.value = value!;
                                  },
                                ),
                                Text(
                                  'remember_me'.tr,
                                  style: TextStyle(color: Colors.black),
                                ),
                                Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    Get.to(ForgotPasswordScreen());
                                  },
                                  child: Text(
                                    'forgot_password'.tr,
                                    style: TextStyle(
                                      color: AppColors.primaryColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            heightBox40,
                            // Sign In Button
                            Roundbutton(
                              title: 'sign_in'.tr,
                              isLoading: controller.isLoading.value,
                              onTap: () {
                                controller.onSignIn();
                              },),
                          ],
                        )
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // Continue with social login text
                  OrContinueWith(),
                  SizedBox(height: 15.h),

                  // Social buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildIconButton(
                        context,
                        AppImages.facebook,
                            () {},
                      ),
                      SizedBox(width: 20.w),
                      buildIconButton(
                        context,
                        AppImages.google,
                            () {},
                      ),
                    ],
                  ),

                  SizedBox(height: 20.h),
                  // Sign In link
                  Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: 'didnt_have_an_account'.tr,
                        style: TextStyle(
                            color: Colors.grey[800], fontSize: 16.sp),
                        children: [
                          TextSpan(
                            text: 'sign_up'.tr,
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // Handle Sign In link tap
                                Get.to(
                                      ()=>SignUpScreen(),
                                  transition: Transition.rightToLeft,
                                  duration: const Duration(milliseconds: 400),
                                );
                              },
                          ),
                        ],
                      ),
                    ),
                  ),

                  30.heightBox
                ],
              ),
            ),




          ],
        ),
      ),
    );
  }

  Widget buildIconButton(
      BuildContext context, String icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
          width: 80.w,
          height: 50.w,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.r),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 10,
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Image.asset(
            icon,
            scale: 4,
          )),
    );
  }
}
