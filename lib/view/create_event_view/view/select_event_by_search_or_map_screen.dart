// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'dart:async';
import 'dart:convert';

import 'package:event_app/data/token_manager/local_storage.dart';
import 'package:event_app/res/app_colors/App_Colors.dart';
import 'package:event_app/res/app_images/App_images.dart';
import 'package:event_app/res/common_widget/RoundButton.dart';
import 'package:event_app/res/common_widget/RoundTextField.dart';
import 'package:event_app/res/common_widget/custom_app_bar.dart';
import 'package:event_app/res/common_widget/custom_text.dart';
import 'package:event_app/res/custom_style/custom_size.dart';
import 'package:event_app/view/create_event_view/controller/create_event_by_map_controller.dart';
import 'package:event_app/view/create_event_view/controller/create_event_controller.dart';
import 'package:event_app/view/create_event_view/view/create_event_by_search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import '../../../data/api/end_point.dart';
import '../../../res/common_widget/responsive_helper.dart';
import 'create_event_by_map_screen.dart';

class SelectEventBySearchOrMapScreen extends StatefulWidget {
  const SelectEventBySearchOrMapScreen({super.key});

  @override
  State<SelectEventBySearchOrMapScreen> createState() => _SelectEventBySearchOrMapScreenState();
}

class _SelectEventBySearchOrMapScreenState extends State<SelectEventBySearchOrMapScreen> {


  final Completer<GoogleMapController> _controller = Completer();
  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(23.8103, 90.4125), // Default coordinates for Dhaka
    zoom: 15.0,
  );

  Set<Marker> _markers = {};
  String _address = "";
  String _coordinates = "";
  String placeId = "";
  double rating = 0.0;
  String name = "";
  int totalReviews = 0;

  @override
  void initState() {
    super.initState();
  }

