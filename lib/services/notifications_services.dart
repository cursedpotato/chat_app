import 'package:awesome_notifications/awesome_notifications.dart';

Future<void> createNotification(String name, String messages) async {
  int id = DateTime.now().millisecondsSinceEpoch.remainder(100000);
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: id,
      channelKey: 'basic_channel',
      title: name,
      body: messages,
      summary: "HELLO", // Anything you want here
      notificationLayout: NotificationLayout.Messaging,
    ),
  );
}
