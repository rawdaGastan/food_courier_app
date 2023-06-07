import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:foodCourier/constants/text_styles.dart';
import 'package:foodCourier/constants/colors.dart';
import 'package:foodCourier/controllers/size_config.dart';
import 'package:foodCourier/models/meal.dart';
import 'package:foodCourier/providers/authentication_provider.dart';
import 'package:foodCourier/providers/meals_provider.dart';
import 'package:foodCourier/widgets/restaurant_screen_widgets/add_item.dart';
import '../../main.dart';

class MealCard extends StatefulWidget {
  final Meal meal;
  final int selectedIndexOfBottomBar;
  final Function callbackNavigationBottomBar;
  final String restaurantLogoUrl;
  final int restaurantID;
  MealCard(
      {this.meal,
      this.selectedIndexOfBottomBar,
      this.callbackNavigationBottomBar,
      this.restaurantLogoUrl,
      this.restaurantID});

  @override
  _MealCardState createState() => _MealCardState();
}

class _MealCardState extends State<MealCard> {
  StreamController _streamController;
  Stream _stream;

  @override
  void initState() {
    super.initState();
    _streamController = StreamController.broadcast();
    _stream = _streamController.stream;
    Future.delayed(Duration.zero, this.getCurrentMeal);
  }

  getCurrentMeal() async {
    String userToken =
        await Provider.of<AuthenticationProvider>(context, listen: false)
            .userToken;
    if (userToken != null) {
      _streamController.add(
          await Provider.of<MealsProvider>(context, listen: false)
              .getSpecificMeal(widget.meal.id, userToken));
    }
  }

  String getPrice(Map<int, List<dynamic>> supplierPrices, int supplierID) {
    int price;
    for (int i = 0; i < supplierPrices.length; i++) {
      if (supplierPrices.values.elementAt(i)[0] == supplierID)
        price = supplierPrices.values.elementAt(i)[1];
    }
    print('priceeeeeeeeeeeeeeeeee $supplierID');
    return price.toString();
  }

  int getProductID(Map<int, List<dynamic>> supplierPrices, int supplierID) {
    int product;
    for (int i = 0; i < supplierPrices.length; i++) {
      if (supplierPrices.values.elementAt(i)[0] == 1)
        product = supplierPrices.keys.elementAt(i);
    }
    return product;
  }

  displayDialog(context, text) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Container(
            height: 20 * SizeConfig.blockSizeVertical,
            child: Column(
              children: [
                Icon(
                  Icons.warning,
                  color: orangeColor,
                  size: 8 * SizeConfig.blockSizeVertical,
                ),
                Text(text, textAlign: TextAlign.center),
              ],
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 4 * SizeConfig.blockSizeHorizontal,
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: secondaryColor,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                        ),
                        child: Text(
                          'Combined',
                          style: blackSmallText17,
                        ),
                        onPressed: () {}),
                    SizedBox(
                      width: 5 * SizeConfig.blockSizeVertical,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                        ),
                        child: Text('New order', style: blackSmallText17),
                        onPressed: () {}),
                  ]),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(2 * SizeConfig.blockSizeHorizontal),
      height: 30 * SizeConfig.blockSizeVertical,
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: StreamBuilder(
          stream: _stream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return InkWell(
                onTap: () {
                  Navigator.pushNamed(context, 'meal', arguments: [
                    snapshot.data,
                    widget.selectedIndexOfBottomBar,
                    widget.callbackNavigationBottomBar,
                    widget.restaurantLogoUrl,
                    widget.restaurantID
                  ]);
                },
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: 2 * SizeConfig.blockSizeHorizontal,
                      ),
                      width: 30 * SizeConfig.blockSizeHorizontal,
                      decoration: BoxDecoration(
                        color: shadow,
                        borderRadius: BorderRadius.circular(8.0),
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(
                              snapshot.data.photoUrls[0]),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Column(
                        //crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 40 * SizeConfig.blockSizeHorizontal,
                                child: AutoSizeText(
                                  snapshot.data.name,
                                  style: mealName,
                                ),
                              ),
                              (foodCourier()
                                      .remoteConfigService
                                      .orderingFeature)
                                  ? IconButton(
                                      icon: Icon(
                                        Icons.add_circle,
                                        color: primaryColor,
                                      ),
                                      onPressed: () {
                                        addItemBottomSheet(
                                            context,
                                            snapshot.data,
                                            getProductID(
                                                snapshot.data.supplierPrices,
                                                widget.restaurantID));
                                        /*displayDialog(context, 'You choose from another store, you can combine the '
                          'order with an extra  fee and time or make a new order');*/
                                      },
                                    )
                                  : Container(),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 60 * SizeConfig.blockSizeHorizontal,
                                margin: EdgeInsets.only(
                                    bottom: SizeConfig.blockSizeHorizontal),
                                child: AutoSizeText(
                                  'is simply dummy text of the printing and typesetting industry.',
                                  style: RestaurantDescription,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              snapshot.data.labelNames != null
                                  ? new Expanded(
                                      child: GridView.builder(
                                        itemCount:
                                            snapshot.data.labelNames.length < 7
                                                ? snapshot
                                                    .data.labelNames.length
                                                : 6,
                                        shrinkWrap: true,
                                        physics: ScrollPhysics(),
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          childAspectRatio:
                                              MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  (MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      4),
                                        ),
                                        itemBuilder: (_, index) => Container(
                                          margin: EdgeInsets.all(
                                              SizeConfig.blockSizeHorizontal),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            color: secondaryColor,
                                          ),
                                          width: 15 *
                                              SizeConfig.blockSizeHorizontal,
                                          height:
                                              3 * SizeConfig.blockSizeVertical,
                                          child: Center(
                                            child: Text(
                                              snapshot.data.labelNames[index],
                                              style: mealLabels,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AutoSizeText(
                                getPrice(snapshot.data.supplierPrices,
                                    widget.restaurantID),
                                style: mealPrice,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        3 * SizeConfig.blockSizeHorizontal),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      child: Icon(
                                        snapshot.data.isFavourite
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: orangeColor,
                                      ),
                                      onTap: () {
                                        setState(() {
                                          snapshot.data.toggleFav();
                                        });
                                      },
                                    ),
                                    Text(snapshot.data.numberOfLikes.toString(),
                                        style: favouriteNumberMeals,
                                        textAlign: TextAlign.center),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
