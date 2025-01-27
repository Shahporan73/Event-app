// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables

import 'package:event_app/res/common_widget/RoundButton.dart';
import 'package:event_app/res/common_widget/RoundTextField.dart';
import 'package:event_app/res/common_widget/custom_network_image_widget.dart';
import 'package:event_app/res/common_widget/custom_text.dart';
import 'package:event_app/res/common_widget/responsive_helper.dart';
import 'package:event_app/res/custom_style/custom_size.dart';
import 'package:event_app/view/event_view/controller/camera_controller.dart';
import 'package:event_app/view/event_view/controller/post_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../res/app_colors/App_Colors.dart';
import '../../../res/common_widget/custom_app_bar.dart';
import 'camera_screen.dart';

class CreatePostScreen extends StatelessWidget {
  final String eventId;
  CreatePostScreen({super.key, required this.eventId});

  final PostController postController = Get.put(PostController());
  final CameraManager cameraController = Get.put(CameraManager());

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Obx(
            () {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomAppBar(
                    appBarName: "new_post".tr,
                    onTap: () {
                      Get.back();
                    },
                  ),

                  // select video and image
                  heightBox20,
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            openCameraDialog(context);
                          },
                          child: Container(
                            width: ResponsiveHelper.w(context, 80),
                            height: ResponsiveHelper.h(context, 80),
                            decoration: BoxDecoration(
                              color: AppColors.whiteColor,
                              border: Border.all(
                                  width: 0.5, color: Color(0xffBBC3CB)),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.camera_alt_outlined,
                                color: Colors.blue,
                                size: 32,
                              ),
                            ),
                          ),
                        ),

                        widthBox10,

                        // Add Image
                        GestureDetector(
                          onTap: () {
                            postController.pickImages();
                          },
                          child: Container(
                            width: ResponsiveHelper.w(context, 80),
                            height: ResponsiveHelper.h(context, 80),
                            decoration: BoxDecoration(
                              color: AppColors.whiteColor,
                              border: Border.all(
                                width: 0.5,
                                color: Color(0xffBBC3CB),
                              ),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Center(
                              child: Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: Colors.blue, shape: BoxShape.circle),
                                child: postController.isUploading.value ? CircularProgressIndicator() : Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        widthBox10,
                        Row(
                            children: postController.uploadedImageUrls.isEmpty ? [] :
                            List.generate(
                              postController.uploadedImageUrls.length,
                          (index) => Container(
                            width: ResponsiveHelper.w(context, 80),
                            height: ResponsiveHelper.h(context, 80),
                            margin: EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              color: AppColors.whiteColor,
                              border: Border.all(
                                width: 0.5,
                                color: Color(0xffBBC3CB),
                              ),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.r),
                              child: CustomNetworkImage(
                                  imageUrl: postController.uploadedImageUrls[index],
                                  height: height,
                                  width: width
                              ),
                            ),
                          ),
                        )),
                      ],
                    ),
                  ),


                  heightBox30,

                  // image , video , content
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          postController.uploadImageList.isEmpty ? SizedBox() : Row(
                            children: [
                              CustomText(
                                  title: "remove"+" ${postController.uploadImageList.length} "+"images".tr,
                                  fontWeight: FontWeight.w400, fontSize: 14,
                                  color: Colors.green
                              ),
                              Spacer(),
                              GestureDetector(
                                onTap: () {
                                  postController.deletedImages();
                                },
                                child: postController.isDeleting.value ? CircularProgressIndicator() : Icon(
                                  Icons.cancel_outlined,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),


                          // video
                          heightBox20,
                          cameraController.uploadedVideoLink.value.isEmpty
                              ? SizedBox()
                              : Center(
                            child: Row(
                              children: [
                                CustomText(
                                    title: "video_ready_for_post".tr,
                                    fontWeight: FontWeight.w400, fontSize: 14,
                                    color: Colors.green
                                ),
                                Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    cameraController.deletedVideo();
                                  },
                                  child: cameraController.isDeleting.value ? CircularProgressIndicator() : Icon(
                                    Icons.cancel_outlined,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          heightBox20,
                          RoundTextField(
                            controller: postController.postController,
                            hint: "what_you_want_to_say".tr,
                            maxLine: 5,
                          ),


                          heightBox30,
                          Roundbutton(
                            title: "post_now".tr,
                            isLoading: postController.isLoading.value,
                            onTap: () async{
                              if(postController.postController.text.isEmpty) {
                                Get.rawSnackbar(message: "please_enter_some_text".tr,
                                    backgroundColor: Colors.red,
                                    snackPosition: SnackPosition.TOP
                                );
                              }else
                              if(postController.postController.text.length < 5) {
                                Get.rawSnackbar(message: "please_enter_at_least_5_characters",
                                    backgroundColor: Colors.red,
                                    snackPosition: SnackPosition.BOTTOM);
                              }else{
                                await postController.createPost(context,eventId);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> openCameraDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                CustomText(
                  textAlign: TextAlign.center,
                  title: 'record_videos_effortlessly_with_a_120_second_duration_perfect_for_capturing_concise_impactful_moments'.tr,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Color(0xff595959),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Roundbutton(
                title: "open_camera".tr,
                fontSize: 14,
                onTap: () {
                  // Dismiss the dialog
                  Navigator.of(context).pop();
                  // Navigate to CameraPage
                  Get.to(() => CameraPage());
                }),
          ],
        );
      },
    );
  }
}
