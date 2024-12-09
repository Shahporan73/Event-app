// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, avoid_unnecessary_containers

import 'package:event_app/res/app_colors/App_Colors.dart';
import 'package:event_app/res/app_images/App_images.dart';
import 'package:event_app/res/common_widget/custom_network_image_widget.dart';
import 'package:event_app/res/common_widget/custom_text.dart';
import 'package:event_app/res/common_widget/responsive_helper.dart';
import 'package:event_app/res/custom_style/custom_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommentScreen extends StatelessWidget {
  const CommentScreen({super.key});

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
                heightBox20,
                CustomText(
                  title: "Comments (23)",
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                Divider(
                  thickness: 1.5,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding: EdgeInsets.all(10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50.r),
                            child: CustomNetworkImage(
                              imageUrl:
                                  'https://www.perfocal.com/blog/content/images/2021/01/Perfocal_17-11-2019_TYWFAQ_100_standard-3.jpg',
                              width: ResponsiveHelper.w(context, 50),
                              height: ResponsiveHelper.h(context, 50),
                            ),
                          ),
                          widthBox14,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                    title: "Abil  wardani",
                                    fontSize: 15,
                                    color: AppColors.blackColor,
                                    fontWeight: FontWeight.w600),
                                heightBox5,
                                CustomText(
                                    title: "1 minutes",
                                    fontSize: 11,
                                    color: Color(0xff81999E),
                                    fontWeight: FontWeight.w400),
                                heightBox10,
                                CustomText(
                                    title:
                                        "so beautifull picture,where did you get that picture from? are you a photographer",
                                    fontSize: 11,
                                    color: AppColors.blackColor,
                                    fontWeight: FontWeight.w400),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),

      bottomNavigationBar: Container(
        width: width,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xffF2F2F3),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  hintText: 'be the first to comment',
                  hintStyle: TextStyle(color: Color(0xffA0A0A0)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide.none,
                  )
                ),
              ),
            ),
            widthBox10,
            InkWell(
              onTap: (){},
              child: Container(
                width: 50.w,
                height: 50.w,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Image.asset(
                  AppImages.sendIcon,
                  scale: 4,
                ),
              ),
            ),
          ],
        ),

      ),
    );
  }
}
