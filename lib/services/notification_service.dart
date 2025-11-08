import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal() {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  }

  Future<void> initNotifications() async {
    const AndroidInitializationSettings androidInitialize =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosInitialize =
        DarwinInitializationSettings();

    final InitializationSettings initSettings = InitializationSettings(
      android: androidInitialize,
      iOS: iosInitialize,
    );

    await _flutterLocalNotificationsPlugin.initialize(initSettings);
    
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    
    print('[v0] Notifications initialized successfully');
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    try {
      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
        'notes_reminder',
        'Notes Reminders',
        channelDescription: 'Reminders for notes',
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
      );

      const DarwinNotificationDetails iosDetails =
          DarwinNotificationDetails(
        presentSound: true,
      );

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      final tz.TZDateTime tzScheduledTime = tz.TZDateTime.from(
        scheduledTime,
        tz.local,
      );

      print('[v0] Scheduling notification: id=$id, title=$title, time=$tzScheduledTime');

      await _flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tzScheduledTime,
        notificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dateAndTime,
      );

      print('[v0] Notification scheduled successfully');
    } catch (e) {
      print('[v0] Error scheduling notification: $e');
    }
  }

  Future<void> cancelNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }
}
