import 'dart:io';

import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:my_restaurant/common/navigation.dart';
import 'package:my_restaurant/data/model/restaurant.dart';
import 'package:my_restaurant/data/provider/list_provider.dart';
import 'package:my_restaurant/ui/detail_page.dart';
import 'package:my_restaurant/ui/favorite_page.dart';
import 'package:my_restaurant/ui/home_page.dart';
import 'package:my_restaurant/ui/list_page.dart';
import 'package:my_restaurant/ui/search_page.dart';
import 'package:my_restaurant/ui/settings_page.dart';
import 'package:my_restaurant/utils/background_service.dart';
import 'package:my_restaurant/utils/notification_helper.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/api/api_service.dart';
import 'data/db/database_helper.dart';
import 'data/preferences/preferences_helper.dart';
import 'data/provider/database_provider.dart';
import 'data/provider/preferences_provider.dart';
import 'data/provider/scheduling_provider.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final NotificationHelper _notificationHelper = NotificationHelper();
  final BackgroundService _service = BackgroundService();

  _service.initializeIsolate();

  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }
  await _notificationHelper.initNotifications(flutterLocalNotificationsPlugin);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ListProvider(apiService: ApiService()),
        ),
        ChangeNotifierProvider(create: (_) => SchedulingProvider()),
        ChangeNotifierProvider(
          create: (_) => DatabaseProvider(databaseHelper: DatabaseHelper()),
        ),
        ChangeNotifierProvider(
          create: (_) => PreferencesProvider(
            preferencesHelper: PreferencesHelper(
              sharedPreferences: SharedPreferences.getInstance(),
            ),
          ),
        ),
      ],
      child: Consumer<PreferencesProvider>(
        builder: (context, provider, child) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            navigatorKey: navigatorKey,
            initialRoute: HomePage.routeName,
            routes: {
              HomePage.routeName: (context) => const HomePage(),
              ListPage.routeName: (context) => const ListPage(),
              SearchPage.routeName: (context) => const SearchPage(),
              FavoritePage.routeName: (context) => const FavoritePage(),
              SettingsPage.routeName: (context) => const SettingsPage(),
              DetailPage.routeName: (context) => DetailPage(
                    restaurant: ModalRoute.of(context)?.settings.arguments
                        as Restaurant,
                  ),
            },
          );
        },
      ),
    );
  }
}
