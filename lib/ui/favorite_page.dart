import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_restaurant/data/api/api_service.dart';
import 'package:my_restaurant/data/provider/database_provider.dart';
import 'package:my_restaurant/data/provider/list_provider.dart';
import 'package:my_restaurant/utils/result_state.dart';
import 'package:my_restaurant/widget/card_restaurant.dart';
import 'package:my_restaurant/widget/platform_widget.dart';
import 'package:provider/provider.dart';

class FavoritePage extends StatefulWidget {
  static const routeName = '/restaurant_favorite_list';

  const FavoritePage({Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite'),
      ),
      body: _buildList(context),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Favorite'),
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
    return ChangeNotifierProvider<ListProvider>(
        create: (_) => ListProvider(apiService: ApiService()),
        child: Consumer<ListProvider>(
          builder: (context, state, _) {
            if (state.state == ResultState.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.state == ResultState.hasData) {
              return SafeArea(
                child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Consumer<DatabaseProvider>(
                          builder: (context, provider, child) {
                            if (provider.state == ResultState.hasData) {
                              return Expanded(
                                child: ListView.builder(
                                  itemCount: provider.favorites.length,
                                  itemBuilder: (context, index) {
                                    var favRestaurant =
                                        provider.favorites[index];
                                    return CardRestaurant(
                                        restaurant: favRestaurant);
                                  },
                                ),
                              );
                            } else {
                              return Column(
                                children: [
                                  Image.asset('assets/empty.png', width: 150,height: 150),
                                  const Text('There\'s empty here, try to add some favorited restaurant',textAlign: TextAlign.center,)
                                ],
                              );
                            }
                          },
                        ),
                      ],
                    )),
              );
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
}
