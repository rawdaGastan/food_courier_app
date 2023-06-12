import 'package:flutter/cupertino.dart';
import 'package:food_courier/controllers/networking.dart';
import 'dart:convert';
import 'package:food_courier/models/restaurant.dart';

class AllFiltersProvider extends ChangeNotifier {
  static List<String> restrictions = [];
  static List<String> cuisines = [];
  static List<String> apiLabels = [];
  List<Restaurant> _menu = [];
  List<Restaurant> _tempMenu = [];

  List get menu => _menu;

  int pageIndex = 1;

  int searchPageIndex = 1;

  int sortPageIndex = 1;

  int sortDistancePageIndex = 1;

  int restaurantByCityPageIndex = 1;

  int deliveryRestaurantPageIndex = 1;

  Map<String, dynamic> filterMap = {
    'type': 'Normal', // 'gluten free','high protein','vegetarian','vegan'
    'cuisine': cuisines,
    'restrictions': restrictions,
  };

  final Map<String, dynamic> _toJson = {
    'delivery': true,
    'labels': ['Vegan'],
  };

  void getLabels() {
    if (filterMap['type'] != 'Normal') apiLabels.add(filterMap['type']);
    for (String restriction in restrictions) {
      apiLabels.add(restriction);
    }
    for (String cuisine in cuisines) {
      apiLabels.add(cuisine);
    }
  }

  void changeType(String value) {
    filterMap.update('type', (_) => value.toLowerCase());
  }

  void deleteType() {
    filterMap.update('type', (_) => 'Normal');
  }

  void addCuisine(String value) {
    cuisines.add(value.toLowerCase());
  }

  void deleteCuisine(String value) {
    if (cuisines.contains(value.toLowerCase())) {
      cuisines.remove(value.toLowerCase());
    }
  }

  void addRestriction(String value) {
    restrictions.add(value.toLowerCase());
  }

  void deleteRestriction(String value) {
    if (restrictions.contains(value.toLowerCase())) {
      restrictions.remove(value.toLowerCase());
    }
  }

  String jsonFilters() {
    return json.encode(_toJson);
  }

  Map<int, String> loadLabels(List labels) {
    Map<int, String> temp = {};
    for (var item in labels) {
      temp.putIfAbsent(item['label']['id'], () => item['label']['label']);
    }
    return temp;
  }

  Map<int, String> loadPhotos(List photos) {
    Map<int, String> temp = {};
    for (var item in photos) {
      temp.putIfAbsent(item['photo']['id'], () => item['photo']['photo']);
    }
    return temp;
  }

  bool checkEqualSuppliersList(
      List<Restaurant> menu, List<Restaurant> newMenu) {
    bool isEqual = false;
    if (menu.length == newMenu.length) {
      for (int i = 0; i < menu.length; i++) {
        if (menu[i].id == newMenu[i].id) {
          isEqual = true;
        } else {
          isEqual = false;
        }
      }
    } else {
      isEqual = false;
    }
    return isEqual;
  }

  List<Restaurant> renewData(Map<String, dynamic> response) {
    List suppliers = response['suppliers'];
    for (int i = 0; i < suppliers.length; i++) {
      List<String> addressLines = [];
      for (int x = 1; suppliers[i]['address_line_$x'] != null; x++) {
        addressLines.add(suppliers[i]['address_line_$x']);
      }
      _tempMenu.add(Restaurant(
        name: suppliers[i]['supplier_name'],
        type: suppliers[i]['supplier_type'],
        city: suppliers[i]['city'],
        town: suppliers[i]['town'],
        email: suppliers[i]['email'],
        isDelivery: suppliers[i]['delivery'],
        phone: suppliers[i]['phone'],
        id: suppliers[i]['id'],
        rating: suppliers[i]['rating'].toString().substring(0, 3),
        logoUrl: suppliers[i]['logo'],
        latitude: suppliers[i]['latitude'],
        longitude: suppliers[i]['longitude'],
        rangePrice: suppliers[i]['price_range'],
        isDineOut: suppliers[i]['dine_out'],
        addressLines: addressLines,
        labels: loadLabels(suppliers[i]['labels']),
        photos: loadPhotos(suppliers[i]['photos']),
      ));
    }
    if (checkEqualSuppliersList(_menu, _tempMenu)) {
      return _menu;
    } else {
      _menu = _tempMenu;
      return _menu;
    }
  }

  Future<List<Restaurant>> loadData(String token, String restaurantType) async {
    Networking net = Networking();
    Map<String, dynamic> response =
        jsonDecode(await net.getSuppliers(pageIndex, token, restaurantType));
    if (pageIndex == 1) _tempMenu = [];

    int? nextIndex = response['next'];
    if (nextIndex != null) {
      pageIndex = nextIndex;
    } else {
      pageIndex = 1;
    }

    _menu = renewData(response);
    return _menu;
  }

