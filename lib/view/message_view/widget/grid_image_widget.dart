// ignore_for_file: prefer_const_constructors

import 'package:event_app/res/common_widget/custom_network_image_widget.dart';
import 'package:event_app/res/common_widget/video_player_widget.dart';
import 'package:event_app/view/event_view/sub_screen/media_viewer_screen.dart';
import 'package:event_app/view/message_view/sub_screen/photo_viewer_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GridImageWidget extends StatelessWidget {
  final List<dynamic> images;

  GridImageWidget({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    int imageCount = images.length;

    if (imageCount == 1) {
      // Single image: Display as large as possible
      return GestureDetector(
        onTap: () {
          Get.to(
                () => PhotoViewerScreen(
              initialIndex: 0,
              mediaList: images,
            ),
            transition: Transition.fadeIn,
            duration: Duration(milliseconds: 100),
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CustomNetworkImage(
            imageUrl: images[0],
            height: 200, // Adjust height for a large image
            width: double.infinity, // Full width
          ),
        ),
      );
    } else if (imageCount == 2) {
      // Two images: Display side by side
      return Row(
        children: images.map((image) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: GestureDetector(
                onTap: () {
                  Get.to(
                        () => PhotoViewerScreen(
                      initialIndex: images.indexOf(image),
                      mediaList: images,
                    ),
                    transition: Transition.fadeIn,
                    duration: Duration(milliseconds: 100),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CustomNetworkImage(
                    imageUrl: image,
                    height: 150,
                    width: double.infinity,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      );
    }

    else if (imageCount == 3) {
      // Three images: Top row with 2 images, bottom row with 1 image
      return Column(
        children: [
          Row(
            children: images.sublist(0, 2).map((image) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: GestureDetector(
                    onTap: () {
                      Get.to(
                            () => PhotoViewerScreen(
                          initialIndex: images.indexOf(image),
                          mediaList: images,
                        ),
                        transition: Transition.fadeIn,
                        duration: Duration(milliseconds: 100),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CustomNetworkImage(
                        imageUrl: image,
                        height: 100,
                        width: double.infinity,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.center,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: GestureDetector(
                onTap: () {
                  Get.to(
                        () => PhotoViewerScreen(
                      initialIndex: 2,
                      mediaList: images,
                    ),
                  );
                },
                child: CustomNetworkImage(
                  imageUrl: images[2],
                  height: 150, // Larger height for bottom image
                  width: MediaQuery.of(context).size.width,
                ),
              ),
            ),
          ),
        ],
      );
    }

    else {
      // Four or more images: Use a grid
      int displayCount = imageCount > 9 ? 9 : imageCount;

      return GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: displayCount,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
          childAspectRatio: 1,
        ),
        itemBuilder: (context, index) {
          // For the last image (9th), show the count overlay
          if (index == 8 && imageCount > 9) {
            return GestureDetector(
              onTap: () {
                Get.to(
                        () => PhotoViewerScreen(
                            initialIndex: index,
                          mediaList: images,
                        ),
                  transition: Transition.fadeIn,
                  duration: Duration(milliseconds: 100),
                );
              },
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CustomNetworkImage(
                      imageUrl: images[index],
                      height: 100,
                      width: 100,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        '+${imageCount - 9}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return GestureDetector(
              onTap: () {
                Get.to(
                      () => PhotoViewerScreen(
                    initialIndex: index,
                    mediaList: images,
                  ),
                  transition: Transition.fadeIn,
                  duration: Duration(milliseconds: 100),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CustomNetworkImage(
                  imageUrl: images[index],
                  height: 100,
                  width: 100,
                ),
              ),
            );
          }
        },
      );
    }
  }
}
