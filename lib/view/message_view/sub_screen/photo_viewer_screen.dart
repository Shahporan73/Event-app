import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotoViewerScreen extends StatefulWidget {
  final List<dynamic> mediaList; // List of image URLs
  final int initialIndex;

  PhotoViewerScreen({super.key, required this.mediaList, this.initialIndex = 0});

  @override
  _PhotoViewerScreenState createState() => _PhotoViewerScreenState();
}

class _PhotoViewerScreenState extends State<PhotoViewerScreen> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
              child: PhotoViewGallery.builder(
                itemCount: widget.mediaList.length,
                pageController: _pageController,
                builder: (context, index) {
                  return PhotoViewGalleryPageOptions(
                    imageProvider: NetworkImage(widget.mediaList[index]),
                    heroAttributes: PhotoViewHeroAttributes(tag: widget.mediaList[index]),
                    minScale: PhotoViewComputedScale.contained * 0.8,
                    maxScale: PhotoViewComputedScale.covered * 2,
                  );
                },
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                loadingBuilder: (context, event) => Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
          ),

          if (widget.mediaList.length > 1)
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  '${_currentIndex + 1} / ${widget.mediaList.length}',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),

          Positioned(
            top: 40,
            right: 16,
            child: Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
