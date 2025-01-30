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
import 'package:event_app/res/custom_style/formate_time.dart';
import 'package:event_app/view/create_event_view/controller/edit_event_controller.dart';
import 'package:event_app/view/home_view/model/category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EditEventScreen extends StatelessWidget {
  EditEventScreen({super.key});

  final EditEventController controller = Get.put(EditEventController());
  DateTime? selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      selectedDate = pickedDate;

      // Update the controller with the new selected date
      controller.eventSelectedDate.value = selectedDate.toString();
    }
  }

  Future<void> _selectTime(BuildContext context, bool isOpening) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      if (selectedDate == null) {
        Get.rawSnackbar(message: "Please select a date first.");
        return;
      }

      // Combine the selected date with the picked time
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
        Get.rawSnackbar(message: "Time must be in the future.");
        return;
      }

      // Format the time for display purposes
      String isoTime = selectedDateTime.toIso8601String();
      String formattedTime = convertFormatTime12hr(isoTime);

      if (isOpening) {
        // Update the start time
        controller.eventStartTime.value = isoTime; // Store as ISO 8601
        print("Updated Start Time: $formattedTime");

        // Validate the end time
        if (controller.eventEndTime.value.isNotEmpty) {
          DateTime endTime = DateTime.parse(controller.eventEndTime.value);
          if (endTime.isBefore(selectedDateTime)) {
            Get.rawSnackbar(message: "Start time cannot be after end time.");
            return;
          }
        }
      } else {
        // Ensure the end time is after the start time
        if (controller.eventStartTime.value.isNotEmpty) {
          DateTime startTime = DateTime.parse(controller.eventStartTime.value);
          if (selectedDateTime.isBefore(startTime)) {
            Get.rawSnackbar(message: "End time must be after start time.");
            return;
          }
        }

        // Update the end time
        controller.eventEndTime.value = isoTime; // Store as ISO 8601
        print("Updated End Time: $formattedTime");
      }
    }
  }




  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    // Initialize selectedDate from the controller
    if (controller.eventSelectedDate.value.isNotEmpty) {
      selectedDate = DateTime.parse(controller.eventSelectedDate.value);
    }
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
                    appBarName: "update_event".tr,
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
                    title: "event_name".tr,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: AppColors.black33,
                  ),
                  heightBox8,
                  TextField(
                    controller: controller.eventNameController,
                    decoration: InputDecoration(
                      hintText: 'enter_event_name'.tr,
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
                    title: "address".tr,
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
                      hintText: 'enter_address'.tr,
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
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
                      hintText: 'select_category_event'.tr
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
                          ? formattedDateMethod(controller.eventSelectedDate.value) // Display selected date or placeholder
                          : 'Select_date'.tr,
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onTap: () => _selectDate(context), // Open date picker on tap
                  ),

                  // opening time and closing time
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
                                ? convertFormatTime12hr(controller.eventStartTime.value) // Display selected time or placeholder
                                : 'opening_time'.tr,
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
                                ? convertFormatTime12hr(controller.eventEndTime.value) // Display selected time or placeholder
                                : 'closing_time'.tr,
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
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
                    controller: controller.eventAboutController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'enter_event_description'.tr,
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
                    title: "update_event".tr,
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

