// ignore_for_file: prefer_const_constructors

import 'package:event_app/res/common_widget/RoundButton.dart';
import 'package:event_app/res/common_widget/custom_network_image_widget.dart';
import 'package:event_app/res/common_widget/custom_text.dart';
import 'package:event_app/res/custom_style/custom_size.dart';
import 'package:event_app/view/auth_view/view/enable_location_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../res/app_colors/App_Colors.dart';

class AddContactScreen extends StatefulWidget {
  AddContactScreen({super.key});

  @override
  _AddContactScreenState createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  List<int> selectedContactIndices = [];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Stack(
        children: [
          Positioned.fill(
              child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Logo and title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(100.r),
                                child: CustomNetworkImage(
                                  imageUrl:
                                  'https://www.perfocal.com/blog/content/images/2021/01/Perfocal_17-11-2019_TYWFAQ_100_standard-3.jpg',
                                  height: 120.h,
                                  width: 120.w,
                                ),
                              ),
                              heightBox10,
                              CustomText(
                                  title: "Istiak Ahmed",
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.black100),
                            ],
                          ),
                        ),
                        widthBox10,
                        Expanded(
                          child: Column(
                            children: [
                              CustomText(
                                  title: 'end_of_registration'.tr,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primaryColor),
                              CustomText(
                                  title: '3_of_3'.tr,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.black100),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Divider(thickness: 1),
                    heightBox10,
                    // Add Contact
                    Center(
                      child: CustomText(
                          title: 'your_contacts_are_using_way_places'.tr,
                          fontSize: 16,
                          textAlign: TextAlign.center,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryColor),
                    ),
                    heightBox20,
                    Container(
                      width: width,
                      height: 80.h,
                      child: ListView.builder(
                        itemCount: 10,
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.only(right: 10),
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(100.r),
                                  child: CustomNetworkImage(
                                    imageUrl:
                                    'https://www.perfocal.com/blog/content/images/2021/01/Perfocal_17-11-2019_TYWFAQ_100_standard-3.jpg',
                                    height: 50.h,
                                    width: 50.w,
                                  ),
                                ),
                                CustomText(
                                  title: "Istiak Ahmed",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.black100,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Divider(),
                    heightBox20,
                    // RECOMMEND WAYPLACES
                    Center(
                      child: CustomText(
                          title: 'recommend_wayplaces'.tr,
                          fontSize: 22,
                          textAlign: TextAlign.center,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryColor),
                    ),
                    heightBox5,
                    CustomText(
                        title: "you_must_select_a_minimum_of_two_2_of_your_contacts".tr,
                        fontSize: 16,
                        textAlign: TextAlign.center,
                        fontWeight: FontWeight.w500,
                        color: AppColors.black100),
                    Divider(),
                    heightBox20,

                    ListView.builder(
                      itemCount: 8,
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        return CheckboxListTile(
                          value: selectedContactIndices.contains(index),
                          onChanged: (bool? selected) {
                            setState(() {
                              if (selected == true) {
                                selectedContactIndices.add(index);
                              } else {
                                selectedContactIndices.remove(index);
                              }
                            });
                          },
                          title: Text(
                            'Istiak Ahmed',
                            style: TextStyle(
                              color: AppColors.blackColor,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          secondary: CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(
                                'https://www.perfocal.com/blog/content/images/2021/01/Perfocal_17-11-2019_TYWFAQ_100_standard-3.jpg'),
                          ),
                          activeColor: AppColors.primaryColor,
                        );
                      },
                    ),


                    60.heightBox,

                  ],
                ),
              ),
            ),
          ),
          ),

          Positioned(
            bottom: 16,
            right: 16,
            left: 16,
              child: Roundbutton(
                title: 'continue'.tr,
                borderRadius: 44.r,
                onTap: () {
                  Get.to(
                        ()=> EnableLocationScreen(),
                    transition: Transition.rightToLeftWithFade,
                    duration: Duration(milliseconds: 500),
                  );
                },
              ),
          ),
        ],
      ),
    );
  }
}
