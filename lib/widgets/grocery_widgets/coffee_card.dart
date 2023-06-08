import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
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

class CoffeeCard extends StatefulWidget {
  PickResult? addressSelectedPlace;
  Location? currentLocation;

  String restaurantType;
  Restaurant restaurant;
  bool isDelivery;

  Function callbackFun;

  bool seeAllCoffee;

  CoffeeCard(
      {Key? key,
      required this.restaurant,
      this.addressSelectedPlace,
      this.currentLocation,
      this.restaurantType = '',
      required this.isDelivery,
      required this.callbackFun,
      required this.seeAllCoffee})
      : super(key: key);

  @override
  CoffeeCardState createState() => CoffeeCardState();
}

class CoffeeCardState extends State<CoffeeCard> {
  bool showLabelDetails = false;
  List<String> labelNames = [
    'oily',
    'oily',
    'oily',
    'oily',
    'oily',
    'oily',
    'oily'
  ];

  bool specialOffers = true;

  LatLng restaurantLocation = const LatLng(31.2696584, 29.9930304);
  String duration = '';
  String lastDuration = '';

  getDuration() async {
    if (widget.addressSelectedPlace != null) {
      var response = await calculateTimeBetweenLocations(
          restaurantLocation.latitude,
          restaurantLocation.longitude,
          widget.addressSelectedPlace!.geometry!.location.lat,
          widget.addressSelectedPlace!.geometry!.location.lng);
      duration = response ?? '';
      if (lastDuration != duration) {
        setState(() {
          duration = response ?? '';
          lastDuration = duration;
        });
      }
    } else {
      String? response = await calculateTimeBetweenLocations(
          restaurantLocation.latitude,
          restaurantLocation.longitude,
          widget.currentLocation!.latitude,
          widget.currentLocation!.longitude);
      duration = response ?? '';
      if (lastDuration != duration) {
        setState(() {
          duration = response ?? '';
          lastDuration = duration;
        });
      }
    }

    widget.callbackFun(null, duration);
  }

