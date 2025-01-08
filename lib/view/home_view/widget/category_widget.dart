// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:event_app/res/app_colors/App_Colors.dart';
import 'package:event_app/res/app_images/App_images.dart';
import 'package:event_app/res/common_widget/custom_network_image_widget.dart';
import 'package:event_app/res/common_widget/custom_text.dart';
import 'package:event_app/res/common_widget/responsive_helper.dart';
import 'package:event_app/res/custom_style/custom_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryWidget extends StatelessWidget {
  final String title;
  final String image;
  final bool isSelected;

  CategoryWidget({
    super.key,
    required this.title,
    required this.image,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primaryColor : Color(0xffF2F2F3),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.02),
            offset: Offset(0.0, 1.0), // (x,y)
            blurRadius: 6.0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomNetworkImage(
            imageUrl: image,
            width: ResponsiveHelper.w(context, 24),
            height: ResponsiveHelper.h(context, 24),
            backgroundColor: isSelected ? Colors.white : Colors.black,
          ),
          SizedBox(width: 10.w),
          CustomText(
            title: title,
            fontSize: 14,
            overflow: TextOverflow.ellipsis,
            fontWeight: FontWeight.w400,
            color: isSelected ? Colors.white : Colors.black,
          ),
        ],
      ),
    );
  }
}

