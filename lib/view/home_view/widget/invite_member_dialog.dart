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

class InviteMemberDialog extends StatelessWidget {
  const InviteMemberDialog({super.key});
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
            title: 'Welcome to Our App!'.tr,
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: AppColors.primaryColor,
          ),
          heightBox5,
          CustomText(
            title: 'We are excited to have you here. Explore, connect, and enjoy!'.tr,
            fontSize: 12,
            textAlign: TextAlign.center,
            fontWeight: FontWeight.w400,
            color: AppColors.black100,
          ),
          heightBox10,
          Roundbutton(
            title: 'Get Started'.tr,
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
