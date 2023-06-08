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
  PickResult? addressSelectedPlace;
  Location? currentLocation;

  String? searchInput;
  String? sortBy;
  String selectedRegion;
  String selectedRegionType;
  bool isDelivery;

  int bottomNavigationIndex;
  Function callbackBottomNavigationBar;

  Function callbackFilters;
  Function callbackRestriction;

  AllCoffee(
      {Key? key,
      this.addressSelectedPlace,
      this.currentLocation,
      this.searchInput,
      this.sortBy,
      required this.isDelivery,
      required this.bottomNavigationIndex,
      required this.callbackBottomNavigationBar,
      required this.selectedRegion,
      required this.selectedRegionType,
      required this.callbackFilters,
      required this.callbackRestriction})
      : super(key: key);

  @override
  AllCoffeeState createState() => AllCoffeeState();
}

class AllCoffeeState extends State<AllCoffee> {
  late StreamController _streamController;
  late Stream _stream;
  bool isLoading = false;

  String duration = '';
  GeoCode geoCode = GeoCode();

  @override
  void initState() {
    super.initState();
    _streamController = StreamController.broadcast();
    _stream = _streamController.stream;
    Future.delayed(Duration.zero, getDataFromProvider);
    //getDummyData();
  }

  callBackDistance(double dis, String? dur) {
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
    String restaurantType = '';
    if (widget.isDelivery == true) {
      restaurantType = 'delivery';
    }

    if (widget.searchInput != null) {
      _streamController.add(await Provider.of<AllFiltersProvider>(context,
              listen: false)
          .searchRestaurant(widget.searchInput!, userToken, restaurantType));
    } else if (widget.sortBy != null) {
      if (widget.sortBy == 'distance') {
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
                            widget.currentLocation!.latitude,
                            widget.currentLocation!.longitude,
                            restaurantType))
            : _streamController.add(await Provider.of<AllFiltersProvider>(context, listen: false)
                .sortRestaurantByDistance(
                    userToken,
                    widget.addressSelectedPlace!.geometry!.location.lat,
                    widget.addressSelectedPlace!.geometry!.location.lng,
                    restaurantType));
      } else {
        _streamController.add(
            await Provider.of<AllFiltersProvider>(context, listen: false)
                .sortRestaurantBy(userToken, widget.sortBy!, restaurantType));
      }
    } else if (widget.selectedRegion != 'no region' &&
        widget.selectedRegion != null) {
      if (widget.selectedRegionType != 'location') {
        _streamController.add(
            await Provider.of<AllFiltersProvider>(context, listen: false)
                .showRestaurantByLocation(userToken, widget.selectedRegion,
                    widget.selectedRegionType, restaurantType));
      } else {
        if (widget.addressSelectedPlace != null) {
          _streamController.add(await Provider.of<AllFiltersProvider>(context,
                  listen: false)
              .showRestaurantByLocation(
                  userToken,
                  widget.addressSelectedPlace!.addressComponents![3].longName,
                  'town',
                  restaurantType));
        } else if (widget.currentLocation != null) {
          var address = await geoCode.reverseGeocoding(
              latitude: widget.currentLocation!.latitude,
              longitude: widget.currentLocation!.longitude);
          _streamController.add(
              await Provider.of<AllFiltersProvider>(context, listen: false)
                  .showRestaurantByLocation(
                      userToken, address.city!, 'town', restaurantType));
        }
      }
    } else {
      _streamController.add(
          await Provider.of<AllFiltersProvider>(context, listen: false)
              .loadData(userToken, restaurantType));
    }
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, getDataFromProvider);

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (!isLoading &&
            scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          setState(() {
            isLoading = true;
          });
        } else if (scrollInfo.metrics.pixels !=
            scrollInfo.metrics.maxScrollExtent) {
          isLoading = false;
        }
        return isLoading;
      },
      child: StreamBuilder(
          stream: _stream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: 9 * SizeConfig.blockSizeVertical!,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 3 * SizeConfig.blockSizeHorizontal!,
                            vertical: SizeConfig.blockSizeVertical!,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('All Coffee Products',
                                  style: groceryLabels),
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
                            physics: const ScrollPhysics(),
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
                                              widget.currentLocation!,
                                          callbackFun: callBackDistance,
                                          seeAllCoffee: true,
                                        )
                                  : CoffeeCard(
                                      restaurant: snapshot.data[index],
                                      isDelivery: widget.isDelivery,
                                      addressSelectedPlace:
                                          widget.addressSelectedPlace!,
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
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
