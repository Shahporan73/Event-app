import 'dart:convert';

import 'package:event_app/data/api/base_client.dart';
import 'package:event_app/data/api/end_point.dart';
import 'package:event_app/data/token_manager/const_veriable.dart';
import 'package:event_app/data/token_manager/local_storage.dart';
import 'package:event_app/res/common_widget/custom_snackbar.dart';
import 'package:event_app/view/auth_view/view/sign_in_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ResetPasswordController extends GetxController{
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  var isLoading = false.obs;
  var isNewPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;

  void toggleNewPasswordVisibility() {
    isNewPasswordVisible.value = !isNewPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  Future<void> resetPassword() async {
    // Input validation
    if (newPasswordController.text.trim().isEmpty) {
      Get.rawSnackbar(message: 'new_password_is_required'.tr);
      return;
    }
    if (newPasswordController.text.trim().length < 6) {
      Get.rawSnackbar(
        message: 'new_password_must_be_at_least_6_characters'.tr,
      );
      return;
    }
    if (confirmPasswordController.text.trim().isEmpty) {
      Get.rawSnackbar(
        message: 'confirm_password_is_required'.tr,
      );
      return;
    }
    if (newPasswordController.text.trim() != confirmPasswordController.text.trim()) {
      Get.rawSnackbar(
        message: 'new_password_and_confirm_password_do_not_match'.tr,
      );
      return;
    }

    isLoading.value = true;

    try {
      String? forgotToken = LocalStorage.getData(key: "forgot_token");

      // Ensure forgotToken is not null
      if (forgotToken == null || forgotToken.isEmpty) {
        Get.rawSnackbar(message: 'Forgot token is missing');
        return;
      }

      print('Forgot token: $forgotToken');

      // Headers and body
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'token': forgotToken,
      };

      Map<String, String> body = {
        'password': newPasswordController.text.trim(),
      };

      // API call
      dynamic responseBody = await BaseClient.handleResponse(
        await BaseClient.postRequest(
          api: Endpoints.resetPasswordUrl,
          body: jsonEncode(body),
          headers: headers,
        ),
      );

      print('Hit API: ${Endpoints.resetPasswordUrl}');
      print("Response Body: $responseBody");

      // Null safety checks
      if (responseBody != null && responseBody['success'] == true) {
        final data = responseBody['data'];
        LocalStorage.saveData(key: myID, data: data['id']);
        LocalStorage.saveData(
            key: 'remain_password',
            data: newPasswordController.text.trim());

        // Show success message and navigate to sign-in
        Get.rawSnackbar(message: 'password_change_successfully'.tr);
        Get.offAll(
              () => SignInScreen(),
          duration: Duration(milliseconds: 100),
          transition: Transition.fade,
        );
      } else {
        // Handle server response errors
        String message = responseBody?['message'] ?? 'Something went wrong';
        Get.rawSnackbar(message: message);
      }
    } catch (e) {
      debugPrint('Reset error: ${e.toString()}');
      Get.rawSnackbar(message: 'An error occurred. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }


}