import 'dart:convert';

import 'package:event_app/data/api/base_client.dart';
import 'package:event_app/data/api/end_point.dart';
import 'package:event_app/data/token_manager/const_veriable.dart';
import 'package:event_app/data/token_manager/local_storage.dart';
import 'package:event_app/view/message_view/view/personal_chat_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class PersonalChatController extends GetxController{
  var isLoading = false.obs;

  Future<void> getChatList({required String receiverId,  String? userName,  String? userImage }) async {
    try {
      isLoading(true);

      var body = jsonEncode({
        "receiverId": receiverId
      });

      String token = LocalStorage.getData(key: "access_token");
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      dynamic responseBody = await BaseClient.handleResponse(
        await BaseClient.postRequest(
            api: Endpoints.sendMessageURL,
            body: body,
            headers: headers
        ),
      );

      if (kDebugMode) {
        print("Response before body: $responseBody");
      }

      if (responseBody['success'] == true) {
        LocalStorage.saveData(key: 'communityId', data: responseBody['data']['id']);
        Get.to(
              () => PersonalChatScreen(
              chatId: responseBody['data']['id'] ?? '',
              userName: userName ?? 'N/A',
              userImage: userImage ?? placeholderImage
          ),
          transition: Transition.leftToRight,
          duration: Duration(milliseconds: 300),
        );

      } else {
        throw 'Failed to load data: ${responseBody['message']}';
      }
    } catch (e) {
      print("Error fetching chat list: $e");
    } finally {
      isLoading(false);
    }
  }
}
