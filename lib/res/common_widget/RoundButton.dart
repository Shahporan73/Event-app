
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app_colors/App_Colors.dart';

// round_button.dart

class Roundbutton extends StatelessWidget {
  final String title;
  final void Function()? onTap;
  final bool isLoading;
  final double width;
  final double padding_vertical;
  final double borderRadius;
  final Color? buttonColor;
  final double fontSize;
  final BoxBorder? border;
  final Color? titleColor;
  final Widget? widget;

  const Roundbutton({
    super.key,
    required this.title,
    required this.onTap,
    this.isLoading = false, // Ensure this is false by default
    this.width = double.infinity,
    this.padding_vertical = 12.0,
    this.borderRadius = 44.0,
    this.buttonColor = AppColors.primaryColor,
    this.border,
    this.titleColor = Colors.white,
    this.widget,
    this.fontSize = 18.0,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(borderRadius.r),
          border: border,
        ),
        width: width,
        padding: EdgeInsets.symmetric(vertical: padding_vertical.h),
        child: isLoading
            ? Center(
          child: SpinKitDualRing(
            size: 20,
            color: Colors.white,
          ),
        )
            : widget ??
            Text(
              title,
              style: GoogleFonts.dmSans(
                fontSize: fontSize.sp,
                fontWeight: FontWeight.w500,
                color: titleColor,
              ),
            ),
      ),
    );
  }
}

// isLoading == true ? Center(child: const CircularProgressIndicator(color: Colors.green,)) :