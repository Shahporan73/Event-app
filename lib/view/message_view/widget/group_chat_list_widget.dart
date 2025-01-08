// ignore_for_file: prefer_const_constructors

import 'dart:math';
import 'package:event_app/data/token_manager/const_veriable.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GroupChatListWidget extends StatelessWidget {
  final String groupName;
  final String lastMessage;
  final String last_message_time;
  final int unSeenMessageCount;
  final List<String> imgList;
  final String profilePicture;
  GroupChatListWidget({
    super.key,
    required this.groupName,
    required this.lastMessage,
    required this.last_message_time,
    required this.unSeenMessageCount,
    required this.imgList,
    required this.profilePicture,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: profilePicture.isNotEmpty?
          CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(profilePicture),
          )
          :imgList.isEmpty
          ? CircleAvatar(
        radius: 25,
        backgroundImage: NetworkImage(placeholderImage),
      ): SizedBox(
        height: 60,
        width: 60,
        child: Row(
          children: List.generate(
            min(3, imgList.length),
                (imgIndex) {
              return Align(
                alignment: Alignment.center,
                widthFactor: 0.3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: imgIndex > 1
                      ? _outlineImage(imgIndex)
                      : Image(
                    image: NetworkImage(imgList[imgIndex]),
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),
      ),
      // Group name
      title: Text(
        groupName,
        style: GoogleFonts.urbanist(
          fontWeight: FontWeight.w700,
          fontSize: 14,
          color: Colors.black,
        ),
      ),

      // Last message
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
            last_message_time,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),


          unSeenMessageCount == 0
              ? SizedBox()
              : Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.teal,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              unSeenMessageCount.toString(),
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
  Widget _outlineImage(int index) {
    return Container(
      width: 50,
      height: 50,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.teal.shade100,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Text(
        '+${imgList.length}',
        style: GoogleFonts.roboto(
          fontWeight: FontWeight.w700,
          color: Colors.black,
          fontSize: 14,
        ),
      ),
    );
  }

}
