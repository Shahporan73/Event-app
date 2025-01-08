// ignore_for_file: empty_catches, avoid_print, prefer_const_constructors, unnecessary_null_comparison, prefer_interpolation_to_compose_strings

import 'dart:convert';

import 'package:event_app/data/api/base_client.dart';
import 'package:event_app/data/api/end_point.dart';
import 'package:event_app/data/token_manager/local_storage.dart';
import 'package:event_app/view/auth_view/view/create_new_password_screen.dart';
import 'package:event_app/view/auth_view/view/sign_in_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'dart:async';

class OtpController extends GetxController {
  // Controller to hold OTP values
  final List<TextEditingController> otpControllers = List.generate(6, (index) => TextEditingController());
  var isLoading = false.obs;

  var secondsRemaining = 180.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining.value > 0) {
        secondsRemaining.value--; // Update remaining time
      } else {
        timer.cancel(); // Stop timer at zero
      }
    });
  }

  void resetTimer() {
    secondsRemaining.value = 180; // Reset to 3 minutes
    startTimer();
  }

// Collect OTP from all controllers and submit it
  void otpSubmitted() async {
    isLoading(true);

    // Collect OTP by concatenating the values from all controllers
    String otpString = otpControllers.map((e) => e.text).join();

    // Check if OTP is exactly 6 digits
    if (otpString.length == 6) {
      try {
        // Try to parse the OTP string as an integer
        int otp = int.parse(otpString);

        Map<String, String> headers = {
          'Content-Type': 'application/json',
          'token': LocalStorage.getData(key: "signup_token"),
        };

        Map<String, dynamic> body = {
          'otp': otp,  // Send OTP as an integer
        };

        // Send the request to verify OTP
        dynamic responseBody = await BaseClient.handleResponse(
          await BaseClient.postRequest(
            api: Endpoints.otpVerifyUrl,
            body: jsonEncode(body),
            headers: headers,
          ),
        );

        print("Response body ======> $responseBody");

        if (responseBody != null) {
          print("====== OTP verified successfully");

          String token = responseBody['data']['accessToken'];
          LocalStorage.saveData(key: "accessToken", data: token);

          // You can navigate to the next screen after OTP verification
          Get.offAll(
                  () => SignInScreen(),
              transition: Transition.rightToLeft,
              duration: Duration(milliseconds: 300)
          );

          Get.snackbar('Message', responseBody['message'], snackPosition: SnackPosition.TOP);
        } else {
          throw "Invalid response: Missing token";
        }
      } catch (e) {
        debugPrint("Catch Error: " + e.toString());
        Get.snackbar("Error", "OTP verification failed! ${e.toString()}", snackPosition: SnackPosition.TOP);
      } finally {
        isLoading(false); // Stop loading spinner when done
      }
    } else {
      // Show an error if the OTP is not 6 digits long
      Get.snackbar("Error", "Please enter a 6-digit OTP", snackPosition: SnackPosition.TOP);
      isLoading(false);
    }
  }

  void onVerifyOtp() async {
    isLoading(true);

    // Collect OTP by concatenating the values from all controllers
    String otpString = otpControllers.map((e) => e.text).join();

    // Check if OTP is exactly 6 digits
    if (otpString.length == 6) {
      try {
        // Try to parse the OTP string as an integer
        int otp = int.parse(otpString);

        Map<String, String> headers = {
          'Content-Type': 'application/json',
          'token': LocalStorage.getData(key: "forgot_token"),
        };

        Map<String, dynamic> body = {
          'otp': otp,
        };

        // Send the request to verify OTP
        dynamic responseBody = await BaseClient.handleResponse(
          await BaseClient.postRequest(
            api: Endpoints.otpVerifyUrl,
            body: jsonEncode(body),
            headers: headers,
          ),
        );

        print('hit api ${Endpoints.otpVerifyUrl}');
        print("Response body ======> $responseBody");

        if (responseBody != null) {
          print("====== OTP verified successfully");

          String token = responseBody['data']['accessToken'];
          LocalStorage.saveData(key: "accessToken", data: token);

          print('reset token ${responseBody['data']['accessToken']}');
          // You can navigate to the next screen after OTP verification
          Get.offAll(
                  () => CreateNewPasswordScreen(),
              transition: Transition.rightToLeft,
              duration: Duration(milliseconds: 300)
          );

          Get.snackbar('Message', 'OTP verification successfully', snackPosition: SnackPosition.TOP);
        } else {
          throw "Invalid response: Missing token";
        }
      } catch (e) {
        debugPrint("Catch Error: " + e.toString());
        Get.snackbar("Error", "OTP verification failed! ${e.toString()}", snackPosition: SnackPosition.TOP);
      } finally {
        isLoading(false); // Stop loading spinner when done
      }
    } else {
      // Show an error if the OTP is not 6 digits long
      Get.snackbar("Error", "Please enter a 6-digit OTP", snackPosition: SnackPosition.TOP);
      isLoading(false);
    }
  }


  void resendOtp() async {
    // Logic to resend OTP
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'token': LocalStorage.getData(key: "signup_token"),
    };

    try {
      dynamic responseBody = await BaseClient.handleResponse(
        await BaseClient.postRequest(
          api: Endpoints.resendOtpUrl,
          headers: headers,
        ),
      );
      print("Signup URL: ${Endpoints.resendOtpUrl}");
      print("response body ======> $responseBody");

      if (responseBody != null) {
        if (secondsRemaining.value == 0) {
          resetTimer();
        }

        print("======otp send success");

        String token = responseBody['data']['token'];

        print("otp-token ===> $token");

        LocalStorage.saveData(key: "otp_token", data: token);
        Get.snackbar("Alert", "OTP sent successfully");
      } else {
        throw "Time expired";
      }
    } catch (e) {
      debugPrint("Catch Error:::::: " + e.toString());
      Get.snackbar("Error", "Otp creation failed!",
          snackPosition: SnackPosition.TOP);
    }
  }

  void verifyResendOtp() async {
    // Logic to resend OTP
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'token': LocalStorage.getData(key: "forgot_token"),
    };

    try {
      dynamic responseBody = await BaseClient.handleResponse(
        await BaseClient.postRequest(
          api: Endpoints.resendOtpUrl,
          headers: headers,
        ),
      );
      print("verify resend otp URL: ${Endpoints.resendOtpUrl}");
      print("response body ======> $responseBody");

      if (responseBody != null) {
        if (secondsRemaining.value == 0) {
          resetTimer();
        }

        print("======otp send success");

        String token = responseBody['data']['token'];

        print("otp-token ===> $token");

        LocalStorage.saveData(key: "otp_token", data: token);
        Get.snackbar("Alert", "OTP sent successfully");
      } else {
        throw "Time expired";
      }
    } catch (e) {
      debugPrint("Catch Error:::::: " + e.toString());
      Get.snackbar("Error", "Otp creation failed!",
          snackPosition: SnackPosition.TOP);
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }


}
