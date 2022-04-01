import 'package:awesome_notifications/awesome_notifications.dart';


Future<void> createNotification() async {
    int id = DateTime.now().millisecondsSinceEpoch.remainder(100000);
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: id,
      channelKey: 'basic_channel',
      title: '${Emojis.plant_cactus} ${Emojis.activites_balloon}',
      body: "Example Notification",
      
      notificationLayout: NotificationLayout.Messaging,
    ),
  );
}
