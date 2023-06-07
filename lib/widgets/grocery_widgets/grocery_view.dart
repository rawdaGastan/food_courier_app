import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocode/geocode.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:provider/provider.dart';
import 'package:foodCourier/constants/text_styles.dart';
import 'package:foodCourier/controllers/location.dart';
import 'package:foodCourier/controllers/size_config.dart';
import 'package:foodCourier/providers/authentication_provider.dart';
import 'package:foodCourier/providers/filters_api_provider.dart';
import 'package:foodCourier/widgets/grocery_widgets/stores.dart';
import 'package:foodCourier/widgets/grocery_widgets/offers.dart';
import 'package:foodCourier/widgets/grocery_widgets/coffee.dart';

class GroceryView extends StatefulWidget {
  final PickResult addressSelectedPlace;
  final Location currentLocation;

  final String searchInput;
  final String sortBy;
  final String selectedRegion;
  final String selectedRegionType;
  final String restaurantType;
  final bool isDelivery;

  final int bottomNavigationIndex;
  final Function callbackBottomNavigationBar;

  final Function callbackFilters;
  final Function callbackRestriction;

  GroceryView(
      {this.addressSelectedPlace,
      this.currentLocation,
      this.searchInput,
      this.sortBy,
      this.restaurantType,
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

class _State extends State<GroceryView> {
  StreamController _streamController;
  Stream _stream;

  double distance;
  String duration;
  GeoCode geoCode = GeoCode();

  @override
  void initState() {
    super.initState();
    _streamController = StreamController.broadcast();
    _stream = _streamController.stream;
    Future.delayed(Duration.zero, this.getDataFromProvider);
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

  callBackDistance(double dis, String dur) {
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

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: StreamBuilder(
          stream: _stream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 2 * SizeConfig.blockSizeHorizontal,
                      vertical: SizeConfig.blockSizeVertical,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Stores',
                          style: groceryLabels,
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(
                              context, 'grocery see all', arguments: [
                            widget.bottomNavigationIndex,
                            widget.callbackBottomNavigationBar,
                            'Stores'
                          ]),
                          child: Text(
                            'See All',
                            style: grocerySeeAll,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Stores(
                    currentLocation: widget.currentLocation,
                    addressSelectedPlace: widget.addressSelectedPlace,
                    searchInput: widget.searchInput,
                    sortBy: widget.sortBy,
                    selectedRegion: widget.selectedRegion,
                    selectedRegionType: widget.selectedRegionType,
                    isDelivery: true,
                    restaurantType: 'GRCR',
                    bottomNavigationIndex: widget.bottomNavigationIndex,
                    callbackBottomNavigationBar:
                        widget.callbackBottomNavigationBar,
                    callbackFilters: widget.callbackFilters,
                    callbackRestriction: widget.callbackRestriction,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 2 * SizeConfig.blockSizeHorizontal,
                      vertical: SizeConfig.blockSizeVertical,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Offers',
                          style: groceryLabels,
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(
                              context, 'grocery see all', arguments: [
                            widget.bottomNavigationIndex,
                            widget.callbackBottomNavigationBar,
                            'Offers'
                          ]),
                          child: Text(
                            'See All',
                            style: grocerySeeAll,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Offers(
                    currentLocation: widget.currentLocation,
                    addressSelectedPlace: widget.addressSelectedPlace,
                    searchInput: widget.searchInput,
                    sortBy: widget.sortBy,
                    selectedRegion: widget.selectedRegion,
                    selectedRegionType: widget.selectedRegionType,
                    isDelivery: true,
                    restaurantType: 'GRCR',
                    bottomNavigationIndex: widget.bottomNavigationIndex,
                    callbackBottomNavigationBar:
                        widget.callbackBottomNavigationBar,
                    callbackFilters: widget.callbackFilters,
                    callbackRestriction: widget.callbackRestriction,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 2 * SizeConfig.blockSizeHorizontal,
                      vertical: SizeConfig.blockSizeVertical,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Coffee',
                          style: groceryLabels,
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(
                              context, 'grocery see all', arguments: [
                            widget.bottomNavigationIndex,
                            widget.callbackBottomNavigationBar,
                            'Coffee'
                          ]),
                          child: Text(
                            'See All',
                            style: grocerySeeAll,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Coffee(
                    currentLocation: widget.currentLocation,
                    addressSelectedPlace: widget.addressSelectedPlace,
                    searchInput: widget.searchInput,
                    sortBy: widget.sortBy,
                    selectedRegion: widget.selectedRegion,
                    selectedRegionType: widget.selectedRegionType,
                    isDelivery: true,
                    restaurantType: 'GRCR',
                    bottomNavigationIndex: widget.bottomNavigationIndex,
                    callbackBottomNavigationBar:
                        widget.callbackBottomNavigationBar,
                    callbackFilters: widget.callbackFilters,
                    callbackRestriction: widget.callbackRestriction,
                  ),
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
