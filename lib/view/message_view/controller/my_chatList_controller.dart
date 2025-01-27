import 'package:event_app/data/api/base_client.dart';
import 'package:event_app/data/api/end_point.dart';
import 'package:event_app/view/message_view/model/chat_list_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class MyChatListController extends GetxController {
  var isLoading = false.obs;
  var myChatListModel = ChatListModel().obs;
  var chatList = <ChatList>[].obs;

  var singleChatList = <ChatList>[].obs;
  var communityChatList = <ChatList>[].obs;

  @override
  void onInit() {
    super.onInit();
    getChatList();
  }

  Future<void> getChatList() async {
    try {
      isLoading(true);

      dynamic responseBody = await BaseClient.handleResponse(
        await BaseClient.getRequest(api: Endpoints.socketUrl),
      );

      if (kDebugMode) {
        print("Response before body: $responseBody");
      }

      if (responseBody['success'] == true) {
        var messageData = responseBody['data'];
        myChatListModel.value = ChatListModel.fromJson(responseBody);
        if (messageData is List && messageData.isNotEmpty) {
          chatList.value = myChatListModel.value.data ?? [];

         /* if (chatList.isNotEmpty) {
            communityChatList.value = chatList.where((chat) => chat.isCommunity == true).toList();
          }
          // add all community == false
          if (chatList.isNotEmpty) {
            singleChatList.value = chatList.where((chat) => chat.isCommunity == false).toList();
            print("Single chat list: ${singleChatList.length} messages.");
          }*/

          print("Filtering for community chats...");
          communityChatList.value = chatList.where((chat) {
            print("Chat: ${chat.communityName}, isCommunity: ${chat.isCommunity}");
            return chat.isCommunity == true;
          }).toList();

          print("Filtering for single chats...");
          singleChatList.value = chatList.where((chat) {
            print("Chat: ${chat.communityName}, isCommunity: ${chat.isCommunity}");
            return chat.isCommunity == false;
          }).toList();



          print("Updated chat list: ${chatList.length} messages.");
        } else {
          print("No messages available in the chat list.");
        }
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
