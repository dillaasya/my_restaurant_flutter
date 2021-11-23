
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_restaurant/data/model/restaurant_search.dart';
import 'package:my_restaurant/ui/detail_page.dart';

class CardRestaurantSearch extends StatelessWidget{
  final Restaurant restaurant;

  const CardRestaurantSearch({Key? key, required this.restaurant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.pushNamed(context, DetailPage.routeName,
              arguments: restaurant.id);
        },
        child: Card(
          margin: const EdgeInsets.only(bottom: 20),
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(children: <Widget>[
            SizedBox(
                height: 90,
                width: 110,
                child: Hero(
                  tag: restaurant.id,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(14),
                        bottom: Radius.circular(14)),
                    child: Image.network(
                      'https://restaurant-api.dicoding.dev/images/small/'
                          + restaurant.pictureId,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant.name,
                    style: const TextStyle(
                      fontFamily: 'UbuntuBold',
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.black26,
                        size: 15,
                      ),
                      const SizedBox(width: 3,),
                      Text(
                        restaurant.city,
                        style: const TextStyle(
                            fontFamily: 'UbuntuRegular',
                            fontSize: 14,
                            color: Colors.black38),
                      ),
                    ],
                  ),
                  const SizedBox(height: 7),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.black45,
                        size: 15,
                      ),
                      const SizedBox(width: 3,),
                      Text(
                        restaurant.rating.toString(),
                        style: const TextStyle(
                            fontFamily: 'UbuntuRegular',
                            fontSize: 14,
                            color: Colors.black54),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ]),
        )
    );
  }

}