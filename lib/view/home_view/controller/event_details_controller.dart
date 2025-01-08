import 'package:event_app/data/api/base_client.dart';
import 'package:event_app/data/api/end_point.dart';
import 'package:event_app/data/token_manager/const_veriable.dart';
import 'package:event_app/data/token_manager/local_storage.dart';
import 'package:event_app/view/home_view/model/get_event_model.dart';
import 'package:event_app/view/home_view/view/joinging_complete_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventDetailsController extends GetxController{
  var isLoading = false.obs;
  var eventModel = GetEventModel().obs;
  String eventId = LocalStorage.getData(key: showEventDetailsId);


  @override
  void onInit() {
    super.onInit();
    getEventDetails();
  }

  Future<void> getEventDetails() async{
    isLoading.value = true;
    if(eventId == null){
      Get.back();
    }
    try {
      String token = LocalStorage.getData(key: "access_token");
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      dynamic responseBody = await BaseClient.handleResponse(
        await BaseClient.getRequest(
          api: Endpoints.getEventDetailsURL(eventId: eventId),
          headers: headers,
        ),
      );
      print('hit api ${Endpoints.getEventDetailsURL(eventId: eventId)}');
      if (responseBody != null) {
        print("responseBody ====> $responseBody");
        eventModel.value = GetEventModel.fromJson(responseBody);
      }
    } finally {
      isLoading.value = false;
    }
  }



  Future<void> jointEvent(String eventId) async{
    isLoading.value = true;
    if(eventId == null){
      Get.rawSnackbar(message: "Something went wrong", snackPosition: SnackPosition.BOTTOM);
    }
    try {
      String token = LocalStorage.getData(key: "access_token");
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      dynamic responseBody = await BaseClient.handleResponse(
        await BaseClient.postRequest(
          api: Endpoints.joinEventURL(eventId: eventId),
          headers: headers,
        ),
      );
      print('hit api ${Endpoints.getEventDetailsURL(eventId: eventId)}');
      if (responseBody != null) {
        print("responseBody ====> $responseBody");
        if(responseBody['success'] == true) {
          Get.snackbar('Success', responseBody["message"], colorText: Colors.white, backgroundColor: Colors.green);
          Get.to(
                  () => JoingingCompleteScreen(),
              transition: Transition.fadeIn
          );
        }else{
          Get.snackbar('Error', responseBody["message"], colorText: Colors.white, backgroundColor: Colors.red);
        }
      }
    } finally {
      isLoading.value = false;
    }
  }
}