// ignore_for_file: prefer_const_constructors

import 'package:event_app/view/create_event_view/view/created_event_by_pin_screen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_place_plus/google_place_plus.dart';

class PinController extends GetxController {
  var isLoading = false.obs;

  /// ✅ Step 1: Get Current Location (Latitude & Longitude)
  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception("❌ Location services are disabled.");
    }

    // Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("❌ Location permissions are denied.");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception("❌ Location permissions are permanently denied.");
    }

    // ✅ Get the current position (Latitude & Longitude)
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  /// ✅ Step 2: Get Address from Latitude & Longitude
  Future<Map<String, String?>> fetchCurrentLocationDetails(GooglePlace googlePlace) async {
    isLoading.value = true;
    try {
      // ✅ Get the current location (Lat, Lng)
      Position position = await _getCurrentLocation();
      print("📍 Current Location: Lat=${position.latitude}, Lng=${position.longitude}");

      // ✅ Use Google Places API to get the address
      final result = await googlePlace.search.getNearBySearch(
        Location(lat: position.latitude, lng: position.longitude),
        200, // Increased search radius
      );

      if (result == null || result.results == null || result.results!.isEmpty) {
        print("⚠️ No nearby places found.");
        return {
          'latitude': position.latitude.toString(),
          'longitude': position.longitude.toString(),
          'address': "No address found",
          'placeName': "Unknown",
          'rating': "0.0",
          'reviews': "0",
        };
      }

      // ✅ Get the closest place details
      final place = result.results!.first;
      print("✅ Found Place: ${place.name} at ${place.vicinity}");

      return {
        'latitude': position.latitude.toString(),
        'longitude': position.longitude.toString(),
        'address': place.vicinity ?? "Unknown Address",
        'placeName': place.name ?? "Unknown Place",
        'rating': place.rating?.toString() ?? "0.0",
        'reviews': place.userRatingsTotal?.toString() ?? "0",
      };
    } catch (e) {
      print("❌ Error fetching location details: $e");
      return {
        'latitude': "N/A",
        'longitude': "N/A",
        'address': "Error retrieving address",
        'placeName': "Unknown",
        'rating': "0.0",
        'reviews': "0",
      };
    } finally {
      isLoading.value = false;
    }
  }

  /// ✅ Step 3: Show Location Dialog & Navigate to Create Event Screen
  Future<void> showLocationDialog(BuildContext context, GooglePlace googlePlace) async {
    isLoading.value = true;
    try {
      // ✅ Fetch current location details
      Map<String, String?> locationDetails = await fetchCurrentLocationDetails(googlePlace);

      // ✅ Show the location in a dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Your Current Location",style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600
            ),),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Latitude: ${locationDetails['latitude']}"),
                Text("Longitude: ${locationDetails['longitude']}"),
                Text("Address: ${locationDetails['address']}"),
                Text("Place Name: ${locationDetails['placeName']}"),
                Text("Rating: ${locationDetails['rating']}"),
                Text("Total Reviews: ${locationDetails['reviews']}"),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel", style: TextStyle(color: Colors.black)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: () {
                  Navigator.pop(context);
                  Get.to(() => CreatedEventByPinScreen(
                    latitude: locationDetails['latitude'].toString(),
                    longitude: locationDetails['longitude'].toString(),
                    rating: double.parse(locationDetails['rating'].toString()),
                    reviews: int.parse(locationDetails['reviews'].toString()),
                    address: '${locationDetails['placeName']}, ${locationDetails['address']}',
                  ));
                },
                child: Text("Create Event", style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print("❌ Error: $e");
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("❌ Error"),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    } finally {
      isLoading.value = false;
    }
  }
}
