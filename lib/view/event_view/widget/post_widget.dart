// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:event_app/data/token_manager/local_storage.dart';
import 'package:event_app/res/app_colors/App_Colors.dart';
import 'package:event_app/res/app_images/App_images.dart';
import 'package:event_app/res/common_widget/custom_network_image_widget.dart';
import 'package:event_app/res/common_widget/custom_text.dart';
import 'package:event_app/view/event_view/sub_screen/media_viewer_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

class PostWidget extends StatelessWidget {
  final String profileImage;
  final List<Map<String, String>> mediaList; // Contains both images and videos
  final String name;
  final String description;
  final String time;
  final bool? isLiked;
  final String likeCount;
  final String commentCount;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onRouteUserProfile;

  PostWidget({
    super.key,
    required this.profileImage,
    required this.mediaList,
    required this.name,
    required this.description,
    required this.time,
    required this.onDelete,
    required this.onEdit,
    required this.onLike,
    required this.onComment,
    this.isLiked = false,
    required this.likeCount,
    required this.commentCount,
    required this.onRouteUserProfile,
  });

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Card(
      color: AppColors.bgColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: onRouteUserProfile,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(profileImage),
                    radius: 25,
                  ),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: AppColors.blackColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      time,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColors.black100,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                PopupMenuButton<int>(
                  icon: Icon(Icons.more_horiz, color: Colors.grey),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Colors.teal, width: 1),
                  ),
                  elevation: 8,
                  offset: Offset(0, 40),
                  onSelected: (value) {
                    if (value == 1) {
                      onEdit();
                    } else if (value == 2) {
                      onDelete();
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 1,
                      child: Row(
                        children: [
                          Icon(Icons.edit, color: Colors.teal),
                          SizedBox(width: 8),
                          Text('Edit', style: TextStyle(color: Colors.black)),
                        ],
                      ),
                    ),
                    PopupMenuDivider(),
                    PopupMenuItem(
                      value: 2,
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Delete', style: TextStyle(color: Colors.black)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              description,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: AppColors.blackColor,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: mediaList.length == 1 ? 1 : 2,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                childAspectRatio: 1.6,
              ),
              itemCount: mediaList.length > 4 ? 4 : mediaList.length,
              itemBuilder: (context, index) {
                if (index == 3 && mediaList.length > 4) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MediaViewerScreen(
                            mediaList: mediaList,
                            initialIndex: index,
                          ),
                        ),
                      );
                    },
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          mediaList[index]['url']!,
                          fit: BoxFit.cover,
                        ),
                        Container(
                          color: Colors.black54,
                          child: Center(
                            child: Text(
                              '+${mediaList.length - 3}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (mediaList[index]['type'] == 'video') {
                  VideoPlayerController controller = VideoPlayerController.network(mediaList[index]['url'] ?? '');

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MediaViewerScreen(
                            mediaList: mediaList,
                            initialIndex: index,
                          ),
                        ),
                      );
                    },
                    child: FutureBuilder(
                      future: controller.initialize(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return Stack(
                            children: [
                              AspectRatio(
                                aspectRatio: controller.value.aspectRatio,
                                child: VideoPlayer(controller),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: VideoControls(videoController: controller),
                              ),
                            ],
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Icon(Icons.error, color: Colors.red),
                          );
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    ),
                  );
                } else {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MediaViewerScreen(
                            mediaList: mediaList,
                            initialIndex: index,
                          ),
                        ),
                      );
                    },
                    child: CustomNetworkImage(
                      imageUrl: mediaList[index]['url']!,
                      height: height,
                      width: width,
                    ),
                  );
                }
              },
            ),

            SizedBox(height: 10),
            Row(
              children: [
                GestureDetector(
                  onTap: onLike,
                  child: Row(
                    children: [
                      Image.asset(
                        AppImages.likeIcon,
                        scale: 4,
                        color: isLiked == true ?
                             AppColors.primaryColor
                            : AppColors.blackColor,
                      ),
                      SizedBox(width: 4),
                      CustomText(
                        title: likeCount,
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                        color: Color(0xff6A798A),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 20),
                GestureDetector(
                  onTap: onComment,
                  child: Row(
                    children: [
                      Image.asset(AppImages.commentIcon, scale: 4),
                      SizedBox(width: 4),
                      CustomText(
                        title: commentCount,
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                        color: Color(0xff6A798A),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


class VideoControls extends StatefulWidget {
  final VideoPlayerController videoController;

  const VideoControls({required this.videoController});

  @override
  State<VideoControls> createState() => _VideoControlsState();
}

class _VideoControlsState extends State<VideoControls> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        VideoProgressIndicator(
          widget.videoController,
          allowScrubbing: true,
          colors: VideoProgressColors(
            playedColor: Colors.red,
            backgroundColor: Colors.grey,
            bufferedColor: Colors.lightBlueAccent,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(
                widget.videoController.value.isPlaying
                    ? Icons.pause
                    : Icons.play_arrow,
                color: Colors.red,
              ),
              onPressed: () {
                setState(() {
                  if (widget.videoController.value.isPlaying) {
                    widget.videoController.pause();
                  } else {
                    widget.videoController.play();
                  }
                });
              },
            ),
            IconButton(
              icon: Icon(
                widget.videoController.value.volume > 0
                    ? Icons.volume_up
                    : Icons.volume_off,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  if (widget.videoController.value.volume > 0) {
                    widget.videoController.setVolume(0);
                  } else {
                    widget.videoController.setVolume(1);
                  }
                });
              },
            ),
          ],
        ),
      ],
    );
  }
}





class VideoWidget extends StatelessWidget {
  final String videoUrl;

  const VideoWidget({Key? key, required this.videoUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    VideoPlayerController controller;

    // Custom headers if needed
    Map<String, String> headers = {
      'Authorization': 'Bearer ${LocalStorage.getData(key: "access_token")}',
      'Accept': 'application/json',
    };
    String encodedUrl = Uri.encodeFull(videoUrl);

    controller = VideoPlayerController.network(encodedUrl, httpHeaders: headers);

    return FutureBuilder(
      future: controller.initialize(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: VideoPlayer(controller),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error loading video'));
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
