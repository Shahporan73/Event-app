// sign_in_controller.dart

import 'dart:convert';
import 'dart:io';
import 'package:event_app/data/api/base_client.dart';
import 'package:event_app/data/api/end_point.dart';
import 'package:event_app/data/services/socket_controller.dart';
import 'package:event_app/data/token_manager/const_veriable.dart';
import 'package:event_app/data/token_manager/local_storage.dart';
import 'package:event_app/view/home_view/view/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../res/common_widget/responsive_helper.dart';
import '../widget/welcome_dialog.dart';

class SignInController extends GetxController {
  // GlobalKey for the Form
  final GlobalKey<FormState> loginKey = GlobalKey<FormState>();

  var isLoading = false.obs;
  var isChecked = true.obs;
  var isGoogleSignInLoading = false.obs;
  var isAppleSignInLoading = false.obs;

  // Text Editing Controllers for form fields
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Stream<User?> authStateChange()=>_auth.authStateChanges();
  String getUserEmail() => _auth.currentUser?.email ?? 'user';


  RxString email = ''.obs;
  RxString password = ''.obs;

  RxBool isPasswordVisible = false.obs;

  // Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void onInit() {
    super.onInit();
    onLoadSaveCredentials();
    reMoveSaveCredentials();
  }

  void onLoadSaveCredentials() async {
    String? savedEmail = await LocalStorage.getData(key: 'remain_email');
    String? savedPassword = await LocalStorage.getData(key: 'remain_password');

    print('Saved Email: $savedEmail');
    print('Saved Password: $savedPassword');

    if (savedEmail != null && savedPassword != null) {
      emailController.text = savedEmail;
      passwordController.text = savedPassword;
    }
  }

  void reMoveSaveCredentials() async {
    if(isChecked.value ==false){
      await LocalStorage.removeData(key: 'remain_email');
      await LocalStorage.removeData(key: 'remain_password');
    }
  }

  bool validateForm() {
    bool isValid = true;

    // Validate Email
    if (emailController.text.trim().isEmpty) {
      email.value = "email_is_required".tr;
      isValid = false;
    } else if (!GetUtils.isEmail(emailController.text.trim())) {
      email.value = "Enter a valid email";
      isValid = false;
    } else {
      email.value = '';
    }

    // Validate Password
    if (passwordController.text.trim().isEmpty) {
      password.value = "password_id_required".tr;
      isValid = false;
    } else if (passwordController.text.trim().length < 6) {
      password.value = "password_must_be_at_least_6_characters".tr;
      isValid = false;
    } else {
      password.value = '';
    }

    return isValid;
  }

  // Method to handle sign-in action
  void onSignIn(context) async {
    if (validateForm()) {
      isLoading(true);

      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };
      String? fcmToken = await messaging.getToken();

      print("FCM Token: $fcmToken");

      Map<String, String> body = {
        'email': emailController.text.trim().toString(),
        'password': passwordController.text.trim().toString(),
        'fcmToken': fcmToken.toString()
      };

      try {
        dynamic responseBody = await BaseClient.handleResponse(
          await BaseClient.postRequest(
            api: Endpoints.signInUrl,
            body: jsonEncode(body),
            headers: headers,
          ),
        );

        print("Signup URL: ${Endpoints.signInUrl}");
        print("body: ${jsonEncode(body)}");
        print("responseBody ====> $responseBody");

        if (responseBody != null && responseBody['data'] != null) {
          String token = responseBody['data']['accessToken'];
          String refreshToken = responseBody['data']['refreshToken'];

          LocalStorage.saveData(key: "access_token", data: token);
          LocalStorage.saveData(key: myID, data: responseBody['data']['id']);
          LocalStorage.saveData(key: "refreshToken", data: refreshToken);

          print("access token ===> $token");
          print("Refresh token ===> $refreshToken");

          Get.to(() => Home(),
              transition: Transition.rightToLeft,
              duration: const Duration(milliseconds: 300));

          // Initialize Socket
          SocketService socketService = Get.put(SocketService());
          await socketService.initializeSocket();

          // Get.rawSnackbar(
          //   message: "Welcome to Bashpin event app",
          //   backgroundColor: Colors.green,
          //   duration: const Duration(seconds: 3),
          //   snackPosition: SnackPosition.TOP,
          //   icon: const Icon(Icons.check, color: Colors.white),
          // );
          welcomeDialog(context);

          if (isChecked.value==true) {
            LocalStorage.saveData(key: 'remain_email', data: emailController.text.toString());
            LocalStorage.saveData(key: 'remain_password', data: passwordController.text.toString());

            print("Saved email save: ${LocalStorage.getData(key: 'remain_email')}");
            print("Saved password: ${LocalStorage.getData(key: 'remain_password')}");
          }else{
            reMoveSaveCredentials();
          }

        } else {
          Get.rawSnackbar(
              message: responseBody['data']?['message'] ?? 'Unknown error',
              backgroundColor: Colors.red,
              snackPosition: SnackPosition.TOP);
          print("responseBody ====> $responseBody");
          isLoading(false);
        }
      } catch (e) {
        debugPrint("Catch Error:::::: " + e.toString());
        Get.snackbar("Error", "sign in failed!",
            backgroundColor: Colors.red, snackPosition: SnackPosition.TOP);
      } finally {
        isLoading(false);
      }
    } else {
      Get.snackbar("error".tr, "please_correct_the_error_in_the_form".tr,
          backgroundColor: Colors.red, snackPosition: SnackPosition.TOP);
      isLoading(false);
    }
  }




  // sign in with google
  Future<void> onGoogleSignIn() async {
    isGoogleSignInLoading(true);
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      FirebaseMessaging messaging = FirebaseMessaging.instance;

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Sign in to Firebase with the Google credential
        UserCredential userCredential =
        await _auth.signInWithCredential(credential);
        User? firebaseUser = userCredential.user;

        if (firebaseUser != null) {
          String email = firebaseUser.email ?? '';
          String name = firebaseUser.displayName ?? '';
          String photoUrl = firebaseUser.photoURL ?? '';
          String? fcmToken = await messaging.getToken();

          // Call the API with Firebase user details
          await onInitGoogle(email, name, photoUrl, fcmToken ?? '');

          print("FCM Token: $fcmToken, email: $email, name: $name, photoUrl: $photoUrl");
        } else {
          Get.rawSnackbar(
              message: 'User not found',
              backgroundColor: Colors.red);
          print("Firebase user not found after Google Sign-In.");
        }
      } else {
        print("Google sign-in was aborted.");
      }
    } catch (e) {
      Get.rawSnackbar(
          message: 'Connection error...', backgroundColor: Colors.red);
      print("Error signing in with Google: ${e.toString()}");
    }finally {
      isGoogleSignInLoading(false);
    }
  }


  // sign in with apple id
  Future<void> onAppleSignIn() async {
    print('Click apple Sign in');
    isAppleSignInLoading(true);
    try {
      // Step 1: Request Apple credentials
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // Step 2: Create an OAuth credential for Firebase
      final oAuthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      // Step 3: Sign in with Firebase
      final userCredential =
      await FirebaseAuth.instance.signInWithCredential(oAuthCredential);

      // Step 4: Retrieve the signed-in user's info
      final user = userCredential.user;

      // Fetch email and name from Apple Sign-In response
      final email = user?.email ?? appleCredential.email;
      final fullName =
      "${appleCredential.givenName ?? ''} ${appleCredential.familyName ?? ''}".trim();

      // Step 5: Get Firebase Messaging Token
      final fcmToken = await FirebaseMessaging.instance.getToken();

      // Step 6: Prepare user data
      final userData = {
        "uid": user?.uid,
        "email": email,
        "name": fullName,
        "photoURL": user?.photoURL,
        "fcmToken": fcmToken,
      };

      onInitGoogle(
          email!,
          fullName,
          user?.photoURL??'',
          fcmToken!
      );

    } catch (e) {
      print("Error during Apple Sign-In: $e");
      rethrow;
    }finally{
      isAppleSignInLoading(false);
    }
  }

  Future<void> signInWithFacebook() async {
    try {
      // Step 1: Trigger Facebook login
      final LoginResult loginResult = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      if (loginResult.status == LoginStatus.success) {
        // Step 2: Get the Facebook access token
        final AccessToken? accessToken = loginResult.accessToken;

        if (accessToken != null) {
          // Step 3: Create a Firebase credential with the Facebook token
          final facebookAuthCredential = FacebookAuthProvider.credential(accessToken.tokenString);

          // Step 4: Sign in with Firebase
          final userCredential = await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);

          // Step 5: Retrieve user information from Facebook
          final facebookUserData = await FacebookAuth.instance.getUserData(fields: "email,name");

          final email = facebookUserData['email'] ?? 'No Email Provided';
          final name = facebookUserData['name'] ?? 'No Name Provided';

          // Step 6: Get Firebase Messaging Token
          final fcmToken = await FirebaseMessaging.instance.getToken();

          // Step 7: Prepare the user data
          final userData = {
            "uid": userCredential.user?.uid,
            "email": email,
            "name": name,
            "fcmToken": fcmToken,
          };

          print('Facebook login data: $userData');
        } else {
          throw Exception('AccessToken is null');
        }
      } else {
        throw Exception('Facebook login failed: ${loginResult.message}');
      }
    } catch (e) {
      print("Error during Facebook Sign-In: $e");
      rethrow;
    }
  }

  Future<void> onInitGoogle(String email, String name, String profilePicture, String fcmToken) async {
    print('init social auth');
    try {
      final headers = {'Content-Type': 'application/json'};

      final body = {'email': email, 'name': name,
        'profilePicture': profilePicture,
        'fcmToken': fcmToken
      };

      var response = await http.post(
        Uri.parse(Endpoints.socialAuthURL),
        body: jsonEncode(body),
        headers: headers,
      );

      print('API called: ${Endpoints.socialAuthURL}');
      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        print('Response data: $responseBody');


        // Ensure the data structure from the response is valid
        if (responseBody['data'] != null) {
          String userId = responseBody['data']['id']; // Correct key is 'id', not '_id'
          String accessToken = responseBody['data']['accessToken'];
          String refreshToken = responseBody['data']['refreshToken'];

          // Save necessary data to local storage
          // LocalStorage.saveData(key: "userId", data: userId);
          // LocalStorage.saveData(key: "access_token", data: accessToken);
          // LocalStorage.saveData(key: "refreshToken", data: refreshToken);

          LocalStorage.saveData(key: "access_token", data: accessToken);
          LocalStorage.saveData(key: myID, data: userId);
          LocalStorage.saveData(key: "refreshToken", data: refreshToken);

          print('Google token : $accessToken');
          print('Google refresh token : $refreshToken');
          print('Google userId : $userId');

          // Navigate to Home screen
          Get.offAll(
                  () => Home(),
              transition: Transition.rightToLeft,
              duration: Duration(milliseconds: 0)
          );

          // Initialize Socket
          SocketService socketService = Get.put(SocketService());
          await socketService.initializeSocket();

          welcomeDialog(Get.context);

         /* Get.rawSnackbar(
            message: "Sign-in successful with Google",
            backgroundColor: Colors.green,
            snackPosition: SnackPosition.TOP,
          );
          Get.rawSnackbar(
            message: "Welcome to Bashpin event app",
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
            snackPosition: SnackPosition.TOP,
            icon: Icon(Icons.check, color: Colors.white),
          );*/

        } else {
          print("Unexpected API response structure: ${response.body}");
          throw "API response is missing required fields.";
        }
      } else {
        print("Sign-in failed with status: ${response.statusCode}");
        throw 'Sign-in failed with status: ${response.statusCode}';
      }
    } on SocketException catch (_) {
      Get.rawSnackbar(
          message: 'Not connected to the internet.',
          backgroundColor: Colors.red);
    } catch (e) {
      print("Error during Google API sign-in: ${e.toString()}");
    }
  }


  Future welcomeDialog(context) {
    Future.delayed(Duration(seconds: 2), () {
      // Get.offAll(
      //         () => Home(),
      //     transition: Transition.rightToLeft,
      //     duration: Duration(milliseconds: 300)
      // );
    });
    return Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        backgroundColor: Colors.white,
        child: Container(
          height: ResponsiveHelper.h(context, 320),
          padding: EdgeInsets.all(10.0),
          child: WelcomeDialog(),
        ),
      ),
      barrierDismissible: true,
      barrierColor: Colors.black26,
    );
  }
}
