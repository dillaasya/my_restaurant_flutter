import 'package:flutter/material.dart';
import 'package:my_restaurant/data/model/restaurant_list.dart';
import 'package:my_restaurant/data/provider/database_provider.dart';
import 'package:my_restaurant/ui/detail_page.dart';
import 'package:provider/provider.dart';

class CardRestaurant extends StatelessWidget {
  final Restaurant restaurant;

  const CardRestaurant({Key? key, required this.restaurant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (context, provider, child) {
        return FutureBuilder<bool>(
          future: provider.isFavorited(restaurant.id),
          builder: (context, snapshot) {
            var isBookmarked = snapshot.data ?? false;
            return Material(
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                leading: Hero(
                  tag: restaurant.id,
                  child: Image.network(
                    'https://restaurant-api.dicoding.dev/images/small/' +
                        restaurant.pictureId,
                    width: 100,
                  ),
                ),
                title: Text(
                  restaurant.name,
                ),
                subtitle: Text(restaurant.city),
                trailing: isBookmarked
                    ? IconButton(
                        icon: const Icon(Icons.favorite),
                        onPressed: () => provider.removeFavorite(restaurant.id),
                      )
                    : IconButton(
                        icon: const Icon(Icons.favorite_border),
                        onPressed: () => provider.addFavortie(restaurant),
                      ),
                onTap: () {
                  Navigator.pushNamed(context, DetailPage.routeName,
                      arguments: restaurant.id);
                },
              ),
            );
          },
        );
      },
    );
  }
}
