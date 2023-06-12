import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:geocode/geocode.dart';

import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:provider/provider.dart';
import 'package:food_courier/constants/colors.dart';
import 'package:food_courier/controllers/location.dart';
import 'package:food_courier/controllers/size_config.dart';
import 'package:food_courier/providers/authentication_provider.dart';
import 'package:food_courier/providers/filters_api_provider.dart';

class Offers extends StatefulWidget {
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

  const Offers(
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
  OffersState createState() => OffersState();
}

class OffersState extends State<Offers> {
  int _index = 0;

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
      if (widget.sortBy == 'distance') {
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

  callBackDistance(double dis, String dur) {
    distance = dis;
    duration = dur;
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
                    height: 19 * SizeConfig.blockSizeVertical!,
                    width: 95 * SizeConfig.blockSizeHorizontal!,
                    decoration: BoxDecoration(
                      color: shadow,
                      borderRadius: BorderRadius.circular(
                          2 * SizeConfig.blockSizeVertical!),
                      border: Border.all(
                          color: whiteColor,
                          width: 0.2 * SizeConfig.blockSizeHorizontal!),
                      boxShadow: const [
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
                                  2 * SizeConfig.blockSizeVertical!),
                              border: Border.all(
                                  color: whiteColor,
                                  width: 0.2 * SizeConfig.blockSizeHorizontal!),
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
                      top: SizeConfig.blockSizeVertical!,
                    ),
                    alignment: Alignment.bottomCenter,
                    child: DotsIndicator(
                      dotsCount: snapshot.data.length,
                      position: _index,
                      decorator: const DotsDecorator(
                        color: lightTextColor, // Inactive color
                        activeColor: primaryColor,
                      ),
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
