import 'dart:async';

import 'package:event_app/main.dart';
import 'package:event_app/res/app_colors/App_Colors.dart';
import 'package:event_app/res/app_images/App_images.dart';
import 'package:event_app/res/common_widget/RoundButton.dart';
import 'package:event_app/res/common_widget/custom_text.dart';
import 'package:event_app/res/common_widget/lottie_loader_widget.dart';
import 'package:event_app/res/custom_style/custom_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../res/common_widget/responsive_helper.dart';

class WelcomeDialog extends StatelessWidget {
  WelcomeDialog({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          LottieLoaderWidget(
            lottieAssetPath: AppImages.welcomeLottie,
            width: 200,
            height: 150,
            repeat: true,
          ),
          CustomText(
            title: 'welcome_to_bashpin'.tr,
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: AppColors.primaryColor,
          ),
          heightBox5,
          CustomText(
            title: 'we_are_excited_to_have_you_here_explore_connect_and_enjoy'.tr,
            fontSize: 12,
            textAlign: TextAlign.center,
            fontWeight: FontWeight.w400,
            color: AppColors.black100,
          ),
          heightBox10,
          Roundbutton(
              title: 'get_started'.tr,
              padding_vertical: 8,
              borderRadius: 4,
              fontSize: 14,
              onTap: ()=>Navigator.of(context).pop(),
          )
        ],
      ),
    );
  }
}
