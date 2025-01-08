// ignore_for_file: prefer_const_constructors

import 'package:event_app/res/common_widget/custom_network_image_widget.dart';
import 'package:event_app/res/common_widget/custom_text.dart';
import 'package:event_app/res/common_widget/video_player_widget.dart';
import 'package:event_app/view/event_view/sub_screen/media_viewer_screen.dart';
import 'package:event_app/view/message_view/controller/media_controller.dart';
import 'package:event_app/view/message_view/sub_screen/full_screen_video.dart';
import 'package:event_app/view/message_view/sub_screen/photo_viewer_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SeeAllMediaScreen extends StatelessWidget {
  SeeAllMediaScreen({super.key});
  final MediaController controller = Get.put(MediaController());

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Obx(
      () {
        return DefaultTabController(
          length: 2, // Two tabs: Images and Videos
          child: Scaffold(
            backgroundColor: Colors.black12,
            appBar: AppBar(
              title: const Text('Media Viewer'),
              bottom: const TabBar(
                tabs: [
                  Tab(text: 'Images'),
                  Tab(text: 'Videos'),
                ],
              ),
            ),
            body: Padding(
                padding: EdgeInsets.all(8.0),
              child: TabBarView(
                children: [
                  // Images Tab
                  controller.imageList.isEmpty ?
                  Center(
                    child: CustomText(
                        title: 'No Images',
                      color: Colors.white,
                    ),
                  ) :
                  GridView.builder(
                    itemCount: controller.imageList.length,
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Get.to(
                                () => PhotoViewerScreen(
                              mediaList: controller.imageList,
                              initialIndex: index,
                            ),
                            transition: Transition.downToUp,
                            duration: const Duration(milliseconds: 100),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CustomNetworkImage(
                              imageUrl: controller.imageList[index],
                              height: height,
                              width: width
                          ),
                        ),
                      );
                    },
                  ),


                  // Videos Tab
                  controller.videoList.isEmpty ?
                  Center(
                    child: CustomText(
                      title: 'No Videos',
                      color: Colors.white,
                    ),
                  ) :GridView.builder(
                    itemCount: controller.videoList.length,
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Get.to(
                            () => FullScreenVideo(
                              videoUrl: controller.videoList[index],
                            ),
                            transition: Transition.downToUp,
                            duration: const Duration(milliseconds: 100),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: VideoPlayerWidget(
                              videoUrl: controller.videoList[index],
                              height: height,
                              width: width
                          ),
                        ),
                      );
                    },
                  ),

                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
