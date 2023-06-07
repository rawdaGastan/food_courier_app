import 'package:flutter/material.dart';
import 'package:foodCourier/constants/text_styles.dart';
import 'package:foodCourier/constants/colors.dart';
import 'package:foodCourier/controllers/size_config.dart';
import 'package:foodCourier/generated/l10n.dart';
import 'package:foodCourier/main.dart';

class DrawerContents extends StatelessWidget {
  final int bottomNavigationIndex;
  final Function callbackBottomNavigationBar;

  DrawerContents(
      {this.bottomNavigationIndex, this.callbackBottomNavigationBar});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 4 * SizeConfig.blockSizeVertical,
        horizontal: 4 * SizeConfig.blockSizeVertical,
      ),
      color: secondaryColor,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: EdgeInsets.only(
                  bottom: 2 * SizeConfig.blockSizeVertical,
                ),
                width: double.infinity,
                height: 4 * SizeConfig.blockSizeVertical,
                child: Text(
                  S().menu,
                  //'Menu',
                  overflow: TextOverflow.clip,
                  style: menuText,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, 'profile'),
              child: Row(
                children: <Widget>[
                  Icon(Icons.person, color: lightTextColor),
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        vertical: 2 * SizeConfig.blockSizeVertical,
                        horizontal: 2 * SizeConfig.blockSizeHorizontal,
                      ),
                      child: Text(
                        S().myProfile,
                        //'My Profile',
                        overflow: TextOverflow.clip,
                        style: blackSmallText20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, 'wish list',
                  arguments: [
                    bottomNavigationIndex,
                    callbackBottomNavigationBar
                  ]),
              child: Row(
                children: <Widget>[
                  Icon(Icons.layers, color: lightTextColor),
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        vertical: 2 * SizeConfig.blockSizeVertical,
                        horizontal: 2 * SizeConfig.blockSizeHorizontal,
                      ),
                      //height: 4 * SizeConfig.blockSizeVertical,
                      child: Text(
                        S().wishList,
                        //'Wish List',
                        overflow: TextOverflow.clip,
                        style: blackSmallText20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            foodCourier().remoteConfigService.orderingFeature
                ? GestureDetector(
                    onTap: () => Navigator.pushNamed(context, 'all orders'),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.shopping_cart, color: lightTextColor),
                        Flexible(
                          child: Container(
                            width: 27 * SizeConfig.blockSizeHorizontal,
                            margin: EdgeInsets.symmetric(
                              vertical: 2 * SizeConfig.blockSizeVertical,
                              horizontal: 2 * SizeConfig.blockSizeHorizontal,
                            ),
                            child: Stack(
                              children: [
                                Text(
                                  'My orders',
                                  overflow: TextOverflow.clip,
                                  style: blackSmallText20,
                                ),
                                Positioned(
                                  bottom: 13,
                                  right: 0,
                                  child: Stack(
                                    children: [
                                      Icon(Icons.brightness_1,
                                          size: 15.0, color: orangeColor),
                                      Positioned(
                                          top: 0.7 *
                                              SizeConfig.blockSizeHorizontal,
                                          right: 0.7 *
                                              SizeConfig.blockSizeHorizontal,
                                          child: Center(
                                            child: Text(
                                              '11',
                                              style: cartLength,
                                            ),
                                          )),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(),
            Divider(color: blackColor),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, 'feedback'),
              child: Row(
                children: <Widget>[
                  Icon(Icons.feedback, color: lightTextColor),
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        vertical: 2 * SizeConfig.blockSizeVertical,
                        horizontal: 2 * SizeConfig.blockSizeHorizontal,
                      ),
                      child: Text(
                        S().sendFeedback,
                        //'Send Feedback',
                        overflow: TextOverflow.clip,
                        style: blackSmallText20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Row(
                children: <Widget>[
                  Icon(Icons.error, color: lightTextColor),
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        vertical: 2 * SizeConfig.blockSizeVertical,
                        horizontal: 2 * SizeConfig.blockSizeHorizontal,
                      ),
                      //height: 4 * SizeConfig.blockSizeVertical,
                      child: Text(
                        S().aboutUs,
                        //'About Us',
                        overflow: TextOverflow.clip,
                        style: blackSmallText20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Row(
                children: <Widget>[
                  Icon(Icons.live_help, color: lightTextColor),
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        vertical: 2 * SizeConfig.blockSizeVertical,
                        horizontal: 2 * SizeConfig.blockSizeHorizontal,
                      ),
                      //height: 4 * SizeConfig.blockSizeVertical,
                      child: Text(
                        S().howItWorks,
                        //'How it Works',
                        overflow: TextOverflow.clip,
                        style: blackSmallText20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: blackColor),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, 'languages'),
              child: Row(
                children: <Widget>[
                  Icon(Icons.g_translate, color: lightTextColor),
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        vertical: 2 * SizeConfig.blockSizeVertical,
                        horizontal: 2 * SizeConfig.blockSizeHorizontal,
                      ),
                      //height: 4 * SizeConfig.blockSizeVertical,
                      child: Text(
                        S().language,
                        //'Language',
                        overflow: TextOverflow.clip,
                        style: blackSmallText20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
