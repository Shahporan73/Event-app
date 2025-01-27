import 'package:get/get.dart';

import '../../../data/api/base_client.dart';
import '../../../data/api/end_point.dart';
import '../../../data/token_manager/local_storage.dart';

class SettingController extends GetxController{
  var isLoading = false.obs;
  var privacyPolicy = "".obs;
  var termsAndCondition = "".obs;
  var aboutUs= "".obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchPrivacyPolicy();
    fetchAboutUs();
    fetchTermsAndCondition();
  }

  Future<void> fetchPrivacyPolicy() async {
    // TODO: implement fetchPrivacyPolicy
    privacyPolicy.value = '';
    try{
      isLoading(true);
      String token = LocalStorage.getData(key: "access_token");

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      dynamic responseBody = await BaseClient.handleResponse(
        await BaseClient.getRequest(
          api: Endpoints.privacyPolicyURL,
          headers: headers,
        ),
      );

      if(responseBody != null){
        print('Privacy policy response ::: $responseBody');
        privacyPolicy.value = responseBody['data']['content'];
      }else{
        isLoading(false);
      }
    }catch(e){
      print('Privacy policy error ::: $e');
    }finally{
      isLoading(false);
    }
  }

  Future<void> fetchTermsAndCondition() async {
    // TODO: implement fetchPrivacyPolicy
    try{
      isLoading(true);
      termsAndCondition.value = '';

      String token = LocalStorage.getData(key: "access_token");

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      dynamic responseBody = await BaseClient.handleResponse(
        await BaseClient.getRequest(
          api: Endpoints.privacyPolicyURL,
          headers: headers,
        ),
      );

      if(responseBody != null){
        print('terms and Condition response ::: $responseBody');
        termsAndCondition.value = responseBody['data']['content'];
      }else{
        isLoading(false);
      }
    }catch(e){
      print('terms and condition error ::: $e');
    }finally{
      isLoading(false);
    }
  }

  Future<void> fetchAboutUs() async {
    // TODO: implement fetchPrivacyPolicy
    try{
      aboutUs.value = '';
      isLoading(true);
      String token = LocalStorage.getData(key: "access_token");

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      dynamic responseBody = await BaseClient.handleResponse(
        await BaseClient.getRequest(
          api: Endpoints.aboutURL,
          headers: headers,
        ),
      );

      if(responseBody != null){
        print('About us response ::: $responseBody');
        aboutUs.value = responseBody['data']['content'];
      }else{
        isLoading(false);
      }
    }catch(e){
      print('About us error ::: $e');
    }finally{
      isLoading(false);
    }
  }
}