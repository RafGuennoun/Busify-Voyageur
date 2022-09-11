import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;


class LocalNotificationService {
  
  LocalNotificationService();

  final _localNotificationService = FlutterLocalNotificationsPlugin();

  final BehaviorSubject<String?> onNotificationClick = BehaviorSubject(); 

  Future<void> initalize() async {
    tz.initializeTimeZones();
    const AndroidInitializationSettings androidInitializationSettings = 
      AndroidInitializationSettings('@drawable/voyageur');

    const InitializationSettings settings = InitializationSettings(
      android: androidInitializationSettings
    );

    await _localNotificationService.initialize(
      settings,
      onSelectNotification: onSelectedNotification
    );  
  }

  Future<NotificationDetails> _notificationDetails() async {
    const AndroidNotificationDetails androidNotificationDetails = 
      AndroidNotificationDetails(
        "channel id", 
        "channel name",
        channelDescription: "Description",
        importance: Importance.max,
        priority: Priority.max,
        playSound: true,
      );
    
    return const NotificationDetails(
      android: androidNotificationDetails
    );
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body
  }) async {
    final details = await _notificationDetails();
    await _localNotificationService.show(
      id, 
      title, 
      body, 
      details
    );
  }

  Future<void> showScheduledNotification({
    required int id,
    required String title,
    required String body,
    required int seconds
  }) async {
    final details = await _notificationDetails();
    await _localNotificationService.zonedSchedule(
      id, 
      title, 
      body, 
      tz.TZDateTime.from(
        DateTime.now().add(Duration(seconds: seconds)), 
        tz.local
      ), 
      details,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime
    );
  }

  Future<void> showScheduledNotifWithPayload({
    required int id,
    required String title,
    required String body,
    required String payload ,
    required int seconds
  }) async {
    final details = await _notificationDetails();
    await _localNotificationService.zonedSchedule(
      id, 
      title, 
      body, 
      tz.TZDateTime.from(
        DateTime.now().add(Duration(seconds: seconds)), 
        tz.local
      ), 
      details,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload
    );
  }
  
  void onSelectedNotification(String? payload) {
    print("payload");
    if (payload != null && payload.isNotEmpty) {
      onNotificationClick.add(payload);
    }
  }

}