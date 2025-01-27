// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:event_app/data/token_manager/local_storage.dart';
import 'package:event_app/res/common_widget/custom_app_bar.dart';
import 'package:event_app/res/common_widget/custom_network_image_widget.dart';
import 'package:event_app/res/custom_style/custom_size.dart';
import 'package:event_app/res/utils/share_event.dart';
import 'package:event_app/res/utils/time_convetor.dart';
import 'package:event_app/view/event_view/controller/my_event_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../../../data/token_manager/const_veriable.dart';
import '../../../res/app_colors/App_Colors.dart';
import '../../../res/custom_style/formate_time.dart';
import 'my_event_details_screen.dart';

class MyEventScreen extends StatelessWidget {
  MyEventScreen({super.key});
  final MyEventController controller = Get.put(MyEventController());

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
                  CustomAppBar(
                    appBarName: "my_event".tr,
                    widget: SizedBox(),
                  ),

                  heightBox20,
                  Expanded(
                    child: RefreshIndicator(
                    onRefresh: () async {
                      controller.getMyEvents();
                    },
                    child: controller.myEventList.isEmpty ?
                    Center(child: Text("no_event_found".tr)) :
                    ListView.builder(
                      shrinkWrap: true,
                      physics: AlwaysScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: controller.myEventList.length,
                      itemBuilder: (context, index) {
                        var data = controller.myEventList[index];
                        DateTime date;
                        try {
                          date = DateTime.parse(data.date.toString());
                        } catch (e) {
                          date = DateTime.now();
                        }
                        String eventDate = DateFormat('MMM d, yyyy').format(date);
                        String startTime = formatTime24hr(data.startTime.toString());
                        String endTime = formatTime24hr(data.endTime.toString());
                        return GestureDetector(
                          onTap: () {
                            LocalStorage.saveData(key: showEventDetailsId, data: data.id);
                            print("Event ID: ${data.id}");
                            Get.to(
                                  () => MyEventDetailsScreen(),
                              transition: Transition.downToUp,
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
                                        imageUrl: data.image ??  placeholderImage,
                                        height: height * 0.190,
                                        width: width * 0.90,
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          data.name ?? 'not_available'.tr,
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
                                                        '${data.rating ?? 0.0}',
                                                        style: GoogleFonts.poppins(
                                                          color: Colors.orange,
                                                          fontSize: width * 0.03,
                                                          fontWeight: FontWeight.w400,
                                                        ),
                                                      ),
                                                      RatingBarIndicator(
                                                        rating: (data.rating ?? 0.0).toDouble(),
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
                                                        "(${data.reviews ?? 0.0})",
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
                                                        eventDate ?? 'not found',
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
                                                        overflow: TextOverflow.ellipsis,
                                                        getLimitedWord(data.address, 20),
                                                        style: GoogleFonts.poppins(
                                                          color: Colors.black,
                                                          fontSize: 10,
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
                                                        '${startTime} - ${endTime}' ?? 'Unavailable',
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
                                    ShareEventData event = ShareEventData(
                                      eventName: data.name.toString(),
                                      eventDate: eventDate,
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
                    ),),),

                ],
              );
            },
          ),
        ),
      ),
    );
  }

}
