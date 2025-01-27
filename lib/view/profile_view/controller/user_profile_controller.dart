import 'dart:convert';

import 'package:event_app/data/api/base_client.dart';
import 'package:event_app/data/api/end_point.dart';
import 'package:event_app/data/token_manager/const_veriable.dart';
import 'package:event_app/data/token_manager/local_storage.dart';
import 'package:event_app/view/profile_view/model/user_profile_model.dart';
import 'package:get/get.dart';

class UserProfileController extends GetxController{
  var isLoading = false.obs;
  var isFollowLoading = false.obs;
  var userProfileModel = UserProfileModel().obs;
  var postList = <Post>[].obs;
  var followStates = <String, bool>{}.obs; // Map to track follow states


  @override
  void onInit() {
    getUserProfile();
    // TODO: implement onInit
    super.onInit();

  }

  Future<void> getUserProfile()async{
    isLoading.value = true;

    var token = LocalStorage.getData(key: "access_token");
    var userId = LocalStorage.getData(key: userProfileId);
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      var response = await BaseClient.handleResponse(
        await BaseClient.getRequest(
          api: Endpoints.userProfileURL(userId: userId),
          headers: headers,
        ),
      );
      print('hit api ${Endpoints.userProfileURL(userId: userId.isNotEmpty ? userId : '')}');
      print("responseBody ====> $response");
      if (response != null) {
        postList.clear();
        print('user profile method hit');
        print("responseBody ====> $response");
        userProfileModel.value = UserProfileModel.fromJson(response);
        postList.assignAll(userProfileModel.value.data?.post ?? []);
      }
    } catch (e) {
      print(e);
    }finally{
      isLoading.value = false;
    }
  }


  Future<void> onFollow(String userId)async{
    isFollowLoading.value = true;
    String token = LocalStorage.getData(key: "access_token");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    Map<String, dynamic> body = {
      "userId": userId,
    };

    try {
      var response = await BaseClient.handleResponse(
        await BaseClient.postRequest(
          api: Endpoints.onFollowURL,
          headers: headers,
          body: jsonEncode(body),
        ),
      );
      print('hit api ${Endpoints.userProfileURL(userId: userId)}');
      print("responseBody ====> $response");
      if (response != null) {
        // Determine the follow/unfollow status from the response
        final message = response['data']['message'] ?? '';
        if (message.contains('Followed')) {
          // Mark the user as followed
          followStates[userId] = true;
        } else if (message.contains('Un-followed')) {
          // Mark the user as unfollowed
          followStates[userId] = false;
        }

        // Display appropriate message
        Get.rawSnackbar(message: message);
        getUserProfile();
      }
    } catch (e) {
      print(e);
    }finally{
      isFollowLoading.value = false;
    }
  }
}