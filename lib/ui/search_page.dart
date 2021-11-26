import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_restaurant/data/api/api_service.dart';
import 'package:my_restaurant/data/provider/search_provider.dart';
import 'package:my_restaurant/utils/result_state.dart';
import 'package:my_restaurant/widget/card_restaurant.dart';
import 'package:my_restaurant/widget/platform_widget.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  static const routeName = '/restaurant_search';

  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String query = '';

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: _buildList(context),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Search'),
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
    return ChangeNotifierProvider<SearchProvider>(
      create: (_) => SearchProvider(apiService: ApiService(), query: query),
      child: Consumer<SearchProvider>(builder: (context, state, _) {
        return SafeArea(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      height: 42,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                        border: Border.all(color: Colors.black26),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: TextField(
                        onSubmitted: (searchQuery) {
                          setState(() {
                            query = searchQuery;
                            state.fetchRestaurantSearch(query);
                            _buildSearch(context, state);
                          });
                        },
                        decoration: const InputDecoration(
                          icon: Icon(Icons.search),
                          hintText: "Type restaurant name here...",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            query.isNotEmpty
                ? _buildSearch(context, state)
                : Column(
                  children: [
                    Image.asset('assets/empty.png', width: 150,height: 150),
                    const Text('No search results')
                  ],
                )
          ],
        ));
      }),
    );
  }

  Widget _buildSearch(BuildContext context, SearchProvider state) {
    if (state.state == ResultState.loading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state.state == ResultState.hasData) {
      return Expanded(
        child: ListView.builder(
          itemCount: state.result.restaurants.length,
          padding: const EdgeInsets.all(16),
          itemBuilder: (context, index) {
            var restaurant = state.result.restaurants[index];
            return CardRestaurant(restaurant: restaurant);
          },
        ),
      );
    } else if (state.state == ResultState.noData) {
      return Center(child: Text(state.message));
    } else if (state.state == ResultState.error) {
      return Center(child: Text(state.message));
    } else {
      return const Center(child: Text(''));
    }
  }
}
