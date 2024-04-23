import 'package:flutter/services.dart';
import 'package:local_notifier/local_notifier.dart';

class NotificationService {

  // Define a method channel for communication with the native plugin
  static const MethodChannel _channel = MethodChannel('my_background_plugin');
  static Future<void> init ()async {
    await localNotifier.setup(
      appName: 'Office Link',
      // The parameter shortcutPolicy only works on Windows
      shortcutPolicy: ShortcutPolicy.requireCreate,
    );
    //await startBackgroundTask();
  }
  // Method to start a background task using the native plugin
  static Future<void> startBackgroundTask() async {
    try {
      await _channel.invokeMethod('startBackgroundTask');
    } on PlatformException catch (e) {
      print('Error starting background task: $e');
    }
  }
  static void showNotification(String title, String body)async {
    LocalNotification notification = LocalNotification(
      title: title,
      body: body,
      actions: [
        LocalNotificationAction(text: 'APPLY'),
        LocalNotificationAction(text: 'REJECT'),
      ]
    );
    notification.show();
    notification.onShow = () {
      print('onShow ${notification.identifier}');
    };
    notification.onClickAction = (actionIndex) {
      print('onClickAction ${notification.actions![actionIndex].text} - $actionIndex');
    };
  }
}