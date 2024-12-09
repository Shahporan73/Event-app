// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../app_colors/App_Colors.dart';
import 'custom_text.dart';

class CustomAppBar extends StatelessWidget {
  final String appBarName;
  final Color titleColor;
  final Color leadingColor;
  final VoidCallback? onTap;
  final Widget? widget;

  const CustomAppBar({
    super.key,
    required this.appBarName,
    this.titleColor = AppColors.black33,
    this.onTap,
    this.leadingColor = Colors.black,
    this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Left-aligned back button or custom widget
        Positioned(
          left: 0,
          child: widget ??
              GestureDetector(
                onTap: onTap,
                child: Padding(
                  padding: EdgeInsets.zero,
                  child: Icon(Icons.arrow_back, color: leadingColor, size: 24.sp),
                ),
              ),
        ),

        // Center-aligned title
        Center(
          child: CustomText(
            title: appBarName,
            color: titleColor,
            fontWeight: FontWeight.w500,
            fontSize: 20.sp,
          ),
        ),
      ],
    );
  }
}
