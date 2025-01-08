import 'dart:convert';

import 'package:event_app/data/api/base_client.dart';
import 'package:event_app/data/api/end_point.dart';
import 'package:event_app/data/token_manager/local_storage.dart';
import 'package:event_app/view/home_view/model/all_event_model.dart';
import 'package:event_app/view/home_view/model/category_model.dart';
import 'package:event_app/view/home_view/model/map_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class EventsController extends GetxController{
  final TextEditingController searchController = TextEditingController();
  final TextEditingController searchMyEventController = TextEditingController();
  var isLoading = false.obs;
  var allEventModel = AllEventsModel().obs;
  var eventList = <EventsList>[].obs;
  var myEventList = <EventsList>[].obs;

  var catEventList = <EventsList>[].obs;

  // map
  var mapModel = MapsModel().obs;
  var placeDetails = <MapResult>{}.obs;

  // for category
  var categoryModel = CategoryModel().obs;
  var categoryList = <CategoryList>[].obs;
  var catId = ''.obs;
  var selectedCatIndex = (-1).obs;
  void updateCat (int index){
    selectedCatIndex.value = index;
    catId.value = categoryList[index].id!;  // Update the selected category ID
    getSelectedCatEvents();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getAllEvents();
    // getPlaceDetails(23.750285, 90.423296);
    getMyEvents();

    getCategories();
    getSelectedCatEvents();
  }

  Future<void> getCategories() async {
    try {
      isLoading.value = true;

      String token = LocalStorage.getData(key: "access_token");

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      dynamic responseBody = await BaseClient.handleResponse(
        await BaseClient.getRequest(
          api: Endpoints.categoriesURL,
          headers: headers,
        ),
      );

      print('hit api ${Endpoints.categoriesURL}');
      print("responseBody ====> $responseBody");

      if(responseBody != null){
        categoryList.clear();
        categoryModel.value = CategoryModel.fromJson(responseBody);
        categoryList.assignAll(categoryModel.value.data!);
      }

    }catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getAllEvents() async {
    try {
      isLoading.value = true;

      String token = LocalStorage.getData(key: "access_token");

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      dynamic responseBody = await BaseClient.handleResponse(
        await BaseClient.getRequest(
          api: Endpoints.allEventsURL,
          headers: headers,
        ),
      );

      print('hit api ${Endpoints.allEventsURL}');
      print("responseBody ====> $responseBody");

      if(responseBody != null){
        eventList.clear();
        allEventModel.value = AllEventsModel.fromJson(responseBody);
        eventList.assignAll(allEventModel.value.data?.data ?? []);
      }

    }catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
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
          api: Endpoints.myEventsURL,
          headers: headers,
        ),
      );

      print('hit api ${Endpoints.myEventsURL}');
      print("responseBody ====> $responseBody");

      if(responseBody != null){
        myEventList.clear();
        allEventModel.value = AllEventsModel.fromJson(responseBody);
        myEventList.assignAll(allEventModel.value.data?.data ?? []);
      }
    }catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getSelectedCatEvents() async {
    isLoading.value = true;
    try {
      String token = LocalStorage.getData(key: "access_token");

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      dynamic responseBody = await BaseClient.handleResponse(
        await BaseClient.getRequest(
          api: Endpoints.catEventsURL(categoryId: catId.value),
          headers: headers,
        ),
      );

      print('hit api ${Endpoints.myEventsURL}');
      print("responseBody ====> $responseBody");

      if(responseBody != null){
        eventList.clear();
        allEventModel.value = AllEventsModel.fromJson(responseBody);
        eventList.assignAll(allEventModel.value.data?.data ?? []);
      }
    }catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> searchEvent() async {
    isLoading.value = true;
    try {
      String token = LocalStorage.getData(key: "access_token");

      String searchTerm = Uri.encodeComponent(searchController.text.trim());

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      dynamic responseBody = await BaseClient.handleResponse(
        await BaseClient.getRequest(
          api: Endpoints.searchEventsURL(searchTerm: searchTerm),
          headers: headers,
        ),
      );
      // print("responseBody ====> $responseBody");

      if(responseBody != null){
        eventList.clear();
        allEventModel.value = AllEventsModel.fromJson(responseBody);
        eventList.assignAll(allEventModel.value.data?.data ?? []);
      }else{
        Get.rawSnackbar(message: "No events found", snackPosition: SnackPosition.BOTTOM);
      }

    }catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> searchMyEvent() async {
    isLoading.value = true;
    try {
      String token = LocalStorage.getData(key: "access_token");

      String searchTerm = Uri.encodeComponent(searchMyEventController.text.trim());

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      dynamic responseBody = await BaseClient.handleResponse(
        await BaseClient.getRequest(
          api: Endpoints.searchMyEventsURL(searchTerm: searchTerm),
          headers: headers,
        ),
      );
      // print("responseBody ====> $responseBody");

      if(responseBody != null){
        myEventList.clear();
        allEventModel.value = AllEventsModel.fromJson(responseBody);
        myEventList.assignAll(allEventModel.value.data?.data ?? []);
      }else{
        Get.rawSnackbar(message: "No events found", snackPosition: SnackPosition.BOTTOM);
      }

    }catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }



  Future<void> deleteEvent(String eventId) async {
    isLoading.value = true;
    try {
      String token = LocalStorage.getData(key: "access_token");
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      dynamic responseBody = await BaseClient.handleResponse(
        await BaseClient.deleteRequest(
          api: Endpoints.deleteEventURL(eventId: eventId),
          headers: headers,
        ),
      );

      print('hit api ${Endpoints.deleteEventURL(eventId: eventId)}');
      print("responseBody ====> $responseBody");
      if(responseBody != null){
        Get.rawSnackbar(message: "Event deleted successfully", backgroundColor: Colors.red, snackPosition: SnackPosition.BOTTOM);
        getMyEvents();
      }else{
        Get.rawSnackbar(message: "No events found", snackPosition: SnackPosition.BOTTOM);
      }
    }catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  // Future<void> getPlaceDetails(double latitude, double longitude) async {
  //   // Step 1: Use the Geocoding API to fetch place information based on latitude and longitude
  //   final geocodeUrl =
  //       'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=${Endpoints.mapApiKey}';
  //
  //   final geocodeResponse = await http.get(Uri.parse(geocodeUrl));
  //
  //   print("geocodeUrl ====> $geocodeUrl");
  //   if (geocodeResponse.statusCode == 200) {
  //     final responseBody = json.decode(geocodeResponse.body);
  //
  //     // Parse the response to find the formatted address and place_id
  //     if (responseBody['results'] != null && responseBody['results'].isNotEmpty) {
  //       final firstResult = responseBody['results'][0];
  //
  //       // Get place_id from the first result
  //       final placeId = firstResult['place_id'];
  //       print('Place ID: $placeId');
  //
  //       // Step 2: Fetch detailed information using Place Details API
  //       await fetchPlaceDetails(placeId);
  //     } else {
  //       print("No place found for the given coordinates.");
  //     }
  //   } else {
  //     print("Failed to fetch place details. Status code: ${geocodeResponse.statusCode}");
  //   }
  // }
  //
  // Future<void> fetchPlaceDetails(String placeId) async {
  //   // Use the Place Details API to get specific details about the place
  //   final detailsUrl =
  //       'https://maps.googleapis.com/maps/api/place/details/json?placeid=$placeId&key=${Endpoints.mapApiKey}';
  //
  //   final detailsResponse = await http.get(Uri.parse(detailsUrl));
  //
  //   print("detailsUrl ====> $detailsUrl");
  //
  //   if (detailsResponse.statusCode == 200) {
  //     final detailsBody = json.decode(detailsResponse.body);
  //
  //     // Extract place details
  //     final placeDetail = detailsBody['result'];
  //     print('Place Name: ${placeDetail['name']}');
  //     print('Address: ${placeDetail['formatted_address']}');
  //     print('Rating: ${placeDetail['rating']}');
  //   } else {
  //     print("Failed to fetch place details. Status code: ${detailsResponse.statusCode}");
  //   }
  // }

}