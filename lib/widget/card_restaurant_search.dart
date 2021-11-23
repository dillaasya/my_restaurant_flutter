import 'package:flutter/material.dart';
import 'package:my_restaurant/data/model/restaurant_search.dart';
import 'package:my_restaurant/data/provider/database_provider.dart';
import 'package:provider/provider.dart';

class CardRestaurantSearch extends StatelessWidget{
  final Restaurant restaurant;

  const CardRestaurantSearch({Key? key, required this.restaurant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (context, provider, child) {
        return FutureBuilder<bool>(
          future: provider.isFavorited(restaurant.id),
          builder: (context, snapshot) {
            //var isBookmarked = snapshot.data ?? false;
            return Material(
              child: ListTile(
                leading: Hero(
                  tag: restaurant.id,
                  child: Image.network(
                    'https://restaurant-api.dicoding.dev/images/small/'
                        + restaurant.pictureId,
                    width: 100,
                  ),
                ),
                title: Text(
                  restaurant.name,
                ),
                subtitle: Text(restaurant.city),
              ),

            );
          },
        );
      },
    );
  }

}