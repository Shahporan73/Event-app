// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomText extends StatelessWidget {
  final String title;
  final double fontSize;
  final Color color;
  final FontWeight fontWeight;
  final TextDecoration? decoration;
  final Color? decorationColor;
  final double? decorationThickness;
  final TextAlign? textAlign;
  CustomText({super.key,
    required this.title,
    this.fontSize=12,
    this.color=Colors.black,
    this.fontWeight=FontWeight.normal,
    this.decoration=TextDecoration.none,
    this.decorationColor=Colors.deepOrangeAccent,
    this.decorationThickness = 2,
    this.textAlign=TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: textAlign,
      style: GoogleFonts.poppins(
        fontSize: fontSize.sp,
        color: color,
        fontWeight: fontWeight,
        decoration: decoration,
        decorationColor:decorationColor,
        decorationThickness: decorationThickness,
      ),
    );
  }
}
