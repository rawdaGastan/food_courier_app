import 'package:flutter/material.dart';
import 'package:geocode/geocode.dart';

import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:provider/provider.dart';
import 'package:food_courier/constants/colors.dart';
import 'package:food_courier/constants/text_styles.dart';
import 'package:food_courier/controllers/size_config.dart';
import 'package:food_courier/providers/filters_api_provider.dart';
import 'package:food_courier/providers/authentication_provider.dart';
import 'package:food_courier/widgets/grocery_widgets/stores_all_card.dart';
import 'package:food_courier/controllers/location.dart';
import 'dart:async';
import 'package:food_courier/widgets/grocery_widgets/offers_tab_bar.dart';

// ignore: must_be_immutable
class AllStores extends StatefulWidget {
  final PickResult? addressSelectedPlace;
  final Location? currentLocation;

  final String? searchInput;
  final String? sortBy;
  final String? selectedRegion;
  final String? selectedRegionType;
  final bool isDelivery;

  final int bottomNavigationIndex;
  final Function callbackBottomNavigationBar;

  final Function callbackFilters;
  final Function callbackRestriction;

  bool offers;

  AllStores(
      {Key? key,
      this.addressSelectedPlace,
      this.currentLocation,
      this.searchInput,
      this.sortBy,
      required this.isDelivery,
      required this.bottomNavigationIndex,
      required this.callbackBottomNavigationBar,
      this.selectedRegion,
      this.selectedRegionType,
      required this.callbackFilters,
      required this.callbackRestriction,
      this.offers = false})
      : super(key: key);

  @override
  AllStoresState createState() => AllStoresState();
}

class AllStoresState extends State<AllStores> {
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
    if (widget.isDelivery) {
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
                              Text(widget.offers ? 'All offers' : 'All stores',
                                  style: groceryLabels),
                              Text(
                                '(${snapshot.data.length} items)',
                                style: grocerySeeAll.copyWith(
                                    color: greyTextColor87),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 3 * SizeConfig.blockSizeHorizontal!,
                          ),
                          child: widget.offers
                              ? Text('Free Delivery',
                                  style: grocerySeeAll.copyWith(
                                      color: darkTextColor))
                              : Container(),
                        ),
                        Expanded(
                          child: ListView.builder(
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
                                      ? AllStoresCard(
                                          restaurant: snapshot.data[index],
                                          isDelivery: widget.isDelivery,
                                          callbackFun: callBackDistance,
                                        )
                                      : AllStoresCard(
                                          restaurant: snapshot.data[index],
                                          isDelivery: widget.isDelivery,
                                          currentLocation:
                                              widget.currentLocation,
                                          callbackFun: callBackDistance)
                                  : AllStoresCard(
                                      restaurant: snapshot.data[index],
                                      isDelivery: widget.isDelivery,
                                      addressSelectedPlace:
                                          widget.addressSelectedPlace,
                                      callbackFun: callBackDistance,
                                    ),
                            ),
                            itemCount: snapshot.data.length,
                          ),
                        ),
                      ],
                    ),
                  ),
                  widget.offers ? const OffersTabBar() : Container(),
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
