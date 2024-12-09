// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../app_colors/App_Colors.dart';
import '../custom_style/custom_size.dart';
import 'custom_network_image_widget.dart';
import 'custom_text.dart';

class LogoAppBar extends StatelessWidget {
  LogoAppBar({super.key});


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        heightBox10,
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100.r),
                    child: CustomNetworkImage(
                      imageUrl: 'https://picsum.photos/250?image=9',
                      width: 40.w,
                      height: 40.h,
                    ),
                  ),

                  // Centering the logo using Expanded and Align
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: CustomText(
                        title: 'Money Transfer',
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            GestureDetector(
              onTap: () {
                // Get.to(NotificationScreen());
              },
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: AppColors.primaryColor,
                    boxShadow: const [
                      BoxShadow(color: AppColors.whiteColor,
                          blurRadius: 10, offset: Offset(0, 1))
                    ]
                ),
                child: Icon(Icons.notifications, color: AppColors.whiteColor, size: 20.sp,),
              ),
            ),
          ],
        )
      ],
    );
  }
}
