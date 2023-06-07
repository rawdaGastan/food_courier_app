import 'package:flutter/material.dart';
import 'package:flutter_sliding_up_panel/flutter_sliding_up_panel.dart';
import 'package:foodCourier/controllers/size_config.dart';
import 'package:foodCourier/widgets/restaurant_screen_widgets/inside_menu_tab.dart';
import 'package:foodCourier/widgets/restaurant_screen_widgets/restaurant_cover_photo_list.dart';
import 'package:foodCourier/widgets/restaurant_screen_widgets/restaurant_profile.dart';
import 'package:foodCourier/models/restaurant.dart';
import 'package:foodCourier/constants/colors.dart';
import 'package:foodCourier/constants/text_styles.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:foodCourier/generated/l10n.dart';
import 'package:foodCourier/widgets/go_to_cart_button.dart';
import 'package:foodCourier/widgets/home_screen_widgets/filter_bottom_sheet.dart';

class RestaurantScreen extends StatefulWidget {
  @override
  _RestaurantScreenState createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  bool isFavourite = false;
  int selectedIndexOfBottomBar;
  bool gotIndexFromNavigationBar = false;
  Function callbackNavigationBottomBar;

  Function callbackFilters;
  Function callbackRestriction;

  SlidingUpPanelController panelController = SlidingUpPanelController();

  void _onItemTapped(int index) {
    setState(() {
      selectedIndexOfBottomBar = index;
    });
    Navigator.pop(context);
    callbackNavigationBottomBar(index);
  }

  @override
  Widget build(BuildContext context) {
    List defaults = ModalRoute.of(context).settings.arguments;
    Restaurant restaurant = defaults[0];
    double distance = defaults[1];
    String duration = defaults[2];
    if (!gotIndexFromNavigationBar) {
      selectedIndexOfBottomBar = defaults[3];
      callbackNavigationBottomBar = defaults[4];
      gotIndexFromNavigationBar = !gotIndexFromNavigationBar;
    }
    callbackFilters = defaults[6];
    callbackRestriction = defaults[5];

    if (restaurant != null) {
      SizeConfig().init(context);
      return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Image(
            image: AssetImage('assets/icons/filter.png'),
            color: whiteColor,
            width: 7 * SizeConfig.blockSizeHorizontal,
          ),
          backgroundColor: primaryColor,
          onPressed: () {
            filterBottomSheet(context, callbackFilters, callbackRestriction);
          },
          //Navigator.pushNamed(context, 'filter'),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: whiteColor,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              activeIcon: Image.asset(
                'assets/icons/delivery.png',
                width: 8 * SizeConfig.blockSizeHorizontal,
              ),
              icon: Image.asset(
                'assets/icons/delivery.png',
                color: lightTextColor,
                width: 8 * SizeConfig.blockSizeHorizontal,
              ),
              //icon: Icon(Icons.delivery_dining),
              label: S().delivery,
              //'Delivery',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_grocery_store),
              label: S().grocery,
              //'Grocery',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.room_service),
              label: S().dineOut,
              //'Dineout',
            ),
          ],
          currentIndex: selectedIndexOfBottomBar,
          selectedItemColor: primaryColor,
          unselectedItemColor: lightTextColor,
          onTap: _onItemTapped,
        ),
        body: Stack(
          children: <Widget>[
            CoverPhotoList(photoUrls: restaurant.photoUrls),
            SlidingUpPanelWidget(
              panelController: panelController,
              /*decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(18.0),
                  ),
                ),
              ),*/
              anchor: 0.67,
              controlHeight: 100 * SizeConfig.blockSizeVertical,
              //minHeight: 67 * SizeConfig.blockSizeVertical,
              //maxHeight: 100 * SizeConfig.blockSizeVertical,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(18.0),
                      ),
                    ),
                    child: RestaurantProfile(distance, duration, restaurant),
                  ),
                  Padding(
                    padding: restaurant.labelNames.length > 0
                        ? EdgeInsets.only(
                            top: 24 * SizeConfig.blockSizeVertical)
                        : EdgeInsets.only(
                            top: 17 * SizeConfig.blockSizeVertical),
                    child: DefaultTabController(
                      length: 3,
                      child: Column(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              color: whiteColor,
                              boxShadow: [
                                BoxShadow(
                                  color: secondaryColor,
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(
                                      0, 2), // changes position of shadow
                                ),
                              ],
                            ),
                            height: 7 * SizeConfig.blockSizeVertical,
                            child: TabBar(
                              tabs: [
                                Tab(
                                  child: AutoSizeText(
                                    S().menu,
                                    maxLines: 1,
                                    style: restaurantBarText,
                                  ),
                                ),
                                Tab(
                                  child: AutoSizeText(
                                    S().restaurantInfo,
                                    maxLines: 1,
                                    style: restaurantBarText,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Tab(
                                  child: AutoSizeText(
                                    S().reviews,
                                    maxLines: 1,
                                    style: restaurantBarText,
                                  ),
                                ),
                              ],
                              isScrollable: false,
                              indicatorColor: primaryColor,
                              indicatorWeight: 4,
                              labelPadding: EdgeInsets.symmetric(
                                  horizontal:
                                      3 * SizeConfig.blockSizeHorizontal),
                            ),
                          ),
                          Expanded(
                            child: TabBarView(
                              children: <Widget>[
                                Container(),
                                Container(),
                                Container(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  DraggableScrollableSheet(
                    minChildSize: restaurant.labelNames.length > 0 ? 0.73 : 0.8,
                    initialChildSize:
                        restaurant.labelNames.length > 0 ? 0.73 : 0.8,
                    maxChildSize: 1.0,
                    expand: true,
                    builder: (_, scrollController) => ListView(
                      controller: scrollController,
                      children: [
                        Container(
                          height: 95 * SizeConfig.blockSizeVertical,
                          width: double.infinity,
                          color: whiteColor,
                          child: RestaurantInsideMenu(
                              scrollController,
                              restaurant.name,
                              selectedIndexOfBottomBar,
                              callbackNavigationBottomBar,
                              restaurant.logoUrl,
                              restaurant.id),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            GoToCartButton(),
          ],
        ),
      );
    } else
      return Container();
  }
}
