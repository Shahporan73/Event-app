// ignore_for_file: prefer_const_constructors

import 'package:event_app/res/custom_style/custom_size.dart';
import 'package:event_app/view/auth_view/view/sign_in_screen.dart';
import 'package:event_app/view/auth_view/view/upload_picture_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../res/app_colors/App_Colors.dart';
import '../../../res/app_images/App_images.dart';
import '../../../res/common_widget/RoundButton.dart';
import '../../../res/common_widget/custom_app_bar.dart';
import '../../../res/common_widget/custom_text.dart';
import '../widget/or_continue_with.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isTermsAccepted = false; // Track checkbox state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Logo and title
              Column(
                children: [

                  SizedBox(height: 10.h),
                  CustomText(
                    title: 'welcome_to_way_places'.tr,
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                  ),

                  heightBox20,
                  Center(
                    child: Image.asset(
                      AppImages.appLogo,
                      width: 130.w,
                    ),
                  ),

                  SizedBox(height: 10.h),
                  CustomText(
                    textAlign: TextAlign.center,
                    title: 'now_enjoy_the_advantage_of_going_to_a_place_and_knowing_with_people_you_can_share'.tr,
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Color(0xff5C5C5C),
                  ),
                  heightBox10,
                  Center(
                    child: Container(
                      width: 120.w,
                      height: 1.5,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  heightBox10,
                  CustomText(
                      title: "registration".tr,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryColor,
                  ),
                  CustomText(
                    title: "1_of_3".tr,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black100,
                  ),
                ],
              ),
              heightBox20,
              // Phone number field
              CustomText(title: "full_name".tr,
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: AppColors.black33,
              ),
              heightBox8,
              TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  hintText: 'Ryan renold',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: 15.h),


              // email field
              CustomText(title: "email".tr,
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: AppColors.black33,
              ),
              heightBox8,
              TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email_outlined),
                  hintText: 'example@gmail.com',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 15.h),

              // Password field with toggle
              CustomText(title: "password".tr,
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
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                  hintText: '**********',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                obscureText: !_isPasswordVisible,
              ),
              SizedBox(height: 15.h),

              // Confirm password field with toggle
              CustomText(title: "confirm_password".tr,
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
                      _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      });
                    },
                  ),
                  hintText: '**********',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                obscureText: !_isConfirmPasswordVisible,
              ),


              SizedBox(height: 20.h),
              // Accept terms and policy with conditional background
              Roundbutton(
                title: "sign_up".tr,
                buttonColor: AppColors.primaryColor,
                onTap: () {
                  Get.to(
                        ()=>UploadPictureScreen(),
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
                  buildIconButton(context,
                    AppImages.facebook,
                        () {},
                  ),
                  SizedBox(width: 20.w),
                  buildIconButton(context,
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
                    text: 'already_have_an_account'.tr,
                    style: TextStyle(color: Colors.grey[800], fontSize: 16.sp),
                    children: [
                      TextSpan(
                        text: 'sign_in'.tr,
                        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                        recognizer: TapGestureRecognizer()..onTap = () {
                          // Handle Sign In link tap
                          Get.to(
                                ()=>SignInScreen(),
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
      ),
    );
  }

  Widget buildIconButton(
      BuildContext context, String icon, VoidCallback onTap
      ) {
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
          )
      ),
    );
  }

}