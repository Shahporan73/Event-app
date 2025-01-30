// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';
import 'package:event_app/data/api/end_point.dart';
import 'package:event_app/data/token_manager/local_storage.dart';
import 'package:event_app/res/app_colors/App_Colors.dart';
import 'package:event_app/res/app_images/App_images.dart';
import 'package:event_app/res/common_widget/RoundButton.dart';
import 'package:event_app/res/common_widget/custom_drop_down_widget.dart';
import 'package:event_app/res/common_widget/custom_network_image_widget.dart';
import 'package:event_app/res/common_widget/custom_text.dart';
import 'package:event_app/res/common_widget/responsive_helper.dart';
import 'package:event_app/res/custom_style/custom_size.dart';
import 'package:event_app/view/create_event_view/controller/create_event_controller.dart';
import 'package:event_app/view/home_view/model/category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'map_screen.dart';

class CreateEventBySearchScreen extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String placeId;

  CreateEventBySearchScreen({super.key,
    required this.latitude,
    required this.longitude,
    required this.placeId
  });
  @override
  State<CreateEventBySearchScreen> createState() => _CreateEventBySearchScreenState();
}

class _CreateEventBySearchScreenState extends State<CreateEventBySearchScreen> {
  // Function to select Date
  String date = '';
  String sTime = '';
  String eTime = '';
  DateTime? selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      // Update the selectedDate variable
      selectedDate = pickedDate;

