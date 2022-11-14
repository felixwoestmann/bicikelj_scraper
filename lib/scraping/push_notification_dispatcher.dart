import 'package:dio/dio.dart';

class PushNotificationDispatcher {
  static void dispatchNotification(String message, String topic) async {
    print('Dispatching notification: $message');
    final dio = Dio();
    await dio.post('https://ntfy.sh/$topic', data: message);
  }
}
