// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:event_app/res/app_colors/App_Colors.dart';
import 'package:event_app/res/app_images/App_images.dart';
import 'package:event_app/res/common_widget/RoundButton.dart';
import 'package:event_app/res/common_widget/custom_app_bar.dart';
import 'package:event_app/res/common_widget/custom_text.dart';
import 'package:event_app/res/custom_style/custom_size.dart';
import 'package:event_app/view/event_view/view/comment_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../res/common_widget/custom_network_image_widget.dart';

class UserProfileScreen extends StatelessWidget {
  UserProfileScreen({super.key});
  final List<String> imageUrls = [
    'https://www.perfocal.com/blog/content/images/2021/01/Perfocal_17-11-2019_TYWFAQ_100_standard-3.jpg',
    'https://www.perfocal.com/blog/content/images/2021/01/Perfocal_17-11-2019_TYWFAQ_100_standard-3.jpg',
    'https://www.perfocal.com/blog/content/images/2021/01/Perfocal_17-11-2019_TYWFAQ_100_standard-3.jpg',
    'https://www.perfocal.com/blog/content/images/2021/01/Perfocal_17-11-2019_TYWFAQ_100_standard-3.jpg',
    'https://www.perfocal.com/blog/content/images/2021/01/Perfocal_17-11-2019_TYWFAQ_100_standard-3.jpg',
    // Add more URLs as needed
  ];

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
                CustomAppBar(
                  appBarName: "Profile",
                  onTap: () {
                    Get.back();
                  },
                ),

                heightBox20,

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      // margin: EdgeInsets.all(5),
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.primaryColor),
                        shape: BoxShape.circle,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100.r),
                        child: CustomNetworkImage(
                          imageUrl: 'https://picsum.photos/250?image=9',
                          width: 100.w,
                          height: 100.h,
                        ),
                      ),
                    ),
                    widthBox10,
                    Expanded(
                      child: CustomText(
                        title: 'Istiak Ahmed',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.blackColor
                    ),),
                  ],
                ),

                //post , follower and following
                heightBox20,
                Row(
                  children: [
                    // post
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(right: BorderSide(width: 1, color: Colors.grey )),
                        ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            title: 'Posts',
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff52697E),
                          ),
                          heightBox5,
                          CustomText(
                            title: '150',
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: AppColors.blackColor,
                          ),

                        ],
                      ),
                    ),
                    ),
                    // follower
                    25.widthBox,
                    Expanded(child: Container(
                      decoration: BoxDecoration(
                        border: Border(right: BorderSide(width: 1, color: Colors.grey )),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CustomText(
                            title: 'Followers',
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff52697E),
                          ),
                          heightBox5,
                          CustomText(
                            title: '824',
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: AppColors.blackColor,
                          ),

                        ],
                      ),
                    ),),
                    // following
                    25.widthBox,
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          title: 'Following',
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff52697E),
                        ),
                        heightBox5,
                        CustomText(
                          title: '162',
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: AppColors.blackColor,
                        ),

                      ],
                    ),),
                  ],
                ),

                // follow and chat button
                heightBox20,
                Row(
                  children: [
                    Expanded(child: Roundbutton(
                      padding_vertical: 8,
                      borderRadius: 8,
                      fontSize: 14,
                      title: "Follow",
                      onTap: (){},
                    ),),
                    widthBox20,
                    Container(
                      width: 80.w,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(8.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 10,
                            blurRadius: 10,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: CustomText(
                          title: "Chat",
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.blackColor
                      ),
                    ),
                  ],
                ),

                // about
                heightBox10,
                Center(
                  child: CustomText(
                      title: "Posts",
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryColor
                  ),
                ),
                Divider(),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Card(
                      color: AppColors.bgColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      'https://www.perfocal.com/blog/content/images/2021/01/Perfocal_17-11-2019_TYWFAQ_100_standard-3.jpg'),
                                  radius: 25,
                                ),
                                SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Ralph Edwards',
                                      style: GoogleFonts.poppins(
                                          fontSize: 14.sp,
                                          color: AppColors.blackColor,
                                          fontWeight: FontWeight.w400
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      '2 minutes',
                                      style: GoogleFonts.poppins(
                                          fontSize: 12.sp,
                                          color: AppColors.black100,
                                          fontWeight: FontWeight.w400
                                      ),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                PopupMenuButton<int>(
                                  icon: Icon(Icons.more_horiz, color: Colors.grey), // Trigger icon
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side: BorderSide(color: Colors.teal, width: 1),
                                  ),
                                  elevation: 8,
                                  offset: Offset(0, 40),
                                  onSelected: (value) {
                                    // Handle selection here
                                    if (value == 1) {
                                      print("Edit selected");
                                    } else if (value == 2) {
                                      print("Delete selected");
                                    }
                                  },
                                  itemBuilder: (context) => [
                                    // Edit option
                                    PopupMenuItem(
                                      value: 1,
                                      child: Row(
                                        children: [
                                          Icon(Icons.edit, color: Colors.teal),
                                          SizedBox(width: 8),
                                          Text(
                                            'Edit',
                                            style: TextStyle(color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Divider between items
                                    PopupMenuDivider(),
                                    // Delete option
                                    PopupMenuItem(
                                      value: 2,
                                      child: Row(
                                        children: [
                                          Icon(Icons.delete, color: Colors.red),
                                          SizedBox(width: 8),
                                          Text(
                                            'Delete',
                                            style: TextStyle(color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Look my collection, I really want to share about my last trip to Bali. Please check guys!',
                              style: GoogleFonts.poppins(
                                  fontSize: 12.sp,
                                  color: AppColors.blackColor,
                                  fontWeight: FontWeight.w400
                              ),
                            ),
                            SizedBox(height: 10),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: imageUrls.length == 1 ? 1 : 2, // Full width if single image
                                mainAxisSpacing: 4,
                                crossAxisSpacing: 4,
                                childAspectRatio: 1.6,
                              ),
                              itemCount: imageUrls.length > 4 ? 4 : imageUrls.length,
                              itemBuilder: (context, index) {
                                if (index == 3 && imageUrls.length > 4) {
                                  // Display the overlay with additional image count
                                  return Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      CustomNetworkImage(
                                        imageUrl: imageUrls[index],
                                        height: height, width: width,
                                      ),
                                      Container(
                                        color: Colors.black54,
                                        child: Center(
                                          child: Text(
                                            '+${imageUrls.length - 3}', // Show count of remaining images
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  // Display regular images
                                  return CustomNetworkImage(
                                    imageUrl: imageUrls[index],
                                    height: height, width: width,
                                  );
                                }
                              },
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Row(
                                  children: [
                                    Image.asset(AppImages.likeIcon, scale: 4),
                                    SizedBox(width: 4),
                                    CustomText(
                                      title: "24k",
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15,
                                      color: Color(0xff6A798A),
                                    ),
                                  ],
                                ),
                                widthBox20,
                                GestureDetector(
                                  onTap: () {
                                    // Handle comment tap
                                    Get.to(
                                            () => CommentScreen(),
                                        transition: Transition.downToUp,
                                        duration: Duration(milliseconds: 300)
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      Image.asset(AppImages.commentIcon, scale: 4),
                                      SizedBox(width: 4),
                                      CustomText(
                                        title: "50k",
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15,
                                        color: Color(0xff6A798A),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
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
