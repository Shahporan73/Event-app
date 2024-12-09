// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:event_app/res/common_widget/custom_network_image_widget.dart';
import 'package:event_app/res/custom_style/custom_size.dart';
import 'package:event_app/view/message_view/view/see_all_memeber_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../res/app_colors/App_Colors.dart';

class CommunityDetailsScreen extends StatefulWidget {
  const CommunityDetailsScreen({super.key});

  @override
  State<CommunityDetailsScreen> createState() => _CommunityDetailsScreenState();
}

class _CommunityDetailsScreenState extends State<CommunityDetailsScreen> {
  String groupName = "Bachata Restaurant"; // Initial name
  final TextEditingController _nameController = TextEditingController();
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Message"),
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // =========== group top section
              Column(
                children: [
                  // Group Avatar Section with Edit Icon
                  Center(
                    child: Stack(
                      children: [
                        GestureDetector(
                          // onTap: () => showImageDialog(context, imageUrl),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100.r),
                            child: CustomNetworkImage(
                              imageUrl: "https://t3.ftcdn.net/jpg/02/43/12/34/360_F_243123463_zTooub557xEWABDLk0jJklDyLSGl2jrr.jpg",
                              width: 180.w,
                              height: 180.h,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 6,
                          right: 15,
                          child: GestureDetector(
                            onTap: () async {
                              _showImagePickerDialog(context);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: 34.w,
                              height: 34.h,
                              decoration: BoxDecoration(
                                color: AppColors.whiteColor,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                              ),
                              child: Icon(
                                Icons.camera_alt_outlined,
                                color: AppColors.blackColor,
                                size: 28.w.h,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Group Name and Edit Icon
                  heightBox20,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        groupName,
                        style: GoogleFonts.roboto(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          _showChangeNameDialog(context);
                        },
                        child: Icon(Icons.edit, size: 24), // Edit icon
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    "10 Members",
                    style: GoogleFonts.roboto(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),

              // =========== group top section
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Get.to(() => SeeAllMemeberScreen(),
                      transition: Transition.rightToLeft,
                      duration: Duration(milliseconds: 500)
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor, // Replace with your desired color
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 50,
                            height: 50,
                            child: Row(
                              children: List.generate(
                                3,
                                    (index) => Align(
                                  widthFactor: 0.3,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: Image.network(
                                      'https://t3.ftcdn.net/jpg/02/43/12/34/360_F_243123463_zTooub557xEWABDLk0jJklDyLSGl2jrr.jpg', // Replace with actual URLs
                                      height: 40,
                                      width: 40,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            "See all members",
                            style: GoogleFonts.urbanist(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Icon(Icons.navigate_next, color: Colors.white, size: 28),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Footer section
              Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.image, size: 24.sp),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Media, Links & Documents",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                              fontSize: 14.sp,
                              color: AppColors.black100
                            ),
                        ),
                        Text("152",  style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp,
                            color: AppColors.primaryColor
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      // Action for media links
                    },
                  ),

                  ListTile(
                    leading: Icon(Icons.notifications_off, size: 24.sp),
                    title: Text(
                      "Mute Notification",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                        color: AppColors.black100,
                      ),
                    ),
                    trailing: Switch(
                      activeColor: AppColors.primaryColor,
                      value: isChecked,
                      onChanged: (value) {
                        setState(() {
                          isChecked = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.logout, size: 24.sp, color: Colors.red),
                    title: Text("Leave Community", style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                        color: AppColors.black100
                    ),),
                    onTap: () {
                      _showLeaveGroupDialog(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  Future<void> _showImagePickerDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select an image'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Gallery'),
              onTap: () {
                // Add logic for selecting an image from the gallery
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Camera'),
              onTap: () {
                // Add logic for taking a new image with the camera
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showChangeNameDialog(BuildContext context) {
    _nameController.text = groupName;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Change Name"),
          content: TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: "Enter new group name"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  groupName = _nameController.text;
                });
                Navigator.of(context).pop();
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void _showLeaveGroupDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Leave Group"),
        content: Text("Are you sure you want to leave this group?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              // Logic for leaving the group
              Navigator.of(context).pop();
            },
            child: Text("Leave", style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          ),
        ],
      ),
    );
  }
}
