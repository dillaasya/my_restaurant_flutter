import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:my_restaurant/utils/background_service.dart';
import 'package:my_restaurant/utils/date_time_helper.dart';

class SchedulingProvider extends ChangeNotifier {
  bool _isScheduled = false;

  bool get isScheduled => _isScheduled;

  Future<bool> scheduledRecommendation(bool value) async {
    _isScheduled = value;
    if (_isScheduled) {
      print('Scheduling Restaurant Recommendations Activated');
      notifyListeners();
      return await AndroidAlarmManager.periodic(
        Duration(hours: 24),
        1,
        BackgroundService.callback,
        startAt: DateTimeHelper.format(),
        exact: true,
        wakeup: true,
      );
    } else {
      print('Scheduling Restaurant Recommendations Canceled');
      notifyListeners();
      return await AndroidAlarmManager.cancel(1);
    }
  }
}
