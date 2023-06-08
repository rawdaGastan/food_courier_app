import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:provider/provider.dart';
import 'package:foodCourier/constants/text_styles.dart';
import 'package:foodCourier/constants/colors.dart';
import 'package:foodCourier/controllers/distance_calculator.dart';
import 'package:foodCourier/controllers/size_config.dart';
import 'package:foodCourier/models/restaurant.dart';
import 'package:foodCourier/providers/type_filter_provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:foodCourier/controllers/location.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:foodCourier/generated/l10n.dart';

class RestaurantCard extends StatefulWidget {
  PickResult? addressSelectedPlace;
  Location? currentLocation;

  String restaurantType;
  Restaurant restaurant;
  bool isDelivery;
  bool isDineOut;

  Function callbackFun;

  RestaurantCard(
      {Key? key,
      required this.restaurant,
      this.addressSelectedPlace,
      this.currentLocation,
      required this.restaurantType,
      required this.isDelivery,
      required this.callbackFun,
      required this.isDineOut})
      : super(key: key);

  @override
  RestaurantCardState createState() => RestaurantCardState();
}

class RestaurantCardState extends State<RestaurantCard> {
  //dummy
  LatLng restaurantLocation = const LatLng(31.2696584, 29.9930304);
  double distance = 1.7;
  double lastDistance = 1.7;

  String duration = '';
  String lastDuration = '';

  bool isFavorite = false;

  getDistance() async {
    if (widget.addressSelectedPlace != null) {
      var response = await calculateDistanceBetweenLocations(
          restaurantLocation.latitude,
          restaurantLocation.longitude,
          widget.addressSelectedPlace!.geometry!.location.lat,
          widget.addressSelectedPlace!.geometry!.location.lng);
      distance = double.parse(response);
      if (lastDistance != distance) {
        setState(() {
          distance = double.parse(response);
          lastDistance = distance;
        });
      }
    } else if (widget.currentLocation != null) {
      var response = await calculateDistanceBetweenLocations(
          restaurantLocation.latitude,
          restaurantLocation.longitude,
          widget.currentLocation!.latitude,
          widget.currentLocation!.longitude);
      distance = double.parse(response);
      if (lastDistance != distance) {
        setState(() {
          distance = double.parse(response);
          lastDistance = distance;
        });
      }
    }
    widget.callbackFun(distance, null);
  }

  getDuration() async {
    if (widget.addressSelectedPlace != null) {
      String? response = await calculateTimeBetweenLocations(
          restaurantLocation.latitude,
          restaurantLocation.longitude,
          widget.addressSelectedPlace!.geometry!.location.lat,
          widget.addressSelectedPlace!.geometry!.location.lng);
      duration = response!;
      if (lastDuration != duration) {
        setState(() {
          duration = response;
          lastDuration = duration;
        });
      }
    } else if (widget.currentLocation != null) {
      String? response = await calculateTimeBetweenLocations(
          restaurantLocation.latitude,
          restaurantLocation.longitude,
          widget.currentLocation!.latitude,
          widget.currentLocation!.longitude);
      duration = response!;
      if (lastDuration != duration) {
        setState(() {
          duration = response;
          lastDuration = duration;
        });
      }
    }
    widget.callbackFun(null, duration);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.restaurantType == 'GRCR') {
      getDuration();
    } else if ((widget.isDelivery == true && widget.restaurantType == 'RSTR') ||
        widget.isDineOut == true) {
      getDistance();
    }

    bool visibilityFilters =
        Provider.of<TypeFilterProvider>(context).isFirstTime
            ? true
            :
            //this will be triggered when a type filter type is applied
            Provider.of<TypeFilterProvider>(context)
                    .contains(widget.restaurant.labelNames)
                ? true
                : false;

    if (Provider.of<TypeFilterProvider>(context)
                .getTypeOfCurrentFilterApplied ==
            'Normal' &&
        widget.restaurant.labelNames.isEmpty) visibilityFilters = true;

