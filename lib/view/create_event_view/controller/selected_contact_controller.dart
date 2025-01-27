import 'dart:convert';

import 'package:event_app/data/api/base_client.dart';
import 'package:event_app/data/api/end_point.dart';
import 'package:event_app/data/token_manager/const_veriable.dart';
import 'package:event_app/data/token_manager/local_storage.dart';
import 'package:event_app/res/common_widget/responsive_helper.dart';
import 'package:event_app/view/create_event_view/model/recommandable_users_model.dart';
import 'package:event_app/view/create_event_view/model/users_model.dart';
import 'package:event_app/view/create_event_view/view/congratulation_screen.dart';
import 'package:event_app/view/home_view/view/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectedContactController extends GetxController{
  final TextEditingController searchController = TextEditingController();
  var isLoading = false.obs;
  var isButtonLoading = false.obs;
  var isSearchLoading = false.obs;
  var userModel = UsersModel().obs;
  var userList = <UserList>[].obs;
  var recommendableUserModel = RecommendableUsersModel().obs;
  var recommendableUserList = <RecommendableUsersList>[].obs;

//   // RxList to manage selected contact IDs
//   var selectedContact_user_list = <int>[].obs;
//
// // Method to toggle selection of an item by ID
//   void toggleSelection(int id) {
//     // Print debugging information
//     print('Toggling selection for ID: $id');
//
//     // Check if the ID is already in the list
//     if (selectedContact_user_list.contains(id)) {
//       // Remove the ID if it's already selected
//       selectedContact_user_list.remove(id);
//       print('Removed ID: $id');
//     } else {
//       // Add the ID if it's not selected
//       selectedContact_user_list.add(id);
//       print('Added ID: $id');
//     }
//
//     // Print updated list of selected IDs
//     print('Selected Contact IDs: ${selectedContact_user_list}');
//   }
//
//
// // Get the list of selected contact IDs
//   List<int> get selectedContacts => selectedContact_user_list;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getAllContacts();
    getRecommendableUsers();
    searchRecommendableUsers();
  }


  Future<void> getAllContacts() async{
    isLoading.value = true;
    try{
      String token = LocalStorage.getData(key: "access_token");

      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      };

      dynamic responseBody = await BaseClient.handleResponse(
        await BaseClient.getRequest(
          api: Endpoints.allUsersURL,
          headers: headers,
        ),
      );
      print('hit api ${Endpoints.allUsersURL}');
      if(responseBody != null){
        print("responseBody ====> $responseBody");
        userList.clear();
        userModel.value = UsersModel.fromJson(responseBody);
        userList.assignAll(userModel.value.data?.data ?? []);
      }

    }catch(e){
      print(e.toString());
    }finally{
      isLoading.value = false;
    }
  }

  Future<void> getRecommendableUsers() async{
    isLoading.value = true;
    try{
      String token = LocalStorage.getData(key: "access_token");

      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      };

      String recommendableEventId = LocalStorage.getData(key: eventIdForInviteEvent);

      dynamic responseBody = await BaseClient.handleResponse(
        await BaseClient.getRequest(
          api: Endpoints.recommendableUsersURL(eventId: recommendableEventId),
          headers: headers,
        ),
      );
      print('hit api ${Endpoints.allUsersURL}');
      if(responseBody != null){
        print("responseBody ====> $responseBody");
        recommendableUserList.clear();
        recommendableUserModel.value = RecommendableUsersModel.fromJson(responseBody);
        recommendableUserList.assignAll(recommendableUserModel.value.data ?? []);
      }

    }catch(e){
      print(e.toString());
    }finally{
      isLoading.value = false;
    }
  }


  // Search for recommendable users
  Future<void> searchRecommendableUsers() async {
    isSearchLoading.value = true;
    try {
      String token = LocalStorage.getData(key: "access_token");
      String recommendableEventId = LocalStorage.getData(key: eventIdForInviteEvent);
      String searchTerm = Uri.encodeComponent(searchController.text.trim());

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      dynamic responseBody = await BaseClient.handleResponse(
        await BaseClient.getRequest(
          api: Endpoints.searchRecommendableUsersURL(eventId: recommendableEventId, searchTerm: searchTerm),
          headers: headers,
        ),
      );
      // print("responseBody ====> $responseBody");

      if(responseBody != null){
        recommendableUserList.clear();
        recommendableUserModel.value = RecommendableUsersModel.fromJson(responseBody);
        recommendableUserList.assignAll(recommendableUserModel.value.data ?? []);
      }else{
        Get.rawSnackbar(message: "No events found", snackPosition: SnackPosition.BOTTOM);
      }

    }catch (e) {
      print(e);
    } finally {
      isSearchLoading.value = false;
    }
  }


