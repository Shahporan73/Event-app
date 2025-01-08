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
                    appBarName: "New Post",
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
                                size: 32.sp,
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
                  heightBox10,
                  postController.uploadImageList.isEmpty ? SizedBox() : Row(
                    children: [
                      CustomText(
                          title: "Remove ${postController.uploadImageList.length} images",
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
                            title: "Video ready for post",
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
                    hint: "What you want to say?",
                    maxLine: 5,
                  ),

                  Spacer(),
                  Roundbutton(
                    title: "Post Now",
                    isLoading: postController.isLoading.value,
                    onTap: () async{
                      if(postController.postController.text.isEmpty) {
                        Get.rawSnackbar(message: "Please enter some text", backgroundColor: Colors.red, snackPosition: SnackPosition.BOTTOM);
                      }else
                      if(postController.postController.text.length < 5) {
                        Get.rawSnackbar(message: "Please enter at least 5 characters",
                            backgroundColor: Colors.red,
                            snackPosition: SnackPosition.BOTTOM);
                      }else{
                        await postController.createPost(context,eventId);
                      }
                    },
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
                  title: 'Record videos effortlessly with '
                      'a 120-second duration—perfect for '
                      'capturing concise,impactful moments!',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Color(0xff595959),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Roundbutton(
                title: "Open Camera",
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
