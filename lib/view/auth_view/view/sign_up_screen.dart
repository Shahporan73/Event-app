// ignore_for_file: prefer_const_constructors

import 'package:event_app/res/custom_style/custom_size.dart';
import 'package:event_app/view/auth_view/controller/sign_in_controller.dart';
import 'package:event_app/view/auth_view/controller/sign_up_controller.dart';
import 'package:event_app/view/auth_view/view/sign_in_screen.dart';
import 'package:event_app/view/auth_view/view/upload_picture_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../res/app_colors/App_Colors.dart';
import '../../../res/app_images/App_images.dart';
import '../../../res/common_widget/RoundButton.dart';
import '../../../res/common_widget/custom_text.dart';
import '../widget/or_continue_with.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final SignUpController controller = Get.put(SignUpController());
  final SignInController signInController = Get.put(SignInController());

  var loading = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.w),
          child: Obx(() {
            return Column(
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
                        width: 130,
                      ),
                    ),

                    SizedBox(height: 10),
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
                CustomText(title: "username".tr,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: AppColors.black33,
                ),
                heightBox8,
                TextField(
                  controller: controller.fullNameController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    hintText: 'enter_user_name'.tr,
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    errorText: controller.fullName.value.isNotEmpty
                        ? controller.fullName.value
                        : null,
                  ),
                  keyboardType: TextInputType.text,
                ),
                SizedBox(height: 15),


                // email field
                CustomText(title: "email".tr,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: AppColors.black33,
                ),
                heightBox8,
                TextField(
                  controller: controller.emailController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email_outlined),
                    hintText: 'example@gmail.com',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    errorText: controller.email.value.isNotEmpty
                        ? controller.email.value
                        : null,
                  ),

                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 15),

                // Password field with toggle
                CustomText(title: "password".tr,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: AppColors.black33,
                ),
                heightBox8,
                TextField(
                  controller: controller.passwordController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isPasswordVisible.value ? Icons.visibility : Icons.visibility_off,
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

                SizedBox(height: 20),
                // Accept terms and policy with conditional background
                Roundbutton(
                  title: "sign_up".tr,
                  buttonColor: AppColors.primaryColor,
                  isLoading: loading.value,
                  onTap: () {
                    loading.value = true;
                    if(controller.validateForm()){
                      Future.delayed(const Duration(seconds: 2), () {
                        Get.to(
                              () => UploadPictureScreen(),
                          transition: Transition.rightToLeft,
                          duration: const Duration(milliseconds: 300),
                        );
                        loading.value = false;
                      });
                    }
                    else{
                      // Get.snackbar("error".tr, "please_fill_all_the_fields".tr);
                      loading.value = false;
                    }
                  },

                ),

                SizedBox(height: 20),

                // Continue with social login text
                OrContinueWith(),
                SizedBox(height: 15),

                // Social buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /*buildIconButton(context,
                      AppImages.facebook,
                          () {},
                    ),*/
                    SizedBox(width: 20),
                    buildIconButton(context,
                      AppImages.google,
                          () async {
                            signInController.onGoogleSignIn();
                          },
                    ),
                  ],
                ),

                SizedBox(height: 20),
                // Sign In link
                Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: 'already_have_an_account'.tr,
                      style: TextStyle(color: Colors.grey[800], fontSize: 16),
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
            );
          },),
        ),
      ),
    );
  }

  Widget buildIconButton(
      BuildContext context,
      String icon,
      VoidCallback onTap
      ) {
    return InkWell(
      onTap: onTap,
      child: Container(
          width: 150,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
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
