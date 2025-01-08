// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:event_app/data/token_manager/const_veriable.dart';
import 'package:event_app/data/token_manager/local_storage.dart';
import 'package:event_app/res/app_colors/App_Colors.dart';
import 'package:event_app/res/common_widget/RoundButton.dart';
import 'package:event_app/res/common_widget/custom_text.dart';
import 'package:event_app/res/custom_style/formate_time.dart';
import 'package:event_app/res/utils/share_event.dart';
import 'package:event_app/view/home_view/controller/event_details_controller.dart';
import 'package:event_app/view/message_view/controller/personal_chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import '../../../res/common_widget/custom_network_image_widget.dart';

class EventDetailScreen extends StatelessWidget {
  EventDetailScreen({super.key});
  final EventDetailsController controller = Get.put(EventDetailsController());
  final PersonalChatController personalChatController = Get.put(PersonalChatController());
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Obx(
        () {
          var data = controller.eventModel.value.data;
          print('event id ${data?.id}');
          print('LocalStorage id ${LocalStorage.getData(key: showEventDetailsId)}');
          if(controller.eventModel.value.data ==null){
            return Center(child: SpinKitCircle(color: AppColors.primaryColor,));
          }
          DateTime date;
          try {
            date = DateTime.parse(data!.date.toString());
          } catch (e) {
            date = DateTime.now();
          }
          String formattedDate = DateFormat('MMM d, yyyy').format(date);

          String startTime = formatTime24hr(data!.startTime.toString());
          String endTime = formatTime24hr(data.endTime.toString());

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
                        data.image ?? placeholderImage,
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

                    // Spacer to push title to the center
                    Spacer(),

                    // Centered Title
                    CustomText(
                      title: 'Event Details',
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),

                    // Spacer to maintain symmetry
                    Spacer(),

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
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.share,
                          color: Colors.black,
                        ),
                      ),
                    ),
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
                      SizedBox(height: 60),
                      // Event title and rating
                      Text(
                        data.name??'Unavailable',
                        style: GoogleFonts.poppins(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.black33
                        ),
                      ),
                      Row(
                        children: [
                          RatingBarIndicator(
                            itemSize: 16,
                            rating: (data.rating ?? 0.0).toDouble(),
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
                            '${data.rating ?? 0.0} (${data.reviews ?? 0})',
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
                          Expanded(child: Text(
                            data.address??'',
                            style: GoogleFonts.poppins(color: Colors.grey[800]),
                          ),),
                        ],
                      ),
                      SizedBox(height: 16),


                      // Organizer section
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(
                              data.organizer?.profilePicture?? placeholderImage
                            ),
                          ),
                          SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data.organizer?.name ?? 'Unavailable',
                                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Organizer',
                                style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.grey[600]),
                              ),
                            ],
                          ),
                          Spacer(),
                          Roundbutton(
                              title: "Message",
                              width: 120,
                              padding_vertical: 5,
                              titleColor: AppColors.primaryColor,
                              buttonColor: AppColors.primaryColor.withOpacity(0.2),
                              fontSize: 12,
                              onTap: () {
                                if(data.organizer?.id == null){
                                  Get.rawSnackbar(message: "User not found");
                                }else{
                                  personalChatController.getChatList(
                                      receiverId: data.organizer?.id ?? "",
                                      userName: data.organizer?.name ?? "",
                                      userImage: data.organizer?.profilePicture ?? ""
                                  );
                                }
                              }
                          )
                        ],
                      ),
                      SizedBox(height: 16),
                      // About event section
                      Text(
                        'About Event',
                        style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      // Expanded text with "Read More" functionality
                      ReadMoreText(
                        data.aboutEvent??'Not found event description',
                        trimLines: 3,
                        colorClickableText: Colors.teal,
                        trimMode: TrimMode.Line,
                        trimCollapsedText: 'Read More',
                        trimExpandedText: 'Show Less',
                        style: GoogleFonts.poppins(color: Colors.grey[700]),
                        moreStyle: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      SizedBox(height: 20),
                      // Join button
                      Roundbutton(
                        title: "Join",
                        isLoading: controller.isLoading.value,
                        onTap: () async {
                          await controller.jointEvent(data.id.toString());
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // show members container
              Positioned(
                top: 160,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: width * 0.60,
                    padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                    decoration: BoxDecoration(
                        color: AppColors.bgColor,
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ]
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: List.generate(
                            3,
                                (index) {
                              var member = data.recommendableUsers[index];
                              return Align(
                                  widthFactor: 0.6,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: CustomNetworkImage(
                                        imageUrl: member.profilePicture?? 'https://t3.ftcdn.net/jpg/02/43/12/34/360_F_243123463_zTooub557xEWABDLk0jJklDyLSGl2jrr.jpg',
                                        height: 50,
                                        width: 50,
                                      )
                                  )
                              );
                            },
                          ),
                        ),
                        SizedBox(width: 20),
                        Text(
                          '+${data.recommendableUsers.length - 3} People',
                          style: GoogleFonts.poppins(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
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
