import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_restaurant/data/api/api_service.dart';
import 'package:my_restaurant/data/provider/list_provider.dart';
import 'package:my_restaurant/widget/card_restaurant.dart';
import 'package:my_restaurant/widget/platform_widget.dart';
import 'package:provider/provider.dart';

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  Widget _buildList(BuildContext context) {
    return ChangeNotifierProvider<ListProvider>(
        create: (_) => ListProvider(apiService: ApiService()),
        child: Consumer<ListProvider>(
          builder: (context, state, _) {
            if (state.state == ResultState.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.state == ResultState.hasData) {
              return SafeArea(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.result.restaurants.length,
                      itemBuilder: (context, index) {
                        var restaurant = state.result.restaurants[index];
                        return CardRestaurant(restaurant: restaurant);
                      },
                    ),
                  )
                ],
              ));
            } else if (state.state == ResultState.noData) {
              return Center(child: Text(state.message));
            } else if (state.state == ResultState.error) {
              return Center(child: Text(state.message));
            } else {
              return const Center(child: Text(''));
            }
          },
        ));
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyRestaurant'),
      ),
      body: _buildList(context),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('MyRestaurant'),
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
}
