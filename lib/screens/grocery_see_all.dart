import 'package:flutter/material.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:foodCourier/constants/text_styles.dart';
import 'package:foodCourier/constants/colors.dart';
import 'package:foodCourier/controllers/push_notification.dart';
import 'package:foodCourier/controllers/size_config.dart';
import 'package:foodCourier/widgets/authentication_screens_widgets/main_button.dart';
import 'package:foodCourier/widgets/home_screen_widgets/drawer.dart';
import 'package:foodCourier/widgets/home_screen_widgets/filterBy_button_list.dart';
import 'package:foodCourier/widgets/home_screen_widgets/dropdown_locations.dart';
import 'package:foodCourier/widgets/home_screen_widgets/filter_bottom_sheet.dart';
import 'package:foodCourier/widgets/home_screen_widgets/search_field.dart';
import 'package:foodCourier/controllers/location.dart';
import 'package:foodCourier/generated/l10n.dart';
import 'package:foodCourier/widgets/grocery_widgets/stores_all.dart';
import 'package:foodCourier/widgets/grocery_widgets/coffee_all.dart';

class GrocerySeeAll extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<GrocerySeeAll> {
  GlobalKey _navigationBarKey = GlobalObjectKey("nav");

  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  bool dropDownLocationsVisibility = false;
  String regionSelected = 'no region';
  String regionSelectedType;

  int selectedIndexOfBottomBar;
  bool gotIndexFromNavigationBar = false;
  Function callbackNavigationBottomBar;

  AllStores allStoresWidget;
  String groceryView;

  @override
  void initState() {
    super.initState();

    allStoresWidget = AllStores(
      isDelivery: true,
      bottomNavigationIndex: selectedIndexOfBottomBar,
      callbackBottomNavigationBar: callbackNavigationBottomBar,
      callbackFilters: callbackFilters,
      callbackRestriction: callbackRestriction,
    );
  }

  void showNotification() async {
    print('again');
    if (PushNotification().onBackground) {
      sharedPreferencesClass
          .setBackgroundNotification(PushNotification().onBackground);
      PushNotification().onBackground = !PushNotification().onBackground;
    }
    print(PushNotification().onBackground);
    await sharedPreferencesClass.showBackgroundNotification().then(
        (showNotification) => {
              (showNotification)
                  ? displayTrackOrderDialog(context)
                  : print(showNotification)
            });
  }

