import 'package:flutter/material.dart';
import 'package:flutter_sliding_up_panel/flutter_sliding_up_panel.dart';
import 'package:foodCourier/controllers/size_config.dart';
import 'package:foodCourier/models/meal.dart';
import 'package:foodCourier/constants/colors.dart';
import 'package:foodCourier/constants/text_styles.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:foodCourier/generated/l10n.dart';
import 'package:foodCourier/widgets/meal_screen_widgets/meal_cover_photo.dart';
import 'package:foodCourier/widgets/meal_screen_widgets/meal_profile.dart';
import 'package:foodCourier/widgets/meal_screen_widgets/meal_description.dart';
import 'package:foodCourier/widgets/meal_screen_widgets/meal_reviews.dart';

class MealScreen extends StatefulWidget {
  @override
  MealScreenState createState() => MealScreenState();
}

class MealScreenState extends State<MealScreen> {
  bool isFavorite = false;

  int selectedIndexOfBottomBar = 0;
  bool gotIndexFromNavigationBar = false;
  late Function callbackNavigationBottomBar;

  int tabBarIndex = 0;
  SlidingUpPanelController panelController = SlidingUpPanelController();

  void _onItemTapped(int index) {
    setState(() {
      selectedIndexOfBottomBar = index;
    });
    Navigator.pop(context);
    Navigator.pop(context);
    callbackNavigationBottomBar(index);
  }

  @override
  Widget build(BuildContext context) {
    List defaults = ModalRoute.of(context)!.settings.arguments as List;
    Meal meal = defaults[0];
    String restaurantLogoUrl = defaults[3];
    int restaurantID = defaults[4];
    if (!gotIndexFromNavigationBar) {
      selectedIndexOfBottomBar = defaults[1];
      callbackNavigationBottomBar = defaults[2];
      gotIndexFromNavigationBar = !gotIndexFromNavigationBar;
    }

    if (meal != null) {
      SizeConfig().init(context);
      return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: whiteColor,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              activeIcon: Image.asset('assets/icons/delivery.png',
                  width: 8 * SizeConfig.blockSizeHorizontal!),
              icon: Image.asset('assets/icons/delivery.png',
                  color: lightTextColor,
                  width: 8 * SizeConfig.blockSizeHorizontal!),
              //icon: Icon(Icons.delivery_dining),
              label: S().delivery,
              //'Delivery',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.local_grocery_store),
              label: S().grocery,
              //'Grocery',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.room_service),
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
            MealCoverPhoto(photoUrl: meal.photoUrls[0]),
            SlidingUpPanelWidget(
              panelController: panelController,
              anchor: 0.67,
              controlHeight: 100 * SizeConfig.blockSizeVertical!,
              /*borderRadius: BorderRadius.vertical(
                top: Radius.circular(18.0),
              ),
              minHeight: 67 * SizeConfig.blockSizeVertical!,
              maxHeight: 100 * SizeConfig.blockSizeVertical!,*/
              child: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(25.0),
                      ),
                    ),
                    child: MealProfile(meal, restaurantLogoUrl),
                  ),
                  Padding(
                    //was 49
                    padding: meal.labelNames.isNotEmpty
                        ? EdgeInsets.only(
                            top: 45 * SizeConfig.blockSizeVertical!)
                        : EdgeInsets.only(
                            top: 37 * SizeConfig.blockSizeVertical!),
                    child: DefaultTabController(
                      length: 2,
                      child: Column(
                        children: <Widget>[
                          Container(
                            decoration: const BoxDecoration(
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
                            height: 7 * SizeConfig.blockSizeVertical!,
                            child: TabBar(
                              tabs: [
                                const Tab(
                                  child: AutoSizeText(
                                    'Description',
                                    maxLines: 1,
                                    style: restaurantBarText,
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
                              onTap: (index) {
                                setState(() {
                                  tabBarIndex = index;
                                });
                              },
                              isScrollable: false,
                              indicatorColor: orangeColor,
                              indicatorWeight: 4,
                              indicatorPadding: EdgeInsets.symmetric(
                                  horizontal:
                                      3 * SizeConfig.blockSizeHorizontal!),
                              labelPadding: EdgeInsets.symmetric(
                                  horizontal:
                                      3 * SizeConfig.blockSizeHorizontal!),
                            ),
                          ),
                          Expanded(
                            child: TabBarView(
                              children: <Widget>[
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
                    // was 45
                    minChildSize: meal.labelNames.isNotEmpty ? 0.525 : 0.595,
                    initialChildSize:
                        meal.labelNames.isNotEmpty ? 0.525 : 0.595,
                    maxChildSize: 1.0,
                    expand: true,
                    builder: (_, scrollController) => ListView(
                      controller: scrollController,
                      children: [
                        Container(
                          height: 95 * SizeConfig.blockSizeVertical!,
                          padding: EdgeInsets.symmetric(
                            vertical: 1 * SizeConfig.blockSizeVertical!,
                            horizontal: 4 * SizeConfig.blockSizeHorizontal!,
                          ),
                          width: double.infinity,
                          color: whiteColor,
                          child: tabBarIndex == 0
                              ? MealDescription(scrollController, meal.name)
                              : MealReview(scrollController, meal.name),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}
