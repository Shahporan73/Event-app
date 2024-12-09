import 'dart:async';
import 'dart:io';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class CameraManager extends GetxController {
  late List<CameraDescription> cameras;
  late CameraController cameraController;
  var isCameraInitialized = false.obs;
  var isRecordingVideo = false.obs;
  var capturedVideoPath = ''.obs; // Store the path of the recorded video
  Timer? timer;
  var elapsedTime = 0.obs; // Observable elapsed time

  @override
  void onInit() {
    super.onInit();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    try {
      cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        cameraController = CameraController(cameras[0], ResolutionPreset.high);
        await cameraController.initialize();
        isCameraInitialized.value = true;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to initialize camera: $e');
    }
  }

  Future<void> startRecordingVideo() async {
    if (!cameraController.value.isInitialized || isRecordingVideo.value) return;

    try {
      final directory = await getTemporaryDirectory();
      final filePath = path.join(directory.path, '${DateTime.now()}.mp4');

      await cameraController.startVideoRecording();
      isRecordingVideo.value = true;
      capturedVideoPath.value = filePath; // Store the path
      elapsedTime.value = 0; // Reset elapsed time

      // Start the elapsed time counter
      timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (elapsedTime.value < 120) {
          elapsedTime.value++;
        } else {
          stopRecordingVideo();
          Get.snackbar('Notice', 'Video recording stopped after 120 seconds.');
        }
      });
    } catch (e) {
      Get.snackbar('Error', 'Failed to start video recording: $e');
    }
  }

  Future<void> toggleCamera() async {
    isCameraInitialized.value = false; // Mark the camera as not initialized
    try {
      // Dispose of the current camera controller
      await cameraController.dispose();

      // Get the index of the next camera
      int currentIndex = cameras.indexOf(cameraController.description);
      int newIndex = (currentIndex + 1) % cameras.length;

      // Initialize the new camera
      cameraController = CameraController(cameras[newIndex], ResolutionPreset.high);

      // Await initialization
      await cameraController.initialize();

      // Notify the UI about the updated state
      isCameraInitialized.value = true;
    } catch (e) {
      // Handle errors gracefully
      isCameraInitialized.value = false; // Mark camera as not initialized
      Get.snackbar('Error', 'Failed to switch camera: $e');
    }
  }

  Future<void> stopRecordingVideo() async {
    if (!cameraController.value.isRecordingVideo) return;

    try {
      timer?.cancel(); // Cancel the timer if it exists
      XFile videoFile = await cameraController.stopVideoRecording();
      isRecordingVideo.value = false;
      elapsedTime.value = 0; // Reset elapsed time
      capturedVideoPath.value = videoFile.path; // Store the video path
      Get.snackbar('Success', 'Video saved to ${videoFile.path}', colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', 'Failed to stop video recording: $e');
    }
  }

  @override
  void onClose() {
    cameraController.dispose();
    timer?.cancel();
    super.onClose();
  }
}


