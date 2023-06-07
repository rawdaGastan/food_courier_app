import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:geocode/geocode.dart';

import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:provider/provider.dart';
import 'package:foodCourier/constants/colors.dart';
import 'package:foodCourier/controllers/location.dart';
import 'package:foodCourier/controllers/size_config.dart';
import 'package:foodCourier/providers/authentication_provider.dart';
import 'package:foodCourier/providers/filters_api_provider.dart';

class Offers extends StatefulWidget {
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

  Offers(
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

class _State extends State<Offers> {
  int _index = 0;

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
        _streamController.sink.add(
            await Provider.of<AllFiltersProvider>(context, listen: false)
                .searchRestaurant(
                    widget.searchInput, userToken, restaurantType));
      } else if (widget.sortBy != null) {
        if (widget.sortBy == 'distance')
          widget.addressSelectedPlace == null
              ? widget.currentLocation == null
                  ? _streamController.sink.add(
                      await Provider.of<AllFiltersProvider>(context, listen: false)
                          .sortRestaurantByDistance(
                              userToken, 0, 0, restaurantType))
                  : _streamController.sink.add(
                      await Provider.of<AllFiltersProvider>(context, listen: false)
                          .sortRestaurantByDistance(
                              userToken,
                              widget.currentLocation.latitude,
                              widget.currentLocation.longitude,
                              restaurantType))
              : _streamController.sink.add(await Provider.of<AllFiltersProvider>(context, listen: false)
                  .sortRestaurantByDistance(userToken, widget.addressSelectedPlace.geometry.location.lat, widget.addressSelectedPlace.geometry.location.lng, restaurantType));
        else
          _streamController.sink.add(
              await Provider.of<AllFiltersProvider>(context, listen: false)
                  .sortRestaurantBy(userToken, widget.sortBy, restaurantType));
      } else if (widget.selectedRegion != 'no region' &&
          widget.selectedRegion != null) {
        if (widget.selectedRegionType != 'location')
          _streamController.sink.add(
              await Provider.of<AllFiltersProvider>(context, listen: false)
                  .showRestaurantByLocation(userToken, widget.selectedRegion,
                      widget.selectedRegionType, restaurantType));
        else {
          if (widget.addressSelectedPlace != null) {
            _streamController.sink.add(
                await Provider.of<AllFiltersProvider>(context, listen: false)
                    .showRestaurantByLocation(
                        userToken,
                        widget
                            .addressSelectedPlace.addressComponents[3].longName,
                        'town',
                        restaurantType));
          } else if (widget.currentLocation != null) {
            var address = await geoCode.reverseGeocoding(
                latitude: widget.currentLocation.latitude,
                longitude: widget.currentLocation.longitude);
            _streamController.sink.add(
                await Provider.of<AllFiltersProvider>(context, listen: false)
                    .showRestaurantByLocation(
                        userToken, address.city, 'town', restaurantType));
          }
        }
      } else {
        _streamController.sink.add(
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
    return SizedBox(
      child: StreamBuilder(
          stream: _stream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  Container(
                    height: 19 * SizeConfig.blockSizeVertical,
                    width: 95 * SizeConfig.blockSizeHorizontal,
                    decoration: BoxDecoration(
                      color: shadow,
                      borderRadius: BorderRadius.circular(
                          2 * SizeConfig.blockSizeVertical),
                      border: Border.all(
                          color: whiteColor,
                          width: 0.2 * SizeConfig.blockSizeHorizontal),
                      boxShadow: [
                        BoxShadow(
                          color: secondaryColor,
                          offset: Offset(3, 5), // changes position of shadow
                        ),
                      ],
                    ),
                    child: PageView.builder(
                        onPageChanged: (int index) =>
                            setState(() => _index = index),
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data.length,
                        itemBuilder: (_, index) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  2 * SizeConfig.blockSizeVertical),
                              border: Border.all(
                                  color: whiteColor,
                                  width: 0.2 * SizeConfig.blockSizeHorizontal),
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                  snapshot.data[index].photoUrls[0],
                                ),
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          );
                        }),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: SizeConfig.blockSizeVertical,
                    ),
                    alignment: Alignment.bottomCenter,
                    child: DotsIndicator(
                      dotsCount: snapshot.data.length,
                      position: _index,
                      decorator: DotsDecorator(
                        color: lightTextColor, // Inactive color
                        activeColor: primaryColor,
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
    );
  }
}
