import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:foodCourier/constants/text_styles.dart';
import 'package:foodCourier/constants/colors.dart';
import 'package:foodCourier/controllers/size_config.dart';

class RestaurantWishList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.only(bottom: 8 * SizeConfig.blockSizeVertical!),
      itemCount: 5,
      itemBuilder: (_, index) => Container(
        margin: EdgeInsets.all(2 * SizeConfig.blockSizeHorizontal!),
        height: 23 * SizeConfig.blockSizeVertical!,
        decoration: BoxDecoration(
          color: whiteColor,
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 1.5 * SizeConfig.blockSizeVertical!),
                    child: Image.asset(
                      'assets/icons/ribbon.png',
                      scale: 1.2,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: 2 * SizeConfig.blockSizeHorizontal!,
                        vertical: 1 * SizeConfig.blockSizeVertical!),
                    decoration: BoxDecoration(
                      color: secondaryColor,
                      borderRadius: BorderRadius.circular(3.0),
                    ),
                    //height: 5 * SizeConfig.blockSizeVertical!,
                    width: 16 * SizeConfig.blockSizeHorizontal!,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.star,
                          color: orangeColor,
                        ),
                        Text(
                          //restaurant.rating,
                          '4.5',
                          textScaleFactor: 1.0,
                          style: ratingTextBlack,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 15 * SizeConfig.blockSizeHorizontal!,
                    height: 6 * SizeConfig.blockSizeVertical!,
                    decoration: BoxDecoration(
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
                          child: Icon(Icons.attach_money, color: primaryColor),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: SizeConfig.blockSizeVertical!,
                            left: 4 * SizeConfig.blockSizeHorizontal!,
                          ),
                          child:
                              Icon(Icons.attach_money, color: lightTextColor),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: SizeConfig.blockSizeVertical!,
                            left: 7 * SizeConfig.blockSizeHorizontal!,
                          ),
                          child:
                              Icon(Icons.attach_money, color: lightTextColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: <Widget>[
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal!),
                      child: CircleAvatar(
                        radius: 4 * SizeConfig.blockSizeVertical!,
                        backgroundImage: AssetImage(
                          'assets/icons/temp.png',
                        ),
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
                            'Restaurants name',
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
                                WidgetSpan(
                                  child: Icon(Icons.location_on,
                                      color: primaryColor, size: 20),
                                ),
                                TextSpan(
                                  text: 'Gaza Alremal Street ',
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
                Container(
                  margin: EdgeInsets.only(
                      left: 4 * SizeConfig.blockSizeHorizontal!,
                      right: 4 * SizeConfig.blockSizeHorizontal!),
                  child: AutoSizeText(
                    'is simply dummy text of the printing and typesetting industry.',
                    style: restaurantDescription,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 4,
                  ),
                ),
                SizedBox(
                  height: 7 * SizeConfig.blockSizeVertical!,
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(
                        vertical: SizeConfig.blockSizeVertical!,
                        horizontal: 2 * SizeConfig.blockSizeHorizontal!),
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: 2,
                    //widget.restaurant.labelNames.length,
                    itemBuilder: (_, index) => Container(
                      margin:
                          EdgeInsets.only(right: SizeConfig.blockSizeVertical!),
                      height: 5 * SizeConfig.blockSizeVertical!,
                      width: 28 * SizeConfig.blockSizeHorizontal!,
                      decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Center(
                        child: AutoSizeText(
                          'label',
                          //S().labels(widget.restaurant.labelNames[index]),
                          style: restaurantLabels,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
