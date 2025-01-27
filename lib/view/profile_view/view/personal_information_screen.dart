// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:event_app/data/token_manager/const_veriable.dart';
import 'package:event_app/main.dart';
import 'package:event_app/res/common_widget/RoundButton.dart';
import 'package:event_app/res/common_widget/responsive_helper.dart';
import 'package:event_app/res/custom_style/custom_size.dart';
import 'package:event_app/view/profile_view/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../res/app_colors/App_Colors.dart';
import '../../../res/app_images/App_images.dart';
import '../../../res/common_widget/custom_app_bar.dart';
import '../../../res/common_widget/custom_text.dart';
import 'edit_profile_screen.dart';

class PersonalInformationScreen extends StatelessWidget {
  PersonalInformationScreen({super.key});

  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Obx(
        () {
          print('name ${controller.name.value}');
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
                              width: ResponsiveHelper.w(context, 150),
                              height: ResponsiveHelper.h(context, 180),
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
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // App Bar
              Positioned(
                top: 40,
                left: 16,
                right: 16,
                child: Center(
                    child: CustomAppBar(
                      appBarName: "profile".tr,
                      titleColor: Colors.white,
                      leadingColor: Colors.white,
                      onTap: () => Get.back(),
                    )),
              ),

              // Scrollable Body
              Positioned.fill(
                top: ResponsiveHelper.w(context, 270),
                child: Scrollbar(
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                      child: Column(
                        children: [

                          Roundbutton(
                            title: "edit_profile".tr,
                            onTap: (){
                              Get.to(
                                    () => EditProfileScreen(),
                                transition: Transition.rightToLeft,
                                duration: const Duration(milliseconds: 400),
                              );
                            },
                            padding_vertical: 5,
                            borderRadius: 4,
                            fontSize: 14,
                            width: ResponsiveHelper.w(context, 120),
                          ),

                          heightBox20,
                          _buildListTile(
                            context: context,
                            icon: Icons.person,
                            title: controller.name.value.isNotEmpty ? controller.name.value : 'not_available'.tr,
                            color: AppColors.primaryColor,
                            onTap: () {},
                          ),
                          Divider(),
                          _buildListTile(
                            context: context,
                            icon: Icons.email,
                            title: controller.email.value.isNotEmpty ? controller.email.value : 'not_available'.tr,
                            color: AppColors.primaryColor,
                            onTap: () {},
                          ),
                          Divider(),
                          _buildListTile(
                            context: context,
                            icon: Icons.phone,
                            title: controller.number.value.isNotEmpty ? controller.number.value : 'not_available'.tr,
                            color: AppColors.primaryColor,
                            onTap: () {},
                          ),
                          Divider(),
                          _buildListTile(
                            context: context,
                            icon: Icons.location_on,
                            title: controller.address.value.isNotEmpty ? controller.address.value : 'not_available'.tr,
                            color: AppColors.primaryColor,
                            onTap: () {},
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
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
        contentPadding: EdgeInsets.zero,
      ),
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
