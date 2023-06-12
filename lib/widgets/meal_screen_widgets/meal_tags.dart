import 'package:flutter/material.dart';
import 'package:foodCourier/constants/text_styles.dart';
import 'package:foodCourier/constants/colors.dart';
import 'package:foodCourier/controllers/size_config.dart';
import 'package:auto_size_text/auto_size_text.dart';

class MealTags extends StatelessWidget {
  final List<String> mealTags;

  const MealTags(this.mealTags, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: mealTags.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (_, index) => Container(
        margin: EdgeInsets.all(
          SizeConfig.blockSizeVertical!,
        ),
        decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: BorderRadius.circular(8.0),
        ),
        width: 30 * SizeConfig.blockSizeHorizontal!,
        height: 5 * SizeConfig.blockSizeVertical!,
        child: Center(
            child: AutoSizeText(
          //'temporary',
          mealTags[index],
          maxLines: 1,
          style: restaurantLabels,
        )),
      ),
    );
  }
}
