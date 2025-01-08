// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:event_app/data/token_manager/const_veriable.dart';
import 'package:event_app/data/token_manager/local_storage.dart';
import 'package:event_app/res/app_colors/App_Colors.dart';
import 'package:event_app/res/common_widget/custom_text.dart';
import 'package:event_app/res/custom_style/custom_size.dart';
import 'package:event_app/view/profile_view/controller/my_invited_event_controller.dart';
import 'package:event_app/view/profile_view/view/invited_event_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class InviteListScreen extends StatelessWidget {
  InviteListScreen({super.key});

  final MyInvitedEventController controller = Get.put(MyInvitedEventController());

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        title: const Text('Invite List'),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Obx(
          () {
            return controller.isLoading.value ?
            Center(child: CircularProgressIndicator()) : Column(
              children: [
                controller.myInvitePendingList.isEmpty ?
                Center(child: CustomText(title: "No Event Found")) :
                ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: controller.myInvitePendingList.length,
                    itemBuilder: (context, index) {
                      var data = controller.myInvitePendingList[index];

                      DateTime createdAt;
                      try {
                        createdAt = DateFormat('MM/dd/yyyy').parse(data.createdAt.toString());
                      } catch (e) {
                        createdAt = DateTime.now();
                      }

                      // Format to 'MM-dd-yyyy' for date (e.g., 10-02-2024)
                      String formattedDate = DateFormat('MM-dd-yyyy').format(createdAt);

                      // Format time to 'hh:mm a' (e.g., 08:20 PM)
                      String time = DateFormat('hh:mm a').format(createdAt);

                      return GestureDetector(
                        onTap: () {
                          // LocalStorage.saveData(key: invitedEventDetailsID, data: data.eventId);
                          Get.to(
                                () => InvitedEventDetailsScreen(),
                            transition: Transition.rightToLeft,
                            duration: Duration(milliseconds: 100),
                          );
                          controller.getInvitedEventDetails(data.eventId.toString());
                        },
                        child: Container(
                          width: width,
                          margin: EdgeInsets.only(bottom: 10),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 2),
                                )
                              ]
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 40,
                                    backgroundColor: Colors.white,
                                    backgroundImage: NetworkImage(
                                      data.event?.image ?? placeholderImage
                                    ),
                                  ),
                                  widthBox10,
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        title: data.event?.name != null && data.event!.name!.length > 20
                                            ? data.event!.name!.substring(0, 20) + '...'
                                            : data.event?.name ?? "Unknown",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                      CustomText(
                                        title: data.event?.address != null && data.event!.address!.length > 30
                                            ? data.event!.address!.substring(0, 30) + '...'
                                            : data.event?.address ?? "Unknown",
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                      ),

                                      CustomText(
                                        title: 'Event Date: $formattedDate',
                                        fontSize: 9,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                      ),
                                      CustomText(
                                        title: 'Event Time: $time',
                                        fontSize: 9,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                )

              ],
            );
          },
        ),
      ),
    );
  }
}
