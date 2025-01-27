// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:event_app/data/token_manager/const_veriable.dart';
import 'package:event_app/data/token_manager/local_storage.dart';
import 'package:event_app/res/common_widget/RoundTextField.dart';
import 'package:event_app/res/common_widget/custom_network_image_widget.dart';
import 'package:event_app/res/common_widget/custom_text.dart';
import 'package:event_app/res/custom_style/formate_time.dart';
import 'package:event_app/res/utils/share_event.dart';
import 'package:event_app/res/utils/time_convetor.dart';
import 'package:event_app/view/create_event_view/view/create_event_details_screen.dart';
import 'package:event_app/view/create_event_view/view/edit_event_screen.dart';
import 'package:event_app/view/create_event_view/view/select_event_by_search_or_map_screen.dart';
import 'package:event_app/view/home_view/controller/events_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../../../res/app_colors/App_Colors.dart';
import '../../../res/common_widget/custom_app_bar.dart';
import '../../../res/custom_style/custom_size.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  @override
  final EventsController controller = Get.put(EventsController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.getMyEvents();
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
          child: Obx(
                () {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomAppBar(
                    appBarName: "create_event".tr,
                    widget: SizedBox(),
                  ),


                  // search section
                  heightBox20,
                  RoundTextField(
                    hint: "search_places".tr,
                    readOnly: true,
                    prefixIcon: Icon(
                      Icons.search_outlined,
                      size: 26.sp,
                    ),
                    onTap: () {
                      Get.to(
                            () => SelectEventBySearchOrMapScreen(),
                        transition: Transition.fadeIn,
                        duration: Duration(milliseconds: 300),
                      );
                    },
                    borderRadius: 44,
                    focusBorderRadius: 44,
                  ),


                  // my created event list
                  heightBox20,
                  Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          await controller.getMyEvents();
                        },
                        child: controller.isLoading.value ?
                        Center(child: SpinKitCircle(color: AppColors.primaryColor,),) :
                        controller.myEventList.isEmpty ? Center(
                            child: CustomText(
                              title: "no_event_created".tr,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.black100,
                            )
                        ) : ListView.builder(
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
                            String formattedDate = DateFormat('MMM d, yyyy').format(date);

                            String startTime = formatTime24hr(data.startTime.toString());
                            String endTime = formatTime24hr(data.endTime.toString());
                            return GestureDetector(
                              onTap: () {
                                LocalStorage.saveData(key: showEventDetailsId, data: data.id);
                                Get.to(
                                      () => CreateEventDetailsScreen(),
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
                                            imageUrl: data.image ?? placeholderImage,
                                            height: height * 0.190,
                                            width: width * 0.90,
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              data.name ?? "event_name".tr,
                                              style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: width * 0.04,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),

                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(Icons.location_on, color: Colors.black, size: width * 0.035),
                                                    SizedBox(width: width * 0.015),
                                                    Text(
                                                      getLimitedWord(data.address, 30),
                                                      style: GoogleFonts.poppins(
                                                        color: Colors.black,
                                                        fontSize: width * 0.03,
                                                        fontWeight: FontWeight.w400,
                                                      ),
                                                    ),
                                                  ],
                                                ),
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

                                                    // PopupMenuButton<int>(
                                                    //   icon: Icon(Icons.more_horiz, color: Colors.grey), // Trigger icon
                                                    //   shape: RoundedRectangleBorder(
                                                    //     borderRadius: BorderRadius.circular(8),
                                                    //     side: BorderSide(color: Colors.teal, width: 1),
                                                    //   ),
                                                    //   elevation: 8,
                                                    //   offset: Offset(0, 40),
                                                    //   onSelected: (value) {
                                                    //     // Handle selection here
                                                    //     if (value == 1) {
                                                    //       print("Edit selected");
                                                    //     } else if (value == 2) {
                                                    //       print("Delete selected");
                                                    //     }
                                                    //   },
                                                    //   itemBuilder: (context) => [
                                                    //     // Edit option
                                                    //     PopupMenuItem(
                                                    //       value: 1,
                                                    //       child: Row(
                                                    //         children: [
                                                    //           Icon(Icons.edit, color: Colors.teal),
                                                    //           SizedBox(width: 8),
                                                    //           Text(
                                                    //             'Edit',
                                                    //             style: TextStyle(color: Colors.black),
                                                    //           ),
                                                    //         ],
                                                    //       ),
                                                    //     ),
                                                    //     // Divider between items
                                                    //     PopupMenuDivider(),
                                                    //     // Delete option
                                                    //     PopupMenuItem(
                                                    //       value: 2,
                                                    //       child: Row(
                                                    //         children: [
                                                    //           Icon(Icons.delete, color: Colors.red),
                                                    //           SizedBox(width: 8),
                                                    //           Text(
                                                    //             'Delete',
                                                    //             style: TextStyle(color: Colors.black),
                                                    //           ),
                                                    //         ],
                                                    //       ),
                                                    //     ),
                                                    //   ],
                                                    // )
                                                  ],
                                                ),
                                              ],
                                            ),

                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      '${data.rating??0.0}',
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
                                                      "(${data.reviews ?? 0})",
                                                      style: GoogleFonts.poppins(
                                                        color: Colors.black,
                                                        fontSize: width * 0.03,
                                                        fontWeight: FontWeight.w400,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Icon(Icons.calendar_today, color: Colors.black, size: width * 0.035),
                                                    SizedBox(width: width * 0.02),
                                                    Text(
                                                      formattedDate ?? '19 July 2021',
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

                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Share and More Options button
                                  Positioned(
                                    top: width * 0.05,
                                    right: width * 0.05,
                                    child: Row(
                                      children: [
                                        // Share Button
                                        GestureDetector(
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
                                        SizedBox(width: 14), // space between buttons
                                        // More Options Button with Popup
                                        GestureDetector(
                                          onTapDown: (TapDownDetails details) {
                                            showMenu<int>(
                                              context: context,
                                              position: RelativeRect.fromLTRB(
                                                details.globalPosition.dx,
                                                details.globalPosition.dy,
                                                details.globalPosition.dx,
                                                details.globalPosition.dy,
                                              ),
                                              items: <PopupMenuEntry<int>>[
                                                PopupMenuItem<int>(
                                                  value: 1,
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.edit, color: Colors.teal),
                                                      SizedBox(width: 8),
                                                      Text('edit'.tr, style: TextStyle(color: Colors.black)),
                                                    ],
                                                  ),
                                                ),
                                                PopupMenuDivider(),
                                                PopupMenuItem<int>(
                                                  value: 2,
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.delete, color: Colors.red),
                                                      SizedBox(width: 8),
                                                      Text('delete'.tr, style: TextStyle(color: Colors.black)),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ).then((value) async {
                                              if (value == 1) {
                                                print("Edit selected");
                                                // Add your edit functionality here
                                                LocalStorage.saveData(key: editEventId, data: data.id.toString());
                                                Get.to(
                                                      () => EditEventScreen(),
                                                  transition: Transition.rightToLeft,
                                                  duration: const Duration(milliseconds: 300),
                                                );
                                              } else if (value == 2) {
                                                print("Delete selected");
                                                // Add your delete functionality here
                                                await controller.deleteEvent(data.id.toString());
                                              }
                                            });
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(width * 0.015),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(Icons.more_vert, color: Colors.black),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),



                                ],
                              ),
                            );
                          },
                        ),
                      )
                  ),

                ],
              );
            },
          ),
        ),
      ),
    );
  }
}


