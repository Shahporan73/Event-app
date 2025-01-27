import 'package:event_app/view/splash_view/welcome_screen.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    // Navigate to the next screen after 2 seconds
    Future.delayed(Duration(seconds: 2), () {
      Get.offAll(
            () => WelcomeScreen(),
        duration: Duration(milliseconds: 300),
        transition: Transition.rightToLeft,
      );
    });
  }
}
