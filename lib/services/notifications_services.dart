import 'package:awesome_notifications/awesome_notifications.dart';

Future<void> createNotification(String name, String message, String time ) async {
  int id = DateTime.now().millisecondsSinceEpoch.remainder(100000);
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: id,
      channelKey: 'basic_channel',
      title: name,
      body: message,
      summary: time, // Anything you want here
      notificationLayout: NotificationLayout.Messaging,
    ),
  );
}
