// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'package:event_app/data/services/socket_controller.dart';
import 'package:event_app/data/token_manager/const_veriable.dart';
import 'package:event_app/data/token_manager/local_storage.dart';
import 'package:event_app/res/app_colors/App_Colors.dart';
import 'package:event_app/res/app_images/App_images.dart';
import 'package:event_app/res/common_widget/custom_network_image_widget.dart';
import 'package:event_app/res/common_widget/custom_text.dart';
import 'package:event_app/res/common_widget/responsive_helper.dart';
import 'package:event_app/res/custom_style/custom_size.dart';
import 'package:event_app/res/utils/time_convetor.dart';
import 'package:event_app/view/message_view/controller/upload_image_controller.dart';
import 'package:event_app/view/message_view/widget/grid_image_widget.dart';
import 'package:event_app/view/message_view/widget/videos_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class PersonalChatScreen extends StatefulWidget {
  final String chatId;
  final String userName;
  final String userImage;
  final bool isOnline;
  PersonalChatScreen({
    super.key, required
    this.chatId,
    required this.userName,
    required this.userImage,
    this.isOnline = false,
  });

  @override
  State<PersonalChatScreen> createState() => _PersonalChatScreenState();
}

class _PersonalChatScreenState extends State<PersonalChatScreen> {
  // Sample data for the chat
  final SocketService socketService = Get.find<SocketService>();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final UploadImageController uploadImageController = Get.put(UploadImageController());

