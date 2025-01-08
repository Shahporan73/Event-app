import 'package:event_app/data/api/base_client.dart';
import 'package:event_app/data/api/end_point.dart';
import 'package:event_app/data/token_manager/local_storage.dart';
import 'package:event_app/view/home_view/model/notification_model.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController{
  var isLoading = false.obs;
  var notificationModel =NotificationsModel().obs;
  var notificationList = <NotificationList>[].obs;
  var currentPage = 1.obs;
  var totalPages = 0.obs;
  var isFetchingMore = false.obs;


  @override
  void onInit() {
    super.onInit();
    getNotification();
  }

  Future<void> getNotification({bool isLoadMore = false}) async {
    if (isLoadMore) {
      // Check if there are more pages to fetch
      if (currentPage.value > totalPages.value) {
        return; // No more pages available
      }
      isFetchingMore.value = true;
    } else {
      isLoading.value = true;
    }

    String token = LocalStorage.getData(key: "access_token");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      // API request with page and limit parameters
      var response = await BaseClient.handleResponse(
        await BaseClient.getRequest(
          api: "${Endpoints.notificationsURL}?page=${currentPage.value}&limit=10",
          headers: headers,
        ),
      );

      print('Fetching notifications for page: ${currentPage.value}');

      if (response != null) {
        var newModel = NotificationsModel.fromJson(response);

        // Update total pages based on meta information
        if (newModel.data?.meta != null) {
          var meta = newModel.data!.meta!;
          totalPages.value = (meta.total! / meta.limit!).ceil();
        }

        // Append data for load more or set fresh data
        if (isLoadMore) {
          notificationList.addAll(newModel.data?.data ?? []);
        } else {
          notificationList.clear();
          notificationList.assignAll(newModel.data?.data ?? []);
        }

        notificationModel.value = newModel;

        // Increment page for next request
        currentPage.value++;
      }
    } catch (e) {
      print('Error fetching notifications: $e');
    } finally {
      if (isLoadMore) {
        isFetchingMore.value = false;
      } else {
        isLoading.value = false;
      }
    }
  }

  void resetPagination() {
    currentPage.value = 1;
    totalPages.value = 1;
    notificationList.clear();
  }

}
