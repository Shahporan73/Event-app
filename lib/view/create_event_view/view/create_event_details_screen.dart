// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings

import 'package:event_app/data/token_manager/const_veriable.dart';
import 'package:event_app/data/token_manager/local_storage.dart';
import 'package:event_app/res/app_colors/App_Colors.dart';
import 'package:event_app/res/common_widget/RoundButton.dart';
import 'package:event_app/res/common_widget/custom_text.dart';
import 'package:event_app/res/common_widget/responsive_helper.dart';
import 'package:event_app/res/custom_style/custom_size.dart';
import 'package:event_app/res/custom_style/formate_time.dart';
import 'package:event_app/res/utils/share_event.dart';
import 'package:event_app/view/create_event_view/view/selected_contact_screen.dart';
import 'package:event_app/view/create_event_view/widget/see_all_member_dialog_widget.dart';
import 'package:event_app/view/home_view/controller/event_details_controller.dart';
import 'package:event_app/view/message_view/view/see_all_memeber_screen.dart';
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
import '../widget/invite_member_from_event.dart';

class CreateEventDetailsScreen extends StatelessWidget {
  CreateEventDetailsScreen({Key? key}) : super(key: key);
  final EventDetailsController controller = Get.put(EventDetailsController());
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Obx(
        () {
          var data = controller.eventModel.value.data;
          if(controller.eventModel.value.data ==null){
            return Center(child: SpinKitCircle(color: AppColors.primaryColor,));
          }
          print('event id ${data?.id}');
          print('local database ${LocalStorage.getData(key: showEventDetailsId)}');
          DateTime date;
          try {
            date = DateTime.parse(data!.date.toString());
          } catch (e) {
            date = DateTime.now();
          }
          String formattedDate = DateFormat('MMM d, yyyy').format(date);

          String startTime = convertFormatTime12hr(data!.startTime.toString());
          String endTime = convertFormatTime12hr(data.endTime.toString());
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
                      title: 'event_details'.tr,
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
                      SizedBox(height: ResponsiveHelper.h(context, 60)),

                      // Member section
                      data.recommendedUser.isNotEmpty ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Only generate the members if the list is not empty
                          data.recommendedUser.isNotEmpty
                              ? Row(
                            children: List.generate(
                              data.recommendedUser.length > 3
                                  ? 3 // Limit to 3 members
                                  : data.recommendedUser.length, // Show all if less than 3
                                  (index) {
                                var member = data.recommendedUser[index];
                                return Align(
                                  widthFactor: 0.6,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: CustomNetworkImage(
                                      imageUrl: (member.user?.profilePicture?.isNotEmpty ?? false)
                                          ? '${member.user?.profilePicture}'
                                          : placeholderImage, // Default image if profilePicture is null or empty
                                      height: 40,
                                      width: 40,
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                              : SizedBox.shrink(), // Empty space when the list is empty
                          SizedBox(width: 20),
                          Text(
                            '${data.recommendedUser.length} ' + 'maybe_im_going'.tr,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          widthBox10,
                          Roundbutton(
                            width: ResponsiveHelper.w(context, 70),
                            padding_vertical: 6,
                            borderRadius: 4,
                            fontSize: 8,
                            title: "see_members".tr,
                            onTap: () {
                              // Get.to(
                              //       () => SeeAllMemeberScreen(),
                              //   transition: Transition.downToUp,
                              //   duration: Duration(milliseconds: 300),
                              // );
                              showSeeAllMemberDialog(context, data.recommendedUser);

                            },
                          ),
                        ],
                      ):
                      Center(
                        child: CustomText(title: 'no_members'.tr,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryColor,
                        ),
                      ),



                      // Event title and rating
                      heightBox10,
                      Text(
                        data.name ?? 'unavailable_event'.tr,
                        style: GoogleFonts.poppins(
                            fontSize: 22,
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
                            '${data.rating} (${data.reviews})',
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
                                data.address ?? 'unavailable_location'.tr,
                                style: GoogleFonts.poppins(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                              /*Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  onTap: () {
                                    Get.to(
                                            ()=> MapScreen(),
                                        transition: Transition.rightToLeft,
                                        duration: Duration(milliseconds: 300)
                                    );
                                  },
                                  child: Image.asset(AppImages.directionIcon, scale: 4.5,),
                                ),
                              )*/
                            ],
                          )),
                        ],
                      ),
                      SizedBox(height: 16),
                      // Organizer section
                      /*Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(
                                data.organizer?.profilePicture ??
                                placeholderImage), // Organizer image
                          ),
                          SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data.organizer?.name ?? '',
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
                              onTap: () {}
                          )
                        ],
                      ),
                      SizedBox(height: 16),*/
                      // About event section
                      Text(
                        'about_event'.tr,
                        style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      // Expanded text with "Read More" functionality
                      ReadMoreText(
                        data.aboutEvent ?? 'unavailable_event_details'.tr,
                        trimLines: 3,
                        colorClickableText: Colors.teal,
                        trimMode: TrimMode.Line,
                        trimCollapsedText: 'read_more'.tr,
                        trimExpandedText: 'read_less'.tr,
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

              // show members container
              Positioned(
                top: 160,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: ResponsiveHelper.w(context, 300),
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
                            data.recommendableUsers.length > 3 ? 3 : data.recommendableUsers.length,
                                (index) {
                              return Align(
                                  widthFactor: 0.6,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: CustomNetworkImage(
                                        imageUrl: data.recommendableUsers[index].profilePicture ?? placeholderImage,
                                        height: 40,
                                        width: 40,
                                      )
                                  )
                              );
                            },
                          ),
                        ),
                        SizedBox(width: 20),
                        Text(
                          '${data.recommendableUsers.length} ' + 'people'.tr,
                          style: GoogleFonts.poppins(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        widthBox20,
                        Roundbutton(
                          width: ResponsiveHelper.w(context, 70),
                          padding_vertical: 5,
                          borderRadius: 4,
                          fontSize: 12,
                          title: "invite".tr,
                          onTap: () {
                            // Get.to(
                            //         () => SelectedContactScreen(),
                            //     transition: Transition.downToUp,
                            //     duration: Duration(milliseconds: 300)
                            // );
                            LocalStorage.saveData(key: eventIdForInviteEvent, data: data.id);
                            Get.to(
                                    () => InviteMemberFromEvent(),
                                transition: Transition.downToUp,
                                duration: Duration(milliseconds: 300)
                            );
                          },
                        )
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
