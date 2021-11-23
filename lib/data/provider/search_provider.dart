import 'package:flutter/material.dart';
import 'package:my_restaurant/data/api/api_service.dart';
import 'package:my_restaurant/data/model/restaurant_list.dart';
import 'package:my_restaurant/data/model/restaurant_search.dart';
import 'package:my_restaurant/utils/result_state.dart';

import '../../utils/result_state.dart';

class SearchProvider extends ChangeNotifier {
  final ApiService apiService;

  String query;

  SearchProvider({required this.apiService, required this.query}) {
    fetchRestaurantSearch(query);
  }

  late RestaurantSearch _restaurantResult;
  late ResultState _state;
  String _message = '';
  String get message => _message;

  RestaurantSearch get result => _restaurantResult;

  ResultState get state => _state;

  Future<dynamic> fetchRestaurantSearch(String query) async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final restaurantSearch = await apiService.searchList(query);
      if (restaurantSearch.restaurants.isEmpty) {
        _state = ResultState.NoData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultState.HasData;
        notifyListeners();
        return _restaurantResult = restaurantSearch;
      }
    } catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      return _message = 'Turn on your internet connection';
    }
  }
}
