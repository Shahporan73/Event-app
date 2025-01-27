// Media Viewer Screen
import 'package:event_app/data/api/base_client.dart';
import 'package:event_app/res/common_controller/video_play_controller.dart';
import 'package:event_app/res/common_widget/video_player_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class MediaViewerScreen extends StatefulWidget {
  final List<Map<String, String>> mediaList;
  final int initialIndex;

  const MediaViewerScreen({required this.mediaList, required this.initialIndex});

  @override
  _MediaViewerScreenState createState() => _MediaViewerScreenState();
}

class _MediaViewerScreenState extends State<MediaViewerScreen> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex; // Set the initial index
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('media_viewer'.tr),
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.mediaList.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index; // Update current index
                });
              },
              itemBuilder: (context, index) {
                final media = widget.mediaList[index];
                if (media['type'] == 'video') {
                  return VideoPlayerWidget(videoUrl: media['url']!);
                } else {
                  return Image.network(
                    media['url']!,
                    fit: BoxFit.contain,
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "viewing".tr+" ${_currentIndex + 1} of ${widget.mediaList.length}",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}