// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:event_app/data/token_manager/const_veriable.dart';
import 'package:event_app/data/token_manager/local_storage.dart';
import 'package:event_app/res/common_widget/RoundTextField.dart';
import 'package:event_app/res/custom_style/custom_size.dart';
import 'package:event_app/res/custom_style/formate_time.dart';
import 'package:event_app/view/home_view/controller/events_controller.dart';
import 'package:event_app/view/home_view/view/event_details_screen.dart';
import 'package:event_app/view/home_view/widget/category_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../../../res/app_colors/App_Colors.dart';
import '../../../res/common_widget/custom_network_image_widget.dart';

class SearchEventScreen extends StatelessWidget {
  SearchEventScreen({super.key});
  final EventsController eventsController = Get.put(EventsController());

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Obx(
            () {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // search section
                  heightBox20,
                  RoundTextField(
                    controller: eventsController.searchController,
                    hint: "Search Places",
                    prefixIcon: Icon(
                      Icons.search_outlined,
                      size: 26,
                    ),
                    borderRadius: 44,
                    focusBorderRadius: 44,
                    onChanged: (p0) {
                      eventsController.searchEvent();
                    },
                  ),

                  // Category section
                  heightBox20,
                  SizedBox(
                    height: 65,
                    child: eventsController.categoryList.isNotEmpty
                        ? ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: eventsController.categoryList.length,
                            itemBuilder: (context, index) {
                              var catName =
                                  eventsController.categoryList[index].name;
                              var catImage =
                                  eventsController.categoryList[index].image;

                              // Check if the category is selected based on selectedCatIndex
                              return GestureDetector(
                                onTap: () {
                                  eventsController.catId.value =
                                      eventsController.categoryList[index].id!;
                                  eventsController.updateCat(
                                      index); // Update the selected category index on click
                                },
                                child: Obx(
                                  () {
                                    // This will rebuild whenever `selectedCatIndex` changes
                                    bool isSelected = eventsController
                                            .selectedCatIndex.value ==
                                        index;

                                    return Container(
                                      color: Colors.transparent,
                                      margin: EdgeInsets.only(right: 10.w),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 0),
                                      child: CategoryWidget(
                                        title: '$catName',
                                        image: '$catImage',
                                        isSelected:
                                            isSelected, // Pass the selection state to CategoryWidget
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          )
                        : Center(
                            child: Text(
                              'No category found',
                              style: GoogleFonts.poppins(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                  ),

                  // nearby place section
                  heightBox20,
                  Expanded(
                      child: RefreshIndicator(
                    color: AppColors.primaryColor,
                    onRefresh: () async {
                      await eventsController.getAllEvents();
                      eventsController.searchController.text = '';
                      eventsController.updateCat(-1);
                      eventsController.eventList.clear();
                    },
                    child: eventsController.eventList.isEmpty
                        ? Center(
                            child: Text(
                              'No events found',
                              style: GoogleFonts.poppins(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: AlwaysScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount: eventsController.eventList.length,
                            itemBuilder: (context, index) {
                              var data = eventsController.eventList[index];
                              DateTime createdAt;
                              try {
                                createdAt = DateFormat('MM/dd/yyyy')
                                    .parse(data.date.toString());
                              } catch (e) {
                                createdAt = DateTime.now();
                              }
                              String formattedDate =
                                  DateFormat('MMM d, yyyy').format(createdAt);

                              String startTime =
                                  formatTime24hr(data.startTime.toString());
                              String endTime =
                                  formatTime24hr(data.endTime.toString());

                              // double latitude = double.parse(data.eventLocation!.latitude.toString());
                              // double longitude = double.parse(data.eventLocation!.longitude.toString());

                              // double latitude = 23.750285;
                              // double longitude = 90.423296;

                              // print(
                              //   'latitude: $latitude, longitude: $longitude',
                              //   // eventsController.getPlaceRating(latitude, longitude);
                              // );
                              // print('show method ${eventsController.getPlaceRating(latitude, longitude)}');
                              return GestureDetector(
                                onTap: () {
                                  LocalStorage.saveData(
                                      key: showEventDetailsId, data: data.id);
                                  Get.to(
                                    () => EventDetailScreen(),
                                    transition: Transition.downToUp,
                                    duration: Duration(milliseconds: 300),
                                  );
                                },
                                child: Stack(
                                  children: [
                                    Container(
                                      height: height * 0.30,
                                      margin: EdgeInsets.only(
                                          bottom: height * 0.015),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: CustomNetworkImage(
                                              imageUrl: data.image ??
                                                  'https://mlscottsdale.com/get/files/image/galleries/Dining_Room_AZ_Shelby_Moore.jpg',
                                              height: height * 0.190,
                                              width: width * 0.90,
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                data.name ??
                                                    "EL Tapatio Mexican Restaurant",
                                                style: GoogleFonts.poppins(
                                                  color: Colors.black,
                                                  fontSize: width * 0.04,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              '4.8',
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                color: Colors
                                                                    .orange,
                                                                fontSize:
                                                                    width *
                                                                        0.03,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            ),
                                                            RatingBarIndicator(
                                                              rating: 2.75,
                                                              itemBuilder:
                                                                  (context,
                                                                          index) =>
                                                                      Icon(
                                                                Icons.star,
                                                                color: Colors
                                                                    .amber,
                                                              ),
                                                              itemCount: 5,
                                                              itemSize:
                                                                  width * 0.035,
                                                              direction: Axis
                                                                  .horizontal,
                                                            ),
                                                            SizedBox(
                                                                width: width *
                                                                    0.02),
                                                            Text(
                                                              "(255)",
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                color: Colors
                                                                    .black,
                                                                fontSize:
                                                                    width *
                                                                        0.03,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                            height:
                                                                height * 0.005),
                                                        Row(
                                                          children: [
                                                            Icon(
                                                                Icons
                                                                    .calendar_today,
                                                                color: Colors
                                                                    .black,
                                                                size: width *
                                                                    0.035),
                                                            SizedBox(
                                                                width: width *
                                                                    0.02),
                                                            Text(
                                                              formattedDate ??
                                                                  '19 July 2021',
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                color: Colors
                                                                    .black,
                                                                fontSize:
                                                                    width *
                                                                        0.03,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
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
                                                            Icon(
                                                                Icons
                                                                    .location_on,
                                                                color: Colors
                                                                    .black,
                                                                size: width *
                                                                    0.035),
                                                            SizedBox(
                                                                width: width *
                                                                    0.015),
                                                            Text(
                                                              data.address!.length > 20 ?
                                                              data.address!.substring(0, 30) + '...' :
                                                              data.address ?? "",
                                                              style: GoogleFonts.poppins(
                                                                color: Colors.black,
                                                                fontSize:width *0.02,
                                                                fontWeight:FontWeight.w400,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                            height:
                                                                height * 0.005),
                                                        Row(
                                                          children: [
                                                            Icon(
                                                                Icons
                                                                    .access_time,
                                                                color: Colors
                                                                    .black,
                                                                size: width *
                                                                    0.035),
                                                            SizedBox(
                                                                width: width *
                                                                    0.02),
                                                            Text(
                                                              '$startTime - $endTime',
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                color: Colors
                                                                    .black,
                                                                fontSize:
                                                                    width *
                                                                        0.03,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
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
                                    Positioned(
                                      top: width * 0.05,
                                      right: width * 0.05,
                                      child: GestureDetector(
                                        onTap: () async {
                                          await Share.share(
                                            eventsController
                                                    .eventList[index].image ??
                                                '',
                                          );
                                        },
                                        child: Container(
                                          padding:
                                              EdgeInsets.all(width * 0.015),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(Icons.share,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  )),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
