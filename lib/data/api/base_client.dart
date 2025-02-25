import 'dart:convert';
import 'dart:io';
import 'package:event_app/data/api/end_point.dart';
import 'package:event_app/data/token_manager/local_storage.dart';
import 'package:event_app/view/auth_view/view/sign_in_screen.dart';
import 'package:flutter/cupertino.dart';

import 'package:get/get.dart' hide Response;
import 'package:http/http.dart' as http;



class BaseClient {

  static getRequest({required String api, params, headers}) async {

    debugPrint("API Hit: $api");
    http.Response response = await http.get(
        Uri.parse(api).replace(queryParameters: params),
        headers: headers
    );
    return response;
  }

  static postRequest({required String api, body, headers}) async {

    debugPrint("API Hit: $api");
    debugPrint("body: $body");
    http.Response response = await http.post(
      Uri.parse(api),
      body: body,
      headers: headers,
    );
    debugPrint("<================= response =================>");
    return response;
  }

  static deleteRequest({required String api, body, headers}) async {
    debugPrint("API Hit: $api");
    debugPrint("body: $body");
    http.Response response = await http.delete(
      Uri.parse(api),
      body: body,
      headers: headers,
    );
    debugPrint("<================= response =================>");
    return response;
  }


  static patchRequest({required String api, body}) async {
    String token = LocalStorage.getData(key: 'access_token');

    var headers = {
      'content-type': 'application/json',
      "Authorization": "Bearer $token"
    };
    debugPrint("API Hit: $api");
    debugPrint("body: $body");

    http.Response response = await http.patch(
      Uri.parse(api),
      body: body,
      headers: headers,
    );
    return response;
  }


  static handleResponse(http.Response response) async {
    try {
      debugPrint('statusCode: ${response.statusCode}');
      debugPrint('Response: ${response.body}');
      if (response.statusCode >= 200 && response.statusCode <= 210) {
        debugPrint('SuccessCode: ${response.statusCode}');
        debugPrint('SuccessResponse: ${response.body}');

        if (response.body.isNotEmpty) {
          return json.decode(response.body);
        } else {
          return response.body;
        }
      } else if (response.statusCode == 401) {

         try {
           print('init token update');
            var response = await http.get(
              Uri.parse(Endpoints.refreshTokenURL),
              headers: {
                'token': '${LocalStorage.getData(key: 'refreshToken')}',
              },
            );
            if (response.statusCode == 200) {
              final Map<String, dynamic> responseData = jsonDecode(response.body);
              print('response data ${responseData}');
              LocalStorage.saveData(key: 'access_token', data: responseData["data"]["accessToken"].toString());
              LocalStorage.saveData(key: 'refreshToken', data: responseData["data"]["refreshToken"].toString());
              Get.snackbar('Success', 'Token Updated.');
              print('access token updated');
            } else {
              Get.snackbar('Error', 'Failed Token Updated');
              Get.to(
                () => SignInScreen(),
                transition: Transition.rightToLeft,
                duration: const Duration(milliseconds: 300),
              );
            }
          } catch (e) {
            Get.snackbar('Error', 'Failed to Token Updated: $e');
          }

        //  logout();
        String msg = "Unauthorized";
        if (response.body.isNotEmpty) {
          if(json.decode(response.body)['errors'] != null){
            msg = json.decode(response.body)['errors'];
          }
        }
        throw msg;
      } else if (response.statusCode == 404) {
        Get.snackbar('Error', json.decode(response.body)['message'],
            snackPosition: SnackPosition.BOTTOM);
        throw 'Page Not Found!';
      }
      else if(response.statusCode == 403){

        Get.snackbar('Error', json.decode(response.body)['message'],
            snackPosition: SnackPosition.BOTTOM);

      }

      else if(response.statusCode == 400){

        Get.snackbar('Error', json.decode(response.body)['message'],
            snackPosition: SnackPosition.BOTTOM);

      }else if(response.statusCode == 406){

        Get.snackbar('Error', json.decode(response.body)['message'],
            snackPosition: SnackPosition.BOTTOM);

      }
      else if(response.statusCode == 406){
        Get.snackbar('Error', json.decode(response.body)['message'],
            snackPosition: SnackPosition.BOTTOM);

      }else if (response.statusCode == 500) {
        throw "Server Error";
      } else {
        debugPrint('ErrorCode: ${response.statusCode}');
        debugPrint('ErrorResponse: ${response.body}');

        String msg = "Something went wrong";
        if (response.body.isNotEmpty) {
          var data = jsonDecode(response.body)['errors'];
          if(data == null){
            msg = jsonDecode(response.body)['message'] ?? msg;
          }
          else if (data is String) {
            msg = data;
          } else if (data is Map) {
            msg = data['email'][0];
          }
        }
        throw msg;
      }
    } on SocketException catch (_) {
      throw "noInternetMessage";
    } on FormatException catch (_) {
      throw "Bad response format";
    } catch (e) {
      throw e.toString();
    }
  }

  static void logout() {
     LocalStorage.removeData(key: 'access_token');
     Get.offAll(
         ()=> SignInScreen(),
       duration: const Duration(milliseconds: 300),
       transition: Transition.fade
     );
  }
}