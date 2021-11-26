import 'package:flutter/foundation.dart';
import 'package:my_restaurant/data/preferences/preferences_helper.dart';

class PreferencesProvider extends ChangeNotifier {
  PreferencesHelper preferencesHelper;

  PreferencesProvider({required this.preferencesHelper}) {
    _getDailyNewsPreferences();
  }

  bool _isDailyNewsActive = false;
  bool get isDailyNewsActive => _isDailyNewsActive;

  void _getDailyNewsPreferences() async {
    _isDailyNewsActive = await preferencesHelper.isDailyNewsActive;
    notifyListeners();
  }

  void enableDailyNews(bool value) {
    preferencesHelper.setDailyNews(value);
    _getDailyNewsPreferences();
  }
}
