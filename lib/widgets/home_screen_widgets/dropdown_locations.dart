import 'package:flutter/material.dart';
import 'package:geocode/geocode.dart';

import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:food_courier/constants/text_styles.dart';
import 'package:food_courier/constants/colors.dart';
import 'package:food_courier/controllers/location.dart';
import 'package:food_courier/controllers/size_config.dart';
import 'package:food_courier/screens/map.dart';
import 'package:food_courier/generated/l10n.dart';

List<String> cities = [
  'Current Location  ➤',
  'Pick on Map   🏴',
  'Cairo',
  'Helwan',
  " • m'adi",
  ' • 15 May',
  'Giza',
];

List<String> cairoCityInside = [
  ' • zaiton',
  ' • sahel',
  ' • rod elfarag',
  ' • shubra',
  " • mo'attam",
  ' • sayeda zeinab',
];

Map<String, String> dropDownCities = {
  'Current Location  ➤': '',
  'Pick on Map   🏴': '',
  'Alexandria': 'city',
  'Montaza 2': 'town',
  'Cairo': 'city',
  '5th Settelment': 'town',
  'Nasr city': 'town',
  'heliopolis': 'town',
  'maadi': 'town',
  'sheikh zayed': 'town',
  'zaiton': 'town',
  'sahel': 'town',
  'rod elfarag': 'town',
  'shubra': 'town',
  "mo'attam": 'town',
  'sayeda zeinab': 'town',
  'Helwan': 'city',
  "m'adi": 'town',
  '15 May': 'town',
  'Giza': 'town',
};

class DropdownLocationsTextField extends StatefulWidget {
  final Function callbackFun;

  const DropdownLocationsTextField(this.callbackFun, {Key? key})
      : super(key: key);

  @override
  DropdownLocationsTextFieldState createState() =>
      DropdownLocationsTextFieldState();
}

class DropdownLocationsTextFieldState
    extends State<DropdownLocationsTextField> {
  PickResult? addressSelectedPlace;
  String currentLocation = '';

  String selectedCity = S().selectRegion;
  String selectedCityType = '';

  //bool showTown = false;
  bool dropDownLocationsVisibility = true;

  Future getCurrentLocationData() async {
    GeoCode geoCode = GeoCode();
    Location location = Location();
    await location.getCurrentLocation();

    Address address = await geoCode.reverseGeocoding(
        latitude: location.latitude, longitude: location.longitude);

    widget.callbackFun(
        null, location, !dropDownLocationsVisibility, null, 'location');
    return address.streetAddress;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: EdgeInsets.only(right: SizeConfig.blockSizeVertical!),
            height: 6 * SizeConfig.blockSizeVertical!,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: secondaryColor,
              ),
              onPressed: () {
                showDropdownItems(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: Text(
                      selectedCity,
                      overflow: TextOverflow.ellipsis,
                      style: fieldText,
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: primaryColor,
                    size: 4 * SizeConfig.blockSizeVertical!,
                  ),
                ],
              ),
            ),
          ),
        ),
        //Spacer(),
        Container(
          height: 6 * SizeConfig.blockSizeVertical!,
          width: 6 * SizeConfig.blockSizeVertical!,
          decoration: BoxDecoration(
            color: secondaryColor,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: IconButton(
            icon: const Icon(
              Icons.close,
              color: primaryColor,
            ),
            onPressed: () {
              setState(() {
                selectedCity = S().selectRegion;
              });
            },
          ),
        ),
      ],
    );
  }

  void showDropdownItems(context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.symmetric(
                horizontal: 2 * SizeConfig.blockSizeVertical!),
            height: 75 * SizeConfig.blockSizeVertical!,
            alignment: Alignment.center,
            child: ListView.separated(
                itemCount: dropDownCities.length,
                separatorBuilder: (context, n) {
                  return const Divider();
                },
                itemBuilder: (context, index) {
                  return SizedBox(
                    height: 5 * SizeConfig.blockSizeVertical!,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                          child: dropDownCities.values.elementAt(index) !=
                                  'town'
                              ? Text(dropDownCities.keys.elementAt(index))
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.person_pin_circle,
                                        color: primaryColor),
                                    SizedBox(
                                        width: 5 *
                                            SizeConfig.blockSizeHorizontal!),
                                    Text(dropDownCities.keys.elementAt(index))
                                  ],
                                ),
                          onTap: () async {
                            if (dropDownCities.keys.elementAt(index) ==
                                'Current Location  ➤') {
                              currentLocation = await getCurrentLocationData();
                              // extract location and send it to API
                              setState(() {
                                currentLocation = currentLocation;
                              });
                            } else if (dropDownCities.keys.elementAt(index) ==
                                'Pick on Map   🏴') {
                              addressSelectedPlace = await openMap(context);
                              setState(() {
                                addressSelectedPlace = addressSelectedPlace;
                              });
                              widget.callbackFun(
                                  addressSelectedPlace,
                                  null,
                                  !dropDownLocationsVisibility,
                                  null,
                                  'location');
                            }
                            setState(() {
                              addressSelectedPlace = addressSelectedPlace;
                              if (dropDownCities.keys.elementAt(index) ==
                                  'Pick on Map   🏴') {
                                selectedCity =
                                    addressSelectedPlace!.formattedAddress!;
                                selectedCityType = 'location';
                              } else if (dropDownCities.keys.elementAt(index) ==
                                  'Current Location  ➤') {
                                selectedCity = currentLocation;
                                selectedCityType = 'location';
                              } else {
                                selectedCity =
                                    dropDownCities.keys.elementAt(index);
                                selectedCityType =
                                    dropDownCities.values.elementAt(index);
                              }
                              widget.callbackFun(
                                  null,
                                  null,
                                  !dropDownLocationsVisibility,
                                  selectedCity,
                                  selectedCityType);
                            });
                            Navigator.of(context).pop();
                          }),
                    ),
                  );
                }),
          );
        });
  }
}
