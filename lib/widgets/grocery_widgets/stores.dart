import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocode/geocode.dart';

import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:provider/provider.dart';
import 'package:food_courier/controllers/location.dart';
import 'package:food_courier/controllers/size_config.dart';
import 'package:food_courier/providers/authentication_provider.dart';
import 'package:food_courier/providers/filters_api_provider.dart';
import 'package:food_courier/widgets/grocery_widgets/store_card.dart';

class Stores extends StatefulWidget {
  final PickResult? addressSelectedPlace;
  final Location? currentLocation;

  final String? searchInput;
  final String? sortBy;
  final String? selectedRegion;
  final String? selectedRegionType;
  final String restaurantType;
  final bool isDelivery;

  final int bottomNavigationIndex;
  final Function callbackBottomNavigationBar;

  final Function callbackFilters;
  final Function callbackRestriction;

  const Stores(
      {Key? key,
      this.addressSelectedPlace,
      this.currentLocation,
      this.searchInput,
      this.sortBy,
      required this.restaurantType,
      required this.isDelivery,
      required this.bottomNavigationIndex,
      required this.callbackBottomNavigationBar,
      this.selectedRegion,
      this.selectedRegionType,
      required this.callbackFilters,
      required this.callbackRestriction})
      : super(key: key);

  @override
  StoresState createState() => StoresState();
}

class StoresState extends State<Stores> {
  late StreamController _streamController;
  late Stream _stream;

  double distance = 0.0;
  String duration = '';
  GeoCode geoCode = GeoCode();

  @override
  void initState() {
    super.initState();
    _streamController = StreamController.broadcast();
    _stream = _streamController.stream;
    Future.delayed(Duration.zero, getDataFromProvider);
  }

  getDataFromProvider() async {
    String userToken =
        await Provider.of<AuthenticationProvider>(context, listen: false)
            .userToken;

    //delivery, grocery or dine out
    String restaurantType = '';
    if (widget.isDelivery) {
      restaurantType = 'delivery';
    }

    if (widget.searchInput != null) {
      _streamController.sink.add(await Provider.of<AllFiltersProvider>(context,
              listen: false)
          .searchRestaurant(widget.searchInput!, userToken, restaurantType));
    } else if (widget.sortBy != null) {
      if (widget.sortBy! == 'distance') {
        widget.addressSelectedPlace == null
            ? widget.currentLocation == null
                ? _streamController.sink.add(await Provider.of<AllFiltersProvider>(context, listen: false)
                    .sortRestaurantByDistance(userToken, 0, 0, restaurantType))
                : _streamController.sink.add(await Provider.of<AllFiltersProvider>(context, listen: false)
                    .sortRestaurantByDistance(
                        userToken,
                        widget.currentLocation!.latitude,
                        widget.currentLocation!.longitude,
                        restaurantType))
            : _streamController.sink.add(await Provider.of<AllFiltersProvider>(context, listen: false)
                .sortRestaurantByDistance(
                    userToken,
                    widget.addressSelectedPlace!.geometry!.location.lat,
                    widget.addressSelectedPlace!.geometry!.location.lng,
                    restaurantType));
      } else {
        _streamController.sink.add(
            await Provider.of<AllFiltersProvider>(context, listen: false)
                .sortRestaurantBy(userToken, widget.sortBy!, restaurantType));
      }
    } else if (widget.selectedRegion != 'no region' &&
        widget.selectedRegion != null) {
      if (widget.selectedRegionType != 'location') {
        _streamController.sink.add(
            await Provider.of<AllFiltersProvider>(context, listen: false)
                .showRestaurantByLocation(userToken, widget.selectedRegion!,
                    widget.selectedRegionType!, restaurantType));
      } else {
        if (widget.addressSelectedPlace != null) {
          _streamController.sink.add(
              await Provider.of<AllFiltersProvider>(context, listen: false)
                  .showRestaurantByLocation(
                      userToken,
                      widget
                          .addressSelectedPlace!.addressComponents![3].longName,
                      'town',
                      restaurantType));
        } else if (widget.currentLocation != null) {
          var address = await geoCode.reverseGeocoding(
              latitude: widget.currentLocation!.latitude,
              longitude: widget.currentLocation!.longitude);
          _streamController.sink.add(
              await Provider.of<AllFiltersProvider>(context, listen: false)
                  .showRestaurantByLocation(
                      userToken, address.city!, 'town', restaurantType));
        }
      }
    } else {
      _streamController.sink.add(
          await Provider.of<AllFiltersProvider>(context, listen: false)
              .loadData(userToken, restaurantType));
    }
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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 18 * SizeConfig.blockSizeVertical!,
      width: double.infinity,
      child: StreamBuilder(
          stream: _stream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (_, index) => GestureDetector(
                  onTap: () =>
                      Navigator.pushNamed(context, 'restaurant', arguments: [
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
                          ? StoreCard(
                              restaurant: snapshot.data[index],
                              restaurantType: widget.restaurantType,
                              isDelivery: widget.isDelivery,
                              callbackFun: callBackDistance,
                            )
                          : StoreCard(
                              restaurant: snapshot.data[index],
                              restaurantType: widget.restaurantType,
                              isDelivery: widget.isDelivery,
                              currentLocation: widget.currentLocation!,
                              callbackFun: callBackDistance)
                      : StoreCard(
                          restaurant: snapshot.data[index],
                          restaurantType: widget.restaurantType,
                          isDelivery: widget.isDelivery,
                          addressSelectedPlace: widget.addressSelectedPlace!,
                          callbackFun: callBackDistance,
                        ),
                ),
                itemCount: snapshot.data.length,
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
