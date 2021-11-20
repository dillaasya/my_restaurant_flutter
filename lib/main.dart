import 'package:flutter/material.dart';
import 'package:my_restaurant/ui/detail_page.dart';
import 'package:my_restaurant/ui/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      //initialRoute: ConnectivityPage.routeName,
      routes: {
        //ConnectivityPage.routeName: (context) => ConnectivityPage(),
        HomePage.routeName: (context) => HomePage(),
        DetailPage.routeName: (context) => DetailPage(
          id: ModalRoute.of(context)?.settings.arguments as String,),
      },
    );
  }
}