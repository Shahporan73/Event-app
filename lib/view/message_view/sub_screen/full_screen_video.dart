import 'package:event_app/res/common_widget/video_player_widget.dart';
import 'package:flutter/material.dart';

class FullScreenVideo extends StatelessWidget {
  final String videoUrl;
  FullScreenVideo({super.key, required this.videoUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
              child: VideoPlayerWidget(
                videoUrl: videoUrl,
                width: double.infinity,
                height: double.infinity,
              ),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: IconButton(
              icon: const Icon(
                Icons.close,
                color: Colors.redAccent,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          )
        ],
      )
    );
  }
}
