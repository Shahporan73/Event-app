import 'package:event_app/data/api/base_client.dart';
import 'package:event_app/data/api/end_point.dart';
import 'package:event_app/data/token_manager/local_storage.dart';
import 'package:event_app/view/message_view/model/media_model.dart';
import 'package:get/get.dart';

class MediaController extends GetxController{
  var isLoading = false.obs;
  var mediaModel = MediaModel().obs;
  var mediaList = <MediaList>[].obs;

  var imageList = [].obs;
  var videoList = [].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchAllMedia();
  }

  Future<void> fetchAllMedia() async {
    isLoading.value = true;
    try {
      String token = LocalStorage.getData(key: "access_token");
      String chatId = LocalStorage.getData(key: "mediaCommunityId");
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      dynamic responseBody = await BaseClient.handleResponse(
        await BaseClient.getRequest(
          api: Endpoints.fetchAllMediaURL(chatId: chatId),
          headers: headers,
        ),
      );

      print('hit api ${Endpoints.fetchAllMediaURL(chatId: chatId)}');
      print("responseBody ====> $responseBody");

      if (responseBody != null) {
        mediaList.clear();
        imageList.clear();
        videoList.clear();

        mediaModel.value = MediaModel.fromJson(responseBody);

        if (mediaModel.value.data != null) {
          mediaList.assignAll([mediaModel.value.data!]);
        } else {
          mediaList.clear();
        }

        // Populate imageList with non-empty files
        imageList.value = mediaList
            .expand((media) => media.message)
            .where((message) => message.files.isNotEmpty) // Exclude empty files
            .expand((message) => message.files)
            .toList();

        // Populate videoList with non-empty videos
        videoList.value = mediaList
            .expand((media) => media.message)
            .where((message) => message.videos.isNotEmpty) // Exclude empty videos
            .expand((message) => message.videos)
            .toList();
      }
    } catch (e) {
      print('Error fetching media: $e');
    } finally {
      isLoading.value = false;
    }
  }


  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    fetchAllMedia();
  }


}