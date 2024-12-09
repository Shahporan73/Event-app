
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app_colors/App_Colors.dart';

class Roundbutton extends StatelessWidget {
  final String title;
  final void Function()? onTap;
  final bool isLoading = false;
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
    isLoading,
    this.width=380,
    this.padding_vertical = 12.0,
    this.borderRadius = 44.0,
    this.buttonColor = AppColors.primaryColor,
    this.border,
    this.titleColor=Colors.white,
    this.widget,
    this.fontSize=18.0
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
          duration:const Duration(milliseconds: 500),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color:buttonColor,
            borderRadius: BorderRadius.circular(borderRadius.r),
            border: border,
          ),

          width: width,
          padding: EdgeInsets.symmetric(vertical: padding_vertical.h),
          child: widget?? Text(
            title,
            style: GoogleFonts.dmSans(
                fontSize: fontSize.sp,
                fontWeight: FontWeight.w500,
                color: titleColor
            ),
          )
      ),
    );
  }
}
// isLoading == true ? Center(child: const CircularProgressIndicator(color: Colors.green,)) :