// Fetch address and placeId from coordinates using Reverse Geocoding API
  Future<void> _getAddressFromLatLng(LatLng latLng) async {
    try {
      final reverseGeocodeUrl =
          'https://maps.googleapis.com/maps/api/geocode/json?latlng=${latLng.latitude},${latLng.longitude}&key=${Endpoints.mapApiKey}';

      final response = await http.get(Uri.parse(reverseGeocodeUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['results'] != null && data['results'].isNotEmpty) {
          final result = data['results'][0];
          setState(() {
            placeId = result['place_id'] ?? "";
            _address = result['formatted_address'] ?? "Address not found";
            _coordinates ="Latitude: ${latLng.latitude}, Longitude: ${latLng.longitude}";
            LocalStorage.saveData(key: 'map_latitude', data: latLng.latitude.toString());
            LocalStorage.saveData(key: 'map_longitude', data: latLng.longitude.toString());
          });
          print("Place ID: $placeId");
          print("Address: $_address");
        } else {
          throw Exception("No results found for the location.");
        }
      } else {
        throw Exception("Failed to fetch place ID. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error getting place ID: $e");
      setState(() {
        _address = "Address not found";
      });
    }
  }

  // Fetch detailed information about a place using its placeId
  Future<void> fetchPlaceDetails() async {
    if (placeId.isEmpty) {
      print("Place ID is empty. Cannot fetch details.");
      return;
    }

    final detailsUrl =
        'https://maps.googleapis.com/maps/api/place/details/json?placeid=$placeId&key=${Endpoints.mapApiKey}';

    print("detailsUrl ====> $detailsUrl");
    final response = await http.get(Uri.parse(detailsUrl));

    if (response.statusCode == 200) {
      final detailsBody = json.decode(response.body);

      final placeDetail = detailsBody['result'];
      print('Place Name: ${placeDetail['name']}');
      print('Address: ${placeDetail['formatted_address']}');
      print('Rating: ${placeDetail['rating']}');

      final fetchedRating = placeDetail['rating'] ?? 0.0;
      final reviews = placeDetail['reviews'] ?? [];
      final reviewCount = reviews.length;

      setState(() {
        name = placeDetail['name'] ?? "Not found";
        rating = fetchedRating ;
        totalReviews = reviewCount;
      });

      print("Rating >> $rating");
      print("Total Reviews >> $totalReviews");
    } else {
      print("Failed to fetch place details. Status code: ${response.statusCode}");
    }
  }


  final CreateEventController controller = Get.put(CreateEventController());
  final CreateEventByMapController CreateEventByMapcontroller = Get.put(CreateEventByMapController());

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAppBar(
                  appBarName: "Create Event",
                  onTap: () {
                    Get.back();
                  },
                ),
                
                heightBox40,
                
                Roundbutton(
                    title: "",
                    widget: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(AppImages.pinLocationIcon, scale: 4,),
                        widthBox10,
                        CustomText(
                            title: 'Create on pin',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        )
                      ],
                    ),
                    onTap: () {},
                ),
                
                heightBox20,
                // Search TextField
                RoundTextField(
                  hint: "Search Places",
                  readOnly: false,
                  prefixIcon: Icon(
                    Icons.search_outlined,
                    size: 26.sp,
                  ),
                  onTap: () {},
                  onChanged: (query) {
                    controller.searchPlaces(query);
                  },
                  borderRadius: 44.r,
                  focusBorderRadius: 44.r,
                ),


                // Loading indicator
                Obx(() {
                  if (controller.isLoading.value) {
                    return Center(
                      child: SpinKitCircle(
                        color: AppColors.primaryColor,
                      ),
                    );
                  } else if (controller.searchResults.isEmpty) {
                    return SizedBox();
                  } else {
                    return Container(
                      height: 250,
                      width: width,
                      child: ListView.builder(
                        itemCount: controller.searchResults.length,
                        itemBuilder: (context, index) {
                          var place = controller.searchResults[index];
                          var latitude = place['geometry']['location']['lat'];
                          var longitude = place['geometry']['location']['lng'];
                          LocalStorage.saveData(key: 'latitude', data: latitude);
                          LocalStorage.saveData(key: 'longitude', data: longitude);
                          /*print('latitude : ${place['geometry']['location']['lat']}');
                          print('longitude : ${place['geometry']['location']['lng']}');
                          print('address : ${place['formatted_address']}');
                          print('imgURL : ${place['icon']}');
                          print('place id : ${place['place_id']}');*/
                          // print('photo reference : ${place['photos'][0]['photo_reference']}');
                          return ListTile(
                            title: Text(place['name']),
                            subtitle: Text(place['formatted_address'] ?? 'No address available'),
                            onTap: () {
                              /*print('latitude : ${place['geometry']['location']['lat']}');
                              print('longitude : ${place['geometry']['location']['lng']}');
                              print('address : ${place['formatted_address']}');
                              print('imgURL : ${place['icon']}');
                              print('place id : ${place['place_id']}');
                              print('name : ${place['name']}');*/
                              LocalStorage.saveData(key: 'place_id', data: place['place_id']);
                              LocalStorage.saveData(key: 'photo_reference', data: place['photos'][0]['photo_reference']);
                              LocalStorage.saveData(key: 'search_address', data: place['formatted_address']);
                              LocalStorage.saveData(key: 'search_name', data: place['name']);
                              Get.to(
                                      ()=>CreateEventBySearchScreen(
                                        latitude: latitude,
                                        longitude: longitude,
                                        placeId: place['place_id'],
                                ),
                                duration: Duration(milliseconds: 300),
                                transition: Transition.rightToLeft
                              );
                            },
                          );
                        },
                      ),
                    );
                  }
                }),



                heightBox20,
                Container(
                  width: width,
                  height: ResponsiveHelper.h(context, 350),
                  //for initial map
                  child: GoogleMap(
                    initialCameraPosition: _initialCameraPosition,
                    markers: _markers,
                    onMapCreated: (controller) {
                      _controller.complete(controller);
                    },
                    zoomControlsEnabled: true,
                    onTap: (LatLng latLng) {
                      // When user taps on the map
                      _getAddressFromLatLng(latLng);

                      // Add a marker at the tapped location
                      setState(() {
                        _markers.clear();
                        _markers.add(
                          Marker(
                            markerId: MarkerId(latLng.toString()),
                            position: latLng,
                            infoWindow: InfoWindow(
                              title: "Selected Location",
                              snippet: _address,
                            ),
                            icon: BitmapDescriptor.defaultMarker,
                          ),
                        );
                      });

                      // Fetch place details after tapping
                      fetchPlaceDetails();
                    },
                  )),
                heightBox5,
                CustomText(
                  title: 'Address : $_address',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
                CustomText(
                  title: 'Place name : $name',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
                /*SizedBox(height: 10),
                Text(
                  _coordinates,
                  style: TextStyle(fontSize: 14),
                ),*/
                Text(
                  "Rating: ${rating.toStringAsFixed(1)}",
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  "Total Reviews: $totalReviews",
                  style: TextStyle(fontSize: 14),
                ),


                heightBox20,
                Roundbutton(
                    title: "Continue",
                    onTap: () {
                      print("latitude : ${LocalStorage.getData(key: 'map_latitude')}");
                      print("longitude : ${LocalStorage.getData(key: 'map_longitude')}");
                      CreateEventByMapcontroller.address.value = _address;
                      CreateEventByMapcontroller.rating.value = rating;
                      CreateEventByMapcontroller.totalReviews.value = totalReviews;

                      print("address : ${CreateEventByMapcontroller.address.value}");
                      print("rating : ${CreateEventByMapcontroller.rating.value}");
                      print("total reviews : ${CreateEventByMapcontroller.totalReviews.value}");
                      Get.to(
                          () => CreateEventByMapScreen(),
                          transition: Transition.downToUp,
                          duration: Duration(milliseconds: 300),
                      );
                    },
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

}
