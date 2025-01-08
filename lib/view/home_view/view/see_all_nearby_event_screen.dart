// ignore_for_file: prefer_const_constructors

import 'package:event_app/data/token_manager/const_veriable.dart';
import 'package:event_app/data/token_manager/local_storage.dart';
import 'package:event_app/res/app_colors/App_Colors.dart';
import 'package:event_app/res/common_widget/custom_app_bar.dart';
import 'package:event_app/res/common_widget/custom_network_image_widget.dart';
import 'package:event_app/res/custom_style/custom_size.dart';
import 'package:event_app/res/custom_style/formate_time.dart';
import 'package:event_app/res/utils/share_event.dart';
import 'package:event_app/view/home_view/controller/nearby_event_controller.dart';
import 'package:event_app/view/home_view/view/event_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

class SeeAllNearbyEventScreen extends StatelessWidget {
  SeeAllNearbyEventScreen({super.key});

  final NearbyEventController nearbyEventController = Get.put(NearbyEventController());

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
            child: Obx(
              () {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomAppBar(
                      appBarName: "Nearby Events",
                      onTap: () {
                        Get.back();
                      },
                    ),

                    heightBox20,
                    ListView.builder(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: nearbyEventController.nearbyEventList.length,
                      itemBuilder: (context, index) {
                        var data = nearbyEventController.nearbyEventList[index];
                        DateTime date;
                        try {
                          date = DateTime.parse(data.date.toString());
                        } catch (e) {
                          date = DateTime.now();
                        }
                        String formattedDate = DateFormat('MMM d, yyyy').format(date);

                        String startTime = formatTime24hr(data.startTime.toString());
                        String endTime = formatTime24hr(data.endTime.toString());
                        return GestureDetector(
                          onTap: () {
                            LocalStorage.saveData(key: showEventDetailsId, data: data.id);
                            Get.to(
                                  () => EventDetailScreen(),
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
                                        imageUrl: data.image ?? 'https://mlscottsdale.com/get/files/image/galleries/Dining_Room_AZ_Shelby_Moore.jpg',
                                        height: height * 0.190,
                                        width: width * 0.90,
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${data.name ?? "Unavailable"}",
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
                                                        '${formattedDate ?? "Unavailable"}',
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
                                                      Flexible(child: Text(
                                                        "${data.address ?? "Unavailable"}",
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: GoogleFonts.poppins(
                                                          color: Colors.black,
                                                          fontSize: width * 0.03,
                                                          fontWeight: FontWeight.w400,
                                                        ),
                                                      )),
                                                    ],
                                                  ),
                                                  SizedBox(height: height * 0.005),
                                                  Row(
                                                    children: [
                                                      Icon(Icons.access_time, color: Colors.black, size: width * 0.035),
                                                      SizedBox(width: width * 0.02),
                                                      Text(
                                                        '$startTime - $endTime',
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
                              Positioned(
                                top: width * 0.05,
                                right: width * 0.05,
                                child: GestureDetector(
                                  onTap: () {
                                    ShareEventData event = ShareEventData(
                                      eventName: data.name.toString(),
                                      eventDate: formattedDate,
                                      eventTime: "$startTime - $endTime",
                                      eventLocation: data.address.toString(),
                                      eventImage: data.image.toString(),
                                    );

                                    // Prepare the share content
                                    String shareContent = '''
🌟 Don't miss this amazing event! 🌟

📅 Event Name: ${event.eventName}
📆 Date: ${event.eventDate}
⏰ Time: ${event.eventTime}
📍 Location: ${event.eventLocation}

👉 Tap the link to view the image: ${event.eventImage}

🎉 See you there! 🎉
''';


                                    // Share the content
                                    Share.share(shareContent);
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
                    )


                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
