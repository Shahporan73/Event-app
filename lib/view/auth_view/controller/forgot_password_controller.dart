import 'dart:convert';

import 'package:event_app/data/api/base_client.dart';
import 'package:event_app/data/api/end_point.dart';
import 'package:event_app/data/token_manager/local_storage.dart';
import 'package:event_app/res/common_widget/custom_snackbar.dart';
import 'package:event_app/view/auth_view/view/user_otp_verified_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController{
  var isLoading = false.obs;
  final TextEditingController emailController = TextEditingController();

  Future<void> forgotPassword() async {
    isLoading.value = true;
    try {
      Map<String, dynamic> body = {
        'email': emailController.text.trim(),
      };
      dynamic responseBody = await BaseClient.handleResponse(
          await BaseClient.postRequest(
              api: Endpoints.forgotPasswordUrl,
              body: body
          )
      );

      print('hit api ${Endpoints.forgotPasswordUrl}');
      print("responseBody ====> $responseBody");
      if(responseBody !=null){
        CustomSnackbar(message: 'Otp sent successfully',);
        LocalStorage.saveData(key: 'forgot_token', data: responseBody['data']['token']);
        print('forgot token ${responseBody['data']['token']}');
        Get.to(
            () => UserOtpVerifiedScreen(
              email: emailController.text.trim(),
            ),
          duration: Duration(milliseconds: 300),
          transition: Transition.rightToLeft,
        );
      }
      isLoading.value = false;
    }catch (e) {
      debugPrint(e.toString());
    }finally {
      isLoading.value = false;
    }
  }
}