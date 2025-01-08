import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:event_app/data/api/base_client.dart';
import 'package:event_app/data/api/end_point.dart';
import 'package:event_app/data/token_manager/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class CameraManager extends GetxController {
  var isDeleting = false.obs;
  late List<CameraDescription> cameras;
  late CameraController cameraController;
  var isCameraInitialized = false.obs;
  var isRecordingVideo = false.obs;
  var capturedVideoPath = ''.obs; // Store the path of the recorded video
  Timer? timer;
  var elapsedTime = 0.obs; // Observable elapsed time

  // for upload
  var isUploading = false.obs;
  var uploadProgress = 0.0.obs;
  var uploadedVideoLink = ''.obs;
  var uploadedVideoKey = [].obs;
  var videoArray = [].obs;

  @override
  void onInit() {
    super.onInit();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    try {
      cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        cameraController = CameraController(
          cameras[0], // Use the first available camera
          ResolutionPreset.high, // Use a resolution that usually supports 16:9
        );

        await cameraController.initialize();

        // Validate the aspect ratio
        if ((cameraController.value.aspectRatio - (16 / 9)).abs() > 0.01) {
          Get.snackbar(
            'Notice',
            'The camera aspect ratio is not exactly 16:9. It may cause scaling or cropping.',
          );
        }

        isCameraInitialized.value = true;
      } else {
        Get.snackbar('Error', 'No cameras available');
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
      cameraController = CameraController(cameras[newIndex], ResolutionPreset.medium);

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

  void deleteLocalVideo(String videoPath, context) {
    isDeleting.value = true;
    final file = File(videoPath);
    if (file.existsSync()) {
      file.deleteSync();
      isDeleting.value = false;
      Get.snackbar('Success', 'Video deleted successfully');
      print('Video deleted successfully');
      Navigator.pop(context);
      capturedVideoPath.value = "";
    }
  }



  // using api
  Future<void> uploadVideo(context) async {
    if (capturedVideoPath.value.isEmpty) {
      Get.snackbar('Error', 'No video to upload.', colorText: Colors.white);
      return;
    }

    isUploading.value = true;
    uploadProgress.value = 0.0;

    try {
      String token = LocalStorage.getData(key: "access_token");
      // Prepare headers
      Map<String, String> headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'multipart/form-data',
      };


      var file = File(capturedVideoPath.value);

      // Create a multipart request
      var request = http.MultipartRequest('POST', Uri.parse(Endpoints.uploadVideoURL));
      request.headers.addAll(headers);

      // Attach video file
      var videoFile = await http.MultipartFile.fromPath('file', file.path);
      request.files.add(videoFile);

      // Listen for the upload progress
      print('Uploading video...');
      print('Video path: ${file.path}');
      print('Video size: ${file.lengthSync()} bytes');
      request.send().then((response) async {
        if (response.statusCode == 200) {
          final respStr = await response.stream.bytesToString();
          var responseBody = jsonDecode(respStr);
          var data = responseBody['data'];

          uploadedVideoLink.value = data['url'];
          var videoKey = data['key'];
          // Add the Map (data) to videoArray
          videoArray.add(data);
          uploadedVideoKey.add(videoKey);
          Get.rawSnackbar(message: "Video uploaded successfully!", backgroundColor: Colors.green, snackPosition: SnackPosition.BOTTOM);
          print('Video uploaded successfully! Response: $respStr');
          print('upload progress: ${uploadProgress.value * 100}%');
          Navigator.pop(context);
        } else {
          Get.snackbar('Error', 'Failed to upload video. Status: ${response.statusCode}',
              colorText: Colors.white);
          print('Failed to upload video. Status: ${response.statusCode}');
        }
      }).catchError((e) {
        Get.snackbar('Error', 'An error occurred during upload: $e', colorText: Colors.white);
        print('An error occurred during upload: $e');
      }).whenComplete(() {
        isUploading.value = false;
        uploadProgress.value = 0.0;
      });
    } catch (e) {
      isUploading.value = false;
      Get.snackbar('Error', 'Failed to upload video: $e', colorText: Colors.white);
      print('Failed to upload video: $e');
    }finally{
      isUploading.value = false;
    }
  }

  // using api
  Future<void> deletedVideo() async {
    isDeleting.value = true;
    try {
      String token = LocalStorage.getData(key: "access_token");
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      dynamic responseBody = await BaseClient.handleResponse(
          await BaseClient.deleteRequest(
            api: Endpoints.deleteVideo,
            headers: headers,
            body: jsonEncode(uploadedVideoKey),
          )
      );
      print('hit api ${Endpoints.deleteVideo}');
      print("responseBody ====> $responseBody");
      if (responseBody != null) {
        uploadedVideoLink.value = "";
        uploadedVideoKey.clear();
        videoArray.clear();
        Get.rawSnackbar(message: "Video deleted successfully", backgroundColor: Colors.green, snackPosition: SnackPosition.BOTTOM);
        print("Images deleted successfully: $responseBody");
      }
    }catch (e) {
      print("Error : $e");
    }finally{
      isDeleting.value = false;
    }
  }


  @override
  void onClose() {
    cameraController.dispose();
    timer?.cancel();
    super.onClose();
  }

}


