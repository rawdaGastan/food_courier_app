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

class AllStoresCard extends StatefulWidget {
  final PickResult? addressSelectedPlace;
  final Location? currentLocation;

  final Restaurant restaurant;
  final bool isDelivery;

  final Function callbackFun;

  const AllStoresCard(
      {Key? key,
      required this.restaurant,
      this.addressSelectedPlace,
      this.currentLocation,
      required this.isDelivery,
      required this.callbackFun})
      : super(key: key);

  @override
  AllStoresCardState createState() => AllStoresCardState();
}

class AllStoresCardState extends State<AllStoresCard> {
  //dummy
  LatLng restaurantLocation = const LatLng(31.2696584, 29.9930304);
  double distance = 1.7;
  double lastDistance = 1.7;

  String duration = '';
  String lastDuration = '';

  bool isFavorite = false;

  bool freeDelivery = false;

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
    getDuration();

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
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 18 * SizeConfig.blockSizeVertical!,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0)),
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
                ),
                SizedBox(height: 0.5 * SizeConfig.blockSizeVertical!),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: 19 * SizeConfig.blockSizeHorizontal!,
                      ),
                      child: AutoSizeText(
                        S().name(widget.restaurant.name),
                        style: restaurantName,
                      ),
                    ),
                    Row(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              children: [
                                Icon(
                                  Icons.attach_money,
                                  color: primaryColor,
                                  size: 5 * SizeConfig.blockSizeHorizontal!,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: 3 * SizeConfig.blockSizeHorizontal!,
                                  ),
                                  child: Icon(
                                    Icons.attach_money,
                                    color: lightTextColor,
                                    size: 5 * SizeConfig.blockSizeHorizontal!,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: 6 * SizeConfig.blockSizeHorizontal!,
                                  ),
                                  child: Icon(
                                    Icons.attach_money,
                                    color: lightTextColor,
                                    size: 5 * SizeConfig.blockSizeHorizontal!,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(
                              Icons.star,
                              color: orangeColor,
                              size: 5 * SizeConfig.blockSizeHorizontal!,
                            ),
                            AutoSizeText(
                              S().rating(widget.restaurant.rating),
                              style: groceryStoreRating.copyWith(
                                  color: darkTextColor),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      WidgetSpan(
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 2 * SizeConfig.blockSizeHorizontal!,
                              top: 1 * SizeConfig.blockSizeVertical!),
                          child: Icon(
                            Icons.location_on,
                            color: lightTextColor,
                            size: 6 * SizeConfig.blockSizeHorizontal!,
                          ),
                        ),
                      ),
                      TextSpan(
                        text:
                            '${S().city(widget.restaurant.city)} - ${S().town(widget.restaurant.town)}',
                        style: groceryStoreLocation,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 4 * SizeConfig.blockSizeHorizontal!,
                      vertical: 0.5 * SizeConfig.blockSizeVertical!),
                  child: const AutoSizeText(
                    'is simply dummy text of the printing and typesetting industry',
                    overflow: TextOverflow.ellipsis,
                    style: groceryStoreLocation,
                    maxLines: 4,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 4 * SizeConfig.blockSizeHorizontal!,
                      vertical: 0.5 * SizeConfig.blockSizeVertical!),
                  child: Row(
                    children: [
                      const AutoSizeText(
                        'With in: ',
                        style: groceryStoreDelivery,
                      ),
                      AutoSizeText(
                        duration,
                        style: groceryStoreDeliveryTime,
                      ),
                      SizedBox(width: 3 * SizeConfig.blockSizeHorizontal!),
                      freeDelivery
                          ? Container()
                          : const Row(
                              children: [
                                AutoSizeText(
                                  'Delivery fee: ',
                                  style: groceryStoreDelivery,
                                ),
                                AutoSizeText(
                                  'EGP 10',
                                  style: groceryStoreDeliveryTime,
                                ),
                              ],
                            ),
                    ],
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
                      margin:
                          EdgeInsets.only(right: SizeConfig.blockSizeVertical!),
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
                freeDelivery
                    ? RichText(
                        text: TextSpan(
                          children: [
                            WidgetSpan(
                              child: Icon(
                                Icons.outlined_flag,
                                color: orangeColor,
                                size: 5 * SizeConfig.blockSizeHorizontal!,
                              ),
                            ),
                            const TextSpan(
                              text: ' Free delivery',
                              style: groceryStoreFreeDelivery,
                            ),
                          ],
                        ),
                      )
                    : Container(),
              ],
            ),
            Positioned(
              top: 14 * SizeConfig.blockSizeVertical!,
              left: 2 * SizeConfig.blockSizeHorizontal!,
              child: CircleAvatar(
                radius: 4 * SizeConfig.blockSizeVertical!,
                backgroundImage:
                    CachedNetworkImageProvider(widget.restaurant.logoUrl),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
