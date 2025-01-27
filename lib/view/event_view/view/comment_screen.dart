// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, avoid_unnecessary_containers, prefer_interpolation_to_compose_strings

import 'package:event_app/data/token_manager/const_veriable.dart';
import 'package:event_app/data/token_manager/local_storage.dart';
import 'package:event_app/res/app_colors/App_Colors.dart';
import 'package:event_app/res/app_images/App_images.dart';
import 'package:event_app/res/common_widget/custom_network_image_widget.dart';
import 'package:event_app/res/common_widget/custom_text.dart';
import 'package:event_app/res/common_widget/responsive_helper.dart';
import 'package:event_app/res/custom_style/custom_size.dart';
import 'package:event_app/res/utils/time_convetor.dart';
import 'package:event_app/view/event_view/controller/comment_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class CommentScreen extends StatelessWidget {
  final String postId;
  CommentScreen({super.key, required this.postId});

  final CommentController controller = Get.put(CommentController());

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
                  child: Obx(
                    () {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          heightBox20,
                          CustomText(
                            title: "comments".tr+" (${controller.commentList.length ?? 0})",
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          Divider(
                            thickness: 1.5,
                          ),
                          controller.isLoading.value ? SpinKitCircle(color: AppColors.primaryColor,) : ListView.builder(
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            itemCount: controller.commentList.length,
                            itemBuilder: (context, index) {
                              var data = controller.commentList[index];
                              String time =
                                  getRelativeTime(data.createdAt.toString());
                              return Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(50.r),
                                      child: CustomNetworkImage(
                                        imageUrl: data.user?.profilePicture ??
                                            placeholderImage,
                                        width: ResponsiveHelper.w(context, 50),
                                        height: ResponsiveHelper.h(context, 50),
                                      ),
                                    ),
                                    widthBox14,
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CustomText(
                                              title: data.user?.name ?? "",
                                              fontSize: 15,
                                              color: AppColors.blackColor,
                                              fontWeight: FontWeight.w600),
                                          heightBox5,
                                          CustomText(
                                              title: time,
                                              fontSize: 11,
                                              color: Color(0xff81999E),
                                              fontWeight: FontWeight.w400),
                                          heightBox10,
                                          CustomText(
                                              title: data.body ?? "no_comment".tr,
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
                          ),
                          heightBox50,

                        ],
                      );
                    },
                  ),
                )),
          )),

          Positioned(
            top: 16,
            left: 16,
            child: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            ),
          ),

          // write comment Box
          Positioned(
            bottom: 16,
              right: 16,
              left: 16,
              child: Container(
                width: width,
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
                        controller: controller.commentController,
                        maxLines: 1,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Color(0xffF2F2F3),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16),
                            hintText: 'be_the_first_to_comment'.tr,
                            hintStyle:
                            TextStyle(color: Color(0xffA0A0A0)),
                            border: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.circular(8.r),
                              borderSide: BorderSide.none,
                            )),
                      ),
                    ),
                    widthBox10,
                    Obx(() => InkWell(
                      onTap: () {
                        controller.createComment(postId);
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: controller.isCreateLoading.value ?
                        SpinKitDualRing(color: AppColors.whiteColor, size: 15,) :
                        Image.asset(
                          AppImages.sendIcon,
                          scale: 4,
                        ),
                      ),
                      ),
                    ),
                  ],
                ),
              ),
          ),
        ],
      ),
    );
  }
}