/*  Future<void> searchRecommendableUsersList() async {
    isSearchLoading.value = true;
    try {
      // Simulate a local search
      String searchTerm = searchController.text.trim().toLowerCase();

      // Filter static users by name containing the search term
      List<Map<String, String>> filteredUsers = recommendableUserList.value
          .where((user) => user["name"]!.toLowerCase().contains(searchTerm))
          .toList();

      recommendableUserList.clear();
      if (filteredUsers.isNotEmpty) {
        recommendableUserList.assignAll(
          filteredUsers.map((user) => UserModel.fromMap(user)).toList(),
        );
      } else {
        Get.rawSnackbar(
          message: "No matching users found",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print(e);
    } finally {
      isSearchLoading.value = false;
    }
  }*/

  // Method to invite selected users
  Future<void> inviteSelectedUsers(List<String> selectedContactUserSet) async {
    isLoading.value = true;
    if (selectedContactUserSet.isEmpty) {
      Get.rawSnackbar(
        message: "No users selected for invitation.",
        snackPosition: SnackPosition.TOP,
      );
      print("No users selected for invitation.");
      return;
    }

    try {
      isButtonLoading.value = true;
      String token = LocalStorage.getData(key: "access_token");

      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      };
      /*List<String> uniqueUserIds = selectedContactUserSet.toSet().toList();*/

      // Prepare request body
      Map<String, dynamic> requestBody = {
        "userIds": selectedContactUserSet
      };

      String eventId = LocalStorage.getData(key: eventIdForInviteEvent);
      print('selectedContactUserSet ====> $selectedContactUserSet');
      dynamic responseBody = await BaseClient.handleResponse(
        await BaseClient.postRequest(
          api: Endpoints.inviteUsersURL(eventId: eventId),
          headers: headers,
          body: jsonEncode(requestBody),
        ),
      );

      if (responseBody != null) {
        selectedContactUserSet.clear();
        print("Invitation sent successfully!");
        Get.rawSnackbar(message: "Invitation sent successfully!");
        print("Response: $responseBody");
        goToCongratulationDialog(Get.context);
      }
    } catch (e) {
      print("Error sending invitation: $e");
    }finally{
      isLoading.value = false;
      isButtonLoading.value = false;
    }
  }

  // Method to invite selected users
  Future<void> inviteSelectedUsersFromCreatedEvent(List<String> selectedContactUserSet) async {
    isLoading.value = true;
    if (selectedContactUserSet.isEmpty) {
      Get.rawSnackbar(
        message: "No users selected for invitation.",
        snackPosition: SnackPosition.TOP,
      );
      print("No users selected for invitation.");
      return;
    }

    try {
      isButtonLoading.value = true;
      String token = LocalStorage.getData(key: "access_token");

      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      };
      /*List<String> uniqueUserIds = selectedContactUserSet.toSet().toList();*/

      // Prepare request body
      Map<String, dynamic> requestBody = {
        "userIds": selectedContactUserSet
      };

      String eventId = LocalStorage.getData(key: eventIdForInviteEvent);
      print('selectedContactUserSet ====> $selectedContactUserSet');
      dynamic responseBody = await BaseClient.handleResponse(
        await BaseClient.postRequest(
          api: Endpoints.inviteUsersURL(eventId: eventId),
          headers: headers,
          body: jsonEncode(requestBody),
        ),
      );

      if (responseBody != null) {
        selectedContactUserSet.clear();
        print("Invitation sent successfully!");
        Get.rawSnackbar(message: "Invitation sent successfully!");
        print("Response: $responseBody");
      }
    } catch (e) {
      print("Error sending invitation: $e");
    }finally{
      isLoading.value = false;
      isButtonLoading.value = false;
    }
  }

  Future goToCongratulationDialog(context) {
    Future.delayed(Duration(seconds: 2), () {
      Get.offAll(
          () => Home(),
          transition: Transition.rightToLeft,
          duration: Duration(milliseconds: 300)
      );
    });
    return Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        backgroundColor: Colors.white,
        child: Container(
          height: ResponsiveHelper.h(context, 300),
          padding: EdgeInsets.all(16.0),
          child: CongratulationScreen(),
        ),
      ),
      barrierDismissible: true,
      barrierColor: Colors.black26,
    );
  }
}