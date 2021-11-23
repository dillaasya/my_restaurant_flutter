import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_restaurant/widget/custom_dialog.dart';
import 'package:my_restaurant/widget/platform_widget.dart';

class SettingPage extends StatelessWidget {
  static const String settingTitle = 'Setting';

  const SettingPage({Key? key}) : super(key: key);

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(settingTitle),
      ),
      body: _buildList(context),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text(settingTitle),
      ),
      child: _buildList(context),
    );
  }

  Widget _buildList(BuildContext context) {
    return ListView(
      children: [
        Material(
          child: ListTile(
            title: const Text('Scheduling News'),
            trailing: (
                Switch.adaptive(
                  value: true,
                  onChanged: (value) async {
                    if (Platform.isIOS) {
                      customDialog(context);
                    } else {
                    }
                  },
                )
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }
}
