import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';


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
        // Video Progress Bar with Scrubbing
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
            // Play/Pause Button
            IconButton(
              icon: Icon(
                widget.videoController.value.isPlaying
                    ? Icons.pause
                    : Icons.play_arrow,
                color: Colors.white,
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
            // Mute/Unmute Button
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