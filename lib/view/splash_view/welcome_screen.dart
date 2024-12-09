// ignore_for_file: prefer_const_constructors

import 'package:event_app/res/common_widget/responsive_helper.dart';
import 'package:event_app/view/auth_view/view/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../res/app_colors/App_Colors.dart';
import '../../res/app_images/App_images.dart';
import '../../res/common_widget/RoundButton.dart';
import '../../res/custom_style/custom_size.dart';
import '../auth_view/view/sign_up_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  late String selectedLanguage;
  late String selectedFlag;

  @override
  void initState() {
    super.initState();

    // Set initial language and flag based on current locale
    if (Get.locale?.languageCode == 'en') {
      selectedLanguage = 'English';
      selectedFlag = AppImages.english;
    } else {
      selectedLanguage = 'Spanish';
      selectedFlag = AppImages.spanish;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 200.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xffffffff),Color(0xff00BDCA)],
                  // transform: GradientRotation(3.14 / 2),
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              child: Text(
                'welcome_to_way_places'.tr,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff000000),
                ),
              ),
            ),

            heightBox20,
            Center(
              child: Image.asset(
                AppImages.appLogo,
                scale: 4,
              ),
            ),

            heightBox40,
            Padding(
              padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
              child: Column(
                children: [
                  SizedBox(
                    width: ResponsiveHelper.w(context, 150),
                    child: DropdownButton<String>(
                      value: selectedLanguage,
                      isExpanded: true,
                      style: TextStyle(color: AppColors.primaryColor),
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: AppColors.primaryColor,
                        size: 35.sp,
                      ),
                      underline: SizedBox(),
                      items: [
                        DropdownMenuItem(
                          value: 'English',
                          child: Row(
                            children: [
                              Image.asset(AppImages.english, width: 24),
                              SizedBox(width: 15),
                              Text(
                                'English',
                                style: TextStyle(color: AppColors.primaryColor),
                              ),
                            ],
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'Spanish',
                          child: Row(
                            children: [
                              Image.asset(AppImages.spanish, width: 24),
                              SizedBox(width: 10),
                              Text(
                                'Spanish',
                                style: TextStyle(color: AppColors.primaryColor),
                              ),
                            ],
                          ),
                        ),
                      ],
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedLanguage = newValue!;
                          if (newValue == 'English') {
                            selectedFlag = AppImages.english;
                            Get.updateLocale(Locale('en', 'US'));
                          } else if (newValue == 'Spanish') {
                            selectedFlag = AppImages.spanish;
                            Get.updateLocale(Locale('es', 'ES'));
                          }
                        });
                      },
                    ),
                  ),
                  heightBox30,
                  Roundbutton(
                    title: "login".tr,
                    padding_vertical: 12,
                    buttonColor: AppColors.primaryColor,
                    onTap: () {
                      // Navigate to login screen
                      Get.to(
                            () => SignInScreen(),
                        transition: Transition.rightToLeft,
                        duration: const Duration(milliseconds: 500),
                      );
                    },
                  ),
                  heightBox20,
                  Roundbutton(
                    title: "register_new_account".tr,
                    padding_vertical: 12,
                    buttonColor: AppColors.whiteColor,
                    titleColor: Colors.black,
                    border: Border.all(color: AppColors.primaryColor, width: 1),
                    onTap: () {
                      Get.to(
                            () => SignUpScreen(),
                        transition: Transition.rightToLeft,
                        duration: const Duration(milliseconds: 500),
                      );
                    },
                  ),
                  heightBox50,
                  Text.rich(
                    textAlign: TextAlign.center,
                    TextSpan(
                      style: GoogleFonts.poppins(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.black100,
                      ),
                      children: [
                        TextSpan(
                          text: 'by_signing_up_you_confirm_that_you_have_read_and_agree_to_the'.tr,
                        ),
                        TextSpan(
                          text: 'our_privacy_policy'.tr,
                          style: TextStyle(color: AppColors.secondaryColor),
                        ),
                        TextSpan(
                          text: 'and'.tr,
                        ),
                        TextSpan(
                          text: 'terms_conditions'.tr,
                          style: TextStyle(color: AppColors.secondaryColor),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      )
    );
  }
}
