// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'package:event_app/data/token_manager/const_veriable.dart';
import 'package:event_app/data/token_manager/local_storage.dart';
import 'package:event_app/res/app_colors/App_Colors.dart';
import 'package:event_app/res/common_widget/RoundTextField.dart';
import 'package:event_app/res/common_widget/custom_app_bar.dart';
import 'package:event_app/res/common_widget/custom_network_image_widget.dart';
import 'package:event_app/res/common_widget/custom_text.dart';
import 'package:event_app/res/common_widget/responsive_helper.dart';
import 'package:event_app/res/custom_style/custom_size.dart';
import 'package:event_app/res/utils/time_convetor.dart';
import 'package:event_app/view/event_view/controller/my_event_controller.dart';
import 'package:event_app/view/event_view/controller/post_controller.dart';
import 'package:event_app/view/event_view/view/edit_post_screen.dart';
import 'package:event_app/view/event_view/widget/post_widget.dart';
import 'package:event_app/view/profile_view/controller/profile_controller.dart';
import 'package:event_app/view/profile_view/view/user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'comment_screen.dart';
import 'create_post_screen.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {

  final MyEventController controller = Get.put(MyEventController());
  final ProfileController profileController = Get.put(ProfileController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.getMyEventsPost();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SingleChildScrollView(
        child: Obx(
          () {
            return Column(
              children: [
                // Header image
                Container(
                    width: width,
                    height: ResponsiveHelper.h(context, 250),
                    child: Stack(
                      children: [
                        CustomNetworkImage(
                            imageUrl: controller.eventPostModel.value.data?.image ?? placeholderImage,
                            height: height,
                            width: width),
                        Positioned(
                          top: 35,
                          right: 16,
                          left: 16,
                          child: CustomAppBar(
                            titleColor: Colors.white,
                            appBarName: "post".tr,
                            onTap: () => Get.back(),
                            leadingColor: Colors.white,
                          ),
                        ),
                      ],
                    )),
                // details
                heightBox10,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      // name and rating

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            '${controller.eventPostModel.value.data?.rating ?? "0.0"}',
                            style: GoogleFonts.poppins(
                              fontSize: 10.sp,
                              color: Color(0xffFEA500),
                            ),
                          ),
                          widthBox10,
                          RatingBarIndicator(
                            itemSize: 12,
                            rating: (controller.eventPostModel.value.data?.rating ?? 0.0).toDouble(),
                            itemCount: 5,
                            direction: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Icon(
                                Icons.star,
                                color: Color(0xffFEA500),
                              );
                            },
                          ),
                          SizedBox(width: 5),
                          Text(
                            '(${controller.eventPostModel.value.data?.reviews ?? "0"})',
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              color: Color(0xffFEA500),
                            ),
                          ),
                        ],
                      ),
                      heightBox10,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            title: controller.eventPostModel.value.data?.name ?? "",
                            color: AppColors.black100,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ],
                      ),


                      // members
                      // heightBox10,
                      // Row(
                      //   crossAxisAlignment: CrossAxisAlignment.center,
                      //   children: [
                      //     Row(
                      //       children: List.generate(
                      //         3,
                      //             (index) {
                      //           return Align(
                      //             widthFactor: 0.5,
                      //             child: ClipRRect(
                      //               borderRadius: BorderRadius.circular(50),
                      //               child: CustomNetworkImage(
                      //                   imageUrl: 'https://www.perfocal.com/blog/content/images/2021/01/Perfocal_17-11-2019_TYWFAQ_100_standard-3.jpg',
                      //                   height: 40,
                      //                   width: 40),
                      //             ),
                      //           );
                      //         },
                      //       ),
                      //     ),
                      //     widthBox20,
                      //     CustomText(
                      //         title: "150 members",
                      //         color: AppColors.secondaryColor,
                      //         fontWeight: FontWeight.w500,
                      //         fontSize: 10),
                      //   ],
                      // ),

                      // image and write something
                      heightBox20,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50.r),
                            child: CustomNetworkImage(
                                imageUrl: profileController.imgURL.value,
                                height: ResponsiveHelper.h(context, 50),
                                width: ResponsiveHelper.w(context, 50)),
                          ),
                          widthBox10,
                          Expanded(
                            child: RoundTextField(
                              hint: "write_something".tr,
                              readOnly: true,
                              borderRadius: 44,
                              focusBorderRadius: 44,
                              onTap: () {
                                Get.to(
                                      () => CreatePostScreen(eventId: controller.eventPostModel.value.data!.id.toString()),
                                  transition: Transition.downToUp,
                                  duration: const Duration(milliseconds: 300),
                                );
                              },
                            ),
                          ),
                        ],
                      ),

                      heightBox10,
                      controller.isLoading.value ?
                          Center(
                            child: SpinKitCircle(
                              color: AppColors.primaryColor,
                            ),
                          )
                          :
                      controller.postList.isEmpty ?
                          Center(
                            child: CustomText(title: 'no_post'.tr),
                          )
                          : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.postList.length,
                        itemBuilder: (context, index) {
                          var data = controller.postList[index];
                          var createdTime = getRelativeTime(data.createdAt.toString());

                          // Merge files (images) and videos into a single mediaList
                          var mediaList = [
                            ...data.files.map<Map<String, String>>((file) => {
                              'url': file.url ?? placeholderImage,
                              'type': 'image',
                            }).toList(), // Convert Iterable to List
                            ...data.videos.map<Map<String, String>>((video) => {
                              'url': '${video.url}' ?? '', /*'https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4'*/
                              'type': 'video',
                            }).toList(), // Convert Iterable to List
                          ];

                          print("mediaList ====> ${mediaList}");

                          return PostWidget(
                            profileImage: data.user?.profilePicture ?? placeholderImage,
                            mediaList: mediaList,
                            name: data.user?.name ?? '',
                            description: data.body ?? '',
                            time: createdTime,
                            likeCount: '${data.likeCount ?? 0}',
                            commentCount: '${data.commentCount ?? 0}',
                            isLiked: data.isMeLiked ?? false,
                            onDelete: () async {
                              await controller.deletePost(data.id.toString());
                              mediaList.clear();
                            },
                            onEdit: () {

                              // save post id to edit this post
                              LocalStorage.saveData(key: editPostId, data: data.id.toString());
                              print("editPostId ====> ${data.id.toString()}");
                              // navigate to edit post screen
                              Get.to(
                                      () =>EditPostScreen(postId: data.id.toString(),),
                                  transition: Transition.downToUp,
                                  duration: const Duration(milliseconds: 300),
                              );
                            },
                            onLike: () async {
                              if(data.isMeLiked == false) {
                                Get.rawSnackbar(message: 'Like',backgroundColor: Colors.green);
                              }else {
                                Get.rawSnackbar(message: 'UnLike', backgroundColor: Colors.red);
                              }
                              await controller.createLike(data.id.toString());
                            },
                            onComment: () {
                              LocalStorage.saveData(key: postIDForGetComment, data: data.id);
                              print("postIDForGetComment ====> ${LocalStorage.getData(key: postIDForGetComment)}");
                              print('post id ${data.id.toString()}');
                              Get.to(
                                      () => CommentScreen(postId: data.id.toString()),
                                  transition: Transition.downToUp,
                                  duration: Duration(milliseconds: 300)
                              );
                            },
                            onRouteUserProfile: () {
                              LocalStorage.saveData(key: userProfileId, data: data.user?.id);
                              Get.to(
                                    () => UserProfileScreen(),
                                transition: Transition.rightToLeft,
                                duration: Duration(milliseconds: 300),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
