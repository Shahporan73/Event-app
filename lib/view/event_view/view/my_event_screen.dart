// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:event_app/res/common_widget/custom_app_bar.dart';
import 'package:event_app/res/common_widget/custom_network_image_widget.dart';
import 'package:event_app/res/custom_style/custom_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';

import '../../../res/app_colors/App_Colors.dart';
import '../../home_view/view/event_details_screen.dart';
import 'my_event_details_screen.dart';

class MyEventScreen extends StatelessWidget {
  const MyEventScreen({super.key});

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
                  appBarName: "My Event",
                  widget: SizedBox(),
                ),

                heightBox20,
                ListView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Get.to(
                              () => MyEventDetailsScreen(),
                          transition: Transition.leftToRight,
                          duration: Duration(milliseconds: 300),
                        );
                      },
                      child: Stack(
                        children: [
                          Container(
                            height: height * 0.30,
                            margin: EdgeInsets.only(bottom: height * 0.015),
                            padding: EdgeInsets.all(width * 0.025),
                            width: width,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.4),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: Offset(0, 0),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: CustomNetworkImage(
                                    imageUrl: 'https://mlscottsdale.com/get/files/image/galleries/Dining_Room_AZ_Shelby_Moore.jpg',
                                    height: height * 0.190,
                                    width: width * 0.90,
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "EL Tapatio Mexican Restaurant",
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: width * 0.04,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    '4.8',
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.orange,
                                                      fontSize: width * 0.03,
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  ),
                                                  RatingBarIndicator(
                                                    rating: 2.75,
                                                    itemBuilder: (context, index) => Icon(
                                                      Icons.star,
                                                      color: Colors.amber,
                                                    ),
                                                    itemCount: 5,
                                                    itemSize: width * 0.035,
                                                    direction: Axis.horizontal,
                                                  ),
                                                  SizedBox(width: width * 0.02),
                                                  Text(
                                                    "(255)",
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.black,
                                                      fontSize: width * 0.03,
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: height * 0.005),
                                              Row(
                                                children: [
                                                  Icon(Icons.calendar_today, color: Colors.black, size: width * 0.035),
                                                  SizedBox(width: width * 0.02),
                                                  Text(
                                                    '19 July 2021',
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.black,
                                                      fontSize: width * 0.03,
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(Icons.location_on, color: Colors.black, size: width * 0.035),
                                                  SizedBox(width: width * 0.015),
                                                  Text(
                                                    "New York, USA",
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.black,
                                                      fontSize: width * 0.03,
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: height * 0.005),
                                              Row(
                                                children: [
                                                  Icon(Icons.access_time, color: Colors.black, size: width * 0.035),
                                                  SizedBox(width: width * 0.02),
                                                  Text(
                                                    '21:00-23:00',
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.black,
                                                      fontSize: width * 0.03,
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // share button
                          Positioned(
                            top: width * 0.05,
                            right: width * 0.05,
                            child: GestureDetector(
                              onTap: () {
                                Share.share('https://example.com');
                              },
                              child: Container(
                                padding: EdgeInsets.all(width * 0.015),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.share, color: Colors.black),
                              ),
                            ),
                          ),
                        ],
                      ),
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