      // Convert the selected date to ISO 8601 format
      date = '${pickedDate.day}-${pickedDate.month}-${pickedDate.year}';
      controller.eventSelectedDate.value = pickedDate.toIso8601String();
    }
  }

  Future<void> _selectTime(BuildContext context, bool isOpening) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null && selectedDate != null) {
      // Combine the selected time with the selected date
      DateTime selectedDateTime = DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
        pickedTime.hour,
        pickedTime.minute,
      );

      // Ensure the selected time is in the future
      final now = DateTime.now();
      if (selectedDateTime.isBefore(now)) {
        // Adjust time to the future (add 1 hour, for example)
        selectedDateTime = selectedDateTime.add(Duration(hours: 1)); // Adjust this as necessary
      }

      // Store the selected time in local time (without converting to UTC)
      String isoTime = selectedDateTime.toIso8601String(); // Keep it in local time

      String formattedTime = pickedTime.format(context);

      if (isOpening) {
        // If it's opening time, store it in controller
        sTime = formattedTime;
        controller.eventStartTime.value = isoTime; // Store local time
      } else {
        // If it's closing time, store it in controller
        eTime = formattedTime;
        controller.eventEndTime.value = isoTime; // Store local time

        // Ensure that the end time is after the start time
        DateTime startTime = DateTime.parse(controller.eventStartTime.value);
        DateTime endTime = DateTime.parse(controller.eventEndTime.value);

        if (endTime.isBefore(startTime)) {
          // Handle case where end time is before start time
          // Adjust the end time to be 1 hour after the start time (or any suitable adjustment)
          endTime = startTime.add(Duration(hours: 1)); // Example: add 1 hour to the end time
          controller.eventEndTime.value = endTime.toIso8601String(); // Store adjusted local time
          eTime = DateFormat("h:mm a").format(endTime); // Update the formatted end time
        }
      }
    } else {
      // Handle case where selectedDate is null (no date selected yet)
      print("Please select a date first.");
      Get.rawSnackbar(message: "Please select a date first.");
    }
  }



  final CreateEventController controller = Get.put(CreateEventController());

  String name = LocalStorage.getData(key: 'search_name');
  String address = LocalStorage.getData(key: 'search_address');


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.fetchPlaceDetails(widget.placeId);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    String mapImgURL = 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=${LocalStorage.getData(key: 'photo_reference')}&key=${Endpoints.mapApiKey}';
    print('mapImgURL ====> $mapImgURL');
    print('rating ====> ${controller.eventRating.value}');
    print('totalReviews ====> ${controller.totalReviews.value}');
    print('controller img url ====> ${controller.imgUrl.value}');
    print('latitude ====> ${LocalStorage.getData(key: 'latitude')}');
    print('longitude ====> ${LocalStorage.getData(key: 'longitude')}');
    controller.address.value = address;
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SingleChildScrollView(
        child: Obx(
          () {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: width,
                  height: ResponsiveHelper.h(context, 250),
                  child: Stack(
                    children: [
                      controller.imgUrl.value.isNotEmpty
                          ? controller.imgUrl.value.startsWith('http')  // If it's a network image
                          ? CustomNetworkImage(
                        imageUrl: controller.imgUrl.value,
                        fit: BoxFit.cover,
                        height: ResponsiveHelper.h(context, 250),
                        width: width,
                      )
                          : Image.file(
                        File(controller.imgUrl.value),  // If it's a local image
                        fit: BoxFit.cover,
                        width: width,
                        height: ResponsiveHelper.h(context, 250),
                      )
                          : CustomNetworkImage(  // If no image is selected, show map image
                        imageUrl: mapImgURL,
                        fit: BoxFit.cover,
                        height: ResponsiveHelper.h(context, 250),
                        width: width,
                      ),
                      Positioned(
                        bottom: 10,
                          right: 10,
                          child: GestureDetector(
                            onTap: () async {
                              // Trigger the image picker when the button is clicked
                             await controller.pickImage();
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                shape: BoxShape.circle
                              ),
                              child: Image.asset(AppImages.editButton, scale: 4),
                            ),
                          ),
                      ),
                    ],
                  ),
                ),

               /* heightBox10,
                CustomNetworkImage(
                    imageUrl: mapImgURL,
                    height: 200,
                    width: width
                ),*/

                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // title and rating
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child:  CustomText(
                            title: name.isNotEmpty? name : "not_found".tr,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.black100,
                          ),),
                          Expanded(
                            child:  Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                RatingBarIndicator(
                                  itemSize: 16,
                                  rating: (controller.eventRating.value ?? 0.0).toDouble(),
                                  itemCount: 5,
                                  direction: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    );
                                  },
                                ),
                                SizedBox(width: 0),
                                Text(
                                  '${controller.eventRating.value} ${controller.totalReviews.value != '' ? '(${controller.totalReviews.value})' : ''}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),),

                        ],
                      ),

                      // location and direction
                      heightBox5,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            color: Color(0xff5C5C5C),
                            size: 16,
                          ),
                          Expanded(child: Text(
                            address.isNotEmpty? address : '',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff5C5C5C),
                            ),
                          )),
                        ],
                      ),

                      // Align(
                      //   alignment: Alignment.centerRight,
                      //   child: GestureDetector(
                      //     onTap: () {
                      //       Get.to(
                      //             () => MapScreen(),
                      //         transition: Transition.rightToLeft,
                      //         duration: const Duration(milliseconds: 300),
                      //       );
                      //     },
                      //     child: Image.asset(AppImages.directionIcon, scale: 4,),
                      //   ),
                      // ),


                      // Event name field
                      heightBox20,
                      CustomText(
                        title: "event_name".tr,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: AppColors.black33,
                      ),
                      heightBox8,
                      TextField(
                        controller: controller.nameController,
                        decoration: InputDecoration(
                          hintText: 'enter_event_name'.tr,
                          hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),


                      // Event Type section
                      heightBox20,
                      CustomText(
                        title: "event_type".tr,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: AppColors.black33,
                      ),
                      heightBox8,
                      Row(
                        children: [
                          Expanded(
                            child: Roundbutton(
                              buttonColor: controller.eventType.value == 'PUBLIC'
                                  ? AppColors.primaryColor
                                  : AppColors.whiteColor,
                              borderRadius: 8,
                              titleColor:
                              controller.eventType.value == 'PUBLIC'
                                  ? Colors.white
                                  : Colors.black,
                              title: "public".tr,
                              border: controller.eventType.value == 'PUBLIC'
                                  ? Border.all(color: AppColors.primaryColor, width: 1)
                                  : null,
                              onTap: () {
                                controller.eventType.value = 'PUBLIC';  // Select Public
                              },
                            ),
                          ),
                          widthBox10,
                          Expanded(
                            child: Roundbutton(
                              buttonColor: controller.eventType.value == 'PRIVATE'
                                  ? AppColors.primaryColor
                                  : AppColors.whiteColor,
                              borderRadius: 8,
                              titleColor:
                              controller.eventType.value == 'PRIVATE'
                                  ? Colors.white
                                  : Colors.black,
                              title: "private".tr,
                              border: controller.eventType.value == 'PRIVATE'
                                  ? Border.all(color: AppColors.primaryColor, width: 1)
                                  : null,
                              onTap: () {
                                controller.eventType.value = 'PRIVATE';  // Select Private
                              },
                            ),
                          ),
                        ],
                      ),

                      // Category section
                      heightBox20,
                      CustomText(
                        title: "category".tr,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: AppColors.black33,
                      ),
                      heightBox8,
                      CustomDropDownWidget(
                          selectedValue: controller.selectedCatName.value,
                          items: controller.categoryList
                              .where((e) => e.name != null && e.name!.isNotEmpty) // Filter out null or empty names
                              .map((e) => e.name ?? '')
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              print("value ====> $value");
                              controller.selectedCatName.value = value;
                              // You can also find the corresponding category ID based on the selected name
                              CategoryList selectedCategory = controller.categoryList.firstWhere(
                                    (category) => category.name == value,
                              );
                              controller.selectedCatId.value = selectedCategory.id!;
                              print("selectedCatId ====> ${controller.selectedCatId.value}");
                            }
                          },
                          hintText: 'Select category event'
                      ),

                      // Select Date
                      heightBox20,
                      CustomText(
                        title: "Select_date".tr,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: AppColors.black33,
                      ),
                      heightBox8,
                      TextField(
                        readOnly: true,
                        decoration: InputDecoration(
                          prefixIcon: GestureDetector(
                            onTap: () => _selectDate(context), // Open the date picker
                            child: Icon(
                              Icons.calendar_month_outlined,
                              color: Colors.grey,
                            ),
                          ),
                          hintText: controller.eventSelectedDate.value.isNotEmpty
                              ? date // Display selected date or placeholder
                              : 'Select_date'.tr,
                          hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        onTap: () => _selectDate(context), // Open date picker on tap
                      ),

                      // Select Time
                      heightBox20,
                      CustomText(
                        title: "Select_time".tr,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: AppColors.black33,
                      ),
                      heightBox8,
                      Row(
                        children: [
                          // Open Time Field
                          Expanded(
                            child: TextField(
                              readOnly: true,
                              decoration: InputDecoration(
                                prefixIcon: GestureDetector(
                                  onTap: () => _selectTime(context, true), // Open time picker for opening time
                                  child: Icon(
                                    Icons.access_time,
                                    color: Colors.grey,
                                  ),
                                ),
                                hintText: controller.eventStartTime.value.isNotEmpty
                                    ? sTime // Display selected time or placeholder
                                    : 'opening_time'.tr,
                                hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                              onTap: () => _selectTime(context, true), // Open time picker for opening time
                            ),
                          ),
                          widthBox10,
                          // Close Time Field
                          Expanded(
                            child: TextField(
                              readOnly: true,
                              decoration: InputDecoration(
                                prefixIcon: GestureDetector(
                                  onTap: () => _selectTime(context, false), // Open time picker for closing time
                                  child: Icon(
                                    Icons.access_time,
                                    color: Colors.grey,
                                  ),
                                ),
                                hintText: controller.eventEndTime.value.isNotEmpty
                                    ? eTime // Display selected time or placeholder
                                    : 'closing_time'.tr,
                                hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onTap: () => _selectTime(context, false), // Open time picker for closing time
                            ),
                          ),
                        ],
                      ),



                      // About Event
                      heightBox20,
                      CustomText(
                        title: "about_event".tr,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: AppColors.black33,
                      ),
                      heightBox8,
                      TextField(
                        maxLines: 3,
                        controller: controller.aboutEventController,
                        decoration: InputDecoration(
                          hintText: 'enter_event_description'.tr,
                          hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),

                      heightBox20,
                      Roundbutton(
                        isLoading: controller.isLoading.value,
                        title: "select_contact".tr,
                        onTap: () {

                          controller.createEventBySearch(controller.imgUrl.value.isEmpty ? mapImgURL : controller.imgUrl.value);
                          /*Get.to(
                                () => SelectedContactScreen(),
                            transition: Transition.rightToLeft,
                            duration: const Duration(milliseconds: 500),
                          );*/
                        },
                      ),
                      heightBox50,

                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
