// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';
import 'package:event_app/res/app_colors/App_Colors.dart';
import 'package:event_app/res/common_widget/RoundButton.dart';
import 'package:event_app/res/common_widget/custom_app_bar.dart';
import 'package:event_app/res/common_widget/custom_dotted_widget.dart';
import 'package:event_app/res/common_widget/custom_drop_down_widget.dart';
import 'package:event_app/res/common_widget/custom_network_image_widget.dart';
import 'package:event_app/res/common_widget/custom_text.dart';
import 'package:event_app/res/common_widget/responsive_helper.dart';
import 'package:event_app/res/custom_style/custom_size.dart';
import 'package:event_app/view/create_event_view/controller/edit_event_controller.dart';
import 'package:event_app/view/home_view/model/category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class EditEventScreen extends StatelessWidget {
  EditEventScreen({super.key});

  String date = '';
  String sTime = '';
  String eTime = '';

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
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

    if (pickedTime != null) {
      final now = DateTime.now();

      // Combine the selected time with the current date
      DateTime selectedDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        pickedTime.hour,
        pickedTime.minute,
      );

      // Ensure the selected time is in the future
      if (selectedDateTime.isBefore(now)) {
        // Adjust time to the future (add 1 hour, for example)
        selectedDateTime = selectedDateTime.add(Duration(hours: 1));  // Adjust this as necessary
      }

      // Convert the selected time to UTC
      String isoTime = selectedDateTime.toUtc().toIso8601String();

      String formattedTime = pickedTime.format(context);

      if (isOpening) {
        // If it's opening time, store it in controller
        sTime = formattedTime;
        controller.eventStartTime.value = isoTime;
      } else {
        // If it's closing time, store it in controller
        eTime = formattedTime;
        controller.eventEndTime.value = isoTime;

        // Ensure that the end time is after the start time
        DateTime startTime = DateTime.parse(controller.eventStartTime.value);
        DateTime endTime = DateTime.parse(controller.eventEndTime.value);

        if (endTime.isBefore(startTime)) {
          // Handle case where end time is before start time
          // Adjust the end time to be 1 hour after the start time (or any suitable adjustment)
          endTime = startTime.add(Duration(hours: 1)); // Example: add 1 hour to the end time
          controller.eventEndTime.value = endTime.toUtc().toIso8601String();
          eTime = endTime.toLocal().toString(); // Update the formatted end time
        }
      }
    }
  }

  final EditEventController controller = Get.put(EditEventController());

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
                  () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // appbar
                  CustomAppBar(
                    appBarName: "Update Event",
                    onTap: () {
                      Get.back();
                    },
                  ),
                  heightBox20,
                  GestureDetector(
                    onTap: () async {
                      await controller.pickImage(); // Allow picking a new image
                    },
                    child: controller.imgUrl.isNotEmpty
                        ? CustomNetworkImage(
                      imageUrl: controller.imgUrl.value, // Display network image
                      height: ResponsiveHelper.h(context, 120),
                      width: width,
                    )
                        : CustomNetworkImage(
                      imageUrl: controller.imgUrl.value, // Display network image
                      height: ResponsiveHelper.h(context, 120),
                      width: width,
                    ),
                  ),

                  // Event name field
                  heightBox20,
                  CustomText(
                    title: "Event name",
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: AppColors.black33,
                  ),
                  heightBox8,
                  TextField(
                    controller: controller.eventNameController,
                    decoration: InputDecoration(
                      hintText: 'Enter event name',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),

                  // Event address field
                  heightBox20,
                  CustomText(
                    title: "Address",
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: AppColors.black33,
                  ),
                  heightBox8,
                  TextField(
                    controller: controller.eventAddressController.value,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.location_on_outlined,
                        color: Colors.grey,
                      ),
                      hintText: 'Enter address',
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
                    title: "Event Type",
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
                          title: "PUBLIC",
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
                          title: "PRIVATE",
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
                    title: "Category",
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
                    title: "Select Date",
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
                          ? controller.eventSelectedDate.value // Display selected date or placeholder
                          : 'Select date',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    onTap: () => _selectDate(context), // Open date picker on tap
                  ),

                  // opening time and closing time
                  heightBox20,
                  CustomText(
                    title: "Select Time",
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
                                ? controller.eventStartTime.value // Display selected time or placeholder
                                : 'Opening time',
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
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
                                ? controller.eventEndTime.value // Display selected time or placeholder
                                : 'Closing time',
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
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
                    title: "About Event",
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: AppColors.black33,
                  ),
                  heightBox8,
                  TextField(
                    controller: controller.eventAboutController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Type event description',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),

                  //   button

                  heightBox20,
                  Roundbutton(
                    title: "Update Event",
                    isLoading: controller.isLoading.value,
                    onTap: () async {
                      await controller.updateEvent(context);
                    },
                  ),

                  heightBox50,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

