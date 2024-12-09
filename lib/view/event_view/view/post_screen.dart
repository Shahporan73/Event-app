// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'package:event_app/res/app_colors/App_Colors.dart';
import 'package:event_app/res/app_images/App_images.dart';
import 'package:event_app/res/common_widget/RoundTextField.dart';
import 'package:event_app/res/common_widget/custom_app_bar.dart';
import 'package:event_app/res/common_widget/custom_network_image_widget.dart';
import 'package:event_app/res/common_widget/custom_text.dart';
import 'package:event_app/res/common_widget/responsive_helper.dart';
import 'package:event_app/res/custom_style/custom_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'comment_screen.dart';
import 'create_post_screen.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header image
            Container(
                width: width,
                height: ResponsiveHelper.h(context, 250),
                child: Stack(
                  children: [
                    CustomNetworkImage(
                        imageUrl: 'https://mlscottsdale.com/get/files/image/galleries/Dining_Room_AZ_Shelby_Moore.jpg',
                        height: height,
                        width: width),
                    Positioned(
                      top: 35,
                      right: 0,
                      left: 0,
                      child: CustomAppBar(
                        titleColor: Colors.white,
                        appBarName: "Mexican Restaurant ",
                        widget: SizedBox(),
                      ),
                    ),
                  ],
                )),
            // details
            heightBox10,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  // name and rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        title: "Mexican Restaurant",
                        color: AppColors.black100,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '4.5',
                              style: GoogleFonts.poppins(
                                fontSize: 10.sp,
                                color: Color(0xffFEA500),
                              ),
                            ),
                            RatingBarIndicator(
                              itemSize: 12.sp,
                              rating: 4.5,
                              itemCount: 5,
                              direction: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Icon(
                                  Icons.star,
                                  color: Color(0xffFEA500),
                                );
                              },
                            ),
                            SizedBox(width: 5),
                            Text(
                              '(255)',
                              style: GoogleFonts.poppins(
                                fontSize: 10.sp,
                                color: Color(0xffFEA500),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),

                  // members
                  heightBox10,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: List.generate(
                          3,
                              (index) {
                            return Align(
                              widthFactor: 0.5,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: CustomNetworkImage(
                                    imageUrl: 'https://www.perfocal.com/blog/content/images/2021/01/Perfocal_17-11-2019_TYWFAQ_100_standard-3.jpg',
                                    height: 40,
                                    width: 40),
                              ),
                            );
                          },
                        ),
                      ),
                      widthBox20,
                      CustomText(
                          title: "150 members",
                          color: AppColors.secondaryColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 10),
                    ],
                  ),

                  // image and write something
                  heightBox20,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50.r),
                        child: CustomNetworkImage(
                            imageUrl: 'https://www.perfocal.com/blog/content/images/2021/01/Perfocal_17-11-2019_TYWFAQ_100_standard-3.jpg',
                            height: ResponsiveHelper.h(context, 50),
                            width: ResponsiveHelper.w(context, 50)),
                      ),
                      widthBox10,
                      Expanded(
                          child: RoundTextField(
                            hint: "Write something...",
                            readOnly: true,
                            borderRadius: 44.r,
                            focusBorderRadius: 44.r,
                            onTap: () {
                              Get.to(
                                () => CreatePostScreen(),
                                transition: Transition.downToUp,
                                duration: const Duration(milliseconds: 300),
                              );
                            },
                          ),
                      ),
                    ],
                  ),

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
          ],
        ),
      ),
    );
  }
}
