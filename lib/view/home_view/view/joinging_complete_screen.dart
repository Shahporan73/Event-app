// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:event_app/res/app_colors/App_Colors.dart';
import 'package:event_app/res/app_images/App_images.dart';
import 'package:event_app/res/common_widget/custom_text.dart';
import 'package:event_app/res/common_widget/lottie_loader_widget.dart';
import 'package:event_app/res/custom_style/custom_size.dart';
import 'package:event_app/view/home_view/view/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Make sure to import GetX for routing

class JoingingCompleteScreen extends StatefulWidget {
  JoingingCompleteScreen({super.key});

  @override
  _JoingingCompleteScreenState createState() => _JoingingCompleteScreenState();
}

class _JoingingCompleteScreenState extends State<JoingingCompleteScreen> {

  @override
  void initState() {
    super.initState();

    // After 3 seconds, navigate back to the HomeScreen
    Future.delayed(Duration(seconds: 3), () {
      Get.back(); // Go back to the previous screen
      Get.to(() => Home()); // Navigate to HomeScreen (replace with your actual HomeScreen widget)
    });
  }

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
            width: 200,
            height: 200,
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
            title: 'join_this_event_and_be_part_of_an_unforgettable_experience'.tr,
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
