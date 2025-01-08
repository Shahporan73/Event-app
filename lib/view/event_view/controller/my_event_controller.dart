import 'package:event_app/data/api/base_client.dart';
import 'package:event_app/data/api/end_point.dart';
import 'package:event_app/data/token_manager/const_veriable.dart';
import 'package:event_app/data/token_manager/local_storage.dart';
import 'package:event_app/view/event_view/model/event_posts_model.dart';
import 'package:event_app/view/event_view/model/my_event_model.dart';
import 'package:event_app/view/profile_view/controller/user_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyEventController extends GetxController{
  var isLoading = false.obs;
  var isLikeLoading = false.obs;
  var isAlreadyLike = false.obs;
  var myEventModel = MyEventsModel().obs;
  var myEventList = <MyEventList>[].obs;

  var eventPostModel = EventPostsModel().obs;
  var postList = <PostList>[].obs;

  final UserProfileController userProfileController = Get.find<UserProfileController>();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getMyEvents();
    getMyEventsPost();
  }

  Future<void> getMyEvents() async {
    isLoading.value = true;
    try {
      String token = LocalStorage.getData(key: "access_token");

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      dynamic responseBody = await BaseClient.handleResponse(
        await BaseClient.getRequest(
          api: Endpoints.myJoinedEventsURL,
          headers: headers,
        ),
      );

      print('hit api ${Endpoints.myJoinedEventsURL}');
      print("responseBody ====> $responseBody");
      if(responseBody != null){
        myEventList.clear();
        myEventModel.value = MyEventsModel.fromJson(responseBody);
        myEventList.assignAll(myEventModel.value.data ?? []);
      }
    }catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getMyEventsPost() async {
    isLoading.value = true;
    try {
      String token = LocalStorage.getData(key: "access_token");
      String eventId = LocalStorage.getData(key: eventPostId);

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      dynamic responseBody = await BaseClient.handleResponse(
        await BaseClient.getRequest(
          api: Endpoints.eventPostURL(eventId: eventId),
          headers: headers,
        ),
      );

      print('hit api ${Endpoints.myJoinedEventsURL}');
      if(responseBody != null){
        postList.clear();
        eventPostModel.value = EventPostsModel.fromJson(responseBody);
        postList.assignAll(eventPostModel.value.data?.post ?? []);
      }
    }catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createLike(postId) async {
    isLikeLoading.value = true;
    try {
      String token = LocalStorage.getData(key: "access_token");
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      dynamic responseBody = await BaseClient.handleResponse(
          await BaseClient.postRequest(
            api: Endpoints.createLikeURL(postId: postId),
            headers: headers,
          )
      );
      print('hit api ${Endpoints.createLikeURL(postId: postId)}');
      if (responseBody != null) {
        // Get.rawSnackbar(message: 'Liked');
        print('liked created successfully');

        getMyEventsPost();
        userProfileController.getUserProfile();
      }
    }catch (e) {
      print("Error : $e");
    }finally{
      isLikeLoading.value = false;
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      String token = LocalStorage.getData(key: "access_token");
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      dynamic responseBody = await BaseClient.handleResponse(
          await BaseClient.deleteRequest(
              api: Endpoints.deletePostURL(postId: postId),
              headers: headers
          )
      );
      print('hit api ${Endpoints.deletePostURL(postId: postId)}');
      print("responseBody ====> $responseBody");
      if (responseBody != null) {
        Get.rawSnackbar(message: "Post deleted successfully",
            backgroundColor: Colors.green,
            snackPosition: SnackPosition.BOTTOM);
        print("Post deleted successfully: $responseBody");
        getMyEventsPost();
        userProfileController.getUserProfile();
      }
    }catch (e) {
      print("Error : $e");
    }
  }

}