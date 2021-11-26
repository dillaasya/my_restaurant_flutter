import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_restaurant/data/api/api_service.dart';
import 'package:my_restaurant/data/model/restaurant.dart';
import 'package:my_restaurant/data/model/restaurant_detail.dart';
import 'package:my_restaurant/data/provider/database_provider.dart';
import 'package:my_restaurant/data/provider/detail_provider.dart';
import 'package:my_restaurant/utils/result_state.dart';
import 'package:my_restaurant/widget/platform_widget.dart';
import 'package:provider/provider.dart';

class DetailPage extends StatelessWidget {
  static const routeName = '/restaurant_list_detail';
  final Restaurant restaurant;
  const DetailPage({Key? key, required this.restaurant}) : super(key: key);

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
    return ChangeNotifierProvider<DetailProvider>(
        create: (_) =>
            DetailProvider(apiService: ApiService(), id: restaurant.id),
        child: Consumer<DetailProvider>(
          builder: (context, state, _) {
            if (state.state == ResultState.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.state == ResultState.hasData) {
              final details = state.result.restaurantDetailsData;
              return Consumer<DatabaseProvider>(
                builder: (context, provider, child) {
                  return FutureBuilder<bool>(
                    future: provider.isFavorite(details.id),
                    builder: (context, snapshot) {
                      var isBookmarked = snapshot.data ?? false;
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            Stack(
                              clipBehavior: Clip.none,
                              children: <Widget>[
                                Hero(
                                  tag: details.id,
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(15),
                                        bottomRight: Radius.circular(15)),
                                    child: Image.network(
                                      'https://restaurant-api.dicoding.dev/images/medium/' +
                                          details.pictureId,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: -20,
                                  right: 30,
                                  child: CircleAvatar(
                                    backgroundColor: const Color(0xFFe0e0e0),
                                    child: isBookmarked
                                        ? IconButton(
                                            icon: const Icon(Icons.favorite),
                                            color: Colors.red,
                                            onPressed: () => provider
                                                .removeFavorite(restaurant.id),
                                          )
                                        : IconButton(
                                            icon: const Icon(
                                                Icons.favorite_border),
                                            color: const Color(0xFFaeaeae),
                                            onPressed: () => provider
                                                .addFavorite(restaurant),
                                          ),
                                  ),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 25, bottom: 25),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    details.name,
                                    style: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    margin: const EdgeInsets.only(left: 0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Icon(
                                          Icons.location_on,
                                          color: Colors.black26,
                                          size: 18,
                                        ),
                                        const SizedBox(
                                          width: 3,
                                        ),
                                        Text(
                                          details.address,
                                          style: GoogleFonts.roboto(fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(height: 20),
                                  const Divider(),
                                  Text(
                                    "Descriptions",
                                    style: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    details.description,
                                    style: GoogleFonts.roboto(fontWeight: FontWeight.w300),
                                  ),
                                  const SizedBox(height: 25),
                                  Text(
                                    "Foods",
                                    style: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 10),
                                  SizedBox(
                                    height: 80,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      itemCount: state
                                          .result
                                          .restaurantDetailsData
                                          .menus
                                          .foods
                                          .length,
                                      itemBuilder: (context, index) {
                                        return _buildMenuItem(context,
                                            details.menus.foods[index]);
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  Text(
                                    "Drinks",
                                    style: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 10),
                                  SizedBox(
                                    height: 80,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      itemCount: state
                                          .result
                                          .restaurantDetailsData
                                          .menus
                                          .drinks
                                          .length,
                                      itemBuilder: (context, index) {
                                        return _buildMenuItem(context,
                                            details.menus.drinks[index]);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
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

Widget _buildMenuItem(BuildContext context, FoodsDrinks menu) {
  return InkWell(
      child: Card(
    margin: const EdgeInsets.only(bottom: 20, right: 20),
    clipBehavior: Clip.antiAlias,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    child: Container(
      width: 150,
      color: const Color(0xFFe0e0e0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            child: Text(
              menu.name,
              style: GoogleFonts.roboto(fontWeight: FontWeight.w400),
            ),
          )
        ],
      ),
    ),
  ));
}
