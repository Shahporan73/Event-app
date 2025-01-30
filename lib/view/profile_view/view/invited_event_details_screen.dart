// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:event_app/data/token_manager/const_veriable.dart';
import 'package:event_app/data/token_manager/local_storage.dart';
import 'package:event_app/res/app_colors/App_Colors.dart';
import 'package:event_app/res/app_images/App_images.dart';
import 'package:event_app/res/common_widget/RoundButton.dart';
import 'package:event_app/res/common_widget/custom_text.dart';
import 'package:event_app/res/custom_style/custom_size.dart';
import 'package:event_app/res/custom_style/formate_time.dart';
import 'package:event_app/view/create_event_view/view/map_screen.dart';
import 'package:event_app/view/home_view/controller/event_details_controller.dart';
import 'package:event_app/view/profile_view/controller/my_invited_event_controller.dart';
import 'package:event_app/view/profile_view/model/my_invited_event_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';
import 'package:shimmer/shimmer.dart';

import '../../../res/common_widget/custom_network_image_widget.dart';

class InvitedEventDetailsScreen extends StatelessWidget {
  InvitedEventDetailsScreen({super.key});
  final MyInvitedEventController controller = Get.put(MyInvitedEventController());
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Obx(
            () {

          var data = controller.myInvitedEventDetails.value.data;

          // Ensure data and event are not null before proceeding
          if (data == null || data.event == null) {
            return Center(
              child: SpinKitCircle(color: AppColors.primaryColor,),
            );
          }
          if(controller.isLoading.value == true){
            return Center(child: SpinKitCircle(color: AppColors.primaryColor),);
          }

          DateTime createdAt;
          try {
            createdAt = DateFormat('MM/dd/yyyy').parse(data.event!.date.toString());
          } catch (e) {
            createdAt = DateTime.now();
          }

          // Format to include day name
          String formattedDate = DateFormat('EEEE, MMM d, yyyy').format(createdAt);

          String startTime = convertFormatTime12hr(data.event!.startTime.toString());
          String endTime = convertFormatTime12hr(data.event!.endTime.toString());
          return Stack(
            children: [
              // Header image
              Positioned(
                top: 0,
                right: 0,
                left: 0,
                child: Container(
                  height: 200,
                  child: Stack(
                    children: [
                      // Shimmer effect as the placeholder while loading
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          color: Colors.grey,
                          height: 200,
                        ),
                      ),
                      // Network image with loading and error handling
                      Image.network(
                        data.event?.image ?? placeholderImage,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child; // Image loaded successfully
                          }
                          return SizedBox.shrink(); // Keep showing shimmer while loading
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.broken_image,
                              color: Colors.grey[600],
                              size: 48,
                            ), // Error image placeholder
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // appbar
              Positioned(
                top: 32,
                right: 16,
                left: 16,
                child: Row(
                  children: [
                    // Back Button
                    IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                    // Centered Title
                    Expanded(child: Center(
                      child: CustomText(
                        title: 'event_details'.tr,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    )),
                  ],
                ),
              ),

              // details
              Positioned(
                top: 180,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      heightBox20,
                      Row(
                        children: [
                          Expanded(
                            child: Roundbutton(
                              borderRadius: 7,
                              title: 'I’m Going',
                              fontSize: 10,
                              buttonColor: Color(0xff2EA355),
                              onTap: () async {
                                controller.eventStatusUpdate('GOING', data.event!.id.toString());
                                Get.rawSnackbar(message: "event_joined_successfully".tr, snackPosition: SnackPosition.BOTTOM);
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                          widthBox10,
                          Expanded(
                            child: Roundbutton(
                              borderRadius: 7,
                              title: 'Maybe I’m Going',
                              fontSize: 10,
                              buttonColor: AppColors.primaryColor,
                              onTap: () async {
                                controller.eventStatusUpdate('MAYBE_GOING', data.event!.id.toString());
                                Get.rawSnackbar(message: "maybe_going_event".tr, snackPosition: SnackPosition.BOTTOM);
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                          widthBox10,
                          Expanded(
                            child: Roundbutton(
                              borderRadius: 7,
                              title: 'Ignore',
                              fontSize: 10,
                              buttonColor: Colors.red,
                              onTap: () async {
                                controller.eventStatusUpdate('IGNORED', data.event!.id.toString());
                                Get.rawSnackbar(message: "event_ignored", snackPosition: SnackPosition.BOTTOM);
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                        ],
                      ),
                      // Event title and rating
                      heightBox10,
                      Text(
                        data.event?.name ?? 'Unavailable Event',
                        style: GoogleFonts.poppins(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.black33
                        ),
                      ),
                      Row(
                        children: [
                          RatingBarIndicator(
                            itemSize: 16.sp,
                            rating: (data.event?.rating ?? 0).toDouble(),
                            itemCount: 5,
                            direction: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Icon(
                                Icons.star,
                                color: Colors.amber,
                              );
                            },
                          ),
                          SizedBox(width: 5),
                          Text(
                            '${data.event?.rating ?? 0} (${data.event?.reviews ?? 0})',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 16),
                      // Date and Location details
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.teal[50],
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.calendar_month_outlined, color: AppColors.primaryColor),
                          ),
                          SizedBox(width: 15),
                          Text(
                            '$formattedDate\n$startTime - $endTime',
                            style: GoogleFonts.poppins(color: Colors.grey[800]),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.teal[50],
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.location_on, color: AppColors.primaryColor),
                          ),
                          SizedBox(width: 15),
                          Expanded(child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data.event?.address ?? 'Unavailable Location',
                                style: GoogleFonts.poppins(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  onTap: () {
                                    Get.to(
                                            ()=> MapScreen(
                                              longitude: data.event?.location?.coordinates[1] ?? 0.0,
                                              latitude: data.event?.location?.coordinates[0] ?? 0.0,
                                            ),
                                        transition: Transition.rightToLeft,
                                        duration: Duration(milliseconds: 300)
                                    );
                                  },
                                  child: Image.asset(AppImages.directionIcon, scale: 4.5,),
                                ),
                              )
                            ],
                          )),
                        ],
                      ),
                      SizedBox(height: 16),
                      // Organizer section
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(
                              // data.organizer?.profilePicture ??
                                data.event!.organizer?.profilePicture ??
                                    placeholderImage), // Organizer image
                          ),
                          SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${data.event?.organizer?.name ?? ''}',
                                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'organizer'.tr,
                                style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.grey[600]),
                              ),
                            ],
                          ),
                          Spacer(),
                          Roundbutton(
                              title: "message".tr,
                              width: 120,
                              padding_vertical: 5,
                              titleColor: AppColors.primaryColor,
                              buttonColor: AppColors.primaryColor.withOpacity(0.2),
                              fontSize: 12,
                              onTap: () {}
                          )
                        ],
                      ),
                      SizedBox(height: 16),
                      // About event section
                      Text(
                        'about_event'.tr,
                        style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      // Expanded text with "Read More" functionality
                      ReadMoreText(
                        data.event?.aboutEvent ?? '',
                        trimLines: 3,
                        colorClickableText: Colors.teal,
                        trimMode: TrimMode.Line,
                        trimCollapsedText: 'read_more'.tr,
                        trimExpandedText: 'show_less'.tr,
                        style: GoogleFonts.poppins(color: Colors.grey[700]),
                        moreStyle: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