  displayRateOrderDialog(context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.all(0 * SizeConfig.blockSizeVertical!),
        content: SizedBox(
          height: 35 * SizeConfig.blockSizeVertical!,
          child: Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.all(2 * SizeConfig.blockSizeVertical!),
                    child: const AutoSizeText(
                      'Labels',
                      style: restaurantName,
                    ), // Modify this till it fills the color properly
                  ),
                  Stack(
                    children: <Widget>[
                      Positioned.fill(
                        child: Container(
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: greyTextColor87),
                          margin: EdgeInsets.all(1.5 *
                              SizeConfig
                                  .blockSizeVertical!), // Modify this till it fills the color properly
                        ),
                      ),
                      IconButton(
                        icon:
                            const Icon(Icons.close_rounded, color: whiteColor),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 8 * SizeConfig.blockSizeVertical!,
                  left: 4 * SizeConfig.blockSizeHorizontal!,
                  right: 4 * SizeConfig.blockSizeHorizontal!,
                ),
                child: Expanded(
                  child: GridView.builder(
                    itemCount: /*widget.restaurant.labelNames.length*/
                        labelNames.length,
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: MediaQuery.of(context).size.width /
                          (MediaQuery.of(context).size.height / 4.5),
                    ),
                    itemBuilder: (_, index) => GestureDetector(
                      onTap: () {
                        setState(() {
                          showLabelDetails = !showLabelDetails;
                        });
                      },
                      child: Column(
                        children: [
                          Container(
                            margin:
                                EdgeInsets.all(SizeConfig.blockSizeHorizontal!),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: secondaryColor,
                            ),
                            width: 15 * SizeConfig.blockSizeHorizontal!,
                            height: 2 * SizeConfig.blockSizeVertical!,
                            child: Center(
                              child: Text(
                                /*widget.restaurant.labelNames*/ labelNames[
                                    index],
                                style: restaurantLabels,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: showLabelDetails,
                child: ChatBubble(
                  clipper: ChatBubbleClipper4(
                    type: BubbleType.sendBubble,
                  ),
                  alignment: Alignment.center,
                  margin:
                      EdgeInsets.only(bottom: SizeConfig.blockSizeVertical!),
                  backGroundColor: detailsColor,
                  child: Row(
                    children: [
                      const Icon(Icons.error, color: greyTextColor87),
                      Text(
                        '   Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
                        maxLines: 3,
                        style: messageStyle.copyWith(color: greyTextColor87),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
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
      width: 50 * SizeConfig.blockSizeHorizontal!,
      height: /*widget.restaurant.labelNames.length*/ labelNames.isNotEmpty
          ? 43 * SizeConfig.blockSizeVertical!
          : 33 * SizeConfig.blockSizeVertical!,
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
            color: whiteColor, width: 0.2 * SizeConfig.blockSizeHorizontal!),
        boxShadow: const [
          BoxShadow(
            color: secondaryColor,
            offset: Offset(3, 5), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                child: Container(
                  width: 50 * SizeConfig.blockSizeHorizontal!,
                  height: 15 * SizeConfig.blockSizeVertical!,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(10.0),
                    ),
                    border: Border.all(
                        color: whiteColor,
                        width: 0.2 * SizeConfig.blockSizeHorizontal!),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                          widget.restaurant.photoUrls[0]),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: 1 * SizeConfig.blockSizeVertical!,
                    left: 3 * SizeConfig.blockSizeHorizontal!),
                child: Stack(
                  children: [
                    CircleAvatar(
                      backgroundColor: whiteColor,
                      radius: 4 * SizeConfig.blockSizeHorizontal!,
                    ),
                    widget.seeAllCoffee
                        ? SizedBox(
                            width: 8 * SizeConfig.blockSizeHorizontal!,
                            height: 8 * SizeConfig.blockSizeHorizontal!,
                            child: const Icon(
                              Icons.playlist_add,
                              color: lightTextColor,
                            ),
                          )
                        : SizedBox(
                            width: 8 * SizeConfig.blockSizeHorizontal!,
                            height: 8 * SizeConfig.blockSizeHorizontal!,
                            child: const Icon(
                              Icons.playlist_add_check,
                              color: orangeColor,
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            height: 27 * SizeConfig.blockSizeVertical!,
            padding: EdgeInsets.symmetric(
              horizontal: 2 * SizeConfig.blockSizeHorizontal!,
              vertical: SizeConfig.blockSizeVertical!,
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
                    Padding(
                      padding: EdgeInsets.only(
                        left: SizeConfig.blockSizeHorizontal!,
                      ),
                      child: const AutoSizeText(
                        'Multi supplier',
                        style: groceryStoreRating,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 0.5 * SizeConfig.blockSizeVertical!,
                ),
                const AutoSizeText(
                  'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
                  style: groceryStoreDelivery,
                  maxLines: 2,
                ),
                SizedBox(
                  height: 0.5 * SizeConfig.blockSizeVertical!,
                ),
                /*widget.restaurant.labelNames.length*/ labelNames.isNotEmpty
                    ? Expanded(
                        child: GridView.builder(
                          itemCount: /*widget.restaurant.labelNames.length*/
                              labelNames.length > 4
                                  ? 4
                                  : /*widget.restaurant.labelNames.length*/ labelNames
                                      .length,
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio:
                                MediaQuery.of(context).size.width /
                                    (MediaQuery.of(context).size.height / 4.5),
                          ),
                          itemBuilder: (_,
                                  index) => /*widget.restaurant.labelNames.length*/
                              labelNames.length > 4 && index > 2
                                  ? Container(
                                      margin: EdgeInsets.all(
                                          SizeConfig.blockSizeHorizontal!),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: greyTextColor87,
                                              width: 0.2 *
                                                  SizeConfig
                                                      .blockSizeHorizontal!),
                                          shape: BoxShape.circle),
                                      child: GestureDetector(
                                        child: const Icon(
                                            Icons.more_horiz_rounded,
                                            color: greyTextColor87),
                                        onTap: () {
                                          displayRateOrderDialog(context);
                                        },
                                      ),
                                    )
                                  : Container(
                                      margin: EdgeInsets.all(
                                          SizeConfig.blockSizeHorizontal!),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        color: secondaryColor,
                                      ),
                                      width:
                                          15 * SizeConfig.blockSizeHorizontal!,
                                      height: 2 * SizeConfig.blockSizeVertical!,
                                      child: Center(
                                        child: Text(
                                          /*widget.restaurant.labelNames*/ labelNames[
                                              index],
                                          style: restaurantLabels,
                                        ),
                                      ),
                                    ),
                        ),
                      )
                    : Container(),
                SizedBox(
                  height: 0.5 * SizeConfig.blockSizeVertical!,
                ),
                specialOffers
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
                              text: ' Special offers',
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
    );
  }
}
