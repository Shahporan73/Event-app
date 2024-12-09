// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables

import 'package:event_app/res/common_widget/RoundButton.dart';
import 'package:event_app/res/common_widget/RoundTextField.dart';
import 'package:event_app/res/common_widget/custom_network_image_widget.dart';
import 'package:event_app/res/common_widget/custom_text.dart';
import 'package:event_app/res/common_widget/responsive_helper.dart';
import 'package:event_app/res/custom_style/custom_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../res/app_colors/App_Colors.dart';
import '../../../res/common_widget/custom_app_bar.dart';
import 'camera_screen.dart';

class CreatePostScreen extends StatelessWidget {
  const CreatePostScreen({super.key});

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAppBar(
                  appBarName: "New Post",
                  onTap: () {
                    Get.back();
                  },
                ),

                heightBox20,
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        openCameraDialog(context);
                      },
                      child: Container(
                        width: ResponsiveHelper.w(context, 80),
                        height: ResponsiveHelper.h(context, 80),
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          border: Border.all(width: 0.5, color: Color(0xffBBC3CB)),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.blue,
                            size: 32.sp,
                          ),
                        ),
                      ),
                    ),

                    widthBox10,
                    Container(
                        width: ResponsiveHelper.w(context, 80),
                        height: ResponsiveHelper.h(context, 80),
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          border: Border.all(width: 0.5, color: Color(0xffBBC3CB),),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle
                            ),
                            child: Icon(
                              Icons.add, color: Colors.white,
                            ),
                          ),
                        )
                    ),
                    widthBox10,
                    Container(
                        width: ResponsiveHelper.w(context, 80),
                        height: ResponsiveHelper.h(context, 80),
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          border: Border.all(width: 0.5, color: Color(0xffBBC3CB),),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.r),
                          child: CustomNetworkImage(
                              imageUrl: 'https://www.perfocal.com/blog/content/images/2021/01/Perfocal_17-11-2019_TYWFAQ_100_standard-3.jpg',
                              height: height,
                              width: width
                          ),
                        ),
                    ),
                  ],
                ),

                heightBox40,
                RoundTextField(
                    hint: "What you want to say?",
                  maxLine: 4,
                ),


              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: ResponsiveHelper.h(context, 60),
        width: width,
        margin: EdgeInsets.only(left: 10, right: 10, bottom: 50),
        child: Roundbutton(
            title: "Post Now",
            onTap: () {},
        ),
      ),
    );
  }

  Future<void> openCameraDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                CustomText(
                  textAlign: TextAlign.center,
                    title: 'Record videos effortlessly with '
                        'a 120-second duration—perfect for '
                        'capturing concise,impactful moments!',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Color(0xff595959),

                ),
              ],
            ),
          ),
          actions: <Widget>[
           Roundbutton(
               title: "Open Camera",
               fontSize: 14,
               onTap: (){
                 // Dismiss the dialog
                 Navigator.of(context).pop();
                 // Navigate to CameraPage
                 Get.to(() => CameraPage());
             }
           ),
          ],
        );
      },
    );
  }

}
