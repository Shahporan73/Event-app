// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:io';
import 'package:event_app/res/app_colors/App_Colors.dart';
import 'package:event_app/res/common_widget/custom_text.dart';
import 'package:event_app/res/custom_style/custom_size.dart';
import 'package:event_app/view/event_view/controller/camera_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
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
  final CameraManager cameraManagerController = Get.put(CameraManager());

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
    _controller.dispose();
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
        actions: [
          GestureDetector(
            onTap: () async {
              await cameraManagerController.uploadVideo(context);
            },
            child: Obx(
                  () =>cameraManagerController.isUploading.value
                      ? const SpinKitThreeBounce(
                    size: 16,
                    color: AppColors.primaryColor,
                  ) : Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.cloud_upload_outlined, color: Colors.black),
                    const SizedBox(width: 8),
                    CustomText(title: "upload".tr, color: Colors.black),
                  ],
                ),
              ),
            ),
          ),


          widthBox5,
          GestureDetector(
            onTap: () async {
              cameraManagerController.deleteLocalVideo(widget.videoPath, context);
            },
            child: Obx(
                  () => Container(
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: cameraManagerController.isDeleting.value
                    ? SpinKitCircle(
                  size: 16,
                  color: AppColors.primaryColor,
                )
                    : Row(
                  children: [
                    Icon(Icons.delete_outline, color: Colors.red),
                    widthBox8,
                    CustomText(title: "Delete".tr, color: Colors.red)
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: _controller.value.isInitialized
            ? Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                height: 400,
                child: VideoPlayer(_controller),
              ),
              SizedBox(height: 30),
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
                      : Icons.replay,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    if (_controller.value.isPlaying) {
                      _controller.pause();
                    } else if (_controller.value.position >=
                        _controller.value.duration) {
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