    return Visibility(
      visible: visibilityFilters,
      child: Container(
        margin: EdgeInsets.only(
          top: 1.5 * SizeConfig.blockSizeVertical!,
          left: 1.5 * SizeConfig.blockSizeVertical!,
          right: 1.5 * SizeConfig.blockSizeVertical!,
        ),
        //height: 50 * SizeConfig.blockSizeVertical!,
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: const BorderRadius.all(Radius.circular(12.0)),
          boxShadow: [
            BoxShadow(
              color: shadow,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(
              height: 25 * SizeConfig.blockSizeVertical!,
              width: double.infinity,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16.0),
                        topRight: Radius.circular(16.0)),
                    child: Container(
                      width: SizeConfig.screenWidth,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(
                              widget.restaurant.photoUrls[0]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 1 * SizeConfig.blockSizeVertical!,
                        left: 82 * SizeConfig.blockSizeHorizontal!),
                    child: Stack(
                      children: [
                        CircleAvatar(
                          backgroundColor: whiteColor,
                          radius: 4 * SizeConfig.blockSizeHorizontal!,
                        ),
                        SizedBox(
                          width: 8 * SizeConfig.blockSizeHorizontal!,
                          height: 8 * SizeConfig.blockSizeHorizontal!,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isFavorite = !isFavorite;
                              });
                            },
                            child: Icon(
                              isFavorite
                                  ? Icons.turned_in
                                  : Icons.turned_in_not,
                              color: orangeColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 2 * SizeConfig.blockSizeVertical!,
                    //left: 70 * SizeConfig.blockSizeHorizontal!,
                    left: 3 * SizeConfig.blockSizeHorizontal!,
                    right: 3 * SizeConfig.blockSizeHorizontal!,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          height: 5 * SizeConfig.blockSizeVertical!,
                          width: 16 * SizeConfig.blockSizeHorizontal!,
                          decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Stack(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: 0.5 * SizeConfig.blockSizeVertical!,
                                    ),
                                    child: const Icon(Icons.attach_money,
                                        color: orangeColor),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: 0.5 * SizeConfig.blockSizeVertical!,
                                      left:
                                          3.5 * SizeConfig.blockSizeHorizontal!,
                                    ),
                                    child: const Icon(Icons.attach_money,
                                        color: lightTextColor),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: 0.5 * SizeConfig.blockSizeVertical!,
                                      left: 7 * SizeConfig.blockSizeHorizontal!,
                                    ),
                                    child: const Icon(Icons.attach_money,
                                        color: lightTextColor),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 5 * SizeConfig.blockSizeVertical!,
                          width: 25 * SizeConfig.blockSizeHorizontal!,
                          decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Tab(
                                icon: widget.restaurantType == 'GRCR'
                                    ? const Icon(Icons.timer,
                                        color: orangeColor)
                                    : widget.isDelivery == true &&
                                            widget.restaurantType == 'RSTR'
                                        ? Image.asset(
                                            'assets/icons/distance.png',
                                            width: 7 *
                                                SizeConfig.blockSizeHorizontal!,
                                            color: orangeColor)
                                        : widget.isDineOut == true
                                            ? Image.asset(
                                                'assets/icons/distance.png',
                                                width: 7 *
                                                    SizeConfig
                                                        .blockSizeHorizontal!,
                                                color: orangeColor)
                                            : null,
                                //Image.asset('assets/icons/distance.png', width: 7 * SizeConfig.blockSizeHorizontal!, color: orangeColor),
                              ),
                              AutoSizeText(
                                widget.restaurantType == 'GRCR'
                                    ? duration
                                    : widget.isDelivery == true &&
                                            widget.restaurantType == 'RSTR'
                                        ? S().distance(distance)
                                        : widget.isDineOut == true
                                            ? S().distance(distance)
                                            : '',
                                //duration,
                                //S().distance(distance),
                                //'$distance k',
                                style: distanceAndRatingText,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: 2 * SizeConfig.blockSizeHorizontal!,
                    right: 2 * SizeConfig.blockSizeHorizontal!,
                    top: 2 * SizeConfig.blockSizeVertical!,
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 4 * SizeConfig.blockSizeVertical!,
                        backgroundImage: CachedNetworkImageProvider(
                            widget.restaurant.logoUrl),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: 3 * SizeConfig.blockSizeHorizontal!),
                            child: AutoSizeText(
                              S().name(widget.restaurant.name),
                              style: restaurantName,
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 2 *
                                            SizeConfig.blockSizeHorizontal!),
                                    child: const Icon(Icons.location_on,
                                        color: primaryColor, size: 20),
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      '${S().city(widget.restaurant.city)} - ${S().town(widget.restaurant.town)}',
                                  style: RestaurantAddress,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: SizeConfig.blockSizeVertical!,
                    left: 2 * SizeConfig.blockSizeHorizontal!,
                    right: 3 * SizeConfig.blockSizeHorizontal!,
                  ),
                  height: 5 * SizeConfig.blockSizeVertical!,
                  width: 16 * SizeConfig.blockSizeHorizontal!,
                  decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Icon(
                        Icons.star,
                        color: orangeColor,
                      ),
                      AutoSizeText(
                        S().rating(widget.restaurant.rating),
                        style: distanceAndRatingText,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 2 * SizeConfig.blockSizeHorizontal!,
                  vertical: SizeConfig.blockSizeVertical!),
              child: const AutoSizeText(
                'is simply dummy text of the printing and typesetting industry',
                overflow: TextOverflow.ellipsis,
                style: RestaurantDescription,
                maxLines: 4,
              ),
            ),
            SizedBox(
              height: 7 * SizeConfig.blockSizeVertical!,
              child: ListView.builder(
                padding: EdgeInsets.symmetric(
                    vertical: SizeConfig.blockSizeVertical!,
                    horizontal: 2 * SizeConfig.blockSizeHorizontal!),
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: widget.restaurant.labelNames.length,
                itemBuilder: (_, index) => Container(
                  margin: EdgeInsets.only(right: SizeConfig.blockSizeVertical!),
                  height: 5 * SizeConfig.blockSizeVertical!,
                  width: 28 * SizeConfig.blockSizeHorizontal!,
                  decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Center(
                    child: AutoSizeText(
                      S().labels(widget.restaurant.labelNames[index]),
                      style: RestaurantLabels,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
