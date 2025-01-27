// ignore_for_file: prefer_const_constructors

import 'package:event_app/res/app_colors/App_Colors.dart';
import 'package:event_app/view/create_event_view/view/created_event_by_pin_screen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_place_plus/google_place_plus.dart';

class PinController extends GetxController{
  var isLoading = false.obs;


  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception("Location services are disabled.");
    }

    // Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("Location permissions are denied.");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          "Location permissions are permanently denied. Cannot fetch location.");
    }

    // Get the current position
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }



  Future<Map<String, String?>> fetchCurrentLocationDetails(GooglePlace googlePlace) async {
    isLoading.value = true;
    try {
      // Get the current location
      Position position = await _getCurrentLocation();

      // Use Google Places API to fetch details for the current location
      final result = await googlePlace.search.getNearBySearch(
        Location(lat: position.latitude, lng: position.longitude),
        50, // Small radius to get the closest place
      );

      if (result != null &&
          result.results != null &&
          result.results!.isNotEmpty) {
        // Get details of the closest place
        final place = result.results!.first;

        return {
          'latitude': position.latitude.toString(),
          'longitude': position.longitude.toString(),
          'address': (place.vicinity ?? "Unknown Address") +
              (place.formattedAddress != null
                  ? ", ${place.formattedAddress}"
                  : ""),
          'placeName': place.name ?? "Unknown Place",
          'rating': place.rating?.toString() ?? "0.0",
          'reviews': place.userRatingsTotal?.toString() ?? "0",
        };
      } else {
        throw Exception("No address found for the current location.");
      }
    } catch (e) {
      throw Exception("Error fetching location details: $e");
    }finally{
      isLoading.value = false;
    }
  }

  Future<void> showLocationDialog(BuildContext context, GooglePlace googlePlace) async {
    // fetchCurrentLocationDetails(googlePlace);
    isLoading.value = true;
    try {
      // Fetch location details
      Map<String, String?> locationDetails = await fetchCurrentLocationDetails(googlePlace);
      // Show the dialog with location details
      showDialog(
        context: context,
        builder: (BuildContext context) {
          print("locationDetails ====> $locationDetails");
          return AlertDialog(
            title: Text("Location Details"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*Text("Latitude: ${locationDetails['latitude']}"),
                Text("Longitude: ${locationDetails['longitude']}"),*/
                Text("Address: ${locationDetails['address']}"),
                Text("Place Name: ${locationDetails['placeName']}"),
                Text("Rating: ${locationDetails['rating']}"),
                Text("Total Reviews: ${locationDetails['reviews']}"),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
                child: Text("Cancel", style: TextStyle(color: Colors.black),),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryColor),
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  // Add additional action, e.g., navigate to another screen
                  Get.to(
                          () => CreatedEventByPinScreen(
                            latitude: locationDetails['latitude'].toString(),
                            longitude: locationDetails['longitude'].toString(),
                            rating: double.parse(locationDetails['rating'].toString()),
                            reviews: int.parse(locationDetails['reviews'].toString()),
                            address: '${locationDetails['placeName']}, ${locationDetails['address']}',
                          ),
                  );
                  /*CreateEventByMapController().createEventByPin(
                    latitude: locationDetails['latitude'].toString(),
                    longitude: locationDetails['longitude'].toString(),
                    rating: locationDetails['rating'].toString(),
                    review: locationDetails['reviews'].toString(),
                    address: '${locationDetails['placeName']} ${locationDetails['address']}',
                  )*/
                },
                child: Text("Confirm", style: TextStyle(color: Colors.white),),
              ),
            ],
          );
        },
      );
    } catch (e) {
      // Handle errors and show a message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the error dialog
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }finally{
      isLoading.value = false;
    }
  }


}
