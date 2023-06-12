import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_courier/constants/text_styles.dart';
import 'package:food_courier/constants/colors.dart';
import 'package:food_courier/controllers/size_config.dart';
import 'package:food_courier/generated/l10n.dart';
import 'package:food_courier/models/restaurant.dart';

class RestaurantName extends StatelessWidget {
  final Restaurant restaurant;
  final double distance;
  final String duration;

  const RestaurantName(
      {Key? key,
      required this.distance,
      required this.duration,
      required this.restaurant})
      : super(key: key);

  String getAddress(List<String> restaurantAddressList) {
    StringBuffer restaurantAddress = StringBuffer();
    for (String item in restaurantAddressList) {
      restaurantAddress.write('$item ');
    }
    return restaurantAddress.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: SizeConfig.blockSizeVertical!),
      child: SizedBox(
        //height: 9 * SizeConfig.blockSizeVertical!,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal!),
                      child: CircleAvatar(
                        radius: 8 * SizeConfig.blockSizeHorizontal!,
                        backgroundImage:
                            CachedNetworkImageProvider(restaurant.logoUrl),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 1 * SizeConfig.blockSizeHorizontal!),
                          child: AutoSizeText(
                            restaurant.name,
                            style: restaurantName,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                            vertical: 0.5 * SizeConfig.blockSizeVertical!,
                            horizontal: 1 * SizeConfig.blockSizeHorizontal!,
                          ),
                          width: 40 * SizeConfig.blockSizeHorizontal!,
                          child: RichText(
                            text: TextSpan(
                              children: [
                                const WidgetSpan(
                                  child: Icon(Icons.location_on,
                                      color: primaryColor, size: 20),
                                ),
                                TextSpan(
                                  text: getAddress(restaurant.addressLines),
                                  style: restaurantAddress,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      width: 15 * SizeConfig.blockSizeHorizontal!,
                      height: 6 * SizeConfig.blockSizeVertical!,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: whiteColor,
                        boxShadow: [
                          BoxShadow(
                            color: secondaryColor,
                            offset: Offset(5, 5), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              top: SizeConfig.blockSizeVertical!,
                              left: SizeConfig.blockSizeHorizontal!,
                            ),
                            child: const Icon(Icons.attach_money,
                                color: orangeColor),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: SizeConfig.blockSizeVertical!,
                              left: 4 * SizeConfig.blockSizeHorizontal!,
                            ),
                            child: const Icon(Icons.attach_money,
                                color: lightTextColor),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: SizeConfig.blockSizeVertical!,
                              left: 7 * SizeConfig.blockSizeHorizontal!,
                            ),
                            child: const Icon(Icons.attach_money,
                                color: lightTextColor),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: 20 * SizeConfig.blockSizeHorizontal!,
                  ),
                  child: Row(
                    children: [
                      Image.asset('assets/icons/distance.png',
                          width: 6 * SizeConfig.blockSizeHorizontal!,
                          color: lightTextColor),
                      Container(width: 1 * SizeConfig.blockSizeHorizontal!),
                      Text(
                        restaurant.type == 'GRCR'
                            ? duration
                            : restaurant.type == 'RSTR'
                                ? S().distance(distance)
                                : restaurant.type == 'DINE'
                                    ? S().distance(distance)
                                    : '',
                        //S().distance(distance),
                        //'$distance k',
                        textScaleFactor: 1.0,
                        style: distanceText,
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: 2 * SizeConfig.blockSizeHorizontal!,
                          vertical: SizeConfig.blockSizeVertical!),
                      height: 4 * SizeConfig.blockSizeVertical!,
                      width: 22 * SizeConfig.blockSizeHorizontal!,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.brightness_1,
                            size: 4 * SizeConfig.blockSizeHorizontal!,
                            color: primaryColor,
                          ),
                          const Text(
                            ' Opened',
                            textScaleFactor: 1.0,
                            style: ratingTextBlack,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: 2 * SizeConfig.blockSizeHorizontal!,
                          vertical: SizeConfig.blockSizeVertical!),
                      decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius: BorderRadius.circular(3.0),
                      ),
                      height: 4 * SizeConfig.blockSizeVertical!,
                      width: 16 * SizeConfig.blockSizeHorizontal!,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Icon(
                            Icons.star,
                            color: orangeColor,
                          ),
                          Text(
                            restaurant.rating,
                            //'4.5',
                            textScaleFactor: 1.0,
                            style: ratingTextBlack,
                          ),
                        ],
                      ),
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
