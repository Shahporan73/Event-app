import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ShowViewScreen extends StatefulWidget {
  final String videoPath;

  ShowViewScreen({required this.videoPath});

  @override
  _ShowViewScreenState createState() => _ShowViewScreenState();
}

class _ShowViewScreenState extends State<ShowViewScreen> {
  late VideoPlayerController _controller;
  Timer? _progressTimer;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.videoPath))
      ..initialize().then((_) {
        setState(() {}); // Update the UI once the video is initialized
        _startProgressTimer();
        _controller.play(); // Automatically play the video on first load
      })
      ..setLooping(false); // Stop looping to handle replay manually

    _controller.addListener(() {
      if (_controller.value.position >= _controller.value.duration) {
        // Video finished, pause automatically
        _controller.pause();
        setState(() {});
      }
    });
  }

  void _startProgressTimer() {
    _progressTimer = Timer.periodic(Duration(milliseconds: 500), (_) {
      if (_controller.value.isInitialized && _controller.value.isPlaying) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the controller to free resources
    _progressTimer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    if (hours > 0) {
      return '${hours}h ${minutes}m ${seconds}s';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: _controller.value.isInitialized
            ? Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
              SizedBox(height: 30),
              // Linear Progress Bar
              Column(
                children: [
                  LinearProgressIndicator(
                    value: _controller.value.position.inSeconds.toDouble() /
                        _controller.value.duration.inSeconds.toDouble(),
                    backgroundColor: Colors.grey,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                    minHeight: 6,
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDuration(_controller.value.position),
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      Text(
                        _formatDuration(_controller.value.duration),
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              IconButton(
                icon: Icon(
                  _controller.value.isPlaying
                      ? Icons.pause
                      : Icons.replay, // Show replay icon when video ends
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    if (_controller.value.isPlaying) {
                      _controller.pause();
                    } else if (_controller.value.position >=
                        _controller.value.duration) {
                      // Replay the video when it's finished
                      _controller.seekTo(Duration.zero);
                      _controller.play();
                    } else {
                      _controller.play();
                    }
                  });
                },
              ),
            ],
          ),
        )
            : CircularProgressIndicator(color: Colors.white),
      ),
    );
  }
}
