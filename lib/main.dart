
import 'package:flutter/material.dart';
import 'package:my_restaurant/data/api/api_service.dart';
import 'package:my_restaurant/data/db/database_helper.dart';
import 'package:my_restaurant/data/provider/database_provider.dart';
import 'package:my_restaurant/data/provider/list_provider.dart';
import 'package:my_restaurant/ui/detail_page.dart';
import 'package:my_restaurant/ui/home_page.dart';
import 'package:provider/provider.dart';

import 'data/db/database_helper.dart';
import 'data/provider/database_provider.dart';

void main() {


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => ListProvider(apiService: ApiService())),
        ChangeNotifierProvider(
          create: (_) => DatabaseProvider(databaseHelper: DatabaseHelper()),
        ),
      ],
      child: Consumer<ListProvider>(
        builder: (context, provider, child) {
          return MaterialApp(
            title: 'News App',
            theme: ThemeData(
              scaffoldBackgroundColor: Colors.white,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              appBarTheme: const AppBarTheme(
                elevation: 0,
              ),
              bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                unselectedItemColor: Colors.grey,
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(0),
                    ),
                  ),
                ),
              ),
            ),
            initialRoute: HomePage.routeName,
            routes: {
              HomePage.routeName: (context) => HomePage(),
              DetailPage.routeName: (context) => DetailPage(
                    id: ModalRoute.of(context)?.settings.arguments as String,
                  )
            },
          );
        },
      ),
    );
  }
}
