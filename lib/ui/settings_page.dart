import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_restaurant/widget/custom_dialog.dart';
import 'package:my_restaurant/data/provider/preferences_provider.dart';
import 'package:my_restaurant/data/provider/scheduling_provider.dart';
import 'package:my_restaurant/widget/platform_widget.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  static const routeName = '/restaurant_settings';

  const SettingsPage({Key? key}) : super(key: key);

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: _buildList(context),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Settings'),
        transitionBetweenRoutes: false,
      ),
      child: _buildList(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }

  Widget _buildList(BuildContext context) {
    return SafeArea(
      child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Consumer<PreferencesProvider>(
                    builder: (context, provider, child) {
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Restaurants Notification'),
                        trailing: Consumer<SchedulingProvider>(
                          builder: (context, scheduled, _) {
                            return Switch.adaptive(
                              value: provider.isDailyNewsActive,
                              onChanged: (value) async {
                                if (Platform.isIOS) {
                                  customDialog(context);
                                } else {
                                  scheduled.scheduledRecommendation(value);
                                  provider.enableDailyNews(value);
                                }
                              },
                            );
                          },
                        ),
                      );
                    },
                  )
                ],
              ),
            ],
          )),
    );
  }
}