  Future<List<Restaurant>> searchRestaurant(
      String searchField, String userToken, String restaurantType) async {
    Networking net = Networking();
    Map<String, dynamic> response = jsonDecode(await net.searchForRestaurant(
        searchField, searchPageIndex, userToken, restaurantType));
    if (searchPageIndex == 1) _tempMenu = [];

    int? nextIndex = response['next'];
    if (nextIndex != null) {
      searchPageIndex = nextIndex;
    } else {
      searchPageIndex = 1;
    }

    _menu = renewData(response);
    return _menu;
  }

  Future<List<Restaurant>> sortRestaurantBy(
      String userToken, String sortBy, String restaurantType) async {
    Networking net = Networking();
    Map<String, dynamic> response = jsonDecode(await net.sortRestaurantBy(
        sortPageIndex, sortBy, userToken, restaurantType));
    if (sortPageIndex == 1) _tempMenu = [];

    int? nextIndex = response['next'];
    if (nextIndex != null) {
      sortPageIndex = nextIndex;
    } else {
      sortPageIndex = 1;
    }

    _menu = renewData(response);
    return _menu;
  }

  Future<List<Restaurant>> sortRestaurantByDistance(
      String userToken, latitude, longitude, String restaurantType) async {
    Networking net = Networking();
    Map<String, dynamic> response = jsonDecode(
        await net.sortRestaurantByDistance(sortDistancePageIndex, latitude,
            longitude, userToken, restaurantType));
    if (sortDistancePageIndex == 1) _tempMenu = [];

    int? nextIndex = response['next'];
    if (nextIndex != null) {
      sortDistancePageIndex = nextIndex;
    } else {
      sortDistancePageIndex = 1;
    }

    _menu = renewData(response);
    return _menu;
  }

  Future<List<Restaurant>> showRestaurantByLocation(String userToken,
      String location, String type, String restaurantType) async {
    Networking net = Networking();
    Map<String, dynamic> response = jsonDecode(
        await net.showSuppliersByLocation(restaurantByCityPageIndex, userToken,
            location, type, restaurantType));
    if (restaurantByCityPageIndex == 1) _tempMenu = [];

    int? nextIndex = response['next'];
    if (nextIndex != null) {
      restaurantByCityPageIndex = nextIndex;
    } else {
      restaurantByCityPageIndex = 1;
    }

    _menu = renewData(response);
    return _menu;
  }

  /* Future<List<Restaurant>> showDeliveryRestaurant(String userToken) async {
    bool sorted = false;
    Networking net = Networking();
    Map<String, dynamic> response = jsonDecode(await net.showDeliverySuppliers(deliveryRestaurantPageIndex, userToken));
    deliveryRestaurantCount = response['count'];

    if(deliveryRestaurantCount == _menu.length && deliveryRestaurantCount != 0 && sorted){
      return _menu;
    }
    else{
      if(deliveryRestaurantPageIndex == 1){
        _menu = [];
      }

      int nextIndex = response['next'];
      deliveryRestaurantPageIndex = nextIndex;
      //searchCount = response['count'];
      if(nextIndex != null)
        deliveryRestaurantPageIndex = nextIndex;
      else {
        sorted = true;
        deliveryRestaurantPageIndex = 1;
      }

      List suppliers = response['suppliers'];
      for(int i=0 ; i< suppliers.length ; i++){

        List<String> addressLines = [];
        for(int x = 1; suppliers[i]['address_line_$x'] != null ; x++){
          addressLines.add(suppliers[i]['address_line_$x']);
        }

        this._menu.add(
            Restaurant(
              name: suppliers[i]['supplier_name'],
              type: suppliers[i]['supplier_type'],
              city: suppliers[i]['city'],
              town: suppliers[i]['town'],
              email: suppliers[i]['email'],
              isDelivery: suppliers[i]['delivery'],
              phone: suppliers[i]['phone'],
              id: suppliers[i]['id'],
              rating: suppliers[i]['rating'].toString().substring(0,3),
              logoUrl: suppliers[i]['logo'],
              latitude: suppliers[i]['latitude'],
              longitude: suppliers[i]['longitude'],
              rangePrice: suppliers[i]['price_range'],
              isDineOut: suppliers[i]['dine_out'],
              addressLines: addressLines,
              labels: loadLabels(suppliers[i]['labels']),
              photos: loadPhotos(suppliers[i]['photos']),
            ));
      }
      return _menu;
    }
  } */
}
