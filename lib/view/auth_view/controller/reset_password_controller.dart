import 'dart:convert';

import 'package:event_app/data/api/base_client.dart';
import 'package:event_app/data/api/end_point.dart';
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
    if (newPasswordController.text.trim().isEmpty) {
      Get.rawSnackbar(message: 'New password is required');
      return;
    }
    if (newPasswordController.text.trim().length < 6) {
      Get.rawSnackbar(
        message: 'New password must be at least 6 characters',
      );
      return;
    }
    if (confirmPasswordController.text.trim().isEmpty) {
      Get.rawSnackbar(
        message: 'Confirm password is required',
      );
      return;
    }
    if (newPasswordController.text.trim() != confirmPasswordController.text.trim()) {
      Get.rawSnackbar(
        message: 'Password and confirm password do not match',
      );
      return;
    }
    isLoading.value = true;
    try {
      
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'token': LocalStorage.getData(key: "forgot_token"),
      };

      Map<String, String> body = {
        'password': newPasswordController.text.trim(),
      };

      dynamic responseBody = await BaseClient.handleResponse(
          await BaseClient.postRequest(
              api: Endpoints.resetPasswordUrl,
              body: jsonEncode(body),
              headers: headers
          ),
      );

      print('hit api ${Endpoints.resetPasswordUrl}');
      print("responseBody ====> $responseBody");

      if(responseBody !=null){
        Get.rawSnackbar (
          message: 'Password changed successfully',
        );
        String token = responseBody['data']['accessToken'];
        String refreshToken = responseBody['data']['refreshToken'];
        LocalStorage.saveData(key: "access_token", data: token);
        LocalStorage.saveData(key: "userId", data: responseBody['data']['id']);
        LocalStorage.saveData(key: "refreshToken", data: refreshToken);
        Get.offAll(
          () => SignInScreen(),
          duration: Duration(milliseconds: 300),
          transition: Transition.fade
        );
        LocalStorage.saveData(key: 'remain_password', data: newPasswordController.text.trim());
      }
    }catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

}