// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:event_app/view/auth_view/view/sign_up_screen.dart';
import 'package:event_app/view/create_event_view/view/create_event_screen.dart';
import 'package:event_app/view/event_view/controller/my_event_controller.dart';
import 'package:event_app/view/home_view/view/home_screen.dart';
import 'package:event_app/view/message_view/view/message_screen.dart';
import 'package:event_app/view/profile_view/controller/user_profile_controller.dart';
import 'package:event_app/view/profile_view/view/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../res/app_colors/App_Colors.dart';
import '../../../res/app_images/App_images.dart';
import '../../event_view/view/my_event_screen.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _tabIndex = 0; // Default selected tab

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: buildBottomNavigationBar(),
      body: getSelectedScreen(),
    );
  }

  /// Returns the screen based on the selected tab index.
  Widget getSelectedScreen() {
    switch (_tabIndex) {
      case 0:
        return HomeScreen();
      case 1:
        return MyEventScreen();
      case 2:
        return CreateEventScreen(); // Center "Create Event" button screen
      case 3:
        return MessageScreen();
      case 4:
        return ProfileScreen();
      default:
        return SignUpScreen(); // Default screen ... home screen
    }
  }

  Widget buildBottomNavigationBar() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 70,
          decoration: BoxDecoration(
            color: Color(0xffFFFFFF),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 4,
                blurRadius: 10,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buildNavItem(AppImages.homeActive, AppImages.homeInactive, "Home", 0),
              buildNavItem(AppImages.eventActive, AppImages.eventInactive, "Event", 1),
              SizedBox(width: 60), // Space for the centered "Create Event" button
              buildNavItem(AppImages.messageActive, AppImages.messageInactive, "Message", 3),
              buildNavItem(AppImages.profileActive, AppImages.profileInactive, "Profile", 4),
            ],
          ),
        ),
        Positioned(
          bottom: 20,
          left: MediaQuery.of(context).size.width / 2 - 35, // Center horizontally
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _tabIndex = 2;
                  });
                },
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 4,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor, // Inner color for the button
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 2),
              Text(
                "Create Event",
                style: GoogleFonts.poppins(
                  color: _tabIndex == 2 ? AppColors.primaryColor : Color(0xff9DB2CE),
                  fontSize: 8.sp, // Adjusted font size to make it closer to the design
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildNavItem(String activeIconPath, String inactiveIconPath, String label, int index) {
    final isSelected = _tabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _tabIndex = index; // Change the tab index on tap
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            isSelected ? activeIconPath : inactiveIconPath,
            width: 24,
            height: 24,
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.poppins(
              color: isSelected ? AppColors.primaryColor : Color(0xff9DB2CE),
              fontSize: 10.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
