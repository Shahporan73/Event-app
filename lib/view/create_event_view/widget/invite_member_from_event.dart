// ignore_for_file: prefer_const_constructors

import 'package:event_app/data/token_manager/const_veriable.dart';
import 'package:event_app/res/app_colors/App_Colors.dart';
import 'package:event_app/res/common_widget/RoundButton.dart';
import 'package:event_app/res/common_widget/RoundTextField.dart';
import 'package:event_app/res/common_widget/custom_text.dart';
import 'package:event_app/res/custom_style/custom_size.dart';
import 'package:event_app/view/create_event_view/controller/selected_contact_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class InviteMemberFromEvent extends StatefulWidget {
  InviteMemberFromEvent({super.key});

  @override
  State<InviteMemberFromEvent> createState() => _InviteMemberFromEventState();
}

class _InviteMemberFromEventState extends State<InviteMemberFromEvent> {
  final SelectedContactController controller = Get.put(SelectedContactController());
  // List to store selected contact indices
  final List<String> selectedContactIndices = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Obx(
                () {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                  ),
                  heightBox5,
                  Center(
                    child: CustomText(
                      title: 'RECOMMEND WAYPLACES',
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  heightBox8,
                  CustomText(
                    textAlign: TextAlign.center,
                    title: 'Invite your friends to join and enjoy this exciting experience together.',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black100,
                  ),
                  heightBox20,
                  RoundTextField(
                    controller: controller.searchController,
                    hint: "Search Name",
                    readOnly: false,
                    prefixIcon: Icon(
                      Icons.search_outlined,
                      color: Colors.grey,
                    ),
                    borderRadius: 20,
                    focusBorderRadius: 20,
                    onChanged: (p0) {
                      controller.searchRecommendableUsers();
                    },
                  ),
                  heightBox20,
                  Expanded(
                    child: controller.isSearchLoading.value ?
                    Center(child: CircularProgressIndicator()) :
                    ListView.builder(
                      itemCount: controller.recommendableUserList.length,
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        var data = controller.recommendableUserList[index];
                        String userId = data.id ?? '';

                        return controller.recommendableUserList.isEmpty
                            ? Center(
                          child: CustomText(
                            title: 'No User Found',
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: AppColors.blackColor,
                          ),
                        )
                            : Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // CircleAvatar
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: AppColors.primaryColor,
                              backgroundImage: NetworkImage(
                                data.profilePicture ?? placeholderImage,
                              ),
                            ),
                            SizedBox(width: 10), // Space between avatar and text

                            // Text
                            Expanded(
                              child: Text(
                                data.name ?? 'Unavailable',
                                style: TextStyle(
                                  color: AppColors.blackColor,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                                overflow: TextOverflow.ellipsis, // In case name is too long
                              ),
                            ),

                            // Checkbox (to select a user)
                            Checkbox(
                              value: selectedContactIndices.contains(userId),
                              onChanged: (bool? selected) {
                                setState(() {
                                  if (selected == true) {
                                    if (!selectedContactIndices.contains(userId)) {
                                      selectedContactIndices.add(userId);
                                    }
                                  } else {
                                    selectedContactIndices.remove(userId);
                                  }
                                });
                                print('Selected Contact IDs: $selectedContactIndices');
                              },
                              activeColor: AppColors.primaryColor,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  heightBox20,
                  Roundbutton(
                    title: 'Invite',
                    isLoading: controller.isButtonLoading.value,
                    buttonColor: AppColors.primaryColor,
                    onTap: () {
                      print('Invite button pressed. Selected Contact IDs: $selectedContactIndices');
                      if (selectedContactIndices.isEmpty) {
                        Get.rawSnackbar(
                          message: "No users selected for invitation.",
                          snackPosition: SnackPosition.TOP,
                        );
                      } else if(selectedContactIndices.length < 1){
                        Get.snackbar(
                            'Alert',
                            "At least 1 users must be selected for invitation.",
                            backgroundColor: Colors.red,
                            colorText: AppColors.whiteColor
                        );
                      }else {
                        controller.inviteSelectedUsersFromCreatedEvent(selectedContactIndices.toList()); // Pass List directly
                        selectedContactIndices.clear();
                      }
                    },
                  ),
                  heightBox20,
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}


