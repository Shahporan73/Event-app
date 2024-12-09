// ignore_for_file: prefer_const_constructors

import 'package:event_app/res/custom_style/custom_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../res/app_colors/App_Colors.dart';
import '../../../res/common_widget/custom_app_bar.dart';
import '../../../res/common_widget/custom_text.dart';
import '../../../res/common_widget/responsive_helper.dart';

class NotificaitonScreen extends StatelessWidget {
  const NotificaitonScreen({super.key});

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
                  appBarName: "Notification",
                  onTap: () {
                    Get.back();
                  },
                ),

                heightBox20,
                ListView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Container(
                        // color: Colors.green,
                        width: ResponsiveHelper.w(context, 60),
                        child: Row(
                          children: [
                            CircleAvatar(radius: 5, backgroundColor: AppColors.primaryColor,),
                            widthBox5,
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Color(0xffE8EBF0),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.notifications_outlined,
                                color: AppColors.primaryColor,
                              ),
                            )
                          ],
                        ),
                      ),
                      title: CustomText(
                        title: 'Welcome, Your account has been created successfully.',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.black33,
                      ),
                      subtitle: CustomText(
                        title: '1 day ago',
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: AppColors.black100,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
