// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieLoaderWidget extends StatelessWidget {
  final String lottieAssetPath;
  final double? height;
  final double? width;
  final Color? overlayColor;
  final double overlayOpacity;
  final String? loadingMessage;
  final TextStyle? messageStyle;
  final bool repeat;
  final bool reverse;
  final double animationSpeed;

  const LottieLoaderWidget({
    Key? key,
    required this.lottieAssetPath,
    this.height,
    this.width,
    this.overlayColor = Colors.black,
    this.overlayOpacity = 0.5,
    this.loadingMessage,
    this.messageStyle,
    this.repeat = true,
    this.reverse = false,
    this.animationSpeed = 1.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Optional overlay background
        if (overlayColor != null)
          Container(
            color: overlayColor!.withOpacity(overlayOpacity),
          ),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                lottieAssetPath,
                height: height ?? 100,
                width: width ?? 100,
                repeat: repeat,
                reverse: reverse,
                animate: true,
                options: LottieOptions(enableMergePaths: true),
                alignment: Alignment.center,
                frameRate: FrameRate.max,
                delegates: LottieDelegates(
                  values: [
                    // Customize colors for specific layers, if applicable
                    ValueDelegate.colorFilter(
                      ["**", "LayerName"], // Use appropriate layer names
                      value: ColorFilter.mode(
                        Colors.blue, // Customize color here
                        BlendMode.srcATop,
                      ),
                    ),
                  ],
                ),
              ),
              if (loadingMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    loadingMessage!,
                    style: messageStyle ??
                        TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
