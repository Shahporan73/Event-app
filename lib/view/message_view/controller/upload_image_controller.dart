import 'dart:convert';
import 'dart:io';

import 'package:event_app/data/api/base_client.dart';
import 'package:event_app/data/api/end_point.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import '../../../data/token_manager/local_storage.dart';

class UploadImageController extends GetxController{
  var isLoading = false.obs;
  var isUploading = false.obs;
  final ImagePicker _picker = ImagePicker();

  // Selected image files
  var selectedImageFiles = <File>[].obs; // Holds selected local image files
  var uploadedImageUrls = <String>[].obs; // just image url list
  var uploadImageList = [].obs; //img list for api
  var imageKeyList = [].obs;

  // selected videos file
  var selectedVideoFiles = <File>[].obs;
  var uploadVideoList = [].obs;
  var elapsedTime = 0.obs;


  // community image update values
  var communityUpdateImageUrl = "".obs;
  var pickedCommunityImageFile = Rxn<File>();


  // Upload selected images
  Future<void> uploadImages() async {
    isLoading.value = true;
    try {
      String token = LocalStorage.getData(key: "access_token");

      // Prepare headers
      Map<String, String> headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'multipart/form-data',
      };

      // Prepare request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(Endpoints.uploadImageURL),
      );
      request.headers.addAll(headers);

      // Attach the image files
      for (File imageFile in selectedImageFiles) {
        request.files.add(
          await http.MultipartFile.fromPath('files', imageFile.path),
        );
      }

      // Send the request
      var streamedResponse = await request.send();

      // Get response
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);

        // Check if 'data' is a list and parse URLs
        if (responseData['data'] is List) {

          // hold image urls
          var imageUrls = (responseData['data'] as List)
              .map<String>((image) => image['url'].toString())
              .toList();

          // hold image keys
          var imageKeys = (responseData['data'] as List)
              .map<String>((image) => image['key'].toString())
              .toList();

          // // add image keys
          // imageKeyList.addAll(imageKeys);
          //
          // // add image urls
          // uploadedImageUrls.addAll(imageUrls);
          //
          // print("imageUrls ====> $imageUrls");

          // add images urls and keys
          uploadImageList.addAll(responseData['data']);
          print("uploadImageList ====> ${uploadImageList.length}");

          print("Images uploaded successfully: $responseData");
        } else {
          print("Unexpected response format: ${response.body}");
        }
      } else {
        print("Image upload failed: ${response.statusCode} ${response.body}");
      }
    } catch (e) {
      print("Error uploading images: $e");
    }
    finally {
      isLoading.value = false;
    }
  }


  Future<void> deletedImages(String key) async {
    isLoading.value = true;
    try {
      String token = LocalStorage.getData(key: "access_token");
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      dynamic responseBody = await BaseClient.handleResponse(
          await BaseClient.deleteRequest(
            api: Endpoints.deleteImage,
            headers: headers,
            body: jsonEncode([key]),
          )
      );
      print('hit api ${Endpoints.deleteImage}');
      print("responseBody ====> $responseBody");
      if (responseBody != null) {

        print("Before deletion: $uploadImageList");
        uploadImageList.removeWhere((image) => image['key'] == key);
        print("After deletion: $uploadImageList");

        Get.rawSnackbar(message: "Images deleted successfully",
            backgroundColor: Colors.green, snackPosition: SnackPosition.BOTTOM);
        print("Images deleted successfully: $responseBody");
      }
    }catch (e) {
      print("Error : $e");
    }finally{
      isLoading.value = false;
    }
  }

  Future<void> uploadVideos(BuildContext context) async {
    isUploading.value = true;
    try {
      String token = LocalStorage.getData(key: "access_token");
      // Prepare headers
      Map<String, String> headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'multipart/form-data',
      };

      // Create a multipart request
      var request = http.MultipartRequest('POST', Uri.parse(Endpoints.uploadVideoURL));
      request.headers.addAll(headers);

      // Attach multiple video files
      for (var videoFile in selectedVideoFiles) {
        var fileStream = File(videoFile.path).openRead();
        var fileLength = await File(videoFile.path).length();

        var file = http.MultipartFile(
          'file',
          fileStream,
          fileLength,
          filename: videoFile.path.split('/').last,
        );

        request.files.add(file);
      }

      // Send the request
      print('Uploading videos...');
      var response = await request.send();

      // Handle the response
      if (response.statusCode == 200) {
        print('====================success');
        final respStr = await response.stream.bytesToString();
        var responseBody = jsonDecode(respStr);

        // Process response data
        if (responseBody['data'] is List) {
          // if the response is a list
          uploadVideoList.addAll(responseBody['data']);

        } else if (responseBody['data'] is Map) {
          // if the response is a map
          uploadVideoList.add(responseBody['data']);
        }

        print('uploadVideoList ====> ${uploadVideoList.length}');
        print('data body ====> ${responseBody['data']}');

        Get.rawSnackbar(
          message: "Videos uploaded successfully!",
          backgroundColor: Colors.green,
          snackPosition: SnackPosition.BOTTOM,
        );
        print('Videos uploaded successfully! Response: $respStr');
      } else {
        Get.snackbar(
          'Error',
          'Failed to upload videos. Status: ${response.statusCode}',
          colorText: Colors.white,
        );
        print('Failed to upload videos. Status: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload videos: $e', colorText: Colors.white);
      print('Failed to upload videos: $e');
    } finally {
      // Clear resources or perform clean-up here if necessary
      selectedVideoFiles.clear();
      isUploading.value = false;
    }
  }


  // using api
  Future<void> deletedVideo(String key) async {
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
            body: jsonEncode([key]),
          )
      );
      print('hit api ${Endpoints.deleteVideo}');
      print("responseBody ====> $responseBody");
      if (responseBody != null) {
        uploadVideoList.removeWhere((video) => video['key'] == key);
        Get.rawSnackbar(message: "Video deleted successfully",
            backgroundColor: Colors.green,
            snackPosition: SnackPosition.BOTTOM);
        print("Images deleted successfully: $responseBody");
      }
    }catch (e) {
      print("Error : $e");
    }
  }


  // Select multiple images
  Future<void> pickImages() async {
    final List<XFile>? pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      selectedImageFiles.value = pickedFiles.map((e) => File(e.path)).toList();
      await uploadImages();
    } else {
      print("No images selected");
      Get.rawSnackbar(message: "No images selected");
    }
  }

