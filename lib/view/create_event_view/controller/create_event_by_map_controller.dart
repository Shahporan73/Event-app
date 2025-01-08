// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:io';

import 'package:event_app/data/api/base_client.dart';
import 'package:event_app/data/api/end_point.dart';
import 'package:event_app/data/token_manager/const_veriable.dart';
import 'package:event_app/data/token_manager/local_storage.dart';
import 'package:event_app/view/create_event_view/view/selected_contact_screen.dart';
import 'package:event_app/view/home_view/model/category_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class CreateEventByMapController extends GetxController{
  var isLoading = false.obs;
  final TextEditingController eventNameController = TextEditingController();
  Rx<TextEditingController> eventAddressController = TextEditingController().obs;
  final TextEditingController eventAboutController = TextEditingController();
  var imgUrl = ''.obs;
  var address = ''.obs;
  var eventType = 'PUBLIC'.obs;
  var rating = 0.0.obs;
  var totalReviews = 0.obs;

  var eventSelectedDate = ''.obs;
  var eventStartTime = ''.obs;
  var eventEndTime = ''.obs;

  var selectedCatName = ''.obs;
  var selectedCatId = ''.obs;

  var categoryModel = CategoryModel().obs;
  var categoryList = <CategoryList>[].obs;
  var selectedCatIndex = 0.obs;
  void updateSelectedCatIndex(String value) {
    selectedCatName.value = value;
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getCategories();
    // Initial value
    eventAddressController.value.text = address.value;

    // Update TextEditingController whenever the address changes
    ever(address, (newValue) {
      eventAddressController.value.text = newValue.toString();
    });
  }

  Future<void> getCategories() async {
    try {
      isLoading.value = true;

      String token = LocalStorage.getData(key: "access_token");

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      dynamic responseBody = await BaseClient.handleResponse(
        await BaseClient.getRequest(
          api: Endpoints.categoriesURL,
          headers: headers,
        ),
      );

      print('hit api ${Endpoints.categoriesURL}');
      print("responseBody ====> $responseBody");

      if(responseBody != null){
        categoryList.clear();
        categoryModel.value = CategoryModel.fromJson(responseBody);
        categoryList.assignAll(categoryModel.value.data!);
      }

    }catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> createEventByMap() async {
    isLoading.value = true;

   /* if (imgUrl.value.isEmpty) {
      Get.snackbar('Error', 'Please select an image.');
      isLoading.value = false;
      return;
    }*/
    print('==============');

    print('Map Latitude: ${LocalStorage.getData(key: "map_latitude")}');
    print('Map Longitude: ${LocalStorage.getData(key: "map_longitude")}');

    try {
      String token = LocalStorage.getData(key: "access_token");
      String latitude = LocalStorage.getData(key: "map_latitude");
      String longitude = LocalStorage.getData(key: "map_longitude");

      // Prepare headers
      Map<String, String> headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'multipart/form-data',  // Ensure the content type is correct
      };
      print("address value: ${address.value}");

      Uri uri = Uri.parse(Endpoints.createEventURL);

      // Combine all fields into a single Map to represent the `data` field
      Map<String, dynamic> data = {
        "name": eventNameController.text.trim(),
        "categoryId": selectedCatId.value,
        "address": eventAddressController.value.text.trim(),
        "type": eventType.value,
        "date": eventSelectedDate.value,
        "startTime": eventStartTime.value,
        "endTime": eventEndTime.value,
        "aboutEvent": eventAboutController.text.trim().toString(),
        "latitude": latitude.toString(),
        "longitude": longitude.toString(),
        "rating": rating.value,
        "reviews": totalReviews.value,
      };
      print("data ====> $data");

      var request = http.MultipartRequest('POST', uri)
        ..headers.addAll(headers)
        ..fields['data'] = jsonEncode(data); // Add `data` as a JSON string

      // Add image to form data
      if (imgUrl.value.isNotEmpty) {
        var file = File(imgUrl.value);

        if (await file.exists()) {
          // Attach image as MultipartFile
          String fileName = basename(file.path); // Extract file name
          request.files.add(await http.MultipartFile.fromPath(
            'image',    // This is the key the server expects for the image
            file.path,
            filename: fileName,
          ));
        } else {
          Get.rawSnackbar(message: 'Image file not found');
          isLoading.value = false;
          return;
        }
      } else {
        Get.rawSnackbar(message: 'Please select an image.');
        isLoading.value = false;
        return;
      }

      print("body: ${request.fields}");
      print("upload image url: ${imgUrl.value}");

      // Send the request
      // http.StreamedResponse response = await request.send();
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      dynamic responseBody = jsonDecode(response.body);


      print("Request fields: ${request.fields}");
      print('API: ${Endpoints.createEventURL}');
      print("Response status code: ${response.statusCode}");

      if (response.statusCode == 201) {
        // var responseBody = await response.stream.bytesToString();
        // var parsedResponse = jsonDecode(responseBody);
        // var eventId = parsedResponse['data']['id'];
        var eventId = responseBody['data']['id'];

        // Save the event ID locally
        LocalStorage.saveData(key: eventIdForInviteEvent, data: eventId);

        Get.rawSnackbar(message: 'Event created successfully');
        Get.to(
              () => SelectedContactScreen(),
          transition: Transition.rightToLeft,
          duration: Duration(milliseconds: 300),
        );
      } else {
        // String responseBody = await response.stream.bytesToString();
        print("Error Response body: $responseBody");
        print('Failed to create event. Status code: ${response.statusCode}');
        Get.rawSnackbar(message: 'Failed to create event');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

/*

  Future<void> uploadHireRequest({
    required serviceImages,
    required String desc,
    required String location,
    required String catId,
    required dynamic urgency,
    required dynamic providerId,
  }) async {
    try {
      isLoading(true);
      String? accessToken = LocalStorage.getData(key: "access_token");

      if (accessToken == null || accessToken.isEmpty) {
        Get.snackbar(
          "Error",
          "No access token found. Please login again.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      var request = http.MultipartRequest('POST', Uri.parse(Endpoints.createEventURL));

      for (var image in serviceImages) {
        String mimeType = lookupMimeType(image.path) ?? 'image/jpeg';
        request.files.add(
          await http.MultipartFile.fromPath(
            'files',
            image.path,
            contentType:
            MediaType(mimeType.split('/')[0], mimeType.split('/')[1]),
          ),
        );
      }

      Map<String, dynamic> data = {
        "service": catId,
        "address": location,
        "description": desc,
        "provider": providerId,
        "priority": urgency ? "yes" : "no"
      };

      request.fields['data'] = jsonEncode(data);

      request.headers.addAll({
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'multipart/form-data',
      });

      print("Request Fields: ${request.fields}");
      print("Files attached: ${serviceImages.map((e) => e.path).toList()}");

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      dynamic responseBody = jsonDecode(response.body);

      if (response.statusCode == 200 && responseBody['success'] == true) {
        CustomToast.showToast("Hire request submitted successfully",
            isError: false);

        _myServiceController.getMyService();
        Get.to(() => DashboardView());
      } else {
        String errorMessage = responseBody['message'] ??
            'Failed to submit request. Please try again.';
        Get.snackbar(
          "Error",
          errorMessage,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      // Hide loading indicator
      isLoading(false);
    }
  }
*/


  // Function to pick an image
  Future<void> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      imgUrl.value = pickedFile.path;
    } else {
      print("No image selected");
    }
  }

}