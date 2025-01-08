// ignore_for_file: prefer_const_constructors

import 'package:country_picker/country_picker.dart';
import 'package:event_app/data/token_manager/const_veriable.dart';
import 'package:event_app/res/common_widget/responsive_helper.dart';
import 'package:event_app/view/profile_view/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../res/app_colors/App_Colors.dart';
import '../../../res/common_widget/RoundButton.dart';
import '../../../res/common_widget/RoundTextField.dart';
import '../../../res/common_widget/custom_app_bar.dart';
import '../../../res/common_widget/custom_network_image_widget.dart';
import '../../../res/common_widget/custom_text.dart';
import '../../../res/custom_style/custom_size.dart';

import 'package:image_picker/image_picker.dart';  // Import image_picker
import 'dart:io'; // For file handling

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});
  final ProfileController controller = Get.put(ProfileController());
  final ImagePicker _picker = ImagePicker();  // Initialize the ImagePicker

  // Method to pick an image
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery); // Pick image from gallery
    if (pickedFile != null) {
      // Set the image path in the controller
      controller.imgURL.value = pickedFile.path;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: SingleChildScrollView(
            child: Obx(() {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomAppBar(
                    appBarName: "Edit Profile",
                    onTap: () {
                      Get.back();
                    },
                  ),

                  // Profile Image Picker
                  heightBox20,
                  Center(
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30.r),
                          child: CustomNetworkImage(
                            imageUrl: controller.imgURL.value.isNotEmpty
                                ? controller.imgURL.value
                                : placeholderImage,
                            width: ResponsiveHelper.w(context, 150),
                            height: ResponsiveHelper.h(context, 150),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _pickImage, // Open image picker when clicked
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.bgColor,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(10.r)),
                              ),
                              child: Icon(
                                Icons.camera_alt_outlined,
                                color: AppColors.primaryColor,
                                size: 28.w.h,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),




                  // Name field
                  heightBox20,
                  CustomText(
                    title: "Name",
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.whiteDarker,
                  ),
                  heightBox10,
                  RoundTextField(
                    controller: controller.nameController.value,  // Use Rx<TextEditingController>
                    hint: 'Enter name',
                    filled: true,
                    prefixIcon: Icon(Icons.person_outline),
                  ),

                  // Email field
                  heightBox20,
                  CustomText(
                    title: "Email",
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.whiteDarker,
                  ),
                  heightBox10,
                  RoundTextField(
                    controller: controller.emailController.value,  // Use Rx<TextEditingController>
                    hint: 'Enter email',
                    filled: true,
                    prefixIcon: Icon(Icons.email_outlined),
                  ),

                  // Phone number field
                  heightBox20,
                  CustomText(
                    title: "Phone Number",
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.whiteDarker,
                  ),
                  heightBox10,
                  RoundTextField(
                    controller: controller.numberController.value,  // Use Rx<TextEditingController>
                    hint: 'Enter phone number',
                    filled: true,
                    prefixIcon: Icon(Icons.phone),
                  ),

                  // Location field
                  heightBox20,
                  CustomText(
                    title: "Location",
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.whiteDarker,
                  ),
                  heightBox10,
                  RoundTextField(
                    controller: controller.addressController.value,  // Use Rx<TextEditingController>
                    hint: 'Enter location',
                    filled: true,
                  ),

                  SizedBox(height: 30),
                  Roundbutton(
                    title: "Update",
                    isLoading: controller.isProfileLoading.value,
                    onTap: () => controller.updateProfile(),
                  ),
                  SizedBox(height: 30),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}