// Select a single video from the gallery
  Future<void> pickSingleVideo(context) async {
    final XFile? pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedVideoFiles.value = [File(pickedFile.path)]; // Replace the list with the single picked video
      await uploadVideos(context);
    } else {
      print("No video selected");
      Get.rawSnackbar(message: "No video selected");
    }
  }


  void showMediaPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text('Select Images'),
              onTap: () {
                Navigator.pop(context);
                pickImages();
              },
            ),
            ListTile(
              leading: const Icon(Icons.videocam),
              title: const Text('Select Videos'),
              onTap: () {
                Navigator.pop(context);
                pickSingleVideo(context);
              },
            ),
          ],
        );
      },
    );
  }

  // Select multiple videos
  Future<void> pickVideos(context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.video,
        allowMultiple: true, // Allow selecting multiple videos
      );

      if (result != null && result.files.isNotEmpty) {
        selectedVideoFiles.value = result.files.map((file) => File(file.path!)).toList();
        print("Selected videos: ${selectedVideoFiles.map((e) => e.path).toList()}");
        // Call your upload or handling logic here if needed
        await uploadVideos(context);
      } else {
        print("No videos selected");
        Get.rawSnackbar(message: "No videos selected");
      }
    } catch (e) {
      print("Error picking videos: $e");
      Get.rawSnackbar(message: "Failed to pick videos");
    }
  }



  ///=================== Upload selected images =======================================================
  Future<void> updateCommunityImage(context) async {
    if (pickedCommunityImageFile.value == null) {
      print("No file selected for upload.");
      return;
    }

    isLoading.value = true;

    try {
      String token = LocalStorage.getData(key: "access_token");

      // Prepare headers
      Map<String, String> headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'multipart/form-data',
      };

      // Prepare request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(Endpoints.uploadImageURL),
      );
      request.headers.addAll(headers);

      print("Image path: ${pickedCommunityImageFile.value!.path}");

      // Add the selected file to the request
      request.files.add(
        await http.MultipartFile.fromPath(
          'files',
          pickedCommunityImageFile.value!.path, // Ensure it's the correct file path
        ),
      );

      // Send the request
      var streamedResponse = await request.send();

      // Get response
      var response = await http.Response.fromStream(streamedResponse);

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);

        // Validate the response structure
        if (responseData != null &&
            responseData['data'] != null &&
            responseData['data'].isNotEmpty) {
          pickedCommunityImageFile.value = null;
          communityUpdateImageUrl.value = responseData['data'][0]['url'];
          print("Image uploaded successfully: ${communityUpdateImageUrl.value}");
        } else {
          print("Unexpected response structure: $responseData");
        }
      } else {
        print("Image upload failed: ${response.statusCode} ${response.body}");
      }
    } catch (e) {
      print("Error uploading images: $e");
    } finally {
      isLoading.value = false;
    }
  }

// Select a single image from the gallery
  Future<void> pickCommunityImage(context) async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      pickedCommunityImageFile.value = File(pickedFile.path); // Ensure it's a valid File object
      print('Picked file path: ${pickedCommunityImageFile.value!.path}');
      await updateCommunityImage(context);
      // Navigate back two screens
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop(); // Go back one screen
      }
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop(); // Go back the second screen
      }

    } else {
      print("No image selected");
      Get.rawSnackbar(message: "No image selected");
    }
  }



}