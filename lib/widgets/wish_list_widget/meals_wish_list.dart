import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_courier/controllers/size_config.dart';
import 'package:food_courier/widgets/restaurant_screen_widgets/meal_info.dart';
import 'package:food_courier/models/meal.dart';

List<Meal> meals = [
  Meal(
      id: 1,
      name: 'Lunch',
      description:
          'is simply dummy text of the printing and typesetting industry.',
      price: 30.0,
      type: 'another',
      labels: {1: 'gh', 2: 'ef', 3: 'ij'}),
  Meal(
      id: 2,
      name: 'Lunch',
      description:
          'is simply dummy text of the printing and typesetting industry.',
      price: 30.0,
      type: 'another',
      labels: {1: 'gh', 2: 'ef', 3: 'ij'}),
  Meal(
      id: 3,
      name: 'Lunch',
      description:
          'is simply dummy text of the printing and typesetting industry.',
      price: 30.0,
      type: 'another',
      labels: {1: 'gh', 2: 'ef', 3: 'ij'}),
  Meal(
      id: 4,
      name: 'Lunch box',
      description:
          'is simply dummy text of the printing and typesetting industry.',
      price: 30.0,
      type: 'another',
      labels: {1: 'gh', 2: 'ef', 3: 'ij'}),
];

class MealsWishList extends StatefulWidget {
  const MealsWishList({Key? key}) : super(key: key);

  @override
  MealsWishListState createState() => MealsWishListState();
}

class MealsWishListState extends State<MealsWishList> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 5 * SizeConfig.blockSizeVertical!,
      child: ListView.builder(
        padding: EdgeInsets.only(bottom: 8 * SizeConfig.blockSizeVertical!),
        itemCount: meals.length,
        itemBuilder: (_, i) => MealCard(
          meal: meals[i],
          callbackNavigationBottomBar: null,
        ),
      ),
    );
  }
}
