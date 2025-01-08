import 'dart:convert';

import 'package:event_app/data/api/base_client.dart';
import 'package:event_app/data/api/end_point.dart';
import 'package:event_app/data/token_manager/const_veriable.dart';
import 'package:event_app/data/token_manager/local_storage.dart';
import 'package:event_app/view/event_view/controller/my_event_controller.dart';
import 'package:event_app/view/event_view/model/comments_model.dart';
import 'package:event_app/view/profile_view/controller/user_profile_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommentController extends GetxController{
  var isLoading = false.obs;
  var isCreateLoading = false.obs;
  final TextEditingController commentController = TextEditingController();
  var commentModel = CommentsModel().obs;
  var commentList = <CommentList>[].obs;
  final MyEventController myEventController = Get.find<MyEventController>();
  final UserProfileController getUserProfile = Get.find<UserProfileController>();


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getComments();
  }

  Future<void> getComments() async {
    isLoading.value = true;
    try {
      String token = LocalStorage.getData(key: "access_token");
      String postId = LocalStorage.getData(key: postIDForGetComment);

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      dynamic responseBody = await BaseClient.handleResponse(
        await BaseClient.getRequest(
          api: Endpoints.getCommentURL(postId: postId),
          headers: headers,
        ),
      );

      print('hit api ${Endpoints.getCommentURL(postId: postId)}');
      print("responseBody ====> $responseBody");
      if(responseBody != null){
        commentList.clear();
        commentModel.value = CommentsModel.fromJson(responseBody);
        commentList.assignAll(commentModel.value.data ?? []);
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createComment(String postId) async {
    isCreateLoading.value = true;
    try {
      String token = LocalStorage.getData(key: "access_token");
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      Map<String, dynamic> body = {
        "postId": postId,
        'body': commentController.text.toString(),
      };
      dynamic responseBody = await BaseClient.handleResponse(
        await BaseClient.postRequest(
          api: Endpoints.createCommentURL,
          headers: headers,
          body: jsonEncode(body),
        ),
      );

      print('hit api ${Endpoints.createCommentURL}');
      print("responseBody ====> $responseBody");
      if(responseBody != null){
        Get.rawSnackbar(message: "Comment added successfully",
            backgroundColor: Colors.green, snackPosition: SnackPosition.TOP);
        getComments();
        commentController.clear();
        myEventController.getMyEventsPost();
        getUserProfile.getUserProfile();
      }else{
        Get.rawSnackbar(message: "Something went wrong, please try again",
            snackPosition: SnackPosition.TOP);
      }
    } catch (e) {
      print('Error : $e');
    } finally {
      isCreateLoading.value = false;
    }
  }

}