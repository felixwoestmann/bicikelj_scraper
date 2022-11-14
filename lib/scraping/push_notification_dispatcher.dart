import 'package:dio/dio.dart';

class PushNotificationDispatcher {
  static void dispatchNotification(String message, String topic) {
    final dio = Dio();
    dio.post('https://ntfy.sh/$topic', data: message);
  }
}
