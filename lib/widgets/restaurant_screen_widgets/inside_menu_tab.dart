import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:foodCourier/constants/text_styles.dart';
import 'package:foodCourier/constants/colors.dart';
import 'package:foodCourier/controllers/size_config.dart';
import 'package:foodCourier/providers/authentication_provider.dart';
import 'package:foodCourier/widgets/restaurant_screen_widgets/tag_tab.dart';
import 'meal_info.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:foodCourier/providers/meals_provider.dart';

// map of tag and index of occurrence in meals to control scroll position
Map<String, int> tags = {
  'oil free': 0,
  'whatever': 1,
  'temp': 2,
  'another': 7,
};

class RestaurantInsideMenu extends StatefulWidget {
  final ScrollController _controller;
  final String restaurantName;
  final selectedIndexOfBottomBar;
  final callbackNavigationBottomBar;
  final String restaurantLogoUrl;
  final int restaurantID;
  RestaurantInsideMenu(
      this._controller,
      this.restaurantName,
      this.selectedIndexOfBottomBar,
      this.callbackNavigationBottomBar,
      this.restaurantLogoUrl,
      this.restaurantID);

  @override
  _RestaurantInsideMenuState createState() => _RestaurantInsideMenuState();
}

class _RestaurantInsideMenuState extends State<RestaurantInsideMenu> {
  int selectedTabIndex = 0;

  StreamController _streamController;
  Stream _stream;

  @override
  void initState() {
    super.initState();
    _streamController = StreamController.broadcast();
    _stream = _streamController.stream;
    Future.delayed(Duration.zero, this.getMealsDataFromProvider);
  }

  getMealsDataFromProvider() async {
    String userToken =
        await Provider.of<AuthenticationProvider>(context, listen: false)
            .userToken;
    if (userToken != null) {
      _streamController.add(
          await Provider.of<MealsProvider>(context, listen: false)
              .loadAllMeals(widget.restaurantName, userToken));
    }
  }

  // if(scrollInfo.metrics.pixels <
  // (tags.values.elementAt(i)/meals.length) * scrollInfo.metrics.maxScrollExtent)

  // ignore: non_constant_identifier_names
  void change_selected_index_basedOn_scrollPosition(
      ScrollNotification scrollInfo) {
    double currentOffset, nextOffset, lastOffset;
    int currentIndex;

    // get index of occurrence for current scroll position
    for (int i = 0; i < tags.length - 1; i++) {
      currentOffset =
          (tags.values.elementAt(i) * 32 * SizeConfig.blockSizeVertical!) +
              (i * 4.22 * SizeConfig.blockSizeVertical!) +
              (i * 16);
      nextOffset =
          (tags.values.elementAt(i + 1) * 32 * SizeConfig.blockSizeVertical!) +
              ((i + 1) * 4.22 * SizeConfig.blockSizeVertical!) +
              ((i + 1) * 16);

      if (scrollInfo.metrics.pixels >= currentOffset &&
          scrollInfo.metrics.pixels < nextOffset) currentIndex = i;

      lastOffset = (tags.values.elementAt(tags.length - 1) *
              32 *
              SizeConfig.blockSizeVertical!) +
          ((tags.length - 1) * 4.22 * SizeConfig.blockSizeVertical!) +
          ((tags.length - 1) * 16);
      if (scrollInfo.metrics.pixels >= lastOffset)
        currentIndex = tags.length - 1;
    }

    setState(() {
      selectedTabIndex = currentIndex == null ? 0 : currentIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          change_selected_index_basedOn_scrollPosition(scrollInfo);
          return;
        },
        child: Stack(
          children: [
            ListView(
              controller: widget._controller,
              children: [
                Container(
                  padding: EdgeInsets.only(
                      bottom: 8 * SizeConfig.blockSizeVertical!),
                  //height: 70 * SizeConfig.blockSizeVertical!,
                  //height: 63 * SizeConfig.blockSizeVertical!,
                  height: 95 * SizeConfig.blockSizeVertical!,
                  child: StreamBuilder(
                      stream: _stream,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          return CustomScrollView(
                            controller: widget._controller,
                            slivers: [
                              SliverStickyHeader(
                                overlapsContent: false,
                                header: Container(
                                  //margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical!),
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          2 * SizeConfig.blockSizeHorizontal!),
                                  height: 6 * SizeConfig.blockSizeVertical!,
                                  decoration: BoxDecoration(
                                    color: secondaryColor,
                                  ),
                                  child: ListView.builder(
                                    itemCount: tags.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (_, i) => Center(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 2 *
                                                SizeConfig
                                                    .blockSizeHorizontal!),
                                        child: TagTab(
                                          tag: tags.keys.elementAt(i),
                                          isSelected: i == selectedTabIndex
                                              ? true
                                              : false,
                                          animate: () {
                                            setState(() {
                                              selectedTabIndex = i;
                                            });
                                            // 32 is the size of meal card and the 12 is profile size + tab bar size
                                            /*double index = (tags.values.elementAt(i) *
                                  32 *
                                  SizeConfig.blockSizeVertical!) +
                                  12 * SizeConfig.blockSizeVertical!;*/
                                            // 32 is the size of meal card and the 4.22 is title size + 16 of padding for title
                                            double index = (tags.values
                                                        .elementAt(i) *
                                                    32 *
                                                    SizeConfig
                                                        .blockSizeVertical) +
                                                (i *
                                                    4.22 *
                                                    SizeConfig
                                                        .blockSizeVertical) +
                                                (i * 16);
                                            widget._controller.animateTo(index,
                                                duration:
                                                    Duration(milliseconds: 500),
                                                curve: Curves.fastOutSlowIn);
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                sliver: SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                    (context, i) => (tags.containsValue(i))
                                        ? Container(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 6 *
                                                            SizeConfig
                                                                .blockSizeHorizontal,
                                                        top: 8.0,
                                                        bottom: 8.0),
                                                    child: AutoSizeText(
                                                      tags.keys.firstWhere(
                                                          (k) => tags[k] == i,
                                                          orElse: () => null),
                                                      style: mealCategoryStyle,
                                                    ),
                                                  ),
                                                ),
                                                MealCard(
                                                  meal: snapshot.data[i],
                                                  selectedIndexOfBottomBar: widget
                                                      .selectedIndexOfBottomBar,
                                                  callbackNavigationBottomBar:
                                                      widget
                                                          .callbackNavigationBottomBar,
                                                  restaurantLogoUrl:
                                                      widget.restaurantLogoUrl,
                                                  restaurantID:
                                                      widget.restaurantID,
                                                ),
                                              ],
                                            ),
                                          )
                                        : MealCard(
                                            meal: snapshot.data[i],
                                            selectedIndexOfBottomBar:
                                                widget.selectedIndexOfBottomBar,
                                            callbackNavigationBottomBar: widget
                                                .callbackNavigationBottomBar,
                                            restaurantLogoUrl:
                                                widget.restaurantLogoUrl,
                                            restaurantID: widget.restaurantID,
                                          ),
                                    childCount: snapshot.data.length,
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      }),
                )
              ],
            ),
          ],
        ));
  }
}
