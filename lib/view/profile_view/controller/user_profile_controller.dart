import 'dart:convert';

import 'package:event_app/data/api/base_client.dart';
import 'package:event_app/data/api/end_point.dart';
import 'package:event_app/data/token_manager/const_veriable.dart';
import 'package:event_app/data/token_manager/local_storage.dart';
import 'package:event_app/view/profile_view/model/user_profile_model.dart';
import 'package:get/get.dart';

class UserProfileController extends GetxController{
  var isLoading = false.obs;
  var isFollow = false.obs;
  var userProfileModel = UserProfileModel().obs;
  var postList = <Post>[].obs;



  @override
  void onInit() {
    getUserProfile();
    // TODO: implement onInit
    super.onInit();

  }

  Future<void> getUserProfile()async{
    isLoading.value = true;
    String token = LocalStorage.getData(key: "access_token");
    String userId = LocalStorage.getData(key: userProfileId);
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
      print('hit api ${Endpoints.userProfileURL(userId: userId)}');
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
    isLoading.value = true;
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
          // isFollow.value = true;
          LocalStorage.saveData(key: 'is_follow', data: 'following');
        }else
        if (message.contains('Un-followed')) {
          // isFollow.value = false;
          LocalStorage.removeData(key: 'is_follow');
        }

        // Display appropriate message
        Get.rawSnackbar(message: message);
        getUserProfile();
      }
    } catch (e) {
      print(e);
    }finally{
      isLoading.value = false;
    }
  }

}