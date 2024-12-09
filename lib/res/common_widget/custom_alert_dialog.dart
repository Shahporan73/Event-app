// ignore_for_file: prefer_const_constructors, sort_child_properties_last
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAlertDialog {
  Future<void> customAlert(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min, // Adjusts column height to fit content
            children: [
              Text(
                'Are you sure',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 14.h), // Replacing heightBox14 with SizedBox
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    width: Get.width * 0.25,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Closes the dialog
                      },
                      child: Text('No'),
                    ),
                  ),
                  Container(
                    width: Get.width * 0.25,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(color: Colors.black),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Closes the dialog
                      },
                      child: Text(
                        'Yes',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> onSuccessAlertDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min, // Adjusts column height to fit content
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.done,
                size: 60,
              ),
              SizedBox(height: 10.h),
              Text(
                "Payment successfully done",
                style: GoogleFonts.urbanist(
                  fontSize: 16.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("OK"),
              ),
            ],
          ),
        );
      },
    );
  }

  void showRejectDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert'),
          content: Text('Are you sure you want to reject the order request?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Closes the dialog
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Closes the dialog
                // Add rejection logic here
              },
              child: Text(
                'Sure?',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  // for logout dialog
  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Alert"),
          content: Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                // Add logout logic here
              },
              child: Text(
                "Logout",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Set the color to red
              ),
            ),
          ],
        );
      },
    );
  }
}
