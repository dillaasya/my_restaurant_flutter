import 'dart:math';
import 'dart:ui';
import 'dart:isolate';
import 'package:my_restaurant/data/api/api_service.dart';
import 'package:my_restaurant/main.dart';
import 'notification_helper.dart';

final ReceivePort port = ReceivePort();

class BackgroundService {
  static BackgroundService? _instance;
  static const String _isolateName = 'isolate';
  static SendPort? _uiSendPort;

  BackgroundService._internal() {
    _instance = this;
  }

  factory BackgroundService() => _instance ?? BackgroundService._internal();

  void initializeIsolate() {
    IsolateNameServer.registerPortWithName(
      port.sendPort,
      _isolateName,
    );
  }

  static Future<void> callback() async {
    print('Alarm fired!');
    final NotificationHelper _notificationHelper = NotificationHelper();
    var result = await ApiService().restaurantList();

    int randomizedNum = Random().nextInt(result.restaurants.length);
    await _notificationHelper.showNotification(
        flutterLocalNotificationsPlugin, result.restaurants[randomizedNum]);

    _uiSendPort ??= IsolateNameServer.lookupPortByName(_isolateName);
    _uiSendPort?.send(null);
  }
}
