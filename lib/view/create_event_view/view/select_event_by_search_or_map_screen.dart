// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'dart:async';

import 'package:event_app/res/app_colors/App_Colors.dart';
import 'package:event_app/res/app_images/App_images.dart';
import 'package:event_app/res/common_widget/RoundButton.dart';
import 'package:event_app/res/common_widget/RoundTextField.dart';
import 'package:event_app/res/common_widget/custom_app_bar.dart';
import 'package:event_app/res/common_widget/custom_text.dart';
import 'package:event_app/res/custom_style/custom_size.dart';
import 'package:event_app/view/create_event_view/view/create_event_by_search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../res/common_widget/responsive_helper.dart';
import 'create_event_by_map_screen.dart';

class SelectEventBySearchOrMapScreen extends StatefulWidget {
  const SelectEventBySearchOrMapScreen({super.key});

  @override
  State<SelectEventBySearchOrMapScreen> createState() => _SelectEventBySearchOrMapScreenState();
}

class _SelectEventBySearchOrMapScreenState extends State<SelectEventBySearchOrMapScreen> {
  final Completer<GoogleMapController> _controller=Completer();
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(23.8103, 90.4125),
    zoom: 3.0,
  );
  Set<Marker> _marker = {};

  // Define the circle centered on the Dhaka area
  final Set<Circle> _circles = {
    Circle(
      circleId: CircleId('dhakaCircle'),
      center: LatLng(23.8103, 90.4125), // Center of the circle
      radius: 5000, // Radius in meters (5 kilometers)
      strokeColor: Colors.red, // Border color
      strokeWidth: 0, // Border width
      fillColor: Colors.red.withOpacity(0.15), // Fill color with opacity
    ),
  };
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _marker.add(
        Marker(
            markerId: MarkerId("dhaka_area_id"),
            position: LatLng(23.8103, 90.4125),
            icon: BitmapDescriptor.defaultMarker,
            infoWindow: InfoWindow(
                title: "Dhaka, Bangladesh"
            )
        )
    );
  }

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
                
                // search section
                heightBox30,
                RoundTextField(
                  hint: "Search Places",
                  readOnly: true,
                  prefixIcon: Icon(
                    Icons.search_outlined,
                    size: 26.sp,
                  ),
                  onTap: () {
                    Get.to(
                          () => CreateEventBySearchScreen(),
                      transition: Transition.fadeIn,
                      duration: Duration(milliseconds: 300),
                    );
                  },
                  borderRadius: 44.r,
                  focusBorderRadius: 44.r,
                ),



                heightBox20,

                Container(
                  width: width,
                  height: ResponsiveHelper.h(context, 300),
                  //for initial map
                  child: GoogleMap(
                    initialCameraPosition: _kGooglePlex,
                    circles: _circles,
                    markers: Set<Marker>.of(_marker),
                    onMapCreated: (controller) {
                      _controller.complete(controller);
                    },
                  ),
                ),





                heightBox50,
                Roundbutton(
                    title: "Continue",
                    onTap: () {
                      Get.to(
                          () => CreateEventByMapScreen(),
                          transition: Transition.downToUp,
                          duration: Duration(milliseconds: 300),
                      );
                    },
                )



              ],
            ),
          ),
        ),
      ),
    );
  }

}
