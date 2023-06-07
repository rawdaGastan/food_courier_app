import 'package:flutter/material.dart';
import 'package:geocode/geocode.dart';

import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:provider/provider.dart';
import 'package:foodCourier/constants/colors.dart';
import 'package:foodCourier/constants/text_styles.dart';
import 'package:foodCourier/controllers/size_config.dart';
import 'package:foodCourier/providers/filters_api_provider.dart';
import 'package:foodCourier/providers/authentication_provider.dart';
import 'package:foodCourier/widgets/grocery_widgets/coffee_card.dart';
import 'package:foodCourier/widgets/grocery_widgets/grocery_tab_bar.dart';
import 'package:foodCourier/controllers/location.dart';
import 'dart:async';

class AllCoffee extends StatefulWidget {
  final PickResult addressSelectedPlace;
  final Location currentLocation;

  final String searchInput;
  final String sortBy;
  final String selectedRegion;
  final String selectedRegionType;
  final bool isDelivery;

  final int bottomNavigationIndex;
  final Function callbackBottomNavigationBar;

  final Function callbackFilters;
  final Function callbackRestriction;

  AllCoffee(
      {this.addressSelectedPlace,
      this.currentLocation,
      this.searchInput,
      this.sortBy,
      this.isDelivery,
      this.bottomNavigationIndex,
      this.callbackBottomNavigationBar,
      this.selectedRegion,
      this.selectedRegionType,
      this.callbackFilters,
      this.callbackRestriction});

  @override
  _State createState() => _State();
}

class _State extends State<AllCoffee> {
  StreamController _streamController;
  Stream _stream;
  bool isLoading = false;

  String duration;
  GeoCode geoCode = GeoCode();

  @override
  void initState() {
    super.initState();
    _streamController = StreamController.broadcast();
    _stream = _streamController.stream;
    Future.delayed(Duration.zero, this.getDataFromProvider);
    //getDummyData();
  }

  callBackDistance(double dis, String dur) {
    if (dur != null) {
      duration = dur;
      /* setState(() {
      duration = dur;
    });*/
    }
  }

  getDataFromProvider() async {
    String userToken =
        await Provider.of<AuthenticationProvider>(context, listen: false)
            .userToken;

    //delivery, grocery or dine out
    String restaurantType;
    if (widget.isDelivery != null && widget.isDelivery)
      restaurantType = 'delivery';

    print(restaurantType);

    if (userToken != null) {
      if (widget.searchInput != null) {
        _streamController.add(await Provider.of<AllFiltersProvider>(context,
                listen: false)
            .searchRestaurant(widget.searchInput, userToken, restaurantType));
      } else if (widget.sortBy != null) {
        if (widget.sortBy == 'distance')
          widget.addressSelectedPlace == null
              ? widget.currentLocation == null
                  ? _streamController.add(
                      await Provider.of<AllFiltersProvider>(context, listen: false)
                          .sortRestaurantByDistance(
                              userToken, 0, 0, restaurantType))
                  : _streamController.add(
                      await Provider.of<AllFiltersProvider>(context, listen: false)
                          .sortRestaurantByDistance(
                              userToken,
                              widget.currentLocation.latitude,
                              widget.currentLocation.longitude,
                              restaurantType))
              : _streamController.add(await Provider.of<AllFiltersProvider>(context, listen: false)
                  .sortRestaurantByDistance(
                      userToken,
                      widget.addressSelectedPlace.geometry.location.lat,
                      widget.addressSelectedPlace.geometry.location.lng,
                      restaurantType));
        else
          _streamController.add(
              await Provider.of<AllFiltersProvider>(context, listen: false)
                  .sortRestaurantBy(userToken, widget.sortBy, restaurantType));
      } else if (widget.selectedRegion != 'no region' &&
          widget.selectedRegion != null) {
        if (widget.selectedRegionType != 'location')
          _streamController.add(
              await Provider.of<AllFiltersProvider>(context, listen: false)
                  .showRestaurantByLocation(userToken, widget.selectedRegion,
                      widget.selectedRegionType, restaurantType));
        else {
          if (widget.addressSelectedPlace != null) {
            _streamController.add(await Provider.of<AllFiltersProvider>(context,
                    listen: false)
                .showRestaurantByLocation(
                    userToken,
                    widget.addressSelectedPlace.addressComponents[3].longName,
                    'town',
                    restaurantType));
          } else if (widget.currentLocation != null) {
            var address = await geoCode.reverseGeocoding(
                latitude: widget.currentLocation.latitude,
                longitude: widget.currentLocation.longitude);
            _streamController.add(
                await Provider.of<AllFiltersProvider>(context, listen: false)
                    .showRestaurantByLocation(
                        userToken, address.city, 'town', restaurantType));
          }
        }
      } else {
        _streamController.add(
            await Provider.of<AllFiltersProvider>(context, listen: false)
                .loadData(userToken, restaurantType));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print('reload data');
    Future.delayed(Duration.zero, this.getDataFromProvider);

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (!isLoading &&
            scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          setState(() {
            this.isLoading = true;
          });
        } else if (scrollInfo.metrics.pixels !=
            scrollInfo.metrics.maxScrollExtent) this.isLoading = false;
        return;
      },
      child: StreamBuilder(
          stream: _stream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: 9 * SizeConfig.blockSizeVertical,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 3 * SizeConfig.blockSizeHorizontal,
                            vertical: SizeConfig.blockSizeVertical,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('All Coffee Products', style: groceryLabels),
                              Text(
                                '(${snapshot.data.length} items)',
                                style: grocerySeeAll.copyWith(
                                    color: greyTextColor87),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: GridView.builder(
                            itemCount: snapshot.data.length,
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: MediaQuery.of(context)
                                      .size
                                      .width /
                                  (MediaQuery.of(context).size.height / 1.18),
                            ),
                            itemBuilder: (_, index) => GestureDetector(
                              onTap: () => Navigator.pushNamed(
                                  context, 'restaurant',
                                  arguments: [
                                    snapshot.data[index],
                                    0,
                                    duration,
                                    widget.bottomNavigationIndex,
                                    widget.callbackBottomNavigationBar,
                                    widget.callbackRestriction,
                                    widget.callbackFilters
                                  ]),
                              child: widget.addressSelectedPlace == null
                                  ? widget.currentLocation == null
                                      ? CoffeeCard(
                                          restaurant: snapshot.data[index],
                                          isDelivery: widget.isDelivery,
                                          callbackFun: callBackDistance,
                                          seeAllCoffee: true,
                                        )
                                      : CoffeeCard(
                                          restaurant: snapshot.data[index],
                                          isDelivery: widget.isDelivery,
                                          currentLocation:
                                              widget.currentLocation,
                                          callbackFun: callBackDistance,
                                          seeAllCoffee: true,
                                        )
                                  : CoffeeCard(
                                      restaurant: snapshot.data[index],
                                      isDelivery: widget.isDelivery,
                                      addressSelectedPlace:
                                          widget.addressSelectedPlace,
                                      callbackFun: callBackDistance,
                                      seeAllCoffee: true,
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GroceryTabBar(),
                ],
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
