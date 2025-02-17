import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:event_app/data/api/base_client.dart';
import 'package:event_app/data/api/end_point.dart';
import 'package:event_app/data/token_manager/const_veriable.dart';
import 'package:event_app/data/token_manager/local_storage.dart';
import 'package:event_app/res/common_widget/custom_snackbar.dart';
import 'package:event_app/view/create_event_view/view/selected_contact_screen.dart';
import 'package:event_app/view/home_view/model/category_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class CreateEventController extends GetxController{
  final TextEditingController nameController = TextEditingController();
  final TextEditingController aboutEventController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final Dio _dio = Dio();
  var searchResults = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  var imgUrl = ''.obs;
  var eventRating = 0.0.obs;
  var totalReviews = 0.obs;
  String mapImgURL = 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=${LocalStorage.getData(key: 'photo_reference')}&key=${Endpoints.mapApiKey}';

  var address = ''.obs;
  var eventType = 'PUBLIC'.obs;

  var eventSelectedDate = ''.obs;
  var eventStartTime = ''.obs;
  var eventEndTime = ''.obs;

  var selectedCatName = ''.obs;
  var selectedCatId = ''.obs;

  var categoryModel = CategoryModel().obs;
  var categoryList = <CategoryList>[].obs;
  var selectedCatIndex = 0.obs;
  void updateSelectedCatIndex(String value) {
    selectedCatName.value = value;
  }


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    // fetchPlaceDetails();
    fetchPlacePhoto();
    getCategories();
  }


  // This method is used to fetch places from Google Places API
  Future<void> searchPlaces(String query) async {
    if (query.isEmpty) {
      searchResults.clear();
      return;
    }

    isLoading.value = true;

    try {
      final response = await _dio.get(
        'https://maps.googleapis.com/maps/api/place/textsearch/json',
        queryParameters: {
          'query': query,
          'key': Endpoints.mapApiKey,
        },
      );

      print('response ====> $response');

      if (response.statusCode == 200) {
        final results = response.data['results'];
        searchResults.value = List<Map<String, dynamic>>.from(results);
        debugPrint(searchResults.toString());
      } else {
        Get.snackbar('Error', 'Failed to fetch places');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch places');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchPlacePhoto() async {
    try{
      var photoReference = LocalStorage.getData(key: 'photo_reference');
      final photoUrl = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=$photoReference&key=${Endpoints.mapApiKey}";

      final response = await http.get(Uri.parse(photoUrl));

      if (response.statusCode == 200) {
        imgUrl.value = photoUrl;
      } else {
        throw Exception('Failed to load photo');
      }

    }catch(e){
      print(e.toString());
    }
  }


  Future<void> fetchPlaceDetails(String placeId) async {
    // Use the Place Details API to get specific details about the place
    // var placeId = LocalStorage.getData(key: 'place_id');
    final detailsUrl =
        'https://maps.googleapis.com/maps/api/place/details/json?placeid=$placeId&key=${Endpoints.mapApiKey}';

    final detailsResponse = await http.get(Uri.parse(detailsUrl));

    print("detailsUrl 2 ====> $detailsUrl");

    if (detailsResponse.statusCode == 200) {
      final detailsBody = json.decode(detailsResponse.body);

      // Extract place details
      final placeDetail = detailsBody['result'];
      print('Place Name: ${placeDetail['name']}');
      print('Address: ${placeDetail['formatted_address']}');
      print('Rating: ${placeDetail['rating']}');
      print('User Ratings Total: ${placeDetail['user_ratings_total']}');

      var formattedAddress = placeDetail['formatted_address'];
      // var rating = placeDetail['rating'];
      // var reviews = placeDetail['user_ratings_total'] ?? 0;

      // Ensure the rating is treated as a double
      var rating = placeDetail['rating'] is int
          ? (placeDetail['rating'] as int).toDouble()
          : placeDetail['rating'];

      // Ensure reviews is treated as an int
      var reviews = placeDetail['user_ratings_total'] ?? 0;

      eventRating.value = rating;
      totalReviews.value = reviews;
      address.value = formattedAddress;
    } else {
      print("Failed to fetch place details. Status code: ${detailsResponse.statusCode}");
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




// Function to create an event by search with image upload using MultipartRequest
  Future<void> createEventBySearch(String imgURL) async {
      // Set loading state using GetX
    if(
    nameController.text.toString().isEmpty
        || address.value == '' || eventType.value == '' || eventSelectedDate.value == '' ||
        aboutEventController.text.toString().isEmpty || eventRating.value == '' || totalReviews.value==''
    || eventStartTime.value == '' || eventEndTime.value == ''
    ){
      Get.rawSnackbar(message: 'Something missing...');
    }else {
      isLoading.value = true;
      try {
        String token = LocalStorage.getData(key: "access_token");
        double latitude = LocalStorage.getData(key: "latitude");
        double longitude = LocalStorage.getData(key: "longitude");

        // Prepare headers with authorization token
        Map<String, String> headers = {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        };

        // Prepare the Uri for your API (replace with your actual API endpoint)
        Uri uri = Uri.parse(Endpoints.createEventURL);

        // if is empty img path
        print('Selected img method ');
        print('getImgeByClass == > ${imgURL}');
        print('getImgeByController == > ${imgUrl.value}');
        Map<String, dynamic> data = {
          "name": nameController.text.toString().trim(),
          "categoryId": selectedCatId.value,
          "address": address.value,
          "type": eventType.value,
          "date": eventSelectedDate.value,
          "startTime": eventStartTime.value,
          "endTime": eventEndTime.value,
          "aboutEvent": aboutEventController.text.toString().trim(),
          "latitude": latitude.toString(),
          "longitude": longitude.toString(),
          "rating": eventRating.value,
          "reviews": totalReviews.value,
          if(imgURL.isNotEmpty) "image": imgURL
        };


        var request = http.MultipartRequest('POST', uri)
          ..headers.addAll(headers)
          ..fields['data'] = jsonEncode(data);

        // Add image to form data
        if(imgUrl.isNotEmpty){
          if (imgUrl.value.isNotEmpty) {
            var file = File(imgUrl.value);

            if (await file.exists()) {
              // Attach image as MultipartFile
              String fileName = basename(file.path); // Extract file name
              request.files.add(await http.MultipartFile.fromPath(
                'image',    // This is the key the server expects for the image
                file.path,
                filename: fileName,
              ));
            } else {
              Get.rawSnackbar(message: 'Image file not found');
              isLoading.value = false;
              return;
            }
          } else {
            Get.rawSnackbar(message: 'Please select an image.');
            isLoading.value = false;
            return;
          }
        }

        // Send the request
        http.StreamedResponse response = await request.send();
        print("Request fields: ${request.fields}");
        print("imgURL ====> $imgURL");
        print('api ====> ${Endpoints.createEventURL}');

        print("response.statusCode ====> ${response.statusCode}");
        // Check the response status
        if (response.statusCode == 201) {
          // Handle the successful response
          print('Event created successfully');
          CustomSnackbar(message: 'Event created successfully',);
          var responseBody = await response.stream.bytesToString();
          print('Response body: $responseBody');

          // Parse the response body into a Map
          var parsedResponse = jsonDecode(responseBody);

          print('event_id ====> ${parsedResponse['data']['id']}');

          var eventId = parsedResponse['data']['id'];
          LocalStorage.saveData(key: eventIdForInviteEvent, data: eventId);
          Get.to(
                () => SelectedContactScreen(),
            transition: Transition.rightToLeft,
            duration: const Duration(milliseconds: 300),
          );

          clearData(latitude, longitude, imgUrl.value);
          isLoading.value = false;
        } else {
          print('Failed to create event');
          String responseBody = await response.stream.bytesToString();
          print('Failed to create event. Status code: ${response.statusCode}');
          print('Response body: $responseBody');
          CustomSnackbar(message: 'Failed to create event',);
          isLoading.value = false;
        }
      } catch (e) {
        print('Error creating event from search: $e');
      } finally {
        isLoading.value = false;  // Reset loading state
      }

    }




  }

  // Function to pick image
  Future<void> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      imgUrl.value = pickedFile.path;
    } else {
      print("No image selected");
    }
  }

  void clearData (latitude, longitude, imgURL) {
    nameController.text = "";
    selectedCatId.value = "";
    address.value = "";
    eventType.value = "";
    eventSelectedDate.value = "";
    eventStartTime.value = "";
    eventEndTime.value = "";
    aboutEventController.text = "";
    latitude = "";
    longitude = "";
    imgURL = "";
  }

}