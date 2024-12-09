// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';


class PickerDialog {

  void showImagePickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Profile Image'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Gallery'),
                onTap: () async {
                  final pickedFile = await ImagePicker().pickImage(
                      source: ImageSource.gallery);
                  if (pickedFile != null) {
                    // Handle the picked image (e.g., update profile)
                    print('Image selected: ${pickedFile.path}');
                  } else {
                    // Show a SnackBar if no image is selected before popping the dialog
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('No image selected'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                  Navigator.of(context).pop(); // Now safely pop the dialog after showing the SnackBar
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Camera'),
                onTap: () async {
                  final pickedFile = await ImagePicker().pickImage(
                      source: ImageSource.camera);
                  if (pickedFile != null) {
                    // Handle the picked image (e.g., update profile)
                    print('Image selected: ${pickedFile.path}');
                  } else {
                    // Show a SnackBar if no image is selected before popping the dialog
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('No image selected'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                  Navigator.of(context).pop(); // Now safely pop the dialog after showing the SnackBar
                },
              ),
            ],
          ),
        );
      },
    );
  }




  // void showDocumentPickerDialog(BuildContext context) async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     type: FileType.custom,
  //     allowedExtensions: ['pdf', 'doc', 'docx', 'xls', 'xlsx'],
  //   );
  //
  //   if (result != null) {
  //     // The user has selected a file
  //     PlatformFile file = result.files.first;
  //     // Do something with the file (e.g., upload it)
  //     print('File selected: ${file.name}');
  //   } else {
  //     // The user canceled the picker
  //     // Show a SnackBar when no file is selected
  //     showSnackDialog(context);
  //   }
  // }
  //
  // showSnackDialog(context){
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text('No file selected'),
  //       duration: Duration(seconds: 2),
  //     ),
  //   );
  // }


  // Function to show name change dialog
  void showNameChangeDialog(BuildContext context) {
    TextEditingController nameControllerText = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: Text('Change Name'),
        content: TextField(
          controller: nameControllerText,
          decoration: InputDecoration(
            hintText: "Enter your name",
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Get.back(); // Close the dialog
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back(); // Close the dialog
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

}