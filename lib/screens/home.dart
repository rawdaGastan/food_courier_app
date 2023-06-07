import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:foodCourier/constants/text_styles.dart';
import 'package:foodCourier/constants/colors.dart';
import 'package:foodCourier/controllers/push_notification.dart';
import 'package:foodCourier/controllers/size_config.dart';
import 'package:foodCourier/main.dart';
import 'package:foodCourier/widgets/authentication_screens_widgets/main_button.dart';
import 'package:foodCourier/widgets/home_screen_widgets/drawer.dart';
import 'package:foodCourier/widgets/home_screen_widgets/filterBy_button_list.dart';
import 'package:foodCourier/widgets/home_screen_widgets/dropdown_locations.dart';
import 'package:foodCourier/widgets/home_screen_widgets/filter_bottom_sheet.dart';
import 'package:foodCourier/widgets/home_screen_widgets/menu.dart';
import 'package:foodCourier/widgets/home_screen_widgets/search_field.dart';
import 'package:foodCourier/controllers/location.dart';
import 'package:foodCourier/generated/l10n.dart';
import 'package:foodCourier/widgets/grocery_widgets/grocery_tab_bar.dart';
import 'package:foodCourier/widgets/grocery_widgets/grocery_view.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GlobalKey _navigationBarKey = GlobalObjectKey("navigationBar");

  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  bool filtersVisibility = true;
  bool dropDownLocationsVisibility = true;
  String regionSelected = 'no region';
  String regionSelectedType;
  int _selectedIndex = 0;

  RestaurantsMenu restaurantsMenuWidget;

  bool bottomBarTapped = false;

  @override
  void initState() {
    super.initState();

    restaurantsMenuWidget = RestaurantsMenu(
        restaurantType: 'RSTR',
        isDelivery: true,
        bottomNavigationIndex: _selectedIndex,
        callbackBottomNavigationBar: callbackBottomNavigation,
        callbackFilters: callbackFilters,
        callbackRestriction: callbackRestriction,
        bottomBarTapped: bottomBarTapped);
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

  void showCoachMarkFAB() async {
    CoachMark coachMarkFAB = CoachMark();
    RenderBox target = _navigationBarKey.currentContext.findRenderObject();
    Rect markRect = target.localToGlobal(Offset.zero) & target.size;
    markRect = markRect.inflate(5.0);

    await sharedPreferencesClass.isFirstTime().then((isFirstTime) => {
          (isFirstTime)
              ? coachMarkFAB.show(
                  targetContext: _navigationBarKey.currentContext,
                  markRect: markRect,
                  markShape: BoxShape.rectangle,
                  children: [
                    Positioned(
                        top: markRect.top - (10 * SizeConfig.blockSizeVertical),
                        right: 5 * SizeConfig.blockSizeHorizontal,
                        left: 5 * SizeConfig.blockSizeHorizontal,
                        child: Text(
                          "click here to choose type of the restaurant",
                          style: const TextStyle(
                            fontSize: 24.0,
                            color: whiteColor,
                          ),
                          textAlign: TextAlign.center,
                        ))
                  ],
                  duration: null,
                  onClose: () {
                    //Timer(Duration(seconds: 3), () => showCoachMarkTile());
                  })
              : null
        });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      bottomBarTapped = true;
      restaurantsMenuWidget.bottomBarTapped = true;
    });
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
        this.restaurantsMenuWidget = RestaurantsMenu(
          addressSelectedPlace: addressSelectedPlace,
          selectedRegion: restaurantsMenuWidget.selectedRegion,
          selectedRegionType: restaurantsMenuWidget.selectedRegionType,
          currentLocation: restaurantsMenuWidget.currentLocation,
          searchInput: restaurantsMenuWidget.searchInput,
          sortBy: restaurantsMenuWidget.sortBy,
          isDelivery: restaurantsMenuWidget.isDelivery,
          restaurantType: restaurantsMenuWidget.restaurantType,
          bottomNavigationIndex: _selectedIndex,
          callbackBottomNavigationBar:
              restaurantsMenuWidget.callbackBottomNavigationBar,
          callbackFilters: restaurantsMenuWidget.callbackFilters,
          callbackRestriction: restaurantsMenuWidget.callbackRestriction,
          bottomBarTapped: bottomBarTapped,
        );
      } else if (currentLocation != null) {
        this.restaurantsMenuWidget = RestaurantsMenu(
          currentLocation: currentLocation,
          selectedRegion: restaurantsMenuWidget.selectedRegion,
          selectedRegionType: restaurantsMenuWidget.selectedRegionType,
          addressSelectedPlace: restaurantsMenuWidget.addressSelectedPlace,
          searchInput: restaurantsMenuWidget.searchInput,
          sortBy: restaurantsMenuWidget.sortBy,
          isDelivery: restaurantsMenuWidget.isDelivery,
          restaurantType: restaurantsMenuWidget.restaurantType,
          bottomNavigationIndex: _selectedIndex,
          callbackBottomNavigationBar:
              restaurantsMenuWidget.callbackBottomNavigationBar,
          callbackFilters: restaurantsMenuWidget.callbackFilters,
          callbackRestriction: restaurantsMenuWidget.callbackRestriction,
          bottomBarTapped: bottomBarTapped,
        );
      }
    });
  }

  callbackSearch(String searchInput) {
    this.setState(() {
      this.restaurantsMenuWidget = RestaurantsMenu(
        searchInput: searchInput,
        selectedRegion: restaurantsMenuWidget.selectedRegion,
        selectedRegionType: restaurantsMenuWidget.selectedRegionType,
        addressSelectedPlace: restaurantsMenuWidget.addressSelectedPlace,
        currentLocation: restaurantsMenuWidget.currentLocation,
        sortBy: restaurantsMenuWidget.sortBy,
        isDelivery: restaurantsMenuWidget.isDelivery,
        restaurantType: restaurantsMenuWidget.restaurantType,
        bottomNavigationIndex: _selectedIndex,
        callbackBottomNavigationBar:
            restaurantsMenuWidget.callbackBottomNavigationBar,
        callbackFilters: restaurantsMenuWidget.callbackFilters,
        callbackRestriction: restaurantsMenuWidget.callbackRestriction,
        bottomBarTapped: bottomBarTapped,
      );
    });
  }

  callbackFilters(String sortBy) {
    if (sortBy != null) {
      setState(() {
        this.restaurantsMenuWidget = RestaurantsMenu(
          sortBy: sortBy,
          selectedRegion: restaurantsMenuWidget.selectedRegion,
          selectedRegionType: restaurantsMenuWidget.selectedRegionType,
          addressSelectedPlace: restaurantsMenuWidget.addressSelectedPlace,
          currentLocation: restaurantsMenuWidget.currentLocation,
          searchInput: restaurantsMenuWidget.searchInput,
          isDelivery: restaurantsMenuWidget.isDelivery,
          restaurantType: restaurantsMenuWidget.restaurantType,
          bottomNavigationIndex: _selectedIndex,
          callbackBottomNavigationBar:
              restaurantsMenuWidget.callbackBottomNavigationBar,
          callbackFilters: restaurantsMenuWidget.callbackFilters,
          callbackRestriction: restaurantsMenuWidget.callbackRestriction,
          bottomBarTapped: bottomBarTapped,
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

  callbackBottomNavigation(int currentIndex) {
    setState(() {
      _selectedIndex = currentIndex;
    });
  }

  /*static const platform = const MethodChannel('samples.flutter.dev/fullstory');
  Future<void> _getFullStorySession() async {
    String sessionUrl;
    try {
      final String result = await platform.invokeMethod('getFullStorySession');
      sessionUrl = 'sessionUrl is : $result .';
    } on PlatformException catch (e) {
      sessionUrl = "Failed to get sessionUrl: '${e.message}'.";
    }

    print(sessionUrl);
  }*/

  showRestaurantsByLocation() {
    if (regionSelected != 'no region' && regionSelected != null)
      this.setState(() {
        this.restaurantsMenuWidget = RestaurantsMenu(
          selectedRegion: regionSelected,
          selectedRegionType: regionSelectedType,
          searchInput: restaurantsMenuWidget.searchInput,
          addressSelectedPlace: restaurantsMenuWidget.addressSelectedPlace,
          currentLocation: restaurantsMenuWidget.currentLocation,
          sortBy: restaurantsMenuWidget.sortBy,
          isDelivery: restaurantsMenuWidget.isDelivery,
          restaurantType: restaurantsMenuWidget.restaurantType,
          bottomNavigationIndex: _selectedIndex,
          callbackBottomNavigationBar:
              restaurantsMenuWidget.callbackBottomNavigationBar,
          callbackFilters: restaurantsMenuWidget.callbackFilters,
          callbackRestriction: restaurantsMenuWidget.callbackRestriction,
          bottomBarTapped: bottomBarTapped,
        );
      });
  }

  @override
  Widget build(BuildContext context) {
    showRestaurantsByLocation();
    Timer(Duration(seconds: 1), () => showCoachMarkFAB());
    showNotification();
    // _getFullStorySession();
    SizeConfig().init(context);

    EdgeInsets _groceryTabBarPadding = EdgeInsets.only(
      top: filtersVisibility & dropDownLocationsVisibility
          ? 35 * SizeConfig.blockSizeVertical
          : filtersVisibility & !dropDownLocationsVisibility
              ? 27 * SizeConfig.blockSizeVertical
              : !filtersVisibility & dropDownLocationsVisibility
                  ? 17 * SizeConfig.blockSizeVertical
                  : 9 * SizeConfig.blockSizeVertical,
    );

    double extraPadding = 0;
    foodCourier().remoteConfigService.groceryFeature && _selectedIndex == 1
        ? extraPadding = 10 * SizeConfig.blockSizeVertical
        : extraPadding = 0;
    EdgeInsets _widgetOptionsPadding = EdgeInsets.only(
      top: filtersVisibility & dropDownLocationsVisibility
          ? 35 * SizeConfig.blockSizeVertical + extraPadding
          : filtersVisibility & !dropDownLocationsVisibility
              ? 27 * SizeConfig.blockSizeVertical + extraPadding
              : !filtersVisibility & dropDownLocationsVisibility
                  ? 17 * SizeConfig.blockSizeVertical + extraPadding
                  : 9 * SizeConfig.blockSizeVertical + extraPadding,
    );
    List<Widget> _widgetOptions = <Widget>[
      Container(
        padding: _widgetOptionsPadding,
        child: restaurantsMenuWidget,
      ),
      /*Container(
        padding: _widgetOptionsPadding,
        child: RestaurantsMenu(
            currentLocation : restaurantsMenuWidget.currentLocation,
            addressSelectedPlace : restaurantsMenuWidget.addressSelectedPlace,
            searchInput: restaurantsMenuWidget.searchInput,
            sortBy: restaurantsMenuWidget.sortBy,
            selectedRegion: restaurantsMenuWidget.selectedRegion,
            selectedRegionType: restaurantsMenuWidget.selectedRegionType,
            isDelivery: true,
            restaurantType: 'GRCR',
            bottomNavigationIndex: _selectedIndex,
            callbackBottomNavigationBar: restaurantsMenuWidget.callbackBottomNavigationBar,
            callbackFilters: restaurantsMenuWidget.callbackFilters,
            callbackRestriction: restaurantsMenuWidget.callbackRestriction,
        ),
      ),*/
      foodCourier().remoteConfigService.groceryFeature
          ? Container(
              padding: _widgetOptionsPadding,
              child: GroceryView(
                currentLocation: restaurantsMenuWidget.currentLocation,
                addressSelectedPlace:
                    restaurantsMenuWidget.addressSelectedPlace,
                searchInput: restaurantsMenuWidget.searchInput,
                sortBy: restaurantsMenuWidget.sortBy,
                selectedRegion: restaurantsMenuWidget.selectedRegion,
                selectedRegionType: restaurantsMenuWidget.selectedRegionType,
                isDelivery: true,
                restaurantType: 'GRCR',
                bottomNavigationIndex: _selectedIndex,
                callbackBottomNavigationBar:
                    restaurantsMenuWidget.callbackBottomNavigationBar,
                callbackFilters: restaurantsMenuWidget.callbackFilters,
                callbackRestriction: restaurantsMenuWidget.callbackRestriction,
              ),
            )
          : Container(),
      Container(
        padding: _widgetOptionsPadding,
        child: RestaurantsMenu(
          currentLocation: restaurantsMenuWidget.currentLocation,
          addressSelectedPlace: restaurantsMenuWidget.addressSelectedPlace,
          searchInput: restaurantsMenuWidget.searchInput,
          sortBy: restaurantsMenuWidget.sortBy,
          selectedRegion: restaurantsMenuWidget.selectedRegion,
          selectedRegionType: restaurantsMenuWidget.selectedRegionType,
          isDineOut: true,
          restaurantType: 'RSTR',
          bottomNavigationIndex: _selectedIndex,
          callbackBottomNavigationBar:
              restaurantsMenuWidget.callbackBottomNavigationBar,
          callbackFilters: restaurantsMenuWidget.callbackFilters,
          callbackRestriction: restaurantsMenuWidget.callbackRestriction,
          bottomBarTapped: bottomBarTapped,
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
            bottomNavigationIndex: _selectedIndex,
            callbackBottomNavigationBar: callbackBottomNavigation),
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
        currentIndex: _selectedIndex,
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
                        left: 10 * SizeConfig.blockSizeHorizontal,
                        right: 22 * SizeConfig.blockSizeHorizontal,
                        top: 2 * SizeConfig.blockSizeVertical,
                      ),
                      child: SearchField(this.callbackSearch),
                    ),
                    Padding(
                      // filter button
                      padding: EdgeInsets.only(
                        left: 80 * SizeConfig.blockSizeHorizontal,
                        right: 10 * SizeConfig.blockSizeHorizontal,
                        top: 2 * SizeConfig.blockSizeVertical,
                      ),
                      child: Container(
                        height: 6 * SizeConfig.blockSizeVertical,
                        width: 6 * SizeConfig.blockSizeVertical,
                        decoration: BoxDecoration(
                          color: secondaryColor,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: IconButton(
                          icon: Image(
                            image: AssetImage('assets/icons/filter.png'),
                            color: primaryColor,
                            width: 5 * SizeConfig.blockSizeHorizontal,
                          ),
                          onPressed: () {
                            setState(() {
                              filtersVisibility = !filtersVisibility;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: filtersVisibility,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: 2 * SizeConfig.blockSizeVertical,
                    ),
                    child: FilterByList(),
                  ),
                ), // navigation body
              ],
            ),
            _widgetOptions.elementAt(_selectedIndex),
            Padding(
              padding: _groceryTabBarPadding,
              child: foodCourier().remoteConfigService.groceryFeature &&
                      _selectedIndex == 1
                  ? GroceryTabBar()
                  : Container(),
            ),
          ],
        ),
      ),
    );
  }
}
