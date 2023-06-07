import 'dart:async';

import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:foodCourier/constants/colors.dart';
import 'package:foodCourier/constants/text_styles.dart';
import 'package:foodCourier/controllers/sharedPreferences.dart';
import 'package:foodCourier/controllers/size_config.dart';
import 'package:foodCourier/widgets/filters_screen_widgets/restrictions_check_list.dart';
import 'package:foodCourier/widgets/home_screen_widgets/filterBy_button_list.dart';
import 'package:foodCourier/widgets/authentication_screens_widgets/main_button.dart';
import 'package:foodCourier/generated/l10n.dart';

import '../locator.dart';

List<String> tabs = ['Gluten Free', 'High Protein', 'Vegetarian', 'Vegan'];
List<String> tabsIcons = [
  'assets/icons/gluten.webp',
  'assets/icons/protein.png',
  'assets/icons/vegetarian.png',
  'assets/icons/vegan.png',
];

class PreferencesRegistration extends StatefulWidget {
  @override
  _PreferencesRegistrationState createState() =>
      _PreferencesRegistrationState();
}

class _PreferencesRegistrationState extends State<PreferencesRegistration> {
  int chosenType = 0; // Gluten Free

  final SharedPreferencesClass sharedPreferencesClass =
      locator<SharedPreferencesClass>();

  GlobalKey _fabKey = GlobalObjectKey("fab");
  GlobalKey _tileKey = GlobalObjectKey("tile_2");

  void showCoachMarkFAB() async {
    CoachMark coachMarkFAB = CoachMark();
    RenderBox target = _fabKey.currentContext.findRenderObject();
    Rect markRect = target.localToGlobal(Offset.zero) & target.size;
    markRect = markRect.inflate(5.0);

    await sharedPreferencesClass.isFirstTime().then((isFirstTime) => {
          (isFirstTime)
              ? coachMarkFAB.show(
                  targetContext: _fabKey.currentContext,
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

  void showCoachMarkTile() {
    CoachMark coachMarkTile = CoachMark();
    RenderBox target = _tileKey.currentContext.findRenderObject();

    Rect markRect = target.localToGlobal(Offset.zero) & target.size;
    markRect = markRect.inflate(5.0);

    coachMarkTile.show(
      targetContext: _tileKey.currentContext,
      markRect: markRect,
      markShape: BoxShape.rectangle,
      children: [
        Positioned(
            top: markRect.bottom + 15.0,
            right: 2 * SizeConfig.blockSizeHorizontal,
            left: 2 * SizeConfig.blockSizeHorizontal,
            child: Text(
              "click here to set your food restrictions",
              style: const TextStyle(
                fontSize: 24.0,
                fontStyle: FontStyle.italic,
                color: whiteColor,
              ),
              textAlign: TextAlign.center,
            ))
      ],
      duration: null,
      //duration: Duration(seconds: 3)
    );
  }

  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 1), () => showCoachMarkFAB());

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        leading: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.arrow_back_ios,
                color: blackColor,
                size: 2.5 * SizeConfig.blockSizeHorizontal,
              ),
              Text(S().back, style: blackSmallText14),
            ],
          ),
        ),
        centerTitle: true,
        title: DotsIndicator(
          dotsCount: 2,
          position: 0,
          decorator: DotsDecorator(
            color: primaryColor, // Inactive color
            activeColor: primaryColor,
            activeSize: Size(8 * SizeConfig.blockSizeHorizontal,
                SizeConfig.blockSizeVertical),
            activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
          ),
        ),
        actions: [
          TextButton(
            child: Text(
              S().skip,
              style: greenSmallText17,
            ),
            onPressed: () => Navigator.pushNamed(context, 'preferences reg'),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                      left: 3 * SizeConfig.blockSizeHorizontal,
                      right: 3 * SizeConfig.blockSizeHorizontal,
                    ),
                    child: Text(
                      S().preferences,
                      //'Preferences & Restrictions',
                      style: titleText,
                    ),
                  ),
                  Container(
                    key: _fabKey,
                    child: FilterByList(),
                    margin: EdgeInsets.only(
                        top: 4 * SizeConfig.blockSizeVertical,
                        bottom: SizeConfig.blockSizeVertical),
                    /*decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: secondaryColor
                    ),*/
                  ),
                  Container(
                    key: _tileKey,
                    child: RestrictionsList(null),
                  ),
                ],
              ),
            ),
            MainButton(
              label: S().continueButton,
              action: () => Navigator.pushNamed(context, 'home'),
            ),
          ],
        ),
      ),
    );
  }
}
