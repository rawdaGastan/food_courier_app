import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:foodCourier/constants/text_styles.dart';
import 'package:foodCourier/constants/colors.dart';
import 'package:foodCourier/controllers/distance_calculator.dart';
import 'package:foodCourier/controllers/location.dart';
import 'package:foodCourier/controllers/size_config.dart';
import 'package:foodCourier/generated/l10n.dart';
import 'package:foodCourier/models/restaurant.dart';
import 'package:auto_size_text/auto_size_text.dart';

class StoreCard extends StatefulWidget {
  final PickResult? addressSelectedPlace;
  final Location? currentLocation;

  final String restaurantType;
  final Restaurant restaurant;
  final bool isDelivery;

  final Function callbackFun;

  const StoreCard(
      {Key? key,
      required this.restaurant,
      this.addressSelectedPlace,
      this.currentLocation,
      required this.restaurantType,
      required this.isDelivery,
      required this.callbackFun})
      : super(key: key);

  @override
  StoreCardState createState() => StoreCardState();
}

class StoreCardState extends State<StoreCard> {
  bool freeDelivery = true;

  LatLng restaurantLocation = const LatLng(31.2696584, 29.9930304);
  String duration = '';
  String lastDuration = '';

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
    SizeConfig();
    getDuration();

    return Container(
      margin: EdgeInsets.only(
        left: SizeConfig.blockSizeHorizontal!,
        right: SizeConfig.blockSizeHorizontal!,
      ),
      width: 65 * SizeConfig.blockSizeHorizontal!,
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
            color: lightTextColor,
            width: 0.2 * SizeConfig.blockSizeHorizontal!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 2 * SizeConfig.blockSizeHorizontal!,
              vertical: SizeConfig.blockSizeVertical!,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 3.5 * SizeConfig.blockSizeVertical!,
                  backgroundImage:
                      CachedNetworkImageProvider(widget.restaurant.logoUrl),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 2 * SizeConfig.blockSizeHorizontal!,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        S().name(widget.restaurant.name),
                        style: restaurantName,
                      ),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical!,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Icons.star,
                            color: orangeColor,
                            size: 4 * SizeConfig.blockSizeHorizontal!,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: SizeConfig.blockSizeHorizontal!,
                            ),
                            child: AutoSizeText(
                              S().rating(widget.restaurant.rating),
                              style: groceryStoreRating,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: SizeConfig.blockSizeHorizontal!,
                            ),
                            child: const AutoSizeText(
                              '|',
                              style: groceryStoreRating,
                            ),
                          ),
                          Stack(
                            children: [
                              Icon(
                                Icons.attach_money,
                                color: primaryColor,
                                size: 4 * SizeConfig.blockSizeHorizontal!,
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 2 * SizeConfig.blockSizeHorizontal!,
                                ),
                                child: Icon(
                                  Icons.attach_money,
                                  color: lightTextColor,
                                  size: 4 * SizeConfig.blockSizeHorizontal!,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 4 * SizeConfig.blockSizeHorizontal!,
                                ),
                                child: Icon(
                                  Icons.attach_money,
                                  color: lightTextColor,
                                  size: 4 * SizeConfig.blockSizeHorizontal!,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 0.5 * SizeConfig.blockSizeVertical!,
                      ),
                      Row(
                        children: [
                          AutoSizeText(
                            freeDelivery ? 'With in: ' : 'With in        : ',
                            style: groceryStoreDelivery,
                          ),
                          AutoSizeText(
                            duration,
                            style: groceryStoreDeliveryTime,
                          ),
                        ],
                      ),
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
                      SizedBox(
                        height: 0.5 * SizeConfig.blockSizeVertical!,
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            WidgetSpan(
                              child: Icon(
                                Icons.location_on,
                                color: primaryColor,
                                size: 4 * SizeConfig.blockSizeHorizontal!,
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
                      SizedBox(height: 0.45 * SizeConfig.blockSizeVertical!),
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
