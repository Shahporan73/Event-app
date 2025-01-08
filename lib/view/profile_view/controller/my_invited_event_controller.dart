import 'dart:convert';

import 'package:event_app/data/api/base_client.dart';
import 'package:event_app/data/api/end_point.dart';
import 'package:event_app/data/token_manager/const_veriable.dart';
import 'package:event_app/data/token_manager/local_storage.dart';
import 'package:event_app/view/profile_view/model/my_invited_event_details_model.dart';
import 'package:event_app/view/profile_view/model/my_invited_event_model.dart';
import 'package:get/get.dart';

class MyInvitedEventController extends GetxController{
  var isLoading = false.obs;
  var isUpdating = false.obs;
  var myInvitedEventModel = MyInvitedEventModel().obs;
  var myInvitePendingList = <MyInvitedEventList>[].obs;
  var myInvitedEventDetails = MyInvitedEventDetailsModel().obs;

  // var invitePendingList = <MyInvitedEventList>[].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getMyInvitedEvent();
    // getInvitedEventDetails();
  }

  Future<void> getMyInvitedEvent() async {
    isLoading.value = true;
    String token = LocalStorage.getData(key: "access_token");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      var response = await BaseClient.handleResponse(
        await BaseClient.getRequest(
          api: Endpoints.myInvitedEventsURL,
          headers: headers,
        ),
      );
      print('hit api ${Endpoints.myInvitedEventsURL}');
      if (response != null) {
        myInvitePendingList.clear();
        print("responseBody ====> $response");
        myInvitedEventModel.value = MyInvitedEventModel.fromJson(response);

        myInvitedEventModel.value.data?.forEach((element) {
          if(element.status == "PENDING"){
            myInvitePendingList.add(element);
          }
        });

        // myInvitePendingList.assignAll(myInvitedEventModel.value.data ?? []);
      }
    } catch (e) {
      print(e);
    }finally{
      isLoading.value = false;
    }
  }


  Future<void> getInvitedEventDetails(String eventId) async {
    isLoading.value = true;
    String token = LocalStorage.getData(key: "access_token");
    // String eventId = LocalStorage.getData(key: invitedEventDetailsID);

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      var response = await BaseClient.handleResponse(
        await BaseClient.getRequest(
          api: Endpoints.invitedEventDetailsURL(eventId: eventId),
          headers: headers,
        ),
      );
      print('hit api ${Endpoints.myInvitedEventsURL}');
      print("responseBody ====> $response");
      if (response != null) {
        print("responseBody ====> $response");
        myInvitedEventDetails.value = MyInvitedEventDetailsModel.fromJson(response);
      }
    } catch (e) {
      print(e);
    }finally{
      isLoading.value = false;
    }
  }

  Future<void> eventStatusUpdate(String status, String eventId) async {
    isUpdating.value = true;
    // String eventId = LocalStorage.getData(key: invitedEventDetailsID);
    print('update event status-> $status and eventId-> $eventId');

    Map<String, String> body = {
      "status": status
    };

    try {
      var response = await BaseClient.handleResponse(
        await BaseClient.patchRequest(
          api: Endpoints.eventJoinStatusURL(eventId: eventId),
          body: jsonEncode(body),
        ),
      );
      print('hit api ${Endpoints.eventJoinStatusURL(eventId: eventId)}');
      print("responseBody ====> $response");
      // print("responseBody ====> $response");
      if (response != null) {
        print("responseBody ====> $response");
        // if(response['success'] == false){
        //   getMyInvitedEvent();
        // }
        Get.rawSnackbar(message: response['data']["message"]);
        getMyInvitedEvent();
        isUpdating.value = false;
      }else{
        getMyInvitedEvent();
        isUpdating.value = false;
      }
    } catch (e) {
      print(e);
    }finally{
      isUpdating.value = false;
    }
  }

}