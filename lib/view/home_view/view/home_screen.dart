// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:event_app/data/token_manager/const_veriable.dart';
import 'package:event_app/data/token_manager/local_storage.dart';
import 'package:event_app/res/app_images/App_images.dart';
import 'package:event_app/res/common_widget/RoundTextField.dart';
import 'package:event_app/res/common_widget/custom_row_widget.dart';
import 'package:event_app/res/common_widget/custom_shimmer_widget.dart';
import 'package:event_app/res/custom_style/custom_size.dart';
import 'package:event_app/res/custom_style/formate_time.dart';
import 'package:event_app/res/utils/share_event.dart';
import 'package:event_app/view/event_view/controller/my_event_controller.dart';
import 'package:event_app/view/event_view/view/my_event_details_screen.dart';
import 'package:event_app/view/event_view/view/my_event_screen.dart';
import 'package:event_app/view/home_view/controller/nearby_event_controller.dart';
import 'package:event_app/view/home_view/view/event_details_screen.dart';
import 'package:event_app/view/home_view/view/search_event_screen.dart';
import 'package:event_app/view/home_view/view/see_all_nearby_event_screen.dart';
import 'package:event_app/view/home_view/widget/my_event_card_widget.dart';
import 'package:event_app/view/profile_view/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import '../../../res/app_colors/App_Colors.dart';
import '../../../res/common_widget/custom_network_image_widget.dart';
import '../../../res/common_widget/custom_text.dart';
import 'notificaiton_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProfileController controller = Get.put(ProfileController());
  final NearbyEventController nearbyEventController = Get.put(NearbyEventController());
  final MyEventController myEventController = Get.put(MyEventController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.getProfile();
    nearbyEventController.getNearbyEvents();
    myEventController.getMyEvents();
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
                // header section
               Obx(() {
                 print('profile imge ${controller.imgURL.value}');
                 return  Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Expanded(
                       child: ListTile(
                         leading: ClipRRect(
                           borderRadius: BorderRadius.circular(100),
                           child: CustomNetworkImage(
                             imageUrl: controller.imgURL.value.isNotEmpty ?
                             controller.imgURL.value :placeholderImage,
                             width: 50,
                             height: 50,
                           ),
                         ),
                         title: CustomText(
                           title: controller.name.value ?? 'Unavailable',
                           fontSize: 18,
                           fontWeight: FontWeight.w500,
                           color: AppColors.blackColor,
                         ),
                         subtitle: CustomText(
                           title: controller.address.value ?? 'Unavailable',
                           fontSize: 10,
                           fontWeight: FontWeight.w400,
                           color: AppColors.black33,
                         ),
                       ),
                     ),

                     // notification section
                     InkWell(
                       onTap: () {
                         Get.to(
                               () => NotificationScreen(),
                           transition: Transition.fadeIn,
                           duration: Duration(milliseconds: 300),
                         );
                       },
                       child: Image.asset(
                         AppImages.notificationIcon,
                         scale: 4,
                       ),
                     )
                   ],
                 );
               }),

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
                      () => SearchEventScreen(),
                      transition: Transition.fadeIn,
                      duration: Duration(milliseconds: 300),
                    );
                  },
                  borderRadius: 44.r,
                  focusBorderRadius: 44.r,
                ),

                // my event section
                heightBox20,
                CustomRowWidget(
                  title: CustomText(
                    title: "my_events".tr,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Color(0xff1E2022),
                  ),
                  value: GestureDetector(
                    onTap: () {
                      Get.to(
                            () => MyEventScreen(),
                        transition: Transition.rightToLeft,
                        duration: Duration(milliseconds: 300),
                      );
                    },
                    child: CustomText(
                      title: "see_more".tr,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: AppColors.secondaryColor,
                    ),
                  ),
                ),
                heightBox10,
                Obx(
                  () {
                    return myEventController.isLoading.value ?
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            height: height * 0.25,
                            child: Row(
                              children: List.generate(3,
                                    (index) => CustomShimmerWidget(height: height * 0.25, width: 280,),
                              ),
                            ),
                          ),
                        )
                     :myEventController.myEventList.isEmpty ?
                    Center(child: Text("no_events_found".tr),)
                        :SizedBox(
                      height: height * 0.25, // Responsive height for the horizontal list
                      child: ListView.builder(
                        itemCount: myEventController.myEventList.length,
                        scrollDirection: Axis.horizontal,
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          var data = myEventController.myEventList[index];

                          var rating = (data.rating?.toDouble() ?? 0.0);
                          DateTime date;
                          try {
                            date = DateTime.parse(data.date.toString() ?? '');
                          } catch (e) {
                            date = DateTime.now();
                          }
                          String formattedDate = DateFormat('MMM d, yyyy').format(date);

                          String startTime = formatTime24hr(data.startTime.toString() ?? '');
                          String endTime = formatTime24hr(data.endTime.toString() ?? '');

                          return GestureDetector(
                            onTap: () {
                              LocalStorage.saveData(key: showEventDetailsId, data: data.id);
                              Get.to(
                                    () => MyEventDetailsScreen(),
                                transition: Transition.downToUp,
                                duration: Duration(milliseconds: 400),
                              );
                            },
                            child: MyEventCardWidget(
                              title: data.name ?? "not_available".tr,
                              imageUrl: data.image ?? placeholderImage,
                              rating: rating,
                              reviews: data.reviews ?? 0,
                              location: data.address ?? "not_available".tr,
                              date: formattedDate ?? "Unavailable",
                              time: "$startTime - $endTime" ?? "Unavailable",
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),

                // nearby place section
                heightBox20,
                CustomRowWidget(
                  title: CustomText(
                    title: "near_by_places".tr,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Color(0xff1E2022),
                  ),
                  value: GestureDetector(
                    onTap: () {
                      Get.to(
                            () => SeeAllNearbyEventScreen(),
                        transition: Transition.leftToRight,
                        duration: Duration(milliseconds: 400),
                      );
                    },
                    child: CustomText(
                      title: "see_more".tr,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: AppColors.secondaryColor,
                    ),
                  ),
                ),
                heightBox10,
                Obx(
                  () {
                    var latitude = LocalStorage.getData(key: nearbyLatitude);
                    var longitude = LocalStorage.getData(key: nearbyLongitude);


                    return latitude ==null && longitude ==null?
                    Center(child: Text("Need to first location permission"),)
                        :
                      nearbyEventController.isLoading.value ?

                    CustomShimmerWidget(height: height * 0.25, width: width,)
                        : nearbyEventController.nearbyEventList.isEmpty ?

                    Center(child: Text("no_events_found".tr),)
                        :
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
                                        imageUrl: data.image ?? placeholderImage,
                                        height: height * 0.190,
                                        width: width * 0.90,
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${data.name ?? "not_available".tr}",
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
                                                        '${data.rating ?? "0"}',
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
                                                        "(${data.reviews ?? "0"})",
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
                                                        "${data.address ?? "not_available".tr}",
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
