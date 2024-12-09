// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:dotted_border/dotted_border.dart';
import 'package:event_app/res/app_colors/App_Colors.dart';
import 'package:event_app/res/common_widget/RoundButton.dart';
import 'package:event_app/res/common_widget/custom_app_bar.dart';
import 'package:event_app/res/common_widget/custom_dotted_widget.dart';
import 'package:event_app/res/common_widget/custom_text.dart';
import 'package:event_app/res/custom_style/custom_size.dart';
import 'package:event_app/view/create_event_view/view/congratulation_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'selected_contact_screen.dart';

class CreateEventByMapScreen extends StatefulWidget {
  const CreateEventByMapScreen({super.key});

  @override
  State<CreateEventByMapScreen> createState() => _CreateEventByMapScreenState();
}

class _CreateEventByMapScreenState extends State<CreateEventByMapScreen> {
  // List of event categories
  final List<String> categories = [
    'Music',
    'Sports',
    'Art',
    'Conference',
    'Festival',
    'Workshop',
  ];

  String? selectedCategory; // Set initial value to null
  DateTime? selectedDate;

  TimeOfDay? openTime;
  TimeOfDay? closeTime;

  bool isPublicSelected = true;
  bool isPrivateSelected = false;

  List<int> selectedContactIndices = [];


  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isOpening) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        if (isOpening) {
          openTime = pickedTime;
        } else {
          closeTime = pickedTime;
        }
      });
    }
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
                // appbar
                CustomAppBar(
                  appBarName: "Create Event",
                  onTap: () {
                    Get.back();
                  },
                ),
                heightBox20,
                CustomDottedWidget(
                  containerHeight: 120,
                  centerWidget: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add,
                        color: AppColors.primaryColor,
                      ),
                      heightBox5,
                      CustomText(
                        title: "Upload Banner",
                        color: AppColors.primaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
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
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.location_on_outlined,
                      color: Colors.grey,
                    ),
                    hintText: '1012 Ocean avenue, New York',
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
                        buttonColor: isPublicSelected
                            ? AppColors.primaryColor
                            : AppColors.whiteColor,
                        borderRadius: 8,
                        titleColor:
                            isPublicSelected ? Colors.white : Colors.black,
                        title: "Public",
                        border: isPublicSelected
                            ? Border.all(
                                color: AppColors.primaryColor, width: 1)
                            : null,
                        onTap: () {
                          setState(() {
                            isPublicSelected = true;
                            isPrivateSelected = false; // Deselect Private
                          });
                        },
                      ),
                    ),
                    widthBox10,
                    Expanded(
                      child: Roundbutton(
                        buttonColor: isPrivateSelected
                            ? AppColors.primaryColor
                            : AppColors.whiteColor,
                        borderRadius: 8,
                        titleColor:
                            isPrivateSelected ? Colors.white : Colors.black,
                        title: "Private",
                        border: isPrivateSelected
                            ? Border.all(
                                color: AppColors.primaryColor, width: 1)
                            : null,
                        onTap: () {
                          setState(() {
                            isPrivateSelected = true;
                            isPublicSelected = false; // Deselect Public
                          });
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
                Container(
                  width: width,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  child: DropdownButton<String>(
                    value: selectedCategory,
                    hint: Text(
                      'Select category event',
                      style: TextStyle(color: Colors.grey, fontSize: 14.sp),
                    ),
                    onChanged: (String? newCategory) {
                      setState(() {
                        selectedCategory = newCategory;
                      });
                    },
                    items: categories.map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    isExpanded: true,
                    underline: SizedBox(),
                  ),
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
                    hintText: selectedDate != null
                        ? '${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}'
                        : 'Select date', // Display selected date or placeholder
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
                            onTap: () => _selectTime(context, true), // Open time picker
                            child: Icon(
                              Icons.watch_later_outlined,
                              color: Colors.grey,
                            ),
                          ),
                          hintText: openTime != null
                              ? openTime!.format(context)
                              : 'Open time', // Display selected time or placeholder
                          hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        onTap: () => _selectTime(context, true), // Open time picker on tap
                      ),
                    ),
                    widthBox10,
                    // Close Time Field
                    Expanded(
                      child: TextField(
                        readOnly: true,
                        decoration: InputDecoration(
                          prefixIcon: GestureDetector(
                            onTap: () => _selectTime(context, false), // Close time picker
                            child: Icon(
                              Icons.watch_later_outlined,
                              color: Colors.grey,
                            ),
                          ),
                          hintText: closeTime != null
                              ? closeTime!.format(context)
                              : 'Close time', // Display selected time or placeholder
                          hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        onTap: () => _selectTime(context, false), // Close time picker on tap
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
                  title: "Select Contact",
                  onTap: () {
                    Get.to(
                      () => SelectedContactScreen(),
                      transition: Transition.rightToLeft,
                      duration: const Duration(milliseconds: 500),
                    );
                  },
                ),

                heightBox50,

              ],
            ),
          ),
        ),
      ),
    );
  }
}
