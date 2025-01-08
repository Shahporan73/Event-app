// sign_in_controller.dart

import 'dart:convert';
import 'package:event_app/data/api/base_client.dart';
import 'package:event_app/data/api/end_point.dart';
import 'package:event_app/data/services/socket_controller.dart';
import 'package:event_app/data/token_manager/const_veriable.dart';
import 'package:event_app/data/token_manager/local_storage.dart';
import 'package:event_app/view/home_view/view/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignInController extends GetxController {
  // GlobalKey for the Form
  final GlobalKey<FormState> loginKey = GlobalKey<FormState>();

  var isLoading = false.obs;
  var isChecked = true.obs;

  // Text Editing Controllers for form fields
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  RxString email = ''.obs;
  RxString password = ''.obs;

  RxBool isPasswordVisible = false.obs;

  // Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void onInit() {
    super.onInit();
    onLoadSaveCredentials();
  }

  void onLoadSaveCredentials() async {
    String? savedEmail = await LocalStorage.getData(key: 'remain_email');
    String? savedPassword = await LocalStorage.getData(key: 'remain_password');

    if (savedEmail != null && savedPassword != null) {
      emailController.text = savedEmail;
      passwordController.text = savedPassword;
    }
  }

  bool validateForm() {
    bool isValid = true;

    // Validate Email
    if (emailController.text.trim().isEmpty) {
      email.value = "Email is required";
      isValid = false;
    } else if (!GetUtils.isEmail(emailController.text.trim())) {
      email.value = "Enter a valid email";
      isValid = false;
    } else {
      email.value = '';
    }

    // Validate Password
    if (passwordController.text.trim().isEmpty) {
      password.value = "Password is required";
      isValid = false;
    } else if (passwordController.text.trim().length < 6) {
      password.value = "Password must be at least 6 characters";
      isValid = false;
    } else {
      password.value = '';
    }

    return isValid;
  }

  // Method to handle sign-in action
  void onSignIn() async {
    if (validateForm()) {
      isLoading(true);

      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };

      Map<String, String> body = {
        'email': emailController.text.trim().toString(),
        'password': passwordController.text.trim().toString(),
      };

      try {
        dynamic responseBody = await BaseClient.handleResponse(
          await BaseClient.postRequest(
            api: Endpoints.signInUrl,
            body: jsonEncode(body),
            headers: headers,
          ),
        );

        print("Signup URL: ${Endpoints.signInUrl}");
        print("body: ${jsonEncode(body)}");
        print("responseBody ====> $responseBody");

        if (responseBody != null && responseBody['data'] != null) {
          String token = responseBody['data']['accessToken'];
          String refreshToken = responseBody['data']['refreshToken'];

          LocalStorage.saveData(key: "access_token", data: token);
          LocalStorage.saveData(key: myID, data: responseBody['data']['id']);
          LocalStorage.saveData(key: "refreshToken", data: refreshToken);

          print("access token ===> $token");
          print("Refresh token ===> $refreshToken");

          Get.to(() => Home(),
              transition: Transition.rightToLeft,
              duration: const Duration(milliseconds: 300));

          // Initialize Socket
          SocketService socketService = Get.put(SocketService());
          await socketService.initializeSocket();

          Get.rawSnackbar(
            message: "Welcome to Bashpin event app",
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
            snackPosition: SnackPosition.TOP,
            icon: const Icon(Icons.check, color: Colors.white),
          );

          if (isChecked.value==true) {
            LocalStorage.saveData(key: 'remain_email', data: emailController.text.toString());
            LocalStorage.saveData(key: 'remain_password', data: passwordController.text.toString());
          }

        } else {
          Get.rawSnackbar(
              message: responseBody['data']?['message'] ?? 'Unknown error',
              backgroundColor: Colors.red,
              snackPosition: SnackPosition.TOP);
          print("responseBody ====> $responseBody");
          isLoading(false);
        }
      } catch (e) {
        debugPrint("Catch Error:::::: " + e.toString());
        Get.snackbar("Error", "sign in failed!",
            backgroundColor: Colors.red, snackPosition: SnackPosition.TOP);
      } finally {
        isLoading(false);
      }
    } else {
      Get.snackbar("Error", "Please correct the errors in the form.",
          backgroundColor: Colors.red, snackPosition: SnackPosition.TOP);
      isLoading(false);
    }
  }
}
