import 'package:flutter/material.dart';
import 'package:my_restaurant/data/api/api_service.dart';
import 'package:my_restaurant/data/model/restaurant_detail.dart';
import 'package:my_restaurant/utils/result_state.dart';

class DetailProvider extends ChangeNotifier {
  final ApiService apiService;

  String id;

  DetailProvider({required this.apiService, required this.id}) {
    _fetchRestaurantDetails(id);
  }

  late RestaurantDetail _restaurantDetails;
  late ResultState _state;
  String _message = '';
  String get message => _message;
  RestaurantDetail get result => _restaurantDetails;
  ResultState get state => _state;

  Future<dynamic> _fetchRestaurantDetails(String? id) async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final restaurantDetails = await apiService.detailList(id);
      if (restaurantDetails.detail.menus.foods.isEmpty && restaurantDetails.detail.menus.drinks.isEmpty) {
        _state = ResultState.NoData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultState.HasData;
        notifyListeners();
        return _restaurantDetails = restaurantDetails;
      }
    } catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      return _message = 'Turn on your internet connection';
    }
  }
}
