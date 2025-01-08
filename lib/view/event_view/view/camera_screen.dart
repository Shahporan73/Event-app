// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:camera/camera.dart';
import 'package:event_app/res/app_images/App_images.dart';
import 'package:event_app/res/common_widget/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controller/camera_controller.dart';
import 'show_video_screen.dart';

class CameraPage extends StatelessWidget {
  final cameraManager = Get.put(CameraManager());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        if (!cameraManager.isCameraInitialized.value) {
          return Center(child: CircularProgressIndicator());
        }

        return Stack(
          children: [
            // Full-Screen Camera Preview with AspectRatio
            Positioned.fill(
              child: AspectRatio(
                aspectRatio: 16 / 9, // Enforcing 16:9 aspect ratio
                child: ClipRect(
                  child: Transform.scale(
                    scale: cameraManager.cameraController.value.aspectRatio / (16 / 9),
                    child: Center(
                      child: CameraPreview(cameraManager.cameraController),
                    ),
                  ),
                ),
              ),
            ),


            // Transparent Overlay and Bottom Controls
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Show Videos Section
                    cameraManager.capturedVideoPath.value.isEmpty ? SizedBox()
                        : Obx(() {
                      return cameraManager.isRecordingVideo.value ?
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          shape: BoxShape.circle,
                        ),
                        child: cameraManager.capturedVideoPath.value.isNotEmpty
                            ? Icon(
                          Icons.play_circle_fill, // Show a play icon for videos
                          size: 40,
                          color: Colors.black,
                        )
                            : Icon(Icons.video_library, color: Colors.black),
                      )
                          :GestureDetector(
                        onTap: () {
                          if (cameraManager.capturedVideoPath.value.isNotEmpty) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ShowViewScreen(
                                  videoPath: cameraManager.capturedVideoPath.value,
                                ),
                              ),
                            );
                          }
                        },
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: cameraManager.capturedVideoPath.value.isNotEmpty
                              ? Icon(
                            Icons.play_circle_fill, // Show a play icon for videos
                            size: 40,
                            color: Colors.grey,
                          )
                              : Icon(Icons.video_library, color: Colors.grey),
                        ),
                      );
                    }),

                    // Record Button
                    GestureDetector(
                      onTap: () {
                        if (cameraManager.isRecordingVideo.value) {
                          cameraManager.stopRecordingVideo();
                        } else {
                          cameraManager.startRecordingVideo();
                        }
                      },
                      child: Container(
                        height: 64,
                        width: 64,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: cameraManager.isRecordingVideo.value
                            ? Icon(
                          Icons.pause,
                          size: 28.sp,
                        )
                            : Icon(
                          Icons.play_arrow,
                          size: 28.sp,
                        ),
                      ),
                    ),

                    // Switch Camera Button
                    cameraManager.isRecordingVideo.value ?
                    IconButton(onPressed: () {

                    }, icon: Image.asset(
                      AppImages.switchCamera,
                      color: Colors.grey,
                      width: 30,
                    )
                    )
                        :
                    IconButton(
                      onPressed: () => cameraManager.toggleCamera(),
                      icon: Image.asset(
                        AppImages.switchCamera,
                        color: Colors.white,
                        width: 30,
                      ),
                    ),
                  ],
                ),
              ),
            ),


            // Display Elapsed Time
            Positioned(
              bottom: ResponsiveHelper.h(context, 150),
              left: 16,
              right: 16,
              child: Obx(() {
                return Center(
                  child: Text(
                    '${cameraManager.elapsedTime.value}s / 120s',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                    ),
                  ),
                );
              }),
            ),

            Positioned(
              bottom: ResponsiveHelper.h(context, 150),
              left: 16,
              right: 16,
              child:// Display Elapsed Time
              Positioned(
                top: 16,
                left: 16,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),

          ],
        );
      }),
    );
  }
}