  displayTrackOrderDialog(context) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          contentPadding: EdgeInsets.all(0 * SizeConfig.blockSizeVertical),
          content: Container(
            height: 18 * SizeConfig.blockSizeVertical,
            child: Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Stack(
                      children: <Widget>[
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: blackColor),
                            margin: EdgeInsets.all(1.5 *
                                SizeConfig
                                    .blockSizeVertical), // Modify this till it fills the color properly
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close_rounded, color: whiteColor),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ],
                ),
                Center(
                  child: Padding(
                    padding:
                        EdgeInsets.only(top: 4 * SizeConfig.blockSizeVertical),
                    child: CircleAvatar(
                      radius: 12 * SizeConfig.blockSizeHorizontal,
                      backgroundColor: backgroundImages,
                      backgroundImage: AssetImage(
                        'assets/icons/temp.png',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actionsPadding:
              EdgeInsets.only(bottom: 3 * SizeConfig.blockSizeVertical),
          actions: <Widget>[
            MainButton(
              label: 'Track your order',
              action: () => Navigator.pushNamed(context, 'track order'),
            ),
          ],
        ),
      );

  void _onItemTapped(int index) {
    setState(() {
      selectedIndexOfBottomBar = index;
    });
    Navigator.pop(context);
    callbackNavigationBottomBar(index);
  }

  callbackDropDownLocation(
      PickResult addressSelectedPlace,
      Location currentLocation,
      bool visibility,
      String selectedCity,
      String selectedCityType) {
    this.setState(() {
      if (selectedCity != null) {
        regionSelected = selectedCity;
      }
      if (selectedCityType != null) {
        regionSelectedType = selectedCityType;
      }
      if (visibility != null) {
        dropDownLocationsVisibility = visibility;
      }
      if (addressSelectedPlace != null) {
        this.allStoresWidget = AllStores(
          addressSelectedPlace: addressSelectedPlace,
          selectedRegion: allStoresWidget.selectedRegion,
          selectedRegionType: allStoresWidget.selectedRegionType,
          currentLocation: allStoresWidget.currentLocation,
          searchInput: allStoresWidget.searchInput,
          sortBy: allStoresWidget.sortBy,
          isDelivery: allStoresWidget.isDelivery,
          bottomNavigationIndex: selectedIndexOfBottomBar,
          callbackBottomNavigationBar:
              allStoresWidget.callbackBottomNavigationBar,
          callbackFilters: allStoresWidget.callbackFilters,
          callbackRestriction: allStoresWidget.callbackRestriction,
        );
      } else if (currentLocation != null) {
        this.allStoresWidget = AllStores(
          currentLocation: currentLocation,
          selectedRegion: allStoresWidget.selectedRegion,
          selectedRegionType: allStoresWidget.selectedRegionType,
          addressSelectedPlace: allStoresWidget.addressSelectedPlace,
          searchInput: allStoresWidget.searchInput,
          sortBy: allStoresWidget.sortBy,
          isDelivery: allStoresWidget.isDelivery,
          bottomNavigationIndex: selectedIndexOfBottomBar,
          callbackBottomNavigationBar:
              allStoresWidget.callbackBottomNavigationBar,
          callbackFilters: allStoresWidget.callbackFilters,
          callbackRestriction: allStoresWidget.callbackRestriction,
        );
      }
    });
  }

  callbackSearch(String searchInput) {
    this.setState(() {
      this.allStoresWidget = AllStores(
        searchInput: searchInput,
        selectedRegion: allStoresWidget.selectedRegion,
        selectedRegionType: allStoresWidget.selectedRegionType,
        addressSelectedPlace: allStoresWidget.addressSelectedPlace,
        currentLocation: allStoresWidget.currentLocation,
        sortBy: allStoresWidget.sortBy,
        isDelivery: allStoresWidget.isDelivery,
        bottomNavigationIndex: selectedIndexOfBottomBar,
        callbackBottomNavigationBar:
            allStoresWidget.callbackBottomNavigationBar,
        callbackFilters: allStoresWidget.callbackFilters,
        callbackRestriction: allStoresWidget.callbackRestriction,
      );
    });
  }

  callbackFilters(String sortBy) {
    if (sortBy != null) {
      setState(() {
        this.allStoresWidget = AllStores(
          sortBy: sortBy,
          selectedRegion: allStoresWidget.selectedRegion,
          selectedRegionType: allStoresWidget.selectedRegionType,
          addressSelectedPlace: allStoresWidget.addressSelectedPlace,
          currentLocation: allStoresWidget.currentLocation,
          searchInput: allStoresWidget.searchInput,
          isDelivery: allStoresWidget.isDelivery,
          bottomNavigationIndex: selectedIndexOfBottomBar,
          callbackBottomNavigationBar:
              allStoresWidget.callbackBottomNavigationBar,
          callbackFilters: allStoresWidget.callbackFilters,
          callbackRestriction: allStoresWidget.callbackRestriction,
        );
      });
    }
  }

  callbackRestriction() {
    setState(() {
      FilterByList();
    });
  }

  callbackDropDownVisibility(bool visibility) {
    setState(() {
      dropDownLocationsVisibility = visibility;
    });
  }

  showRestaurantsByLocation() {
    if (regionSelected != 'no region' && regionSelected != null)
      this.setState(() {
        this.allStoresWidget = AllStores(
          selectedRegion: regionSelected,
          selectedRegionType: regionSelectedType,
          searchInput: allStoresWidget.searchInput,
          addressSelectedPlace: allStoresWidget.addressSelectedPlace,
          currentLocation: allStoresWidget.currentLocation,
          sortBy: allStoresWidget.sortBy,
          isDelivery: allStoresWidget.isDelivery,
          bottomNavigationIndex: selectedIndexOfBottomBar,
          callbackBottomNavigationBar:
              allStoresWidget.callbackBottomNavigationBar,
          callbackFilters: allStoresWidget.callbackFilters,
          callbackRestriction: allStoresWidget.callbackRestriction,
        );
      });
  }

  @override
  Widget build(BuildContext context) {
    showRestaurantsByLocation();
    showNotification();
    // _getFullStorySession();
    SizeConfig().init(context);

    List defaults = ModalRoute.of(context).settings.arguments;
    if (!gotIndexFromNavigationBar) {
      selectedIndexOfBottomBar = defaults[0];
      callbackNavigationBottomBar = defaults[1];
      gotIndexFromNavigationBar = !gotIndexFromNavigationBar;
    }
    groceryView = defaults[2];

    EdgeInsets _widgetOptionsPadding = EdgeInsets.only(
      top: dropDownLocationsVisibility
          ? 17 * SizeConfig.blockSizeVertical
          : 9 * SizeConfig.blockSizeVertical,
    );

    allStoresWidget.offers = false;

    List<Widget> allWidgets = <Widget>[
      Container(
        padding: _widgetOptionsPadding,
        child: allStoresWidget,
      ),
      Container(
        padding: _widgetOptionsPadding,
        child: AllStores(
          selectedRegion: regionSelected,
          selectedRegionType: regionSelectedType,
          searchInput: allStoresWidget.searchInput,
          addressSelectedPlace: allStoresWidget.addressSelectedPlace,
          currentLocation: allStoresWidget.currentLocation,
          sortBy: allStoresWidget.sortBy,
          isDelivery: allStoresWidget.isDelivery,
          bottomNavigationIndex: selectedIndexOfBottomBar,
          callbackBottomNavigationBar:
              allStoresWidget.callbackBottomNavigationBar,
          callbackFilters: allStoresWidget.callbackFilters,
          callbackRestriction: allStoresWidget.callbackRestriction,
          offers: true,
        ),
      ),
      Container(
        padding: _widgetOptionsPadding,
        child: AllCoffee(
          selectedRegion: regionSelected,
          selectedRegionType: regionSelectedType,
          searchInput: allStoresWidget.searchInput,
          addressSelectedPlace: allStoresWidget.addressSelectedPlace,
          currentLocation: allStoresWidget.currentLocation,
          sortBy: allStoresWidget.sortBy,
          isDelivery: allStoresWidget.isDelivery,
          bottomNavigationIndex: selectedIndexOfBottomBar,
          callbackBottomNavigationBar:
              allStoresWidget.callbackBottomNavigationBar,
          callbackFilters: allStoresWidget.callbackFilters,
          callbackRestriction: allStoresWidget.callbackRestriction,
        ),
      ),
    ];

    return Scaffold(
      key: _drawerKey,
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        leading: TextButton(
          onPressed: () {
            _drawerKey.currentState.openDrawer();
          },
          child: Image(
            image: AssetImage('assets/icons/menu.png'),
            width: 6 * SizeConfig.blockSizeHorizontal,
          ),
        ),
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(S().Ve,
                //'Ve',
                style: veTitleText),
            Text(S().Good,
                //'Good',
                style: goodTitleText),
          ],
        ),
        actions: [
          TextButton(
            child: Text(
              regionSelected.length > 15
                  ? regionSelected.substring(0, 15)
                  : regionSelected,
              overflow: TextOverflow.clip,
              maxLines: 1,
              style: fieldText,
              textAlign: TextAlign.center,
            ),
            onPressed: () => setState(() {
              dropDownLocationsVisibility = !dropDownLocationsVisibility;
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        /*child: SvgPicture.asset(
          'assets/icons/filter.svg',
          color: whiteColor,
        ),*/
        child: Image(
          image: AssetImage('assets/icons/filter.png'),
          color: whiteColor,
          width: 7 * SizeConfig.blockSizeHorizontal,
        ),
        backgroundColor: primaryColor,
        onPressed: () {
          filterBottomSheet(context, callbackFilters, callbackRestriction);
        },
        //Navigator.pushNamed(context, 'filter'),
      ),
      drawer: Drawer(
        child: DrawerContents(
            bottomNavigationIndex: selectedIndexOfBottomBar,
            callbackBottomNavigationBar: callbackNavigationBottomBar),
      ),
      bottomNavigationBar: BottomNavigationBar(
        key: _navigationBarKey,
        backgroundColor: whiteColor,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            activeIcon: Image.asset(
              'assets/icons/delivery.png',
              width: 8 * SizeConfig.blockSizeHorizontal,
            ),
            icon: Image.asset(
              'assets/icons/delivery.png',
              color: lightTextColor,
              width: 8 * SizeConfig.blockSizeHorizontal,
            ),
            //icon: Icon(Icons.delivery_dining),
            label: S().delivery,
            //'Delivery',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_grocery_store),
            label: S().grocery,
            //'Grocery',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.room_service),
            label: S().dineOut,
            //'Dineout',
          ),
        ],
        currentIndex: selectedIndexOfBottomBar,
        selectedItemColor: primaryColor,
        unselectedItemColor: lightTextColor,
        onTap: _onItemTapped,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: <Widget>[
                Visibility(
                  visible: dropDownLocationsVisibility,
                  child: Padding(
                    // dropdown menu textfield
                    padding: EdgeInsets.only(
                      left: 10 * SizeConfig.blockSizeHorizontal,
                      right: 10 * SizeConfig.blockSizeHorizontal,
                      top: 2 * SizeConfig.blockSizeVertical,
                    ),
                    child: DropdownLocationsTextField(
                        this.callbackDropDownLocation),
                  ),
                ),
                Stack(
                  children: [
                    Padding(
                      // search field
                      padding: EdgeInsets.only(
                        top: 1.5 * SizeConfig.blockSizeVertical,
                      ),
                      child: IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () => Navigator.pop(context)),
                    ),
                    Padding(
                      // search field
                      padding: EdgeInsets.only(
                        left: 12 * SizeConfig.blockSizeHorizontal,
                        right: 2 * SizeConfig.blockSizeHorizontal,
                        top: 2 * SizeConfig.blockSizeVertical,
                      ),
                      child: SearchField(this.callbackSearch),
                    ),
                  ],
                ),
              ],
            ),
            groceryView == 'Stores'
                ? allWidgets[0]
                : groceryView == 'Offers'
                    ? allWidgets[1]
                    : allWidgets[2],
          ],
        ),
      ),
    );
  }
}
