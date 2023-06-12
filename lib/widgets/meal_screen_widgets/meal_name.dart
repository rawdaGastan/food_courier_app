import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodCourier/constants/text_styles.dart';
import 'package:foodCourier/constants/colors.dart';
import 'package:foodCourier/controllers/size_config.dart';
import 'package:foodCourier/models/meal.dart';

class MealName extends StatefulWidget {
  final Meal meal;
  final String logoUrl;

  const MealName({Key? key, required this.meal, required this.logoUrl})
      : super(key: key);

  @override
  MealNameState createState() => MealNameState();
}

class MealNameState extends State<MealName> {
  int serves = 2;
  int calories = 150;

  showIngredients(list) {
    var concatenate = StringBuffer();

    list.forEach((item) {
      concatenate.write('$item, ');
    });
    return concatenate
        .toString()
        .substring(0, concatenate.toString().length - 2);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: SizeConfig.blockSizeVertical!),
      child: SizedBox(
        //height: 9 * SizeConfig.blockSizeVertical!,
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal!),
                      child: CircleAvatar(
                        radius: 3 * SizeConfig.blockSizeVertical!,
                        backgroundImage:
                            CachedNetworkImageProvider(widget.logoUrl),
                      ),
                    ),
                    Container(
                      width: 55 * SizeConfig.blockSizeHorizontal!,
                      padding: EdgeInsets.symmetric(
                          horizontal: 1 * SizeConfig.blockSizeHorizontal!),
                      child: AutoSizeText(
                        widget.meal.name,
                        style: restaurantName,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 1 * SizeConfig.blockSizeHorizontal!),
                  margin: EdgeInsets.symmetric(
                      horizontal: 2 * SizeConfig.blockSizeHorizontal!,
                      vertical: 2 * SizeConfig.blockSizeVertical!),
                  decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.circular(3.0),
                  ),
                  height: 5 * SizeConfig.blockSizeVertical!,
                  width: 18 * SizeConfig.blockSizeHorizontal!,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Icon(
                        Icons.star,
                        color: orangeColor,
                      ),
                      Text(
                        widget.meal.rating,
                        textScaleFactor: 1.0,
                        style: ratingTextBlack,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Price',
                          style: mealSubTitles,
                        ),
                        SizedBox(
                          height: SizeConfig.blockSizeVertical!,
                        ),
                        Container(
                          width: 75 * SizeConfig.blockSizeHorizontal!,
                          padding: EdgeInsets.symmetric(
                            horizontal: 2 * SizeConfig.blockSizeHorizontal!,
                          ),
                          child: AutoSizeText(
                            widget.meal.price.toString(),
                            style: mealPrice,
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.blockSizeVertical!,
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2 * SizeConfig.blockSizeHorizontal!),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            child: Icon(
                              widget.meal.isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: orangeColor,
                            ),
                            onTap: () {
                              setState(() {
                                widget.meal.toggleFav();
                              });
                            },
                          ),
                          Text(
                            widget.meal.numberOfLikes.toString(),
                            style: favoriteNumberMeals,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Ingredients',
                            style: mealIngredientsStyle,
                          ),
                          SizedBox(
                            height: SizeConfig.blockSizeVertical!,
                          ),
                          Container(
                            //width: 75 * SizeConfig.blockSizeHorizontal!,
                            padding: EdgeInsets.symmetric(
                              horizontal: 2 * SizeConfig.blockSizeHorizontal!,
                            ),
                            child: AutoSizeText(
                              showIngredients(widget.meal.ingredients),
                              style: mealPrice,
                            ),
                          ),
                          SizedBox(height: SizeConfig.blockSizeVertical!),
                        ]),
                  ],
                ),
                const Text(
                  'Meal Info',
                  style: mealSubTitles,
                ),
                SizedBox(
                  height: SizeConfig.blockSizeVertical!,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Image(
                              image:
                                  const AssetImage('assets/icons/serves.png'),
                              color: darkTextColor,
                              width: 5 * SizeConfig.blockSizeHorizontal!,
                            ),
                            //Icon(Icons.room_service, color: darkTextColor),
                            SizedBox(width: SizeConfig.blockSizeHorizontal!),
                            Text(
                              serves.toString(),
                              style: fillFieldText,
                            ),
                          ],
                        ),
                        const Text(
                          'Serves',
                          style: mealInfo,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Image(
                              image:
                                  const AssetImage('assets/icons/calories.png'),
                              color: darkTextColor,
                              width: 5 * SizeConfig.blockSizeHorizontal!,
                            ),
                            //Icon(Icons.local_fire_department, color: darkTextColor),
                            SizedBox(width: SizeConfig.blockSizeHorizontal!),
                            Text(
                              calories.toString(),
                              style: fillFieldText,
                            ),
                          ],
                        ),
                        const Text(
                          'Calories',
                          style: mealInfo,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
