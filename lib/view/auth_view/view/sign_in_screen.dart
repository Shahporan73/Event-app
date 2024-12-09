// ignore_for_file: prefer_const_constructors

import 'package:event_app/res/custom_style/custom_size.dart';
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

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _isPasswordVisible = false;
  bool isChecked = true;

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
              height: 200.h,
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
                     width: 180.w,
                   ),
                 ),
                  heightBox20,

                  // email field
                  CustomText(
                    title: "email".tr,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: AppColors.black33,
                  ),
                  heightBox8,
                  TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email_outlined),
                      hintText: 'example@gmail.com',
                      hintStyle:
                      TextStyle(color: Colors.grey, fontSize: 14.sp),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
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
                  TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                      hintText: '**********',
                      hintStyle:
                      TextStyle(color: Colors.grey, fontSize: 14.sp),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    obscureText: !_isPasswordVisible,
                  ),

                  SizedBox(height: 10.h),

                  // remember me
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        Checkbox(
                          activeColor: AppColors.primaryColor,
                          value: isChecked,
                          onChanged: (value) {
                            setState(() {
                              isChecked = value ?? true;
                            });
                          },
                        ),
                        CustomText(
                          title: "remember_me".tr,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: AppColors.black33,
                        ),
                      ],),

                      GestureDetector(
                        onTap: () {
                          Get.to(
                                ()=>ForgotPasswordScreen(),
                            transition: Transition.rightToLeft,
                            duration: Duration(milliseconds: 500),
                          );
                        },
                        child: CustomText(
                          title: "forgot_password".tr,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: AppColors.primaryColor,
                        ),
                      )

                    ],
                  ),

                  heightBox20,
                  // Sign In button
                  Roundbutton(
                    title: "sign_in".tr,
                    buttonColor: AppColors.primaryColor,
                    onTap: () {
                      Get.to(
                            ()=>Home(),
                        transition: Transition.rightToLeft,
                        duration: Duration(milliseconds: 500),
                      );
                    },
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
