// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:event_app/main.dart';
import 'package:event_app/res/common_widget/custom_network_image_widget.dart';
import 'package:event_app/res/custom_style/custom_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class PersonalUserListWidget extends StatelessWidget {
  final String name;
  final String imgPath;
  final String lastMessage;
  final String  lastMessageTime;
  final int messageCount;
  final VoidCallback onTap;
  final bool isOnline;

  PersonalUserListWidget({super.key,
    required this.name,
    required this.imgPath,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.messageCount,
    required this.onTap,
    this.isOnline=false
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              child: Stack(
                children: [
                  Positioned.fill(
                      child: CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(imgPath),
                      )
                  ),
                  // active status
                  Positioned(
                      bottom: 5,
                      right: 0,
                      child: Container(
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isOnline ? Colors.green : Colors.redAccent,
                        )
                      )
                  ),
                ],
              ),
            ),
            widthBox10,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.urbanist(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                heightBox5,
                Text(
                  lastMessage,
                  style: GoogleFonts.urbanist(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),

              ],
            ),
            Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                messageCount == 0 ? Container() : Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    messageCount.toString(),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
                heightBox5,
                Text(
                  lastMessageTime,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

/*  Widget mm(){
    return GestureDetector(
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            child: CustomNetworkImage(
              imageUrl: imgPath,
              height: 50,
              width: 50,
            ),
          ),
          widthBox10,
          Column(
            children: [
              Text(
                name,
                style: GoogleFonts.urbanist(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              heightBox5,
              Text(
                lastMessage,
                style: GoogleFonts.urbanist(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),

            ],
          ),
          Spacer(),
          Column(
            children: [
              Text(
                lastMessageTime,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              heightBox5,
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.teal,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  messageCount.toString(),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }*/
}
