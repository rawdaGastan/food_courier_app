import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:foodCourier/constants/APIKeys.dart';

final kInitialPosition = LatLng(-33.8567844, 151.213108);

openMap(context) async {
  PickResult selectedPlace;
  final result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) {
        return PlacePicker(
          apiKey: theApiKey,
          initialPosition: kInitialPosition,
          useCurrentLocation: true,
          selectInitialPosition: true,

          usePlaceDetailSearch: true,
          onPlacePicked: (result) {
            selectedPlace = result;
            Navigator.pop(context, selectedPlace);
            //Navigator.of(context).pop();
          },
          //forceSearchOnZoomChanged: true,
          //automaticallyImplyAppBarLeading: false,
          //autocompleteLanguage: "ko",
          //region: 'au',
          //selectInitialPosition: true,
          // selectedPlaceWidgetBuilder: (_, selectedPlace, state, isSearchBarFocused) {
          //   print("state: $state, isSearchBarFocused: $isSearchBarFocused");
          //   return isSearchBarFocused
          //       ? Container()
          //       : FloatingCard(
          //           bottomPosition: 0.0, // MediaQuery.of(context) will cause rebuild. See MediaQuery document for the information.
          //           leftPosition: 0.0,
          //           rightPosition: 0.0,
          //           width: 500,
          //           borderRadius: BorderRadius.circular(12.0),
          //           child: state == SearchingState.Searching
          //               ? Center(child: CircularProgressIndicator())
          //               : RaisedButton(
          //                   child: Text("Pick Here"),
          //                   onPressed: () {
          //                     // IMPORTANT: You MUST manage selectedPlace data yourself as using this build will not invoke onPlacePicker as
          //                     //            this will override default 'Select here' Button.
          //                     print("do something with [selectedPlace] data");
          //                     Navigator.of(context).pop();
          //                   },
          //                 ),
          //         );
          // },
          // pinBuilder: (context, state) {
          //   if (state == PinState.Idle) {
          //     return Icon(Icons.favorite_border);
          //   } else {
          //     return Icon(Icons.favorite);
          //   }
          // },
        );
      },
    ),
  );
  return result;
}
