// ignore_for_file: prefer_const_constructors, unnecessary_null_comparison

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:event_app/data/api/end_point.dart';
import 'package:event_app/data/token_manager/local_storage.dart';
import 'package:event_app/view/auth_view/view/otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class SignUpController extends GetxController {
  // GlobalKey for the Form
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  var isLoading = false.obs;

  // Text Editing Controllers for form fields
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Observables for validation error messages
  RxString email = ''.obs;
  RxString fullName = ''.obs;
  RxString password = ''.obs;
  RxString profileImageUrl = ''.obs;


  // Visibility state for password fields
  RxBool isPasswordVisible = false.obs;

  // To hold the selected image
  Rx<File?> selectedImage = Rx<File?>(null);

  // Image picker instance
  final ImagePicker picker = ImagePicker();

  // Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // Method to validate form
  bool validateForm() {
    bool isValid = true;

    if (fullNameController.text.trim().isEmpty) {
      fullName.value = "full_name_is_required".tr;
      isValid = false;
    } else {
      fullName.value = '';
    }

    if (emailController.text.trim().isEmpty) {
      email.value = "email_is_required".tr;
      isValid = false;
    } else if (!GetUtils.isEmail(emailController.text.trim())) {
      email.value = "enter_a_valid_email".tr;
      isValid = false;
    } else {
      email.value = '';
    }

    if (passwordController.text.trim().isEmpty) {
      password.value = "password_is_required".tr;
      isValid = false;
    } else if (passwordController.text.trim().length < 6) {
      password.value = "password_must_be_at_least_6_characters".tr;
      isValid = false;
    } else {
      password.value = '';
    }

    return isValid;
  }


  // Upload the profile image
  void uploadProfileImage(File imageFile) {
    selectedImage.value = imageFile;
    update();
  }

  /// sign up function
  Future<void> onSignUp() async {
    isLoading(true);
    try {

      Map<String, dynamic> data = {
        "name": fullNameController.text.trim(),
        "email": emailController.text.trim(),
        "password": passwordController.text.trim(),
      };

      // Adding form fields
      var request = http.MultipartRequest('POST', Uri.parse(Endpoints.signUp))
        ..fields['data'] = jsonEncode(data);

      print("Request fields: ${request.fields}");

      // Add image if selected (without compression)
      if (selectedImage.value != null) {
        File imageFile = selectedImage.value!;

        // Log file details before upload
        print("File path: ${imageFile.path}");
        print("File size for upload: ${await imageFile.length()} bytes");

        var imageStream = http.ByteStream(imageFile.openRead());
        var imageLength = await imageFile.length();

        // Get the file extension to determine MIME type
        String mimeType = getMimeType(imageFile.path);

        // Add image to request with MIME type
        request.files.add(http.MultipartFile(
          'profilePicture',
          imageStream,
          imageLength,
          filename: basename(imageFile.path),
          contentType: MediaType.parse(mimeType), // Adding MIME type
        ));
        print("Image uploaded with path: ${imageFile.path}");
      } else {
        print("No image selected for upload");
      }

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      print('Response status: ${response.statusCode}');
      print('API hit: ${Endpoints.signUp}');
      print('Full response body: $responseBody'); // Log the full response for debugging

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(responseBody);

        print("Response data: ${jsonResponse['data']}");

        String token = jsonResponse['data']['token'];
        LocalStorage.saveData(key: "signup_token", data: token);

        Get.snackbar("success".tr, "account_created_successfully".tr, snackPosition: SnackPosition.TOP);
        Get.offAll(
              () => OtpScreen(email: emailController.text.toString()),
          transition: Transition.rightToLeft,
          duration: const Duration(milliseconds: 300),
        );
        print('sign up token: $token');
      } else {
        try {
          var jsonResponse = jsonDecode(responseBody);
          print('Error message: ${jsonResponse['message']}');
          Get.rawSnackbar(
            message: jsonResponse['message'],
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
          );
        } catch (_) {
          Get.rawSnackbar(
            message: 'Unexpected response from server',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
          );
        }
        print("Sign up failed with status: ${response.statusCode}");
      }
    } catch (e) {
      print("Account creation failed: $e");
      Get.rawSnackbar(
        message: 'An error occurred: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
      );
    } finally {
      isLoading(false);
    }
  }

// Function to get MIME type based on file extension
  String getMimeType(String path) {
    if (path.endsWith('.jpg') || path.endsWith('.jpeg')) {
      return 'image/jpeg';
    } else if (path.endsWith('.png')) {
      return 'image/png';
    } else if (path.endsWith('.gif')) {
      return 'image/gif';
    } else {
      return 'application/octet-stream';
    }
  }

  /// disposed
  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
