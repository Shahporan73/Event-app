
import 'package:flutter/cupertino.dart';

String getRelativeTime(String createdAt) {
  try {
    DateTime createdTime = DateTime.parse(createdAt);
    DateTime currentTime = DateTime.now();

    Duration difference = currentTime.difference(createdTime);

    if (difference.inSeconds < 60) {
      return "just now";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes} minutes ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours} hours ago";
    } else if (difference.inDays < 7) {
      return "${difference.inDays} days ago";
    } else {
      return "${(difference.inDays / 7).floor()} weeks ago";
    }
  } catch (e) {
    print("Error parsing date: $e");
    return '';
  }
}
