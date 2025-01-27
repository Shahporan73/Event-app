// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:event_app/data/token_manager/const_veriable.dart';
import 'package:event_app/data/token_manager/local_storage.dart';
import 'package:event_app/res/app_colors/App_Colors.dart';
import 'package:event_app/res/app_images/App_images.dart';
import 'package:event_app/res/common_widget/RoundButton.dart';
import 'package:event_app/res/common_widget/custom_app_bar.dart';
import 'package:event_app/res/common_widget/custom_text.dart';
import 'package:event_app/res/custom_style/custom_size.dart';
import 'package:event_app/res/utils/time_convetor.dart';
import 'package:event_app/view/event_view/controller/my_event_controller.dart';
import 'package:event_app/view/event_view/view/comment_screen.dart';
import 'package:event_app/view/event_view/view/edit_post_screen.dart';
import 'package:event_app/view/event_view/widget/post_widget.dart';
import 'package:event_app/view/message_view/controller/personal_chat_controller.dart';
import 'package:event_app/view/profile_view/controller/user_profile_controller.dart';
import 'package:event_app/view/profile_view/view/edit_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../res/common_widget/custom_network_image_widget.dart';

class UserProfileScreen extends StatefulWidget {
  UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final UserProfileController controller = Get.put(UserProfileController());
  final MyEventController myEventController = Get.put(MyEventController());
  final PersonalChatController personalChatController = Get.put(PersonalChatController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.getUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: SingleChildScrollView(
            child: Obx(
                  () {
                var data =controller.userProfileModel.value.data;
                var userId = LocalStorage.getData(key: userProfileId);
                var myId = LocalStorage.getData(key: myID);
                var isMe = myId == data?.id;

                print('myId ===> $myId, and user id => $userId');

                return data == null ? Center(child: SpinKitCircle(color: AppColors.primaryColor),) : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomAppBar(
                      appBarName: "profile".tr,
                      onTap: () {
                        Get.back();
                      },
                    ),

                    heightBox20,

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          // margin: EdgeInsets.all(5),
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.primaryColor),
                            shape: BoxShape.circle,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100.r),
                            child: CustomNetworkImage(
                              imageUrl: data.profilePicture ?? placeholderImage,
                              width: 100,
                              height: 100,
                            ),
                          ),
                        ),
                        widthBox10,
                        Expanded(
                          child: CustomText(
                              title: data.name ?? '',
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppColors.blackColor
                          ),),
                      ],
                    ),

                    //post , follower and following
                    heightBox20,
                    Row(
                      children: [
                        // post
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(right: BorderSide(width: 1, color: Colors.grey )),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  title: 'posts'.tr,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff52697E),
                                ),
                                heightBox5,
                                CustomText(
                                  title: '${data?.postCount ?? '0'}',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.blackColor,
                                ),

                              ],
                            ),
                          ),
                        ),
                        // follower
                        25.widthBox,
                        Expanded(child: Container(
                          decoration: BoxDecoration(
                            border: Border(right: BorderSide(width: 1, color: Colors.grey )),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              CustomText(
                                title: 'Followers',
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff52697E),
                              ),
                              heightBox5,
                              CustomText(
                                title: '${data?.followerCount ?? '0'}',
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: AppColors.blackColor,
                              ),

                            ],
                          ),
                        ),),
                        // following
                        25.widthBox,
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              title: 'Following',
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff52697E),
                            ),
                            heightBox5,
                            CustomText(
                              title: data?.followingCount.toString() ?? '0',
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: AppColors.blackColor,
                            ),

                          ],
                        ),),
                      ],
                    ),

                    // follow and chat button
                    heightBox20,
                    isMe? Roundbutton(
                        title: 'edit_profile'.tr,
                        padding_vertical: 8,
                        borderRadius: 8,
                        onTap: (){
                          Get.to(
                                () => EditProfileScreen(),
                            transition: Transition.rightToLeft,
                            duration: Duration(milliseconds: 300),
                          );
                        }
                    ) :
                    Row(
                      children: [
                        Expanded(
                          child: Roundbutton(
                            padding_vertical: 8,
                            borderRadius: 8,
                            fontSize: 14,
                            title: controller.followStates[data.id.toString()] == true
                                ? "Following"
                                : "Follow",

                            widget: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CustomText(
                                  title: controller.followStates[data.id.toString()] == true
                                      ? "Following"
                                      : "Follow",
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                                widthBox5,
                                controller.isFollowLoading.value?
                                SpinKitThreeBounce(color: Colors.white, size: 12,):SizedBox(),
                              ],
                            ),
                            onTap: () async {
                              print("userId ====> ${data.id.toString()}");
                              await controller.onFollow(
                                data.id.toString() ?? '',
                              );
                            },
                          ),
                        ),
                        widthBox20,
                        GestureDetector(
                          onTap: () {
                            if (data?.id == null) {
                              Get.rawSnackbar(message: "User not found");
                            } else {
                              personalChatController.getChatList(
                                receiverId: data?.id ?? "",
                                userName: data?.name ?? "",
                                userImage: data?.profilePicture ?? "",
                              );
                            }
                          },
                          child: Container(
                            width: 80,
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(vertical: 8.h),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(8.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 10,
                                  blurRadius: 10,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: CustomText(
                              title: "chat".tr,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: AppColors.blackColor,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // about
                    heightBox10,
                    Center(
                      child: CustomText(
                          title: "posts".tr,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryColor
                      ),
                    ),
                    Divider(),
                    controller.postList.isEmpty?
                    Center(
                      child: CustomText(title: 'no_post_found'.tr,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryColor),
                    ) : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: controller.postList.length,
                      itemBuilder: (context, index) {

                        var post = controller.postList[index];
                        // String createdAt = ge;
                        var createdTime = getRelativeTime(post.createdAt.toString());


                        // Merge files (images) and videos into a single mediaList
                        var mediaList = [
                          ...post.files.map<Map<String, String>>((file) => {
                            'url': file.url ?? placeholderImage,
                            'type': 'image',
                          }).toList(), // Convert Iterable to List
                          ...post.videos.map<Map<String, String>>((video) => {
                            'url': '${video.url}' ?? '', /*'https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4'*/
                            'type': 'video',
                          }).toList(), // Convert Iterable to List
                        ];

                        print("mediaList ====> ${mediaList}");
                        bool isLiked = post.like.any((e) => e.userId == myId);

                        return PostWidget(
                          profileImage: data?.profilePicture ?? placeholderImage,
                          mediaList: mediaList,
                          name: data?.name ?? '',
                          description: post.body ?? '',
                          time: createdTime,
                          likeCount: '${post.likeCount ?? 0}',
                          commentCount: '${post.commentCount ?? 0}',
                          isLiked: isLiked,
                          onDelete: () async {
                            await myEventController.deletePost(post.id.toString());
                            mediaList.clear();
                          },
                          onEdit: () {
                            // save post id to edit this post
                            LocalStorage.saveData(key: editPostId, data: post.id.toString());
                            print("editPostId ====> ${post.id.toString()}");
                            // navigate to edit post screen
                            Get.to(
                                  () =>EditPostScreen(postId: post.id.toString(),),
                              transition: Transition.downToUp,
                              duration: const Duration(milliseconds: 300),
                            );
                          },
                          onLike: () async {
                            // if(isMe == true) {
                            //   Get.rawSnackbar(message: 'Like',backgroundColor: Colors.green);
                            // }else {
                            //   Get.rawSnackbar(message: 'UnLike', backgroundColor: Colors.red);
                            // }
                            await myEventController.createLike(post.id.toString());
                          },
                          onComment: () {
                            LocalStorage.saveData(key: postIDForGetComment, data: post.id);
                            print("postIDForGetComment ====> ${LocalStorage.getData(key: postIDForGetComment)}");
                            print('post id ${post.id.toString()}');
                            Get.to(
                                    () => CommentScreen(postId: post.id.toString()),
                                transition: Transition.downToUp,
                                duration: Duration(milliseconds: 300)
                            );
                          },
                          onRouteUserProfile: () {
                          },
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

