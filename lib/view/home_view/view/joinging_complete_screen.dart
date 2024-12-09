// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:event_app/res/app_colors/App_Colors.dart';
import 'package:event_app/res/app_images/App_images.dart';
import 'package:event_app/res/common_widget/custom_text.dart';
import 'package:event_app/res/common_widget/lottie_loader_widget.dart';
import 'package:event_app/res/custom_style/custom_size.dart';
import 'package:flutter/material.dart';

class JoingingCompleteScreen extends StatelessWidget {
  const JoingingCompleteScreen({super.key});

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
            width: 200,height: 200,
            repeat: true,
          ),

          heightBox20,
          CustomText(
              title: 'Congratulation',
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: AppColors.primaryColor,
          ),

          heightBox20,
          CustomText(
            title: 'Join this event and be part of an unforgettable experience!',
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
