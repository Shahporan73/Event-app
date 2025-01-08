import 'dart:convert';

import 'package:event_app/data/api/base_client.dart';
import 'package:event_app/data/api/end_point.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePasswordController extends GetxController{
  var isLoading = false.obs;
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  var isCurrentPasswordVisible = false.obs;
  var isNewPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;
  void toggleCurrentPasswordVisibility() {
    isCurrentPasswordVisible.value = !isCurrentPasswordVisible.value;
  }

  // Toggles the visibility of new password
  void toggleNewPasswordVisibility() {
    isNewPasswordVisible.value = !isNewPasswordVisible.value;
  }

  // Toggles the visibility of confirm password
  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }


  Future<void> onChangePassword(context) async {
    // Validate form inputs before making the API request
    if (oldPasswordController.text.trim().isEmpty) {
      Get.snackbar("Error", "Old password is required");
      return;
    }

    if (newPasswordController.text.trim().isEmpty) {
      Get.snackbar("Error", "New password is required");
      return;
    }

    if (confirmPasswordController.text.trim().isEmpty) {
      Get.snackbar("Error", "Confirm password is required");
      return;
    }

    // Validate the minimum length for passwords
    if (newPasswordController.text.trim().length < 6) {
      Get.snackbar("Error", "New password must be at least 6 characters long");
      return;
    }

    if (confirmPasswordController.text.trim().length < 6) {
      Get.snackbar("Error", "Confirm password must be at least 6 characters long");
      return;
    }

    // Check if new password and confirm password match
    if (newPasswordController.text.trim() != confirmPasswordController.text.trim()) {
      Get.snackbar("Error", "New password and confirm password do not match");
      return;
    }

    try {
      isLoading.value = true;
      Map<String, String> body = {
        'oldPassword': oldPasswordController.text.trim(),
        'newPassword': newPasswordController.text.trim(),
      };

      dynamic responseBody = await BaseClient.handleResponse(
        await BaseClient.patchRequest(
          api: Endpoints.changePasswordURL,
          body: body,
        ),
      );

      print('hit api ${Endpoints.changePasswordURL}');
      print("responseBody ====> $responseBody");

      if (responseBody != null) {
        Get.snackbar("Success", responseBody['message'],
            snackPosition: SnackPosition.TOP,
        colorText: Colors.white, backgroundColor: Colors.green
        );
        Navigator.pop(context);
      }

    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

}