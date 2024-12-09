// ignore_for_file: prefer_const_constructors

import 'package:event_app/main.dart';
import 'package:event_app/res/common_widget/custom_network_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class PersonalUserListWidget extends StatelessWidget {
  final String name;
  final String imgPath;
  final String lastMessage;
  final String  time;
  final String messageCount;
  final VoidCallback onTap;
  PersonalUserListWidget({super.key, required this.name, required this.imgPath, required this.lastMessage, required this.time, required this.messageCount, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(50.r),
        child: CustomNetworkImage(
          imageUrl: imgPath,
          height: 50,
          width: 50,
        ),
      ),
      title: Text(
        name,
        style: GoogleFonts.urbanist(
          fontWeight: FontWeight.w700,
          fontSize: 14,
          color: Colors.black,
        ),
      ),
      subtitle: Text(
        lastMessage,
        style: GoogleFonts.urbanist(
          fontWeight: FontWeight.w400,
          fontSize: 12,
          color: Colors.grey,
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            time,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.teal,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              messageCount,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
