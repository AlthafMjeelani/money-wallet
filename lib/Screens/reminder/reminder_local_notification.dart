import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/timezone.dart';

class NotificationApi {
  static final _notification = FlutterLocalNotificationsPlugin();
  static final onNotification = BehaviorSubject<String?>();

  static cancelNotification() => _notification.cancelAll();
  static Future notificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name ',
        channelDescription: 'channel discription',
        importance: Importance.max,
      ),
      iOS: IOSNotificationDetails(),
    );
  }

  static Future init({bool initSheduled = false}) async {
    const android =
        AndroidInitializationSettings('@drawable/launch_background');
    const ios = IOSInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: ios);

    await _notification.initialize(settings,
        onSelectNotification: (payload) async {
      onNotification.add(payload);
    });

    if (initSheduled) {
      tz.initializeTimeZones();
      final locationName = await FlutterNativeTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(locationName));
    }
  }

  Future<void> showScheduledNotification({
    int id = 0,
    required String? title,
    required String? body,
    required String? payload,
    required Time sheduleddatetime,
  }) async =>
      _notification.zonedSchedule(
        id,
        title,
        body,
        _sheduleddaily(sheduleddatetime),
        await notificationDetails(),
        payload: payload,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );

  tz.TZDateTime _sheduleddaily(Time? time) {
    final TZDateTime now = tz.TZDateTime.now(
      tz.local,
    ).add(
      Duration(
        hours: time!.hour,
        minutes: time.minute,
        seconds: 0,
      ),
    );

    final sheduleddate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
      time.second,
    );

    return sheduleddate.isBefore(now)
        ? sheduleddate.add(
            const Duration(days: 1),
          )
        : sheduleddate;
  }
}
