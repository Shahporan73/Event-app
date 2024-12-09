// ignore_for_file: prefer_const_constructors

import 'package:event_app/res/app_images/App_images.dart';
import 'package:event_app/res/common_widget/RoundTextField.dart';
import 'package:event_app/res/custom_style/custom_size.dart';
import 'package:event_app/view/create_event_view/view/user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../res/app_colors/App_Colors.dart';
import '../../../res/common_widget/custom_app_bar.dart';

class SeeAllMemeberScreen extends StatelessWidget {
  const SeeAllMemeberScreen({super.key});

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
                  appBarName: "Members",
                  onTap: () {
                    Get.back();
                  },
                ),
                heightBox20,

                RoundTextField(
                  hint: "Search Members",
                  borderRadius: 44.r,
                  focusBorderRadius: 44.r,
                  prefixIcon: Icon(
                    Icons.search_outlined,
                    size: 26.sp,
                  ),
                ),
                heightBox20,
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: 15,
                    physics: ScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(30.r),
                          child: Image.network(
                            'https://t4.ftcdn.net/jpg/03/64/21/11/360_F_364211147_1qgLVxv1Tcq0Ohz3FawUfrtONzz8nq3e.jpg',
                            width: 40.w,
                            height: 40.h,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(
                         'Alisa',
                          style: GoogleFonts.poppins(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        trailing: IconButton(
                          icon: Image.asset(AppImages.chatIcon,scale: 4,),
                          onPressed: () {
                            // Action for the message button
                          },
                        ),
                        onTap: () {
                          // Optional: Action on tapping the ListTile
                          Get.to(
                            () => UserProfileScreen(),
                            transition: Transition.leftToRight,
                            duration: Duration(milliseconds: 300),
                          );
                        },
                      );
                    },
                )

              ],
            ),
          ),
        ),
      ),
    );
  }

}
