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

// Assuming 'group_data' is a list of data objects with necessary fields.
final List<GroupData> group_data = [
  // Populate with your actual data
  GroupData(
    title: "Texworld New York City",
    sub_title: "Appreciate it! See you soon!",
    last_message_time: "08/05",
    message_count: "1",
    profile_img: "https://t3.ftcdn.net/jpg/02/43/12/34/360_F_243123463_zTooub557xEWABDLk0jJklDyLSGl2jrr.jpg",
    imgList: [
      "https://t3.ftcdn.net/jpg/02/43/12/34/360_F_243123463_zTooub557xEWABDLk0jJklDyLSGl2jrr.jpg",
      "https://cdn.psychologytoday.com/sites/default/files/styles/article-inline-half/public/field_blog_entry_images/2017-09/shutterstock_243101992.jpg?itok=sxfMiTsD",
      "https://cdn.psychologytoday.com/sites/default/files/styles/article-inline-half-caption/public/field_blog_entry_images/2018-09/shutterstock_648907024.jpg?itok=0hb44OrI",
      "https://t3.ftcdn.net/jpg/02/43/12/34/360_F_243123463_zTooub557xEWABDLk0jJklDyLSGl2jrr.jpg",
      "https://cdn.psychologytoday.com/sites/default/files/styles/article-inline-half/public/field_blog_entry_images/2017-09/shutterstock_243101992.jpg?itok=sxfMiTsD",
      "https://cdn.psychologytoday.com/sites/default/files/styles/article-inline-half-caption/public/field_blog_entry_images/2018-09/shutterstock_648907024.jpg?itok=0hb44OrI",
    ],
  ),

  GroupData(
    title: "Las Vegas Market Show",
    sub_title: "See you soon!",
    last_message_time: "08/05",
    message_count: "4",
    profile_img: "https://t3.ftcdn.net/jpg/02/43/12/34/360_F_243123463_zTooub557xEWABDLk0jJklDyLSGl2jrr.jpg",
    imgList: [
      "https://t3.ftcdn.net/jpg/02/43/12/34/360_F_243123463_zTooub557xEWABDLk0jJklDyLSGl2jrr.jpg",
      "https://t3.ftcdn.net/jpg/02/43/12/34/360_F_243123463_zTooub557xEWABDLk0jJklDyLSGl2jrr.jpg",
      "https://t3.ftcdn.net/jpg/02/43/12/34/360_F_243123463_zTooub557xEWABDLk0jJklDyLSGl2jrr.jpg",
    ],
  ),


  GroupData(
    title: "Restaurant Bar & shop",
    sub_title: "New uniforms are ready. 👍",
    last_message_time: "08/05",
    message_count: "5",
    profile_img: "https://t3.ftcdn.net/jpg/02/43/12/34/360_F_243123463_zTooub557xEWABDLk0jJklDyLSGl2jrr.jpg",
    imgList: [
      "https://t3.ftcdn.net/jpg/02/43/12/34/360_F_243123463_zTooub557xEWABDLk0jJklDyLSGl2jrr.jpg",
    ],
  ),

  // Add more items as needed
];

class GroupData {
  final String title;
  final String sub_title;
  final String last_message_time;
  final String message_count;
  final String profile_img;
  final List<String> imgList;

  GroupData({
    required this.title,
    required this.sub_title,
    required this.last_message_time,
    required this.message_count,
    required this.profile_img,
    required this.imgList,
  });
}

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
                appBarName: "Messages",
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
                  Tab(text: 'Community'),
                  Tab(text: 'Personal'),
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
                          title: 'No community available',
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
                              "No personal chats available",
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


  Widget _groupItem({
    required int index,
    required String groupName,
    required String lastMessage,
    required String last_message_time,
    required String message_count,
    required List<String> imgList,
    required String unSeenMessageCount
  }
      ) {
    return GestureDetector(
      onTap: () {
        // Get.to(
        //         () => CommunityChatScreen(),
        //     transition: Transition.downToUp,
        //     duration: Duration(milliseconds: 100
        //     )
        // );
      },
      child: ListTile(
        leading: group_data[index].imgList.isEmpty
            ? Image(
          image: NetworkImage(group_data[index].profile_img),
          height: 50,
          width: 50,
          fit: BoxFit.cover,
        )
            : SizedBox(
          height: 60,
          width: 60,
          child: Row(
            children: List.generate(
              min(3, imgList.length),
                  (imgIndex) {
                return Align(
                  alignment: Alignment.center,
                  widthFactor: 0.3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: imgIndex > 1
                        ? _outlineImage(index)
                        : Image(
                      image: NetworkImage(imgList[imgIndex]),
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        // Group name
        title: Text(
          groupName,
          style: GoogleFonts.urbanist(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: Colors.black,
          ),
        ),

        // Last message
        subtitle: Text(
          lastMessage,
          style: GoogleFonts.urbanist(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              lastMessage,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            message_count.isEmpty
                ? SizedBox()
                : Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                unSeenMessageCount,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _outlineImage(int index) {
    return Container(
      width: 50,
      height: 50,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.teal.shade100,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Text(
        '+${group_data[index].imgList.length}',
        style: GoogleFonts.roboto(
          fontWeight: FontWeight.w700,
          color: Colors.black,
          fontSize: 14,
        ),
      ),
    );
  }

}
