// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:event_app/data/token_manager/const_veriable.dart';
import 'package:event_app/data/token_manager/local_storage.dart';
import 'package:event_app/res/app_images/App_images.dart';
import 'package:event_app/res/common_widget/responsive_helper.dart';
import 'package:event_app/res/custom_style/custom_size.dart';
import 'package:event_app/view/about_us_view/about_us_screen.dart';
import 'package:event_app/view/auth_view/view/sign_in_screen.dart';
import 'package:event_app/view/profile_view/view/user_profile_screen.dart';
import 'package:event_app/view/privacy_policy_view/privacy_policy_screen.dart';
import 'package:event_app/view/profile_view/controller/profile_controller.dart';
import 'package:event_app/view/settings_view/view/settings_screen.dart';
import 'package:event_app/view/terms_condition_view/terms_and_condition_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../res/app_colors/App_Colors.dart';
import '../../../res/common_widget/custom_app_bar.dart';
import '../../../res/common_widget/custom_text.dart';
import 'invite_list_screen.dart';
import 'personal_information_screen.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});
  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Obx(() {
        return Stack(
          children: [


            // Header image and background
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipPath(
                    clipper: ProfileClipper(),
                    child: Container(
                      width: double.infinity,
                      height: ResponsiveHelper.w(context, 300),
                      color: Colors.teal,
                      padding: const EdgeInsets.only(top: 50, bottom: 40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Profile Image
                          Container(
                            width: ResponsiveHelper.w(context, 120),
                            height: ResponsiveHelper.h(context, 150),
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(24),
                              image: DecorationImage(
                                image: NetworkImage(
                                    controller.imgURL.value.isNotEmpty ? controller.imgURL.value : placeholderImage
                                ), // Replace with actual image URL or AssetImage
                                fit: BoxFit.cover,
                              ),
                              border: Border.all(color: Colors.white, width: 4),
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Name Text
                          Text(
                            controller.name.value.isNotEmpty ? controller.name.value : 'User Name',
                            style: GoogleFonts.openSans(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // App Bar
            Positioned(
              top: 32,
              left: 16,
              right: 16,
              child: Center(
                  child: CustomAppBar(
                    appBarName: "Profile",
                    titleColor: Colors.white,
                    widget: SizedBox(),
                  )),
            ),

            // Scrollable Body
            Positioned.fill(
              top: ResponsiveHelper.w(context, 290),
              child: Scrollbar(
                thumbVisibility: true,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    child: Column(
                      children: [
                        _buildListTile(
                          context: context,
                          icon: Icons.person,
                          title: "Personal Information",
                          color: AppColors.primaryColor,
                          onTap: () {
                            Get.to(
                                    ()=>PersonalInformationScreen(),
                                transition: Transition.fadeIn,
                                duration: const Duration(milliseconds: 400)
                            );
                          },
                        ),
                        Divider(),
                        Container(
                          alignment: Alignment.center,
                          height: ResponsiveHelper.h(context, 50),
                          child: ListTile(
                            leading: Image.asset(AppImages.invitedListIcon, scale: 4,),
                            title: CustomText(
                              title: "Invite List",
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: AppColors.blackColor,
                            ),
                            minVerticalPadding: 0,
                            onTap: () {
                              Get.to(
                                      ()=>InviteListScreen(),
                                  transition: Transition.fadeIn,
                                  duration: const Duration(milliseconds: 400)
                              );
                            },
                          ),
                        ),
                        Divider(),
                        Container(
                          alignment: Alignment.center,
                          height: ResponsiveHelper.h(context, 50),
                          child: ListTile(
                            leading: Image.asset(AppImages.profileActive, scale: 4,),
                            title: CustomText(
                              title: "My profile",
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: AppColors.blackColor,
                            ),
                            minVerticalPadding: 0,
                            onTap: () {
                              String myId = LocalStorage.getData(key: myID);
                              LocalStorage.saveData(key: userProfileId, data: myId);
                              print('myID: $myId and user id: ${LocalStorage.getData(key: userProfileId)}');
                              Get.to(
                                      ()=> UserProfileScreen(),
                                  transition: Transition.fadeIn,
                                  duration: const Duration(milliseconds: 400)
                              );
                            },
                          ),
                        ),
                        Divider(),
                        _buildListTile(
                          context: context,
                          icon: Icons.settings,
                          title: "Settings",
                          color: AppColors.primaryColor,
                          onTap: () {
                            Get.to(
                                    ()=>SettingsScreen(),
                                transition: Transition.rightToLeft,
                                duration: const Duration(milliseconds: 400)
                            );
                          },
                        ),
                        Divider(),
                        _buildListTile(
                          context: context,
                          icon: Icons.insert_drive_file,
                          title: "Terms of Services",
                          color: AppColors.primaryColor,
                          onTap: () {
                            Get.to(
                                    ()=>TermsAndConditionsScreen(),
                                transition: Transition.rightToLeft,
                                duration: const Duration(milliseconds: 400)
                            );
                          },
                        ),
                        Divider(),
                        _buildListTile(
                          context: context,
                          icon: Icons.verified_user,
                          title: "Privacy Policy",
                          color: AppColors.primaryColor,
                          onTap: () {
                            Get.to(
                                    ()=>PrivacyAndPolicyScreen(),
                                transition: Transition.rightToLeft,
                                duration: const Duration(milliseconds: 400)
                            );
                          },
                        ),
                        Divider(),
                        _buildListTile(
                          context: context,
                          icon: Icons.info,
                          title: "About us",
                          color: AppColors.primaryColor,
                          onTap: () {
                            Get.to(
                                    ()=>AboutUsScreen(),
                                transition: Transition.rightToLeft,
                                duration: const Duration(milliseconds: 400)
                            );
                          },
                        ),
                        Divider(),
                        _buildListTile(
                          context: context,
                          icon: Icons.logout,
                          title: "Logout",
                          color: Colors.red,
                          textColor: Colors.red,
                          onTap: () {
                            showLogoutDialog(context);
                          },
                        ),

                        heightBox20,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },),
    );
  }

  Widget _buildListTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Color color,
    Color textColor = Colors.black,
    required VoidCallback onTap,
  }) {
    return Container(
      alignment: Alignment.center,
      height: ResponsiveHelper.h(context, 50),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: CustomText(
          title: title,
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: textColor,
        ),
        minVerticalPadding: 0,
        onTap: onTap,
      ),
    );
  }


  void showLogoutDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Logout",
      transitionDuration: Duration(milliseconds: 300), // Animation duration
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Do you want to logout your profile?",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.black,
                    decoration: TextDecoration.none,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close dialog
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: AppColors.primaryColor),
                        ),
                      ),
                      child: Text(
                        "Cancel",
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        // Perform logout action
                        LocalStorage.removeData(key: 'access_token');
                        LocalStorage.removeData(key: 'remain_email');
                        LocalStorage.removeData(key: 'remain_password');
                        Get.offAll(
                                ()=> SignInScreen(),
                            duration: const Duration(milliseconds: 300),
                            transition: Transition.fade
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "Log Out",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedValue = Curves.easeInOutBack.transform(animation.value) - 1;
        return Transform.translate(
          offset: Offset(0, curvedValue * -50),
          child: Opacity(
            opacity: animation.value,
            child: child,
          ),
        );
      },
    );
  }
}

// Custom Clipper for creating the curved background
class ProfileClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 50);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
