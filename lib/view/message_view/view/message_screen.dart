// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:math';
import 'package:event_app/data/services/socket_controller.dart';
import 'package:event_app/data/token_manager/const_veriable.dart';
import 'package:event_app/data/token_manager/local_storage.dart';
import 'package:event_app/res/app_colors/App_Colors.dart';
import 'package:event_app/res/common_widget/custom_text.dart';
import 'package:event_app/res/utils/time_convetor.dart';
import 'package:event_app/view/message_view/controller/my_chatList_controller.dart';
import 'package:event_app/view/message_view/widget/group_chat_list_widget.dart';
import 'package:event_app/view/message_view/widget/personal_user_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../res/common_widget/custom_app_bar.dart';
import 'community_chat_screen.dart';
import 'personal_chat_screen.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  final MyChatListController controller = Get.put(MyChatListController());

  final SocketService socketService = Get.put(SocketService());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppBar(
                appBarName: "message".tr,
                widget: SizedBox(),
              ),
              SizedBox(height: 16),

              /*Roundbutton(
                  title: 'Hit chatList ',
                  onTap: () async {
                    // socketService.initialized;
                    print('chatList');
                    await socketService.chatList();
                    print('Community chat list: ${controller.communityChatList.length} messages.');
                  },
              ),*/

              TabBar(
                controller: _tabController,
                labelColor: Colors.teal,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.teal,
                tabs: [
                  Tab(text: 'community'.tr),
                  Tab(text: 'personal'.tr),
                ],
              ),


              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [


                    // CommunityTab(),
                    Obx(() {
                      return controller.communityChatList.isEmpty
                          ? Center(
                        child: CustomText(
                          title: 'no_community_available'.tr,
                        ),
                      )
                          : ListView.builder(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemCount: controller.communityChatList.length,
                        itemBuilder: (context, index) {
                          // Safely access the first participant
                          var participants = controller.communityChatList[index].participant;

                          String lastTime = getRelativeTime(controller.communityChatList[index].lastMessage?.updatedAt.toString() ?? '');

                          return GestureDetector(
                            onTap: () {

                              // Save the community ID to LocalStorage
                              LocalStorage.saveData(key: 'communityId', data: controller.communityChatList[index].id);
                              print('communityId: ${controller.communityChatList[index].id}');
                              // Navigate to CommunityChatScreen
                              Get.to(
                                      () => CommunityChatScreen(
                                          chatId: controller.communityChatList[index].id,
                                        communityName: controller.communityChatList[index].communityName ?? 'N/A',
                                        members: controller.communityChatList[index].participant ?? [],
                                        communityImage: controller.communityChatList[index].communityProfile ?? '',
                                        isCommunityOwner: controller.communityChatList[index].event != null ? true : false,
                                      ),
                                  transition: Transition.downToUp,
                                  duration: Duration(milliseconds: 100
                                  )
                              );
                            },
                            child: GroupChatListWidget(
                              groupName:  controller.communityChatList[index].communityName ?? 'N/A',
                              lastMessage: controller.communityChatList[index].lastMessage?.content ?? 'N/A',
                              last_message_time: lastTime,
                              imgList: participants
                                  .map((participant) =>
                              participant.user?.profilePicture ?? placeholderImage)
                                  .toList(),
                              unSeenMessageCount:controller.communityChatList[index].unseenMessageCount ?? 0,
                              profilePicture: controller.communityChatList[index].communityProfile ?? '',
                            ),
                          );
                        },
                      );
                    }),



                    // PersonalTab(),
                    Obx(
                      () {
                        if (controller.singleChatList.isEmpty) {
                          return Center(
                            child: Text(
                              "no_personal_chats_available".tr,
                              style: GoogleFonts.urbanist(fontSize: 16, color: Colors.grey),
                            ),
                          );
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemCount: controller.singleChatList.length,
                          itemBuilder: (context, index) {
                            var data = controller.singleChatList[index];

                            // Check if any participant in this specific `data` is online
                            var isOnline = data.participant.any((participant) =>
                                socketService.onlineUsers.any((user) => user['id'] == participant.user?.id));


                            print('isOnline for ${data.id}: $isOnline');

                            String lastTime = getRelativeTime(data.lastMessage?.updatedAt.toString() ?? '');
                            /*String nameList = data.participant.map((e) => e.user?.name).join(', ');
                            print("nameList: $nameList");*/
                            return PersonalUserListWidget(
                                name:  data.participant[0].user?.name ?? 'N/A',
                                imgPath: data.participant[0].user?.profilePicture ?? placeholderImage,
                                lastMessage: data.lastMessage?.content ?? 'N/A',
                                lastMessageTime: lastTime,
                                messageCount: data.unseenMessageCount ?? 0,
                                onTap: (){

                                  // Save the community ID to LocalStorage
                                  LocalStorage.saveData(key: 'communityId', data: data.id);
                                  print('communityId: ${data.id}');

                                  Get.to(
                                        () => PersonalChatScreen(
                                            chatId: data.id.toString(),
                                          userName: data.participant[0].user?.name ?? 'N/A',
                                          userImage: data.participant[0].user?.profilePicture ?? '',
                                          isOnline: isOnline,
                                        ),
                                    transition: Transition.downToUp,
                                    duration: Duration(milliseconds: 100),
                                  );
                                },
                              isOnline: isOnline,
                            );
                          },
                        );
                      },
                    ),


                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
