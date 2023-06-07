import 'package:flutter/material.dart';
import 'package:foodCourier/constants/text_styles.dart';
import 'package:foodCourier/controllers/size_config.dart';
import 'package:foodCourier/models/meal.dart';
import 'package:foodCourier/widgets/meal_screen_widgets/meal_tags.dart';
import 'package:foodCourier/widgets/meal_screen_widgets/meal_name.dart';

class MealProfile extends StatelessWidget {
  final Meal meal;
  final String logoUrl;

  final ScrollController _controller = ScrollController();

  MealProfile(this.meal, this.logoUrl);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _controller,
      child: Container(
          //height: 25 * SizeConfig.blockSizeVertical!,
          padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical!),
          margin: EdgeInsets.symmetric(
            vertical: 1 * SizeConfig.blockSizeVertical!,
            horizontal: 4 * SizeConfig.blockSizeHorizontal!,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Labels',
                style: mealSubTitles,
              ),
              meal.labelNames.length > 0
                  ? SizedBox(
                      height: 7 * SizeConfig.blockSizeVertical!,
                      child: MealTags(meal.labelNames),
                    )
                  : Container(),
              MealName(
                meal: meal,
                logoUrl: logoUrl,
              ),
            ],
          )),
    );
  }
}
