import 'dart:convert';
import 'dart:io';

import 'package:event_app/data/api/base_client.dart';
import 'package:event_app/data/api/end_point.dart';
import 'package:event_app/data/token_manager/const_veriable.dart';
import 'package:event_app/data/token_manager/local_storage.dart';
import 'package:event_app/view/event_view/controller/camera_controller.dart';
import 'package:event_app/view/event_view/controller/my_event_controller.dart';
import 'package:event_app/view/event_view/model/event_posts_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class PostController extends GetxController{
  var isLoading = false.obs;
  var isUploading = false.obs;
  var isDeleting = false.obs;
  final TextEditingController postController = TextEditingController();
  final TextEditingController editPostController = TextEditingController();

  var selectedImageFiles = <File>[].obs; // Holds selected local image files
  var uploadedImageUrls = <String>[].obs; // just image url list
  var uploadImageList = [].obs; //img list for api
  var imageKeyList = [].obs;


  var videoList = [].obs;
  final ImagePicker _picker = ImagePicker();

  final CameraManager cameraController = Get.find<CameraManager>();
  final MyEventController myEventController = Get.find<MyEventController>();


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    loadEditPostData();
  }

  Future<void> loadEditPostData() async {
    // isLoading.value = true;
    try {
      String token = LocalStorage.getData(key: "access_token");
      String postId = LocalStorage.getData(key: editPostId);
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      dynamic responseBody = await BaseClient.handleResponse(
        await BaseClient.getRequest(
          api: Endpoints.getPostDetailsURL(postId: postId),
          headers: headers,
        ),
      );
      print('hit api ${Endpoints.getEventDetailsURL(eventId: postId)}');

      print('=====================================');

      if (responseBody != null) {
        print("responseBody ====> $responseBody");
        var data = responseBody['data'];
        editPostController.text = data['body'];

        // Storing URLs and keys in uploadImageList
        uploadImageList.addAll(data['files'].map((e) {
          return {'url': e['url'], 'key': e['key']};
        }).toList());

        uploadedImageUrls.addAll(
          data['files'].map<String>((e) => e['url'] as String).toList(),
        );
        imageKeyList.addAll(data['files'].map<String>((e) => e['key'] as String).toList());



        var videoArray = data['videos'].map((e) {
          return {'url': e['url'], 'key': e['key']};
        }).toList();

        if (videoArray.isNotEmpty) {
          // Storing the first video URL and key
          var videoUrl = videoArray[0]['url'];
          var videoKey = videoArray[0]['key'];

          // For check: store video URL
          cameraController.uploadedVideoLink.value = videoUrl;

          // For delete: store video key
          cameraController.uploadedVideoKey.add(videoKey);

          // For update: store video URLs and keys
          cameraController.videoArray.addAll(videoArray);
        }



        // cameraController.videoArray.addAll(data['videos']);
        print("responseBody hello ====> $responseBody");
      }
    }catch (e) {
      print("Error : $e");
    }
    // finally {
    //   isLoading.value = false;
    // }
  }




  // Upload selected images
  Future<void> uploadImages() async {
    isUploading.value = true;
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
          var imageUrls = (responseData['data'] as List)
              .map<String>((image) => image['url'].toString())
              .toList();
          var imageKeys = (responseData['data'] as List)
              .map<String>((image) => image['key'].toString())
              .toList();

          imageKeyList.addAll(imageKeys);


          uploadedImageUrls.addAll(imageUrls);

          print("imageUrls ====> $imageUrls");


          uploadImageList.addAll(responseData['data']);

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
      isUploading.value = false;
    }
  }

  Future<void> deletedImages() async {
    isDeleting.value = true;
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
            body: jsonEncode(imageKeyList),
          )
      );
      print('hit api ${Endpoints.deleteImage}');
      print("responseBody ====> $responseBody");
      if (responseBody != null) {
        uploadImageList.clear();
        imageKeyList.clear();
        uploadedImageUrls.clear();
        Get.rawSnackbar(message: "Images deleted successfully", backgroundColor: Colors.green, snackPosition: SnackPosition.BOTTOM);
        print("Images deleted successfully: $responseBody");
      }
    }catch (e) {
      print("Error : $e");
    }finally{
      isDeleting.value = false;
    }
  }



  Future<void> createPost(context, eventId) async {
    isLoading.value = true;
    print('CameraManager instance: $cameraController');
    print('Videos in videoArray: ${cameraController.videoArray}');
    print('video path ${cameraController.uploadedVideoLink.value}');
    try {
      String token = LocalStorage.getData(key: "access_token");
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      Map<String, dynamic> body = {
        "eventId": eventId,
        "body": postController.text.toString(),
        "files": uploadImageList,
        "videos" : cameraController.videoArray.toList(),
      };

      dynamic responseBody = await BaseClient.handleResponse(
          await BaseClient.postRequest(
              api: Endpoints.createPostURL,
              headers: headers,
              body: jsonEncode(body),
          )
      );
      print('hit api ${Endpoints.createPostURL}');
      print("responseBody ====> $responseBody");
      if (responseBody != null) {
        uploadImageList.clear();
        uploadedImageUrls.clear();
        imageKeyList.clear();
        cameraController.uploadedVideoLink.value = '';
        cameraController.uploadedVideoKey.clear();
        cameraController.videoArray.clear();
        print("Post created successfully: $responseBody");
        Get.rawSnackbar(message: "Post created successfully",
            backgroundColor: Colors.green, snackPosition: SnackPosition.BOTTOM);
        myEventController.getMyEventsPost();
        Navigator.pop(context);
      }else{
        Get.rawSnackbar(message: "No events found");
        print("No events found");
      }

    }catch (e) {
      print("Error : $e");
    }finally{
      isLoading.value = false;
    }
  }


  Future<void> updatePost(context, postId) async {
    isLoading.value = true;
    try {
      /*String token = LocalStorage.getData(key: "access_token");
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };*/
      Map<String, dynamic> body = {
        "body": postController.text.toString(),
        "files": uploadImageList,
        "videos" : cameraController.videoArray.toList(),
      };

      dynamic responseBody = await BaseClient.handleResponse(
          await BaseClient.patchRequest(
            api: Endpoints.updatePostURL(postId: postId),
            body: jsonEncode(body),
          )
      );
      print('hit api ${Endpoints.updatePostURL(postId: postId)}');
      print("responseBody ====> $responseBody");
      if (responseBody != null) {
        uploadImageList.clear();
        uploadedImageUrls.clear();
        imageKeyList.clear();

        cameraController.uploadedVideoLink.value = '';
        cameraController.uploadedVideoKey.clear();
        cameraController.videoArray.clear();
        print("Post created successfully: $responseBody");
        Get.rawSnackbar(message: "Post created successfully",
            backgroundColor: Colors.green, snackPosition: SnackPosition.BOTTOM);
        myEventController.getMyEventsPost();
        Navigator.pop(context);
      }else{
        Get.rawSnackbar(message: "No events found");
        print("No events found");
      }

    }catch (e) {
      print("Error : $e");
    }finally{
      isLoading.value = false;
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
}