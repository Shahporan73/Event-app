// ignore_for_file: prefer_const_constructors


import 'package:event_app/res/app_colors/App_Colors.dart';
import 'package:event_app/res/common_widget/RoundButton.dart';
import 'package:event_app/res/common_widget/custom_app_bar.dart';
import 'package:event_app/res/common_widget/custom_text.dart';
import 'package:event_app/view/auth_view/view/forgot_password_screen.dart';
import 'package:event_app/view/settings_view/controller/change_psssword_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ChangePasswordScreen extends StatelessWidget {
  ChangePasswordScreen({super.key});

  final ChangePasswordController controller = Get.put(ChangePasswordController());
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
            child: Obx(
                  () {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    CustomAppBar(
                      appBarName: "Change Password",
                      onTap: () => Get.back(),
                    ),

                    // Current Password Field
                    SizedBox(height: 50),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Color(0xffFFFFFF),
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.lock_outline, color: Colors.black54),
                          SizedBox(width: 16),
                          Expanded(
                            child: TextField(
                              controller: controller.oldPasswordController,
                              obscureText: !controller.isCurrentPasswordVisible.value,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Current Password',
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              controller.isCurrentPasswordVisible.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.black54,
                            ),
                            onPressed: controller.toggleCurrentPasswordVisibility,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),

                    // New Password Field
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Color(0xffFFFFFF),
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.lock_outline, color: Colors.black54),
                          SizedBox(width: 16),
                          Expanded(
                            child: TextField(
                              controller: controller.newPasswordController,
                              obscureText: !controller.isNewPasswordVisible.value,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'New Password',
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              controller.isNewPasswordVisible.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.black54,
                            ),
                            onPressed: controller.toggleNewPasswordVisibility,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),

                    // Confirm Password Field
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Color(0xffFFFFFF),
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.lock_outline, color: Colors.black54),
                          SizedBox(width: 16),
                          Expanded(
                            child: TextField(
                              controller: controller.confirmPasswordController,
                              obscureText: !controller.isConfirmPasswordVisible.value,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Confirm New Password',
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              controller.isConfirmPasswordVisible.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.black54,
                            ),
                            onPressed: controller.toggleConfirmPasswordVisibility,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),

                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          Get.to(
                                ()=> ForgotPasswordScreen(),
                            transition: Transition.rightToLeft,
                            duration: Duration(milliseconds: 500),
                          );
                        },
                        child: CustomText(
                          title: "Forgot the password?",
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Confirm button
                    Roundbutton(
                      isLoading: controller.isLoading.value,
                      title: "Confirm",
                      borderRadius: 8,
                      onTap: () {
                        // Handle password change confirmation
                        controller.onChangePassword(context);
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
