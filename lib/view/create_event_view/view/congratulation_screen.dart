import 'dart:async';

import 'package:event_app/main.dart';
import 'package:event_app/res/app_colors/App_Colors.dart';
import 'package:event_app/res/app_images/App_images.dart';
import 'package:event_app/res/common_widget/custom_text.dart';
import 'package:event_app/res/common_widget/lottie_loader_widget.dart';
import 'package:event_app/res/custom_style/custom_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CongratulationScreen extends StatelessWidget {
  CongratulationScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          LottieLoaderWidget(
            lottieAssetPath: AppImages.successAnim,
            width: 100,
            height: 100,
            repeat: false,
          ),

          heightBox20,
          CustomText(
            title: 'congratulation'.tr,
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: AppColors.primaryColor,
          ),

          heightBox20,
          CustomText(
            title: 'you_have_successfully_invited_this_person_to_join_the_event'.tr,
            fontSize: 16,
            textAlign: TextAlign.center,
            fontWeight: FontWeight.w400,
            color: AppColors.black100,
          ),
        ],
      ),
    );
  }
}
