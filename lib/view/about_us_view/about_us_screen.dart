// ignore_for_file: prefer_const_constructors

import 'package:event_app/res/common_widget/custom_text.dart';
import 'package:event_app/res/custom_style/custom_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import '../../data/html_view/html_view.dart';
import '../../res/app_colors/App_Colors.dart';
import '../../res/common_widget/custom_app_bar.dart';
import '../settings_view/controller/setting_controller.dart';

class AboutUsScreen extends StatelessWidget {
   AboutUsScreen({super.key});
   final SettingController controller = Get.put(SettingController());
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        title: CustomText(title: 'about_us'.tr, fontSize: 18, fontWeight: FontWeight.w600,),
        backgroundColor: AppColors.bgColor,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        child: Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            controller.isLoading.value? Center(
              child: SpinKitCircle(
                color: AppColors.primaryColor,
              ),
            )  :HTMLView(
                htmlData: controller.aboutUs.value.toString()
            ),
          ],
        ),),
      ),
    );
  }
}