// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'dart:math';

import 'package:event_app/data/services/socket_controller.dart';
import 'package:event_app/data/token_manager/const_veriable.dart';
import 'package:event_app/res/common_widget/custom_network_image_widget.dart';
import 'package:event_app/res/custom_style/custom_size.dart';
import 'package:event_app/view/message_view/controller/media_controller.dart';
import 'package:event_app/view/message_view/controller/upload_image_controller.dart';
import 'package:event_app/view/message_view/model/chat_list_model.dart';
import 'package:event_app/view/message_view/view/see_all_media_screen.dart';
import 'package:event_app/view/message_view/widget/see_all_user_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../res/app_colors/App_Colors.dart';

class CommunityDetailsScreen extends StatefulWidget {
  final String communityName;
  final List<Participant> members;
  final String communityImage;
  final String communityId;
  final bool isCommunityOwner;
  CommunityDetailsScreen({
    super.key,
    required this.communityName,
    required this.members,
    required this.communityImage,
    required this.communityId,
    this.isCommunityOwner = false,
  });

  @override
  State<CommunityDetailsScreen> createState() => _CommunityDetailsScreenState();
}

class _CommunityDetailsScreenState extends State<CommunityDetailsScreen> {
  String groupName = ''; // Initial name
  final TextEditingController _nameController = TextEditingController();
  bool isChecked = false;
  final UploadImageController uploadImageController = Get.put(UploadImageController());
  final SocketService socketService = Get.find<SocketService>();
  final MediaController mediaController = Get.put(MediaController());

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
                          child: Obx(() => ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: CustomNetworkImage(
                              imageUrl: uploadImageController.communityUpdateImageUrl.value.isNotEmpty ?
                              uploadImageController.communityUpdateImageUrl.value :
                              widget.communityImage.isNotEmpty ? widget.communityImage : placeholderImage,
                              width: 180,
                              height: 180,
                            ),
                          ),),
                        ),
                        widget.isCommunityOwner==false ? SizedBox(): Positioned(
                          bottom: 6,
                          right: 15,
                          child: GestureDetector(
                            onTap: () async {
                              await uploadImageController.pickCommunityImage(context);
                              await socketService.updateCommunityPicture(
                                    communityId: widget.communityId,
                                    picture: uploadImageController.communityUpdateImageUrl.value,
                                  );
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: 34,
                              height: 34,
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
                                size: 28,
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
                        groupName.isNotEmpty ? groupName : widget.communityName ?? "N/A",
                        style: GoogleFonts.roboto(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: 10),
                      widget.isCommunityOwner==false ?
                      SizedBox(): GestureDetector(
                        onTap: () {
                          _showChangeNameDialog(context);

                        },
                        child: Icon(Icons.edit, size: 24), // Edit icon
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    "${widget.members.length ?? 0} "+"Members".tr,
                    style: GoogleFonts.roboto(
                      fontSize: 18,
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
                  /*Get.to(() => SeeAllMemeberScreen(),
                      transition: Transition.rightToLeft,
                      duration: Duration(milliseconds: 500)
                  );*/

                  showSeeAllUserDialog(context, widget.members);

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
                                min(3, widget.members.length),
                                    (index) => Align(
                                  widthFactor: 0.3,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: Image.network(
                                      widget.members[index].user?.profilePicture ?? placeholderImage, // Replace with actual URLs
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
                            widget.members.isEmpty? "no_members".tr : "see_all_members".tr,
                            style: GoogleFonts.urbanist(
                              fontSize: 14,
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
                        Text("see_all_media".tr,
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                              fontSize: 12,
                              color: AppColors.black100
                            ),
                        ),
                        Obx(() => mediaController.isLoading.value
                            ? SpinKitThreeBounce(color: AppColors.primaryColor, size: 8,) :
                        Text("${mediaController.imageList.length + mediaController.videoList.length}",
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              color: AppColors.primaryColor
                          ),
                        ),),
                      ],
                    ),
                    onTap: () {
                      // Action for media links
                      // LocalStorage.saveData(key: 'mediaCommunityId', data: widget.communityId);
                      Get.to(
                        () => SeeAllMediaScreen(),
                      );
                    },
                  ),


                  // Mute Notification
                  /*ListTile(
                    leading: Icon(Icons.notifications_off, size: 24),
                    title: Text(
                      "Mute Notification",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
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
                  ),*/


                  ListTile(
                    leading: Icon(Icons.logout, size: 24, color: Colors.red),
                    title: Text("leave_community".tr, style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
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

  void _showChangeNameDialog(BuildContext context) {
    groupName = widget.communityName;
    _nameController.text = groupName;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("change_name".tr),
          content: TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: "enter_new_group_name".tr),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("cancel".tr),
            ),
            ElevatedButton(
              onPressed: () {
                socketService.updateCommunityName(communityId: widget.communityId, communityName: _nameController.text);
                setState(() {
                  groupName = _nameController.text;
                });

                Navigator.of(context).pop();
                // Navigate back two screens
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop(); // Go back one screen
                }
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop(); // Go back the second screen
                }

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
        title: Text("leave_group".tr),
        content: Text("are_you_sure_you_want_to_leave_this_group".tr),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("cancel".tr),
          ),
          ElevatedButton(
            onPressed: () {
              // Logic for leaving the group
              Navigator.of(context).pop();
              socketService.LeaveCommunity(communityId: widget.communityId);

              // Navigate back two screens
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop(); // Go back one screen
              }
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop(); // Go back the second screen
              }

            },
            child: Text("leave".tr, style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          ),
        ],
      ),
    );
  }

}
