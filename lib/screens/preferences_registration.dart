import 'dart:async';

import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:food_courier/constants/colors.dart';
import 'package:food_courier/constants/text_styles.dart';
import 'package:food_courier/controllers/shared_preferences.dart';
import 'package:food_courier/controllers/size_config.dart';
import 'package:food_courier/widgets/filters_screen_widgets/restrictions_check_list.dart';
import 'package:food_courier/widgets/home_screen_widgets/filter_by_button_list.dart';
import 'package:food_courier/widgets/authentication_screens_widgets/main_button.dart';
import 'package:food_courier/generated/l10n.dart';

import '../locator.dart';

List<String> tabs = ['Gluten Free', 'High Protein', 'Vegetarian', 'Vegan'];
List<String> tabsIcons = [
  'assets/icons/gluten.webp',
  'assets/icons/protein.png',
  'assets/icons/vegetarian.png',
  'assets/icons/vegan.png',
];

class PreferencesRegistration extends StatefulWidget {
  const PreferencesRegistration({Key? key}) : super(key: key);

  @override
  PreferencesRegistrationState createState() => PreferencesRegistrationState();
}

class PreferencesRegistrationState extends State<PreferencesRegistration> {
  int chosenType = 0; // Gluten Free

  final SharedPreferencesClass sharedPreferencesClass =
      locator<SharedPreferencesClass>();

  final GlobalKey _fabKey = const GlobalObjectKey('fab');
  final GlobalKey _tileKey = const GlobalObjectKey('tile_2');
  final GlobalKey _showCaseKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    sharedPreferencesClass.isFirstTime().then((isFirstTime) => {
          Timer(const Duration(seconds: 1),
              () => ShowCaseWidget.of(context).startShowCase([_showCaseKey]))
        });

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
                size: 2.5 * SizeConfig.blockSizeHorizontal!,
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
            activeSize: Size(8 * SizeConfig.blockSizeHorizontal!,
                SizeConfig.blockSizeVertical!),
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
            Showcase(
              key: _showCaseKey,
              title: 'Restrictions',
              description: 'click here to set your food restrictions',
              child: Container(),
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                      left: 3 * SizeConfig.blockSizeHorizontal!,
                      right: 3 * SizeConfig.blockSizeHorizontal!,
                    ),
                    child: Text(
                      S().preferences,
                      //'Preferences & Restrictions',
                      style: titleText,
                    ),
                  ),
                  Container(
                    key: _fabKey,
                    margin: EdgeInsets.only(
                        top: 4 * SizeConfig.blockSizeVertical!,
                        bottom: SizeConfig.blockSizeVertical!),
                    child: const FilterByList(),
                    /*decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: secondaryColor
                    ),*/
                  ),
                  Container(
                    key: _tileKey,
                    child: RestrictionsList(() {}),
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
