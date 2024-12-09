// ignore_for_file: prefer_const_constructors

import 'package:event_app/data/translation/my_translation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../res/common_widget/custom_text.dart';

class OrContinueWith extends StatelessWidget {
  const OrContinueWith({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the screen width and height
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Row(
      children: [
        Expanded(
          child: Container(
            width: width,
            height: 1,
            decoration: BoxDecoration(
              color: Color(0xffCECECE),
            ),
          ),
        ),
        SizedBox(width: 5,),
        Container(
          alignment: Alignment.center,
          child:  CustomText(
            title: "or_continue_with".tr,
            color: Color(0xff5A5A5A),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(width: 5,),
        Expanded(
          child: Container(
            width: width,
            height: 1,
            decoration: BoxDecoration(
              color: Color(0xffCECECE),
            ),
          ),
        ),
      ],
    );
  }
}