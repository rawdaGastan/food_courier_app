import 'package:flutter/material.dart';
import 'package:geocode/geocode.dart';

import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:provider/provider.dart';
import 'package:foodCourier/providers/filters_api_provider.dart';
import 'package:foodCourier/providers/authentication_provider.dart';
import 'package:foodCourier/controllers/location.dart';
import 'dart:async';

import 'package:foodCourier/widgets/home_screen_widgets/restaurant_card.dart';

// ignore: must_be_immutable
class RestaurantsMenu extends StatefulWidget {
  final PickResult? addressSelectedPlace;
  final Location? currentLocation;

  final String? searchInput;
  final String? sortBy;
  final String? selectedRegion;
  final String? selectedRegionType;
  final String restaurantType;
  final bool isDelivery;
  final bool isDineOut;

  final int bottomNavigationIndex;
  final Function callbackBottomNavigationBar;

  final Function callbackFilters;
  final Function callbackRestriction;

  bool bottomBarTapped;

  RestaurantsMenu(
      {Key? key,
      this.addressSelectedPlace,
      this.currentLocation,
      this.searchInput,
      this.sortBy,
      required this.restaurantType,
      this.isDelivery = false,
      required this.bottomNavigationIndex,
      required this.callbackBottomNavigationBar,
      this.isDineOut = false,
      this.selectedRegion,
      this.selectedRegionType,
      required this.callbackFilters,
      required this.callbackRestriction,
      required this.bottomBarTapped})
      : super(key: key);

  @override
  RestaurantsMenuState createState() => RestaurantsMenuState();
}

class RestaurantsMenuState extends State<RestaurantsMenu> {
  final ScrollController _controller = ScrollController();

  late StreamController _streamController;
  late Stream _stream;
  bool isLoading = false;

  double distance = 0.0;
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

  callBackDistance(double? dis, String? dur) {
    if (dis != null) {
      distance = dis;
      /* setState(() {
      distance = dis;
    });*/
    }
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
    if (widget.isDelivery) {
      restaurantType = 'delivery';
    } else if (widget.isDineOut) {
      restaurantType = 'dine_out';
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
                .showRestaurantByLocation(userToken, widget.selectedRegion!,
                    widget.selectedRegionType!, restaurantType));
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

    if (widget.bottomBarTapped) {
      _controller.animateTo(0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.fastOutSlowIn);
    }

    widget.bottomBarTapped = false;

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
              return Column(
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                      controller: _controller,
                      itemBuilder: (_, index) => GestureDetector(
                        onTap: () => Navigator.pushNamed(context, 'restaurant',
                            arguments: [
                              snapshot.data[index],
                              distance,
                              duration,
                              widget.bottomNavigationIndex,
                              widget.callbackBottomNavigationBar,
                              widget.callbackRestriction,
                              widget.callbackFilters
                            ]),
                        child: widget.addressSelectedPlace == null
                            ? widget.currentLocation == null
                                ? RestaurantCard(
                                    restaurant: snapshot.data[index],
                                    restaurantType: widget.restaurantType,
                                    isDelivery: widget.isDelivery,
                                    isDineOut: widget.isDineOut,
                                    callbackFun: callBackDistance,
                                  )
                                : RestaurantCard(
                                    restaurant: snapshot.data[index],
                                    restaurantType: widget.restaurantType,
                                    isDelivery: widget.isDelivery,
                                    isDineOut: widget.isDineOut,
                                    currentLocation: widget.currentLocation,
                                    callbackFun: callBackDistance)
                            : RestaurantCard(
                                restaurant: snapshot.data[index],
                                restaurantType: widget.restaurantType,
                                isDelivery: widget.isDelivery,
                                isDineOut: widget.isDineOut,
                                addressSelectedPlace:
                                    widget.addressSelectedPlace,
                                callbackFun: callBackDistance,
                              ),
                      ),
                      itemCount: snapshot.data.length,
                    ),
                  ),
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
