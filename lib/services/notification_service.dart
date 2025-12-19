import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) {
        // Handle notification tap
      },
    );

    // Request permissions
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future<void> scheduleDailyReminder(TimeOfDay time) async {
    final now = DateTime.now();
    final scheduledTime = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    // If the time has passed today, schedule for tomorrow
    final scheduleTime = scheduledTime.isBefore(now)
        ? scheduledTime.add(const Duration(days: 1))
        : scheduledTime;

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      1, // ID
      'Blood Sugar Reminder',
      'Time to check your blood sugar!',
      tz.TZDateTime.from(scheduleTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'blood_sugar_channel',
          'Blood Sugar Reminders',
          channelDescription: 'Daily reminders to log blood sugar',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(
          sound: 'default',
          badgeNumber: 1,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );

    // Save reminder time
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('reminder_time', '${time.hour}:${time.minute}');
  }

  Future<void> cancelReminder() async {
    await _flutterLocalNotificationsPlugin.cancel(1);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('reminder_time');
  }

  Future<TimeOfDay?> getReminderTime() async {
    final prefs = await SharedPreferences.getInstance();
    final timeString = prefs.getString('reminder_time');
    if (timeString != null) {
      final parts = timeString.split(':');
      return TimeOfDay(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1]),
      );
    }
    return null;
  }

  Future<void> checkForMissedLogging() async {
    // Check if it's been more than 8 hours since last reading
    final lastReadingTime = await _getLastReadingTime();
    if (lastReadingTime != null) {
      final hoursSince = DateTime.now().difference(lastReadingTime).inHours;
      if (hoursSince >= 8) {
        await _flutterLocalNotificationsPlugin.show(
          2, // Different ID
          'Missed Blood Sugar Reading',
          'It\'s been ${hoursSince} hours since your last reading. Consider logging your blood sugar.',
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'blood_sugar_channel',
              'Blood Sugar Reminders',
              channelDescription: 'Reminders for blood sugar logging',
              importance: Importance.defaultImportance,
              priority: Priority.defaultPriority,
            ),
            iOS: DarwinNotificationDetails(
              sound: 'default',
            ),
          ),
        );
      }
    }
  }

  Future<DateTime?> _getLastReadingTime() async {
    // This would need access to database - for now return null
    // In a real implementation, query the database for latest record
    return null;
  }
}
