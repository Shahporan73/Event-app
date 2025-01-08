class Endpoints {
  static const String mapApiKey = 'AIzaSyDhzY2k-tIrpnoBut75TTDJTuE1kURA_fU';
  static const String baseURl = 'http://192.168.10.188:8000/api/v1';

  // auth
  static const String signUp = '$baseURl/auth/sign-up';
  static const String otpVerifyUrl = '$baseURl/auth/verify-account';
  static const String resendOtpUrl = '$baseURl/auth/resend-otp';
  static const String signInUrl = '$baseURl/auth/sign-in';
  static const String profileURl = '$baseURl/user/profile';
  static const String changePasswordURL = '$baseURl/auth/change-password';
  static const String forgotPasswordUrl = '$baseURl/auth/forget-password';
  static const String resetPasswordUrl = '$baseURl/auth/reset-password';
  static const String refreshTokenURL = '$baseURl/auth/refresh-token';


// event
  static const String categoriesURL = '$baseURl/category/categories';
  static const String allEventsURL = '$baseURl/event/events';
  static String searchEventsURL({required String searchTerm}) => '$baseURl/event/events?searchTerm=$searchTerm';
  static String catEventsURL({required String categoryId}) => '$baseURl/event/events?categoryId=$categoryId';
  static String searchMyEventsURL({required String searchTerm}) => '$baseURl/event/my-events?searchTerm=$searchTerm';

  static const String myEventsURL = '$baseURl/event/my-events';
  static const String createEventURL = '$baseURl/event/create';
  static String getEventDetailsURL ({required String eventId}) => '$baseURl/event/$eventId';
  static String joinEventURL ({required String eventId}) => '$baseURl/event/join/$eventId';
  static String nearestEventsURL ({required String latitude, required String longitude}) =>
      '$baseURl/event/nearest-events?latitude=$latitude&longitude=$longitude';

  static String invitedEventDetailsURL ({required String eventId}) =>
      '$baseURl/event/my-invited-event/$eventId';

  static String eventJoinStatusURL ({required String eventId}) =>
      '$baseURl/event/invite/$eventId';
  static String recommendableUsersURL ({required String eventId}) =>'$baseURl/event/recommendable-users/$eventId';
  static String searchRecommendableUsersURL ({required String eventId, required String searchTerm}) =>'$baseURl/event/recommendable-users/$eventId?searchTerm=$searchTerm';
  static String deleteEventURL ({required String eventId}) =>'$baseURl/event/delete/$eventId';
  static String updateEventURL ({required String eventId}) =>'$baseURl/event/update/$eventId';

  static const String myInvitedEventsURL = '$baseURl/event/my-invited-events';
  static const String myJoinedEventsURL = '$baseURl/event/my-joined-events';



//   user
  static const String allUsersURL = '$baseURl/user/users';
  static String userProfileURL ({required String userId}) => '$baseURl/user/user/$userId';
  static  String inviteUsersURL ({required String eventId}) => '$baseURl/event/invite/$eventId';
  static const String onFollowURL = '$baseURl/user/follow';



//   post
  static String eventPostURL ({required String eventId}) =>'$baseURl/post/event-posts/$eventId';
  static const String createPostURL = '$baseURl/post/create';
  static String updatePostURL ({required String postId}) =>'$baseURl/post/update/$postId';
  static String deletePostURL ({required String postId}) =>'$baseURl/post/delete/$postId';
  static String getPostDetailsURL ({required String postId}) =>'$baseURl/post/$postId';
  static const String uploadImageURL = '$baseURl/upload/images';
  static const String deleteImage = '$baseURl/upload/files?type=image';
  static const String deleteVideo = '$baseURl/upload/files?type=video';
  static const String uploadVideoURL = '$baseURl/upload/video';

  static String getCommentURL ({required String postId}) =>'$baseURl/post/comments/$postId';
  static const String createCommentURL='$baseURl/post/create-comment';
  static String createLikeURL ({required String postId}) =>'$baseURl/post/create-like/$postId';

//   media
  static String fetchAllMediaURL ({required String chatId}) =>'$baseURl/chat/media/$chatId';


//   notification
  static const String notificationsURL = '$baseURl/notification/notifications?isRead=false';
  static const String sendMessageURL = '$baseURl/chat/personal-chat';




//   chat socket
  static const String chatListURL = 'http://192.168.10.188:8001';
}