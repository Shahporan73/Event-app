// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'package:event_app/res/app_colors/App_Colors.dart';
import 'package:event_app/res/app_images/App_images.dart';
import 'package:event_app/res/common_widget/custom_network_image_widget.dart';
import 'package:event_app/res/common_widget/custom_text.dart';
import 'package:event_app/res/common_widget/responsive_helper.dart';
import 'package:event_app/res/custom_style/custom_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../res/common_widget/picker_dialog.dart';
import 'community_details_screen.dart';

class CommunityChatScreen extends StatefulWidget {
  const CommunityChatScreen({super.key});

  @override
  State<CommunityChatScreen> createState() => _CommunityChatScreenState();
}

class _CommunityChatScreenState extends State<CommunityChatScreen> {
  // Sample data for the chat
  final List<Map<String, dynamic>> chatMessages = [
    {
      "sender": "User", // Changed to "User"
      "message": "Hey there! 👋",
      "time": "10:08",
      "isSentByMe": false,
    },
    {
      "sender": "User", // Changed to "User"
      "message":
      "Game RA 2 has just had a new update for macOS.\nThere is support for many new items and characters. 😌",
      "time": "10:08",
      "isSentByMe": false,
    },
    {
      "sender": "Me", // "Me" for messages sent by the user
      "message": "Hi!",
      "time": "10:10",
      "isSentByMe": true,
    },
    {
      "sender": "Me", // "Me" for messages sent by the user
      "message":
      "Great, thanks for letting me know! \nI really look forward to experiencing it soon. 🎉",
      "time": "10:11",
      "isSentByMe": true,
    },
    {
      "sender": "User", // Changed to "User"
      "message": "Does this update fix error 352 for the Engineer character?",
      "time": "10:11",
      "isSentByMe": false,
    },
    {
      "sender": "User", // Changed to "User"
      "message": "Does this update fix error 352 for the Engineer character?",
      "time": "10:11",
      "isSentByMe": false,
    },
    {
      "sender": "User", // Changed to "User"
      "message": "Does this update fix error 352 for the Engineer character?",
      "time": "10:11",
      "isSentByMe": false,
    },
    {
      "sender": "User", // Changed to "User"
      "message": "Does this update fix error 352 for the Engineer character?",
      "time": "10:11",
      "isSentByMe": false,
    },
    {
      "sender": "User", // Changed to "User"
      "message": "Does this update fix error 352 for the Engineer character?",
      "time": "10:11",
      "isSentByMe": false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Get the screen width and height
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(Icons.arrow_back, color: Colors.black),
                  ),
                  widthBox5,
                  Expanded(
                    child: ListTile(
                      onTap: () {
                        Get.to(
                          () => CommunityDetailsScreen(),
                          transition: Transition.downToUp,
                          duration: Duration(milliseconds: 300),
                        );
                      },
                      leading: SizedBox(
                        width: ResponsiveHelper.w(context, 50), 
                        child: Row(
                          children: List.generate(
                            3,
                                (index) => Align(
                              widthFactor: 0.3,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50), // Ensure this is not using `.r`
                                child: CustomNetworkImage(
                                  imageUrl: 'https://t3.ftcdn.net/jpg/02/43/12/34/360_F_243123463_zTooub557xEWABDLk0jJklDyLSGl2jrr.jpg',
                                  width: 40, // Adjust as needed
                                  height: 40,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      title: CustomText(
                        title: "Bachata Restaurant",
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff1D242D),
                      ),
                      subtitle: CustomText(
                        title: "112 members",
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff1D242D),
                      ),
                    ),
                  ),
                ],
              ),
            ),



            20.heightBox,

            // Chat messages section
            Expanded(
              child: ListView.builder(
                itemCount: chatMessages.length,
                itemBuilder: (context, index) {
                  final message = chatMessages[index];
                  final isSentByMe = message['isSentByMe'] as bool;

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 10.0),
                    child: Align(
                      alignment: isSentByMe
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        width: width * 0.70,
                        decoration: BoxDecoration(
                          color: isSentByMe
                              ? AppColors.secondaryColor
                              : AppColors.whiteColor,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              bottomRight: isSentByMe
                                  ? Radius.circular(0)
                                  : Radius.circular(10),
                              topLeft: isSentByMe
                                  ? Radius.circular(10)
                                  : Radius.circular(0)),

                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 10,
                              blurRadius: 10,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              message['message'],
                              style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15.sp,
                                  color: isSentByMe
                                      ? Colors.white
                                      : Color(0xff1D242D)),
                            ),
                            6.heightBox,
                            Align(
                              alignment: isSentByMe? Alignment.centerRight : Alignment.centerRight,
                              child: Text(
                                message['time'],
                                style: GoogleFonts.roboto(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    color: isSentByMe? Colors.white : AppColors.black100),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Input message field section
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.r),
                      topRight: Radius.circular(20.r)
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 10,
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    )
                  ]
              ),
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: 'Message',
                          suffixIcon: Container(
                            width: 80,
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    PickerDialog().showImagePickerDialog(context);
                                  },
                                  child: Icon(Icons.image, color: AppColors.secondaryColor,size: 26.sp,),
                                ),
                                widthBox10,
                                Container(
                                  width: 30.w,
                                  height: 30.h,
                                  decoration: BoxDecoration(
                                      color: AppColors.secondaryColor,
                                      shape: BoxShape.circle
                                  ),
                                  child: IconButton(
                                    onPressed: () {

                                    },
                                    icon: Image.asset(
                                      AppImages.sendIcon,
                                      scale: 4.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              borderSide: BorderSide.none
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              borderSide: BorderSide.none
                          )
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
