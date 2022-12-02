import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tinder/config/utils.dart';

class NotificationApi {
  static final notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String>();

  static Future notificationDetailsDetails(String uri) async {
    if (uri != '') {
      final largeIconPath = await Utils.downloadFile(uri, 'largeIcon');

      final styleInformation = BigPictureStyleInformation(
        FilePathAndroidBitmap(largeIconPath),
        largeIcon: FilePathAndroidBitmap(largeIconPath),
      );

      return NotificationDetails(
        android: AndroidNotificationDetails('channel title', 'channel name',
            playSound: true,
            priority: Priority.high,
            importance: Importance.max,
            styleInformation: styleInformation),
      );
    } else {
      return const NotificationDetails(
          android: AndroidNotificationDetails(
        'channel title',
        'channel name',
        playSound: true,
        priority: Priority.high,
        importance: Importance.max,
      ));
    }
  }

  static void selectNotification(String? payload) {
    if (payload != null && payload.isNotEmpty) {
      onNotifications.add(payload);
    }
  }

  static Future initNotification() async {
    await notifications.initialize(
        onSelectNotification: selectNotification,
        const InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        ));
  }

  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
    String? uri,
  }) async =>
      notifications.show(
          id, title, body, await notificationDetailsDetails(uri!),
          payload: payload);
}
