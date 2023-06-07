import 'package:flutter/cupertino.dart';
import 'package:foodCourier/controllers/networking.dart';
import 'dart:convert';
import 'package:foodCourier/models/meal.dart';

class MealsProvider extends ChangeNotifier {
  static List<String> restrictions = [];
  static List<String> cuisines = [];
  static List<String> apiLabels = [];

  List<Meal> _meals = [];
  List get meals => _meals;

  int pageIndex = 1;
  int count = 0;

  Map<int, String> loadLabels(List labels) {
    Map<int, String> temp = {};
    for (var item in labels)
      temp.putIfAbsent(item['label']['id'], () => item['label']['label']);
    return temp;
  }

  Map<int, String> loadPhotos(List photos) {
    Map<int, String> temp = {};
    for (var item in photos)
      temp.putIfAbsent(item['photo']['id'], () => item['photo']['photo']);
    return temp;
  }

  Map<int, List<dynamic>> loadSupplierPrices(List supplierPrices) {
    Map<int, List<dynamic>> temp = {};
    for (var item in supplierPrices)
      temp.putIfAbsent(
          item['id'], () => [item['supplier'], item['price'], item['active']]);
    return temp;
  }

  Future<List<Meal>> loadAllMeals(
      String restaurantName, String userToken) async {
    Networking net = new Networking();
    Map<String, dynamic> response = jsonDecode(
        await net.getMealsData(restaurantName, pageIndex, userToken));
    count = response['count'];

    if (count == _meals.length && count != 0) {
      return _meals;
    } else {
      if (pageIndex == 1) _meals = [];

      int nextIndex = response['next'];
      pageIndex = nextIndex;
      if (nextIndex != null)
        pageIndex = nextIndex;
      else
        pageIndex = 1;

      List products = response['products'];
      for (int i = 0; i < products.length; i++) {
        this._meals.add(Meal(
              id: products[i]['id'],
              name: products[i]['product_name'],
              type: products[i]['product_type'],
              category: products[i]['category'],
              price: products[i]['price'],
              rating: products[i]['rating'],
              ingredients: [
                'Gluten free',
                'High protein',
                'Vegetarian',
                'Vegan'
              ],
              //products[i]['ingredients'],
              photos: {},
              labels: loadLabels(products[i]['labels']),
            ));
      }
      return _meals;
    }
  }

  Future<Meal> getSpecificMeal(int id, String userToken) async {
    Meal meal;
    Networking net = new Networking();
    List<dynamic> response =
        jsonDecode(await net.getSpecificMeal(id, userToken));

    Map<String, dynamic> product = response[0];

    meal = Meal(
      id: product['id'],
      name: product['product_name'],
      type: product['product_type'],
      category: product['category'],
      price: product['price'],
      rating: product['rating'],
      ingredients: ['Gluten free', 'High protein', 'Vegetarian', 'Vegan'],
      //description: product['description'],
      //products[i]['ingredients'],
      labels: loadLabels(product['labels']),
      photos: loadPhotos(product['photos']),
      numberOfLikes: product['number_of_likes'],
      supplierPrices: loadSupplierPrices(product['suppliers_prices']),
    );
    return meal;
  }
}
