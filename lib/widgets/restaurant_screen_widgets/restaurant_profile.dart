import 'package:flutter/material.dart';
import 'package:foodCourier/controllers/size_config.dart';
import 'package:foodCourier/widgets/restaurant_screen_widgets/restaurant_tags.dart';
import 'package:foodCourier/widgets/restaurant_screen_widgets/restaurant_name_pic.dart';
import 'package:foodCourier/models/restaurant.dart';

class RestaurantProfile extends StatelessWidget {
  final Restaurant restaurant;
  final double distance;
  final String duration;

  final ScrollController _controller = ScrollController();

  RestaurantProfile(this.distance, this.duration, this.restaurant, {Key? key})
      : super(key: key);

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
            children: <Widget>[
              restaurant.labelNames.isNotEmpty
                  ? SizedBox(
                      height: 7 * SizeConfig.blockSizeVertical!,
                      child: RestaurantTags(restaurant.labelNames),
                    )
                  : Container(),
              RestaurantName(
                restaurant: restaurant,
                distance: distance,
                duration: duration,
              ),
            ],
          )),
    );
  }
}
