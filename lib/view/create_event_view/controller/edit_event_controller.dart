import 'dart:convert';
import 'dart:io';

import 'package:event_app/data/api/base_client.dart';
import 'package:event_app/data/api/end_point.dart';
import 'package:event_app/data/token_manager/const_veriable.dart';
import 'package:event_app/data/token_manager/local_storage.dart';
import 'package:event_app/view/home_view/model/category_model.dart';
import 'package:event_app/view/home_view/model/get_event_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class EditEventController extends GetxController{
  var isLoading = false.obs;
  final TextEditingController eventNameController = TextEditingController();
  Rx<TextEditingController> eventAddressController = TextEditingController().obs;
  final TextEditingController eventAboutController = TextEditingController();
  var imgUrl = ''.obs;
  var address = ''.obs;
  var eventType = ''.obs;

  var eventSelectedDate = ''.obs;
  var eventStartTime = ''.obs;
  var eventEndTime = ''.obs;

  var getEventSelectedDate = ''.obs;
  var getEeventStartTime = ''.obs;
  var getEeventEndTime = ''.obs;

  var selectedCatName = ''.obs;
  var selectedCatId = ''.obs;

  var categoryModel = CategoryModel().obs;
  var categoryList = <CategoryList>[].obs;
  var selectedCatIndex = 0.obs;
  void updateSelectedCatIndex(String value) {
    selectedCatName.value = value;
  }

  var eventModel = GetEventModel().obs;


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getCategories();
    loadEditEventData();
  }

  Future<void> loadEditEventData() async {
    isLoading.value = true;
    try {
      String token = LocalStorage.getData(key: "access_token");
      String eventId = LocalStorage.getData(key: editEventId);
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
        imgUrl.value = eventModel.value.data!.image!;
        eventNameController.text = eventModel.value.data!.name!;
        eventAboutController.text = eventModel.value.data!.aboutEvent!;
        eventAddressController.value.text = eventModel.value.data!.address!;
        address.value = eventModel.value.data!.address!;
        eventType.value = eventModel.value.data!.type!;
        eventSelectedDate.value = eventModel.value.data!.date.toString();
        eventStartTime.value = eventModel.value.data!.startTime.toString();
        eventEndTime.value = eventModel.value.data!.endTime.toString();
        selectedCatName.value = eventModel.value.data!.category!.name!;
        selectedCatId.value = eventModel.value.data!.category!.id!;
        selectedCatIndex.value = categoryList.indexWhere((element) => element.id == selectedCatId.value);
      }
    } finally {
      isLoading.value = false;
    }
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


  Future<void> uploadImage(File imageFile) async {
    isLoading.value = true;
    try {
      String token = LocalStorage.getData(key: "access_token");

      // Prepare headers
      Map<String, String> headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'multipart/form-data',
      };

      // Prepare request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(Endpoints.uploadImageURL),
      );
      request.headers.addAll(headers);

      // Attach the image file
      request.files.add(
        await http.MultipartFile.fromPath(
          'files',
          imageFile.path
        ),
      );

      // Send the request
      var streamedResponse = await request.send();

      // Get response
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        print("Image uploaded successfully: $responseData");
        var imageUrl = responseData['data'][0]['url'];
        imgUrl.value = imageUrl;
      } else {
        print("Image upload failed: ${response.statusCode} ${response.body}");
      }
    } catch (e) {
      print("Error uploading image: $e");
    } finally {
      isLoading.value = false;
    }
  }



  Future<void> updateEvent(BuildContext context) async {
    isLoading.value = true;
    try {
      String token = LocalStorage.getData(key: "access_token");
      String eventId = LocalStorage.getData(key: editEventId);
      // Map<String, String> headers = {
      //   'Content-Type': 'application/json',
      //   'Authorization': 'Bearer $token',
      // };

      Map<String, String> body = {
        "category": selectedCatId.value,
        "name": eventNameController.text,
        "address": eventAddressController.value.text,
        "type": eventType.value,
        "date": eventSelectedDate.value,
        "startTime": eventStartTime.value,
        "endTime": eventEndTime.value,
        "aboutEvent": eventAboutController.text,
        "image": imgUrl.value
      };
      dynamic responseBody = await BaseClient.handleResponse(
        await BaseClient.patchRequest(
          api: Endpoints.updateEventURL(eventId: eventId),
          body: jsonEncode(body),
        ),
      );

      print('hit api ${Endpoints.updateEventURL(eventId: eventId)}');
      if(responseBody != null){
        print("responseBody ====> $responseBody");
        Get.rawSnackbar(message: "Event updated successfully",
            backgroundColor: Colors.green,
            snackPosition: SnackPosition.BOTTOM
        );
        Navigator.pop(context);
        LocalStorage.removeData(key: editEventId);
      }

    }catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }


  // Function to pick an image
  Future<void> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      await uploadImage(File(pickedFile.path));
      // imgUrl.value = pickedFile.path;
    } else {
      print("No image selected");
    }
  }
}