// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:event_app/res/app_images/App_images.dart';
import 'package:event_app/res/common_widget/RoundTextField.dart';
import 'package:event_app/res/common_widget/custom_row_widget.dart';
import 'package:event_app/res/custom_style/custom_size.dart';
import 'package:event_app/view/event_view/view/my_event_details_screen.dart';
import 'package:event_app/view/home_view/view/event_details_screen.dart';
import 'package:event_app/view/home_view/view/search_event_screen.dart';
import 'package:event_app/view/home_view/widget/category_widget.dart';
import 'package:event_app/view/home_view/widget/my_event_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../res/app_colors/App_Colors.dart';
import '../../../res/common_widget/custom_network_image_widget.dart';
import '../../../res/common_widget/custom_text.dart';
import 'notificaiton_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  var catImageList = [
    AppImages.all,
    AppImages.healthcare,
    AppImages.sports,
    AppImages.all,
  ];
  var catNameList = [
    'All',
    'Health',
    'Sports',
    'VIP',
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
                // header section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(100.r),
                          child: CustomNetworkImage(
                            imageUrl: 'https://picsum.photos/250?image=9',
                            width: 50.w,
                            height: 50.h,
                          ),
                        ),
                        title: CustomText(
                          title: 'Money Transfer',
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.blackColor,
                        ),
                        subtitle: CustomText(
                          title: 'Road 3, Rampura, Dhaka',
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: AppColors.black33,
                        ),
                      ),
                    ),

                    // notification section
                    InkWell(
                      onTap: () {
                        Get.to(
                          () => NotificaitonScreen(),
                          transition: Transition.fadeIn,
                          duration: Duration(milliseconds: 300),
                        );
                      },
                      child: Image.asset(
                        AppImages.notificationIcon,
                        scale: 4,
                      ),
                    )
                  ],
                ),

                // search section
                heightBox20,
                RoundTextField(
                  hint: "Search Places",
                  readOnly: true,
                  prefixIcon: Icon(
                    Icons.search_outlined,
                    size: 26.sp,
                  ),
                  onTap: () {
                    Get.to(
                      () => SearchEventScreen(),
                      transition: Transition.fadeIn,
                      duration: Duration(milliseconds: 300),
                    );
                  },
                  borderRadius: 44.r,
                  focusBorderRadius: 44.r,
                ),

                // category section
                heightBox20,
                SizedBox(
                  height: 60.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: catNameList.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                        child: Container(
                          color: Colors.transparent,
                          margin: EdgeInsets.only(right: 10.w),
                          padding:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                          child: CategoryWidget(
                            title: catNameList[index],
                            image: catImageList[index],
                            isSelected:
                                selectedIndex == index, // Pass selection status
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // my event section
                heightBox20,
                CustomRowWidget(
                  title: CustomText(
                    title: "My Events",
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Color(0xff1E2022),
                  ),
                  value: GestureDetector(
                    child: CustomText(
                      title: "see more",
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: AppColors.secondaryColor,
                    ),
                  ),
                ),
                heightBox10,
                SizedBox(
                  height: width * 0.45, // Responsive height for the horizontal list
                  child: ListView.builder(
                    itemCount: 5,
                    scrollDirection: Axis.horizontal,
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Get.to(
                            () => MyEventDetailsScreen(),
                            transition: Transition.leftToRight,
                            duration: Duration(milliseconds: 400),
                          );
                        },
                        child: MyEventCardWidget(
                          title: "Mexican Restaurant",
                          imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRDxbxJ9JgpzZvt8XN3V2PFLumxqQuGj0OeYA&s",
                          rating: 4.8,
                          reviews: 255,
                          location: "New York, USA",
                          date: "19 July 2021",
                          time: "21:00 - 23:00",
                        ),
                      );
                    },
                  ),
                ),




                // nearby place section
                heightBox20,
                CustomRowWidget(
                  title: CustomText(
                    title: "Near by Places",
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Color(0xff1E2022),
                  ),
                  value: GestureDetector(
                    child: CustomText(
                      title: "see more",
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: AppColors.secondaryColor,
                    ),
                  ),
                ),
                heightBox10,
                ListView.builder(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: 10,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Get.to(
                          () => EventDetailScreen(),
                      transition: Transition.leftToRight,
                      duration: Duration(milliseconds: 300),
                    );
                  },
                  child: Stack(
                    children: [
                      Container(
                        height: height * 0.30,
                        margin: EdgeInsets.only(bottom: height * 0.015),
                        padding: EdgeInsets.all(width * 0.025),
                        width: width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.4),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: CustomNetworkImage(
                                imageUrl: 'https://mlscottsdale.com/get/files/image/galleries/Dining_Room_AZ_Shelby_Moore.jpg',
                                height: height * 0.190,
                                width: width * 0.90,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "EL Tapatio Mexican Restaurant",
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: width * 0.04,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                '4.8',
                                                style: GoogleFonts.poppins(
                                                  color: Colors.orange,
                                                  fontSize: width * 0.03,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              RatingBarIndicator(
                                                rating: 2.75,
                                                itemBuilder: (context, index) => Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                ),
                                                itemCount: 5,
                                                itemSize: width * 0.035,
                                                direction: Axis.horizontal,
                                              ),
                                              SizedBox(width: width * 0.02),
                                              Text(
                                                "(255)",
                                                style: GoogleFonts.poppins(
                                                  color: Colors.black,
                                                  fontSize: width * 0.03,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: height * 0.005),
                                          Row(
                                            children: [
                                              Icon(Icons.calendar_today, color: Colors.black, size: width * 0.035),
                                              SizedBox(width: width * 0.02),
                                              Text(
                                                '19 July 2021',
                                                style: GoogleFonts.poppins(
                                                  color: Colors.black,
                                                  fontSize: width * 0.03,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Icon(Icons.location_on, color: Colors.black, size: width * 0.035),
                                              SizedBox(width: width * 0.015),
                                              Text(
                                                "New York, USA",
                                                style: GoogleFonts.poppins(
                                                  color: Colors.black,
                                                  fontSize: width * 0.03,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: height * 0.005),
                                          Row(
                                            children: [
                                              Icon(Icons.access_time, color: Colors.black, size: width * 0.035),
                                              SizedBox(width: width * 0.02),
                                              Text(
                                                '21:00-23:00',
                                                style: GoogleFonts.poppins(
                                                  color: Colors.black,
                                                  fontSize: width * 0.03,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: width * 0.05,
                        right: width * 0.05,
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: EdgeInsets.all(width * 0.015),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.share, color: Colors.black),
                          ),
                        ),
                      ),
                    ],
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
