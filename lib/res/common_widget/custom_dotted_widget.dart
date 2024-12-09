// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'custom_text.dart';

class CustomDottedWidget extends StatelessWidget {
  final VoidCallback? onTap;
  final Color dottedColor;
  final Color buttonColor;
  final Color textColor;
  final Widget? centerWidget;
  final double? containerHeight;
  CustomDottedWidget({
    super.key,
    this.onTap,
    this.dottedColor=Colors.black,
    this.buttonColor=Colors.black,
    this.textColor=Colors.black,
    this.centerWidget,
    this.containerHeight
  });

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        DottedBorder(
          color: dottedColor,
          // Dotted border color
          strokeWidth: 1,
          dashPattern: const [6, 3],
          // Length of dashes and gaps
          borderType: BorderType.RRect,
          // Rounded rectangular border
          radius: Radius.circular(6.r),
          // Border radius
          child: Container(
            width: width,
            height: containerHeight ?? 150,
            decoration: BoxDecoration(
              color: Colors
                  .transparent, // Background color inside dotted border
            ),
          ),
        ),
        Positioned.fill(
          child: GestureDetector(
            onTap: onTap,
            child: centerWidget ?? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.add,
                  size: 32,
                  color: buttonColor,
                ),
                SizedBox(
                  height: 5,
                ),
                CustomText(
                  title: "Upload",
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
