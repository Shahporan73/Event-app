// ignore_for_file: prefer_const_constructors

import 'package:country_picker/country_picker.dart';
import 'package:event_app/res/common_widget/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../res/app_colors/App_Colors.dart';
import '../../../res/common_widget/RoundButton.dart';
import '../../../res/common_widget/RoundTextField.dart';
import '../../../res/common_widget/custom_app_bar.dart';
import '../../../res/common_widget/custom_network_image_widget.dart';
import '../../../res/common_widget/custom_text.dart';
import '../../../res/custom_style/custom_size.dart';
import '../widget/phone_number_field_widget.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

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
                CustomAppBar(
                  appBarName: "Edit Profile",
                  onTap: () {
                    Get.back();
                  },
                ),

                // Profile Image Picker
                heightBox20,
                Center(
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(30.r),
                        child: CustomNetworkImage(
                          imageUrl:
                          'https://media.istockphoto.com/id/1338134319/photo/portrait-of-young-indian-businesswoman-or-school-teacher-pose-indoors.jpg?s=612x612&w=0&k=20&c=Dw1nKFtnU_Bfm2I3OPQxBmSKe9NtSzux6bHqa9lVZ7A=',
                          width: ResponsiveHelper.w(context, 150),
                          height: ResponsiveHelper.h(context, 150),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.bgColor,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(10.r)),
                            ),
                            child: Icon(
                              Icons.camera_alt_outlined,
                              color: AppColors.primaryColor,
                              size: 28.w.h,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),


                // name
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    heightBox20,
                    CustomText(
                      title: "Name",
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.whiteDarker,
                    ),
                    heightBox10,
                    RoundTextField(
                      hint: 'James Tracy',
                      filled: true,
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                  ],
                ),

                // name
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    heightBox20,
                    CustomText(
                      title: "Email",
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.whiteDarker,
                    ),
                    heightBox10,
                    RoundTextField(
                      hint: 'example@gmail.com',
                      filled: true,
                      prefixIcon: Icon(Icons.email_outlined),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ],
                ),

                // phone number
                SizedBox(height: 20),
                PhoneNumberFieldWidget(),


                // Location
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    heightBox20,
                    CustomText(
                      title: "Location",
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.whiteDarker,
                    ),
                    heightBox10,
                    RoundTextField(
                      hint: 'New York, USA',
                      filled: true,
                    ),
                  ],
                ),

                SizedBox(height: 30),
                Roundbutton(
                  title: "Update",
                  onTap: () => Get.back(),
                ),

                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
