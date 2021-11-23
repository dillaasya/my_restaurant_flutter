import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_restaurant/data/api/api_service.dart';
import 'package:my_restaurant/data/provider/detail_provider.dart';
import 'package:my_restaurant/widget/platform_widget.dart';
import 'package:provider/provider.dart';

import '../utils/result_state.dart';

class DetailPage extends StatelessWidget{
  static const routeName = '/restaurant_list_detail';
  final String id;
  const DetailPage({Key? key, required this.id}) : super(key: key);

  Widget _buildDetail(BuildContext context) {

    return ChangeNotifierProvider<DetailProvider>(
        create: (_) => DetailProvider(apiService: ApiService(), id: id),
        child: Consumer<DetailProvider>(
          builder: (context, state, _) {
            if (state.state == ResultState.Loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.state == ResultState.HasData) {
              final details = state.result.detail;
              return Scaffold(
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      Stack(
                        children: <Widget>[
                          Hero(
                            tag: details.id,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(15)
                              ),
                              child: Image.network(
                                'https://restaurant-api.dicoding.dev/images/medium/'
                                    + details.pictureId,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              details.name, style: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              margin: const EdgeInsets.only(left: 0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    color: Colors.black26,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 3,),
                                  Text(
                                    details.address,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Divider(),
                            const SizedBox(height: 10),
                            const Text(
                              "Descriptions",
                            ),
                            const SizedBox(height: 10),
                            Text(
                              details.description,
                              textAlign: TextAlign.justify
                            ),
                            const SizedBox(height: 25),
                            const Text(
                              "Foods",
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 100,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: state.result.detail.menus.foods.length,
                                itemBuilder: (context, index) {
                                  return _buildMenu(context, details.menus.foods[index]);
                                },
                              ),
                            ),

                            const SizedBox(height: 15),
                            const Text(
                              "Drinks",
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 100,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: state.result.detail.menus.drinks.length,
                                itemBuilder: (context, index) {
                                  return _buildMenu(context, details.menus.drinks[index]);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (state.state == ResultState.NoData) {
              return Center(child: Text(state.message));
            } else if (state.state == ResultState.Error) {
              return Center(child: Text(state.message));
            } else {
              return const Center(child: Text(''));
            }
          },
        )
    );

  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Detail')
      ),
      body: _buildDetail(context),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('MyRestaurant'),
        transitionBetweenRoutes: false,
      ),
      child: _buildDetail(context),
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

Widget _buildMenu(BuildContext context, menu) {
  return InkWell(
      child: SizedBox(
        width: 150,
        child: Card(
          margin: const EdgeInsets.only(bottom: 20, right: 20),
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                child: Text(
                  menu.name,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ],
          )
        ),
      )
  );
}
