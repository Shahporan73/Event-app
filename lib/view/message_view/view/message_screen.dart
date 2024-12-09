// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:math';
import 'package:event_app/res/app_colors/App_Colors.dart';
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
                  ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: group_data.length,
                    itemBuilder: (context, index) {
                    return _groupItem(index);
                    },
                  ),

                    // PersonalTab(),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemCount: 8,
                      itemBuilder: (context, index) {
                        return PersonalUserListWidget(
                            name: 'Alisha',
                            imgPath: 'https://cdn.psychologytoday.com/sites/default/files/styles/article-inline-half/public/field_blog_entry_images/2017-09/shutterstock_243101992.jpg?itok=sxfMiTsD',
                            lastMessage: 'Great, thanks so much! 💫',
                            time: '09/05',
                            messageCount: '5',
                            onTap: (){
                              Get.to(
                                () => PersonalChatScreen(),
                                transition: Transition.downToUp,
                                duration: Duration(milliseconds: 100),
                              );
                            }
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


  Widget _groupItem(int index) {
    return GestureDetector(
      onTap: () {
        Get.to(
                () => CommunityChatScreen(),
            transition: Transition.downToUp,
            duration: Duration(milliseconds: 100
            )
        );
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
              min(3, group_data[index].imgList.length),
                  (imgIndex) {
                return Align(
                  alignment: Alignment.center,
                  widthFactor: 0.3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: imgIndex > 1
                        ? _outlineImage(index)
                        : Image(
                      image: NetworkImage(group_data[index].imgList[imgIndex]),
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
        title: Text(
          group_data[index].title,
          style: GoogleFonts.urbanist(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: Colors.black,
          ),
        ),
        subtitle: Text(
          group_data[index].sub_title,
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
              group_data[index].last_message_time,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            group_data[index].message_count.isEmpty
                ? SizedBox()
                : Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                group_data[index].message_count,
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
