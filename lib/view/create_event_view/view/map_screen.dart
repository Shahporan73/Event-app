import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart'; // For reverse geocoding

class MapScreen extends StatefulWidget {
  final double latitude;
  final double longitude;

  const MapScreen({super.key, required this.latitude, required this.longitude});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();

  Set<Marker> _markers = {};
  String _address = "fetching_address".tr;

  @override
  void initState() {
    super.initState();
    _initializeMarkerAndAddress();
  }

  Future<void> _initializeMarkerAndAddress() async {
    // Reverse geocode to get the address
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(widget.latitude, widget.longitude);
      Placemark place = placemarks.first;
      setState(() {
        _address = "${place.name}, ${place.locality}, ${place.country}";
      });
    } catch (e) {
      setState(() {
        _address = "unable_to_fetch_address".tr;
      });
    }

    // Add marker for the location
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId("current_location"),
          position: LatLng(widget.latitude, widget.longitude),
          infoWindow: InfoWindow(title: "your_location".tr, snippet: _address),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(widget.latitude, widget.longitude),
              zoom: 14.0,
            ),
            markers: _markers,
            onMapCreated: (controller) {
              _controller.complete(controller);
            },
          ),
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back, color: Colors.black),
            ),
          ),
          Positioned(
            top: 80,
            left: 16,
            right: 16,
            child: Container(
              padding: EdgeInsets.all(12),
              color: Colors.white,
              child: Text(
                _address,
                style: TextStyle(fontSize: 16),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
