import 'dart:convert';
import 'dart:io';

import 'package:event_app/data/api/base_client.dart';
import 'package:event_app/data/api/end_point.dart';
import 'package:event_app/data/token_manager/local_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ProfileController extends GetxController {
  var isProfileLoading = false.obs;

  // Make controllers Rx<TextEditingController> to make them reactive
  Rx<TextEditingController> nameController = TextEditingController().obs;
  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> numberController = TextEditingController().obs;
  Rx<TextEditingController> addressController = TextEditingController().obs;

  var imgURL = ''.obs;
  var name = ''.obs;
  var email = ''.obs;
  var number = ''.obs;
  var address = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Fetch profile data
    getProfile();
    getEditProfile();
  }

  Future<void> getProfile() async {
    try {
      isProfileLoading.value = true;
      String token = LocalStorage.getData(key: "access_token");

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      dynamic responseBody = await BaseClient.handleResponse(
        await BaseClient.getRequest(
          api: Endpoints.profileURl,
          headers: headers,
        ),
      );

      if (responseBody != null) {
        name.value = responseBody['data']['name'] ?? "";
        email.value = responseBody['data']['email'] ?? "";
        number.value = responseBody['data']['phoneNumber'] ?? "";
        address.value = responseBody['data']['location'] ?? "";
        imgURL.value = responseBody['data']['profilePicture'] ?? "";
      }
    } catch (e) {
      print(e);
    } finally {
      isProfileLoading.value = false;
    }
  }



  Future<void> getEditProfile() async {
    try {
      isProfileLoading.value = true;
      String token = LocalStorage.getData(key: "access_token");

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      dynamic responseBody = await BaseClient.handleResponse(
        await BaseClient.getRequest(
          api: Endpoints.profileURl,
          headers: headers,
        ),
      );

      if (responseBody != null) {
        nameController.value.text = responseBody['data']['name'] ?? "";
        emailController.value.text = responseBody['data']['email'] ?? "";
        numberController.value.text = responseBody['data']['phoneNumber'] ?? "";
        addressController.value.text = responseBody['data']['location'] ?? "";
      }
    } catch (e) {
      print(e);
    } finally {
      isProfileLoading.value = false;
    }
  }

  Future<void> updateProfile() async {
    try {
      isProfileLoading.value = true;

      String token = LocalStorage.getData(key: "access_token");

      // Prepare headers
      Map<String, String> headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'multipart/form-data', // Ensure this is multipart
      };

      // Prepare the URI (Endpoint)
      Uri uri = Uri.parse(Endpoints.profileURl);

      // Prepare the multipart request
      var request = http.MultipartRequest('PATCH', uri);

      // Add text fields
      request.fields['name'] = nameController.value.text;
      request.fields['email'] = emailController.value.text;
      request.fields['phoneNumber'] = numberController.value.text;
      request.fields['location'] = addressController.value.text;

      // Add image if available (handle optional files)
      if (imgURL.value.isNotEmpty) {
        // Assuming imgURL contains a path to an image file
        File file = File(imgURL.value);
        if (await file.exists()) {
          request.files.add(await http.MultipartFile.fromPath(
            'profilePicture',
            file.path,
            contentType: MediaType('image', 'jpeg'),
          ));
        }
      }

      print("Request fields: ${request.fields}");
      // Attach the headers to the request
      request.headers.addAll(headers);

      // Send the request and get the response
      http.Response response = await http.Response.fromStream(await request.send());

      if (response.statusCode == 200) {
        // Parse response if successful
        print("Profile updated successfully");
        Get.rawSnackbar(message: "Profile updated successfully.");
        var responseBody = jsonDecode(response.body);
        print("Response body: $responseBody");
        getEditProfile();  // Fetch updated profile data
        getProfile();
      } else {
        print("Failed to update profile: ${response.statusCode}");
      }
    } catch (e) {
      print("Error updating profile: $e");
    } finally {
      isProfileLoading.value = false;
    }
  }
}



