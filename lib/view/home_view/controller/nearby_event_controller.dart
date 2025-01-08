import 'dart:convert';

import 'package:event_app/data/api/base_client.dart';
import 'package:event_app/data/api/end_point.dart';
import 'package:event_app/data/token_manager/const_veriable.dart';
import 'package:event_app/data/token_manager/local_storage.dart';
import 'package:event_app/view/home_view/model/nearest_event_model.dart';
import 'package:get/get.dart';

class NearbyEventController extends GetxController{
  var isLoading = false.obs;
  var nearbyEventModel = NearestEventModel().obs;
  var nearbyEventList = <NearbyEventList>[].obs;


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getNearbyEvents();
  }
  Future<void>  getNearbyEvents() async{
    isLoading.value = true;
    String latitude = LocalStorage.getData(key: nearbyLatitude);
    String longitude = LocalStorage.getData(key: nearbyLongitude);
    try{
      String token = LocalStorage.getData(key: "access_token");
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      dynamic responseBody = await BaseClient.handleResponse(
        await BaseClient.getRequest(
          api: Endpoints.nearestEventsURL(latitude: latitude.toString(), longitude: longitude.toString()),
          headers: headers,
        ),
      );

      print('hit api ${Endpoints.nearestEventsURL(latitude: latitude.toString(), longitude: longitude.toString())}');
      print("responseBody ====> $responseBody");

      if (responseBody != null) {
        print(responseBody);
        nearbyEventList.clear();
        nearbyEventModel.value = NearestEventModel.fromJson(responseBody);
        nearbyEventList.assignAll(nearbyEventModel.value.data ?? []);
        return responseBody;
      }

    }catch(e){
      print(e);
    }finally{
      isLoading.value = false;
    }
  }
}