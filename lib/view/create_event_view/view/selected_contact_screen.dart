// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:event_app/res/app_colors/App_Colors.dart';
import 'package:event_app/res/common_widget/RoundButton.dart';
import 'package:event_app/res/common_widget/RoundTextField.dart';
import 'package:event_app/res/common_widget/custom_text.dart';
import 'package:event_app/res/common_widget/responsive_helper.dart';
import 'package:event_app/res/custom_style/custom_size.dart';
import 'package:event_app/view/create_event_view/view/congratulation_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SelectedContactScreen extends StatefulWidget {
  const SelectedContactScreen({super.key});

  @override
  State<SelectedContactScreen> createState() => _SelectedContactScreenState();
}

class _SelectedContactScreenState extends State<SelectedContactScreen> {
  List<int> selectedContactIndices = [];
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(Icons.arrow_back, color: Colors.black,),
                ),
                heightBox5,
                Center(
                  child: CustomText(
                    title: 'RECOMMEND WAYPLACES',
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryColor,
                  ),
                ),
                heightBox8,
                CustomText(
                  textAlign: TextAlign.center,
                    title: 'Invite your friends to join and enjoy this exciting experience together.',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black100,
                ),

                heightBox20,
                RoundTextField(
                    hint: "Search Name",
                    readOnly: false,
                  prefixIcon: Icon(Icons.search_outlined, color: Colors.grey,),
                  borderRadius: 20,
                  focusBorderRadius: 20,
                ),

                heightBox20,
                ListView.builder(
                  itemCount: 8,
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return CheckboxListTile(
                      value: selectedContactIndices.contains(index),
                      onChanged: (bool? selected) {
                        setState(() {
                          if (selected == true) {
                            selectedContactIndices.add(index);
                          } else {
                            selectedContactIndices.remove(index);
                          }
                        });
                      },
                      title: Text(
                        'Istiak Ahmed',
                        style: TextStyle(
                          color: AppColors.blackColor,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      secondary: CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(
                            'https://www.perfocal.com/blog/content/images/2021/01/Perfocal_17-11-2019_TYWFAQ_100_standard-3.jpg'),
                      ),
                      activeColor: AppColors.primaryColor,
                    );
                  },
                ),

                heightBox20,
                Roundbutton(
                  title: 'Invite',
                  buttonColor: AppColors.primaryColor,
                  onTap: () {
                    goToCongratulationDialog();
                    setState(() {
                      selectedContactIndices.clear();
                    });

                    Future.delayed(Duration(seconds: 2), () {
                      Get.back();
                    });
                  },
                ),
                heightBox20,

              ],
            ),
          ),
        ),
      ),
    );
  }

  Future goToCongratulationDialog(){
    Future.delayed(Duration(seconds: 2), () {});
    return Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        backgroundColor: Colors.white,
        child: Container(
          height: ResponsiveHelper.h(context, 300),
          padding: EdgeInsets.all(16.0),
          child: CongratulationScreen(),
        ),
      ),
      barrierDismissible: true,
      barrierColor: Colors.black26,
    );
  }
}
