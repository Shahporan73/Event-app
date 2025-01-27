
// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:event_app/data/api/base_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

String getRelativeTime(String createdAt) {
  try {
    DateTime createdTime = DateTime.parse(createdAt);
    DateTime currentTime = DateTime.now();

    Duration difference = currentTime.difference(createdTime);

    if (difference.inSeconds < 60) {
      return "just_now".tr;
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes} "+"minutes_ago".tr;
    } else if (difference.inHours < 24) {
      return "${difference.inHours} "+"hours_ago".tr;
    } else if (difference.inDays < 7) {
      return "${difference.inDays} "+"days_ago".tr;
    } else {
      return "${(difference.inDays / 7).floor()} "+"weeks_ago".tr;
    }
  } catch (e) {
    print("Error parsing date: $e");
    return '';
  }
}


String getLimitedWord(String? address, int maxLength) {
  if (address == null || address.isEmpty) return "";
  return address.length > maxLength ? address.substring(0, maxLength) + '...' : address;
}