  @override
  void initState() {
    super.initState();
    // Fetch messages using the stored community ID
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchMessages();
    });
    socketService.seenMessage(chatId: widget.chatId, token: LocalStorage.getData(key: 'access_token'));
  }

  void fetchMessages() async {
    String? communityId = await LocalStorage.getData(key: 'communityId');
    if (communityId != null) {
      socketService.messages.clear();
      socketService.fetchMessages(chatId: communityId);
    } else {
      print('Community ID not found!');
    }
  }

  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    socketService.seenMessage(chatId: widget.chatId, token: LocalStorage.getData(key: 'access_token'));
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen width and height
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar section
            // App Bar section
            Padding(
              padding: EdgeInsets.only(top: 0, left: 16, right: 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(Icons.arrow_back, color: Colors.black),
                  ),
                  Expanded(
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: CustomNetworkImage(
                          imageUrl: widget.userImage.isNotEmpty ? widget.userImage : placeholderImage,
                          width: 50,
                          height: 50,
                        ),
                      ),
                      title: CustomText(
                        title: widget.userName.isNotEmpty ? widget.userName : "User",
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff1D242D),
                      ),
                      subtitle: CustomText(
                        title: widget.isOnline == true ? "Active now" : "Offline",
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: widget.isOnline == true ? Colors.green : Colors.redAccent,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 20.heightBox,
            // Chat messages section
            Expanded(
              child: Obx(() {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollToBottom();
                });

                // if (socketService.messages.isEmpty) {
                //   return Center(
                //       child: CustomText(
                //           title: 'No messages yet.',
                //           fontSize: 16,
                //           fontWeight: FontWeight.w400,
                //           color: AppColors.black100
                //       ),
                //   );
                // }

                return socketService.messages.isEmpty ?
                Center(child: SpinKitRipple(color: AppColors.primaryColor, size: 40,)) :
                    socketService.messages.isEmpty ? Center(child: CustomText(
                        title: 'no_message_yet'.tr,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: AppColors.black100
                    ),) :
                ListView.builder(
                  controller: _scrollController,
                  itemCount: socketService.messages.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final message = socketService.messages[index];
                    final isSentByMe = message['senderId'] == LocalStorage.getData(key: myID);
                    String createdTime = getRelativeTime(message['createdAt']);

                    var body = socketService.messages;

                   /* print('message body: ${body}');

                    var contentList = body.map((item) => item['text']).toList();
                    print('contentList: $contentList');

                    // var imageList = body.map((item) => item['images']).toList();
                    print('imageList1: ${body.map((item) => item['images']).toList()}');*/

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 10.0),
                      child: Align(
                        alignment: isSentByMe
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          width: MediaQuery.of(context).size.width * 0.70,
                          decoration: BoxDecoration(
                            color: isSentByMe
                                ? AppColors.secondaryColor
                                : AppColors.whiteColor,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              bottomRight: isSentByMe
                                  ? Radius.circular(0)
                                  : Radius.circular(10),
                              topLeft: isSentByMe
                                  ? Radius.circular(10)
                                  : Radius.circular(0),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 10,
                                blurRadius: 10,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // message
                              Text(
                                message['text'] ?? '',
                                style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15,
                                    color: isSentByMe
                                        ? Colors.white
                                        : Color(0xff1D242D)),
                              ),

                              // image
                              if (message['images'] != null && message['images'].isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: GridImageWidget(images: message['images']),
                                ),

                              if (message['videos'] != null && message['videos'].isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: VideoListWidget(videos: message['videos']),
                                ),

                              SizedBox(height: 6),
                              // time
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  createdTime,
                                  style: GoogleFonts.roboto(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      color: isSentByMe
                                          ? Colors.white
                                          : AppColors.black100),
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),

            // Upload image and video section
            Obx(() {
              return uploadImageController.uploadImageList.isEmpty && uploadImageController.uploadVideoList.isEmpty
                  ? SizedBox()
                  : SingleChildScrollView(
                  scrollDirection: Axis.horizontal, // Enable horizontal scrolling
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: List.generate(
                          uploadImageController.uploadImageList.length,
                              (index) {
                            final imageItem = uploadImageController.uploadImageList[index];
                            return Container(
                              width: ResponsiveHelper.w(context, 80),
                              height: ResponsiveHelper.h(context, 80),
                              margin: EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                color: AppColors.whiteColor,
                                border: Border.all(
                                  width: 0.5,
                                  color: Color(0xffBBC3CB),
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Stack(
                                children: [
                                  // Image Display
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: CustomNetworkImage(
                                      imageUrl: imageItem['url'], // Accessing the URL from the map
                                      height: ResponsiveHelper.h(context, 80),
                                      width: ResponsiveHelper.w(context, 80),
                                    ),
                                  ),
                                  // Delete Button
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: () {
                                        // Access 'key' from the map and pass it to the delete method
                                        uploadImageController.deletedImages(imageItem['key']);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                        ),
                                        child: Icon(
                                          Icons.close,
                                          color: Colors.redAccent,
                                          size: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: List.generate(
                          uploadImageController.uploadVideoList.length,
                              (index) {
                            final videoItem = uploadImageController.uploadVideoList[index];
                            return Container(
                              width: ResponsiveHelper.w(context, 80),
                              height: ResponsiveHelper.h(context, 80),
                              margin: EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                color: AppColors.whiteColor,
                                border: Border.all(
                                  width: 0.5,
                                  color: Color(0xffBBC3CB),
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Stack(
                                children: [
                                  // Image Display
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      alignment: Alignment.center,
                                      color: Colors.grey.shade200,
                                      child: Icon(Icons.play_arrow),
                                    ),
                                  ),
                                  // Delete Button
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: () {
                                        // Access 'key' from the map and pass it to the delete method
                                        uploadImageController.deletedVideo(videoItem['key']);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                        ),
                                        child: Icon(
                                          Icons.close,
                                          color: Colors.redAccent,
                                          size: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  )
              );
            }),

            // Input message field section
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20)
                ),
                border: Border(top: BorderSide(width: 1, color: Color(0xffBBC3CB))),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 5,
                    // offset: Offset(0, 2),
                  )
                ]
              ),
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                          hintText: 'message'.tr,
                          suffixIcon: Container(
                            width: 80,
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                   // await uploadImageController.pickImages();
                                    uploadImageController.showMediaPicker(context);
                                  },
                                  child: Icon(Icons.image, color: AppColors.secondaryColor,size: 26,),
                                ),
                                widthBox10,
                                Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                      color: AppColors.secondaryColor,
                                      shape: BoxShape.circle
                                  ),
                                  child: IconButton(
                                    onPressed: () async {

                                      if(
                                      _messageController.text.toString().isEmpty
                                          // uploadImageController.uploadImageList.isEmpty ||
                                          // uploadImageController.uploadVideoList.isEmpty
                                      ){
                                       return;
                                      }else{
                                        await socketService.submitMessage(
                                          text: _messageController.text,
                                          chatId:  widget.chatId,
                                          imagesUrls: uploadImageController.uploadImageList.map((url) => url['url']).toList(),
                                          videosUrls: uploadImageController.uploadVideoList.map((url) => url['url']).toList(),
                                        );

                                        _messageController.clear();
                                        uploadImageController.uploadImageList.clear();
                                        uploadImageController.uploadVideoList.clear();
                                      }
                                    },
                                    icon: Image.asset(
                                      AppImages.sendIcon,
                                      scale: 4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none
                          )
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
