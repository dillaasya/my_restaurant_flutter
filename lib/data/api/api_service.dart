import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:my_restaurant/data/model/restaurant_detail.dart';
import 'package:my_restaurant/data/model/restaurant_list.dart';
import 'package:my_restaurant/data/model/restaurant_search.dart';

class ApiService {
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev/';
  static const String _main = 'list';
  static const String _detail = 'detail/';
  static const String _search = 'search?q=';

  Future<RestaurantList> restaurantList() async {
    final response = await http.get(Uri.parse(_baseUrl + _main));
    if (response.statusCode == 200) {
      return RestaurantList.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load restaurant list');
    }
  }

  Future<RestaurantDetail> detailList(String? id) async {
    final response = await http.get(Uri.parse(_baseUrl + _detail + id!));
    if (response.statusCode == 200) {
      return RestaurantDetail.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load restaurant details');
    }
  }

  Future<RestaurantSearch> searchList(String query) async {
    final response = await http.get(Uri.parse(_baseUrl + _search + query));
    if (response.statusCode == 200) {
      return RestaurantSearch.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load restaurant details');
    }
  }
}
