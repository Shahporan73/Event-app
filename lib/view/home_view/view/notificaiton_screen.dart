// ignore_for_file: prefer_const_constructors

import 'package:event_app/res/custom_style/custom_size.dart';
import 'package:event_app/view/home_view/controller/notification_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../res/app_colors/App_Colors.dart';
import '../../../res/common_widget/custom_app_bar.dart';
import '../../../res/common_widget/custom_text.dart';
import '../../../res/common_widget/responsive_helper.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({super.key});

  final NotificationController controller = Get.put(NotificationController());
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    // Add a listener to the ScrollController for pagination
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent &&
          !controller.isFetchingMore.value) {
        controller.getNotification(isLoadMore: true);
      }
    });

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
              Expanded(
                child: Obx(
                      () {
                    if (controller.isLoading.value && controller.notificationList.isEmpty) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryColor,
                        ),
                      );
                    }

                    return controller.notificationList.isEmpty
                        ? Center(
                      child: CustomText(title: 'No Notification'),
                    )
                        : ListView.builder(
                      controller: scrollController,
                      itemCount: controller.notificationList.length +
                          (controller.isFetchingMore.value ? 1 : 0),
                      itemBuilder: (context, index) {
                        // Show loader at the end of the list when loading more
                        if (index == controller.notificationList.length &&
                            controller.isFetchingMore.value) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primaryColor,
                              ),
                            ),
                          );
                        }

                        var data = controller.notificationList[index];
                        return ListTile(
                          leading: Container(
                            width: ResponsiveHelper.w(context, 60),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 5,
                                  backgroundColor: AppColors.primaryColor,
                                ),
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
                            title: data.body ?? '',
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
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
