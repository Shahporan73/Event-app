// ignore_for_file: prefer_const_constructors

import 'package:event_app/res/common_widget/video_player_widget.dart';
import 'package:event_app/view/message_view/sub_screen/full_screen_video.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VideoListWidget extends StatelessWidget {
  final List<dynamic> videos;

  VideoListWidget({super.key,required this.videos});

  @override
  Widget build(BuildContext context) {
    int imageCount = videos.length;
    if(imageCount==0){
      return Container();
    }else{
      return ListView.builder(
        itemCount: imageCount,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Get.to(
                    () => FullScreenVideo(
                  videoUrl: videos[index],
                ),
                transition: Transition.downToUp,
                duration: Duration(milliseconds: 100),
              );
            },
            child: Container(
              margin: EdgeInsets.only(bottom: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.black,
              ),
              child: VideoPlayerWidget(
                videoUrl: videos[index],
                width: MediaQuery.of(context).size.width * 0.5,
                height: 150,
              ),
            ),
          );
        },
      );
    }
  }
}
