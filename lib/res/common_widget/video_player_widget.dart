// ignore_for_file: prefer_const_constructors

import 'package:event_app/view/message_view/sub_screen/full_screen_video.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final double height;
  final double width;

  const VideoPlayerWidget({
    Key? key,
    required this.videoUrl,
    this.height = 300.0, // Default height
    this.width = 300.0,  // Default width
  }) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _isFullScreen = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {}); // Refresh the widget when the video is initialized
      });

    _controller.addListener(() {
      setState(() {}); // Update the state whenever the position changes
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the controller when the widget is removed
    super.dispose();
  }

  void toggleFullScreen() {
    if (_isFullScreen) {
      Navigator.pop(context); // Exit fullscreen
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FullScreenVideo(videoUrl: widget.videoUrl),
        ),
      ); // Enter fullscreen
    }
  }

  String formatDuration(Duration duration) {
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _controller.value.isInitialized
          ? SizedBox(
          height: widget.height,
          width: widget.width,
          child: Stack(
            children: [
              Positioned.fill(
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
              ),
              Positioned(
                bottom: 10,
                left: 10,
                right: 10,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(
                            _controller.value.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                          ),
                          color: Colors.red,
                          onPressed: () {
                            setState(() {
                              _controller.value.isPlaying
                                  ? _controller.pause()
                                  : _controller.play();
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.stop),
                          color: Colors.red,
                          onPressed: () {
                            setState(() {
                              _controller.seekTo(Duration.zero);
                              _controller.pause();
                            });
                          },
                        ),
                       /*IconButton(
                          icon: _isFullScreen ? const Icon( Icons.fullscreen_exit,) : const Icon( Icons.fullscreen,),
                          onPressed: toggleFullScreen,
                        ),*/
                      ],
                    ),
                    // Time display and seek bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            formatDuration(_controller.value.position),
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.red
                          ),
                        ),
                        Expanded(child: SizedBox(
                          height: 5.0,
                          child: Slider(
                            activeColor: Colors.red,
                            inactiveColor: Colors.red.withAlpha(100),
                            value: _controller.value.position.inSeconds.toDouble(),
                            min: 0.0,
                            max: _controller.value.duration.inSeconds.toDouble(),
                            onChanged: (value) {
                              setState(() {
                                _controller.seekTo(Duration(seconds: value.toInt()));
                              });
                            },
                          ),
                        )
                        ),
                        Text(formatDuration(_controller.value.duration), style: TextStyle(
                          fontSize: 12,
                          color: Colors.red
                        ),),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          )


      )
          : SpinKitCircle(color: Colors.red), // Show loader while video initializes
    );
  }
}
