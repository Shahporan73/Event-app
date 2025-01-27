// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'package:event_app/data/services/socket_controller.dart';
import 'package:event_app/data/token_manager/const_veriable.dart';
import 'package:event_app/data/token_manager/local_storage.dart';
import 'package:event_app/res/app_colors/App_Colors.dart';
import 'package:event_app/res/app_images/App_images.dart';
import 'package:event_app/res/common_controller/video_play_controller.dart';
import 'package:event_app/res/common_widget/custom_network_image_widget.dart';
import 'package:event_app/res/common_widget/custom_text.dart';
import 'package:event_app/res/common_widget/responsive_helper.dart';
import 'package:event_app/res/common_widget/video_player_widget.dart';
import 'package:event_app/res/custom_style/custom_size.dart';
import 'package:event_app/res/utils/time_convetor.dart';
import 'package:event_app/view/message_view/controller/upload_image_controller.dart';
import 'package:event_app/view/message_view/model/chat_list_model.dart';
import 'package:event_app/view/message_view/widget/grid_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../widget/videos_list_widget.dart';
import 'community_details_screen.dart';

class CommunityChatScreen extends StatefulWidget {
  final chatId;
  final String communityName;
  final List<Participant> members;
  final String communityImage;
  final bool isCommunityOwner;
  CommunityChatScreen({
    super.key, this.chatId,
    required this.communityName,
    required this.members,
    required this.communityImage,
    required this.isCommunityOwner
  });

  @override
  State<CommunityChatScreen> createState() => _CommunityChatScreenState();
}

class _CommunityChatScreenState extends State<CommunityChatScreen> {
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
    socketService.messages.clear();
    if (communityId != null) {
      socketService.fetchMessages(chatId: communityId);
    } else {
      print('Community ID not found!');
    }
  }

  @override
  void dispose() {
    super.dispose();
    socketService.seenMessage(chatId: widget.chatId, token: LocalStorage.getData(key: 'access_token'));
  }
  void _scrollToBottom() {
    // Ensure the operation is executed after the current frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 150), // Shortened duration for faster scrolling
          curve: Curves.easeInOut, // Smoother scrolling curve
        );
        // _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }


  @override
  Widget build(BuildContext context) {

    // print('Member boyd ${widget.members.map((e) => e.user?.name,)}');

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar section
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(Icons.arrow_back, color: Colors.black),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: ListTile(
                      onTap: () {

                        // Save the community ID to local storage
                        LocalStorage.saveData(key: 'mediaCommunityId', data: widget.chatId);

                        Get.to(
                              () => CommunityDetailsScreen(
                                  communityName: widget.communityName,
                                  members: widget.members,
                                  communityImage: widget.communityImage,
                                communityId: widget.chatId,
                                isCommunityOwner: widget.isCommunityOwner,
                              ),
                          transition: Transition.downToUp,
                          duration: Duration(milliseconds: 300),
                        );
                      },
                      leading: CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(
                          widget.communityImage.isNotEmpty ? widget.communityImage : placeholderImage,
                        ),
                      ),
                      title: CustomText(
                        title: widget.communityName ?? "N/A",
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff1D242D),
                      ),
                      subtitle: CustomText(
                        title: '${widget.members.length ?? 0} '+'members'.tr,
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff1D242D),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Chat messages section
            Expanded(
              child: Obx(() {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollToBottom();
                });

                return socketService.isLoading.value || socketService.messages.isEmpty?
                Center(child: SpinKitRipple(color: AppColors.primaryColor, size: 32,)) :
                ListView.builder(
                  controller: _scrollController,
                  shrinkWrap: true,
                  itemCount: socketService.messages.length,
                  itemBuilder: (context, index) {
                    final message = socketService.messages[index];
                    final isSentByMe = message['senderId'] == LocalStorage.getData(key: myID);
                    String createdTime = getRelativeTime(message['createdAt']);

                    var body = socketService.messages;

                    print('message body: ${body}');

                    return message['type'] != null ?
                        Container(
                          padding: EdgeInsets.all(5.0),
                          margin: EdgeInsets.symmetric(horizontal: 0.0, vertical: 5.0),
                          color: Colors.grey[50],
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                message['text'] ?? '',
                                style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    color: isSentByMe
                                        ? Colors.black
                                        : Colors.black,
                                ),
                              ),
                              /*heightBox5,
                              Text(
                                createdTime,
                                style: GoogleFonts.roboto(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: isSentByMe
                                        ? Colors.black
                                        : Colors.black
                                ),
                              ),*/
                            ],
                          ),
                        )
                        : Padding(
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
                                color: Colors.black.withOpacity(0.10),
                                spreadRadius: 2,
                                blurRadius: 2,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              if (!isSentByMe)
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        radius: 15,
                                        backgroundColor: AppColors.primaryColor,
                                        backgroundImage: NetworkImage(
                                          message['senderProfilePicture'] ?? placeholderImage,
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        message['senderName'] ?? '',
                                        style: GoogleFonts.roboto(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            color: AppColors.black100
                                        ),
                                      ),
                                    ],
                                  )
                                ),

                              if (!isSentByMe)
                                Divider(),

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
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  createdTime,
                                  style: GoogleFonts.roboto(
                                      fontSize: 12,
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
              return uploadImageController.uploadImageList.isEmpty &&
                  uploadImageController.uploadVideoList.isEmpty
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
                  topLeft: Radius.circular(20.r),
                  topRight: Radius.circular(20.r),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 10,
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'message'.tr,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      // await uploadImageController.pickImages();
                      uploadImageController.showMediaPicker(context);
                    },
                    child: Icon(Icons.image, color: AppColors.secondaryColor,size: 26,),
                  ),
                  IconButton(
                    onPressed: () async {

                      if(
                      _messageController.text.isEmpty
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
                      color: AppColors.primaryColor,
                      scale: 3,
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
