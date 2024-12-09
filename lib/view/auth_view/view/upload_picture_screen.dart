// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:dotted_border/dotted_border.dart';
import 'package:event_app/res/app_images/App_images.dart';
import 'package:event_app/res/common_widget/RoundButton.dart';
import 'package:event_app/view/auth_view/view/add_contact_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../res/app_colors/App_Colors.dart';
import '../../../res/common_widget/custom_app_bar.dart';
import '../../../res/common_widget/custom_text.dart';
import '../../../res/custom_style/custom_size.dart';

class UploadPictureScreen extends StatelessWidget {
  const UploadPictureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50.r),
                  child: Image.asset(AppImages.placeholderImage,
                    width: 150, height: 150, fit: BoxFit.cover,
                  ),
                ),
              ),

              SizedBox(height: 15.h),
              CustomText(
                title: "profile_picture".tr,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.black100,
              ),
              heightBox10,
              CustomText(
                textAlign: TextAlign.center,
                title: 'the_profile_picture_is_necessary_to_guarantee_a_better_user_experience'.tr,
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
                title: "2_of_3".tr,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.black100,
              ),
              heightBox30,
              Row(
                children: [
                  Expanded(
                      child: DottedBorder(
                        color: AppColors.primaryColor,
                        // Dotted border color
                        strokeWidth: 1,
                        dashPattern: const [6, 3],
                        // Length of dashes and gaps
                        borderType: BorderType.RRect,
                        // Rounded rectangular border
                        radius: Radius.circular(6.r),
                        child: Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Color(0xffECF2FF),
                          ),
                          child: Column(
                            children: [
                              Image.asset(AppImages.captureCamera, scale: 4,),
                              heightBox10,
                              Roundbutton(
                                title: "Open camera",
                                padding_vertical: 5,
                                fontSize: 10,
                                borderRadius: 20.r,
                                onTap: () {},
                              ),
                            ],
                          ),
                        ),
                      ),
                  ),
                  widthBox10,
                  Expanded(
                    child: DottedBorder(
                      color: AppColors.primaryColor,
                      // Dotted border color
                      strokeWidth: 1,
                      dashPattern: const [6, 3],
                      // Length of dashes and gaps
                      borderType: BorderType.RRect,
                      // Rounded rectangular border
                      radius: Radius.circular(6.r),
                      child: Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Color(0xffECF2FF),
                        ),
                        child: Column(
                          children: [
                            Image.asset(AppImages.captureGallery, scale: 4,),
                            heightBox10,
                            Roundbutton(
                              title: "Open gallery",
                              padding_vertical: 5,
                              fontSize: 10,
                              borderRadius: 20.r,
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),



                ],
              ),

              heightBox50,
              Roundbutton(
                title: "continue".tr,
                padding_vertical: 15,
                borderRadius: 44.r,
                onTap: (){
                  Get.to(
                      ()=>AddContactScreen(),
                    transition: Transition.rightToLeft,
                    duration: const Duration(milliseconds: 500),
                  );
                },
              ),


            ],
          ),
        ),
      ),
    );
  }
}
