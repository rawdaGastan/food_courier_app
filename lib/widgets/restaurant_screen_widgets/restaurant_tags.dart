import 'package:flutter/material.dart';
import 'package:food_courier/constants/text_styles.dart';
import 'package:food_courier/constants/colors.dart';
import 'package:food_courier/controllers/size_config.dart';
import 'package:auto_size_text/auto_size_text.dart';

class RestaurantTags extends StatelessWidget {
  final List<String> restaurantLabelNames;

  const RestaurantTags(this.restaurantLabelNames, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: restaurantLabelNames.length,
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
          restaurantLabelNames[index],
          maxLines: 1,
          style: restaurantLabels,
        )),
      ),
    );
  }
}
