import 'dart:async';

import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:provider/provider.dart';
import 'package:foodCourier/constants/text_styles.dart';
import 'package:foodCourier/constants/colors.dart';
import 'package:foodCourier/controllers/shared_preferences.dart';
import 'package:foodCourier/controllers/size_config.dart';
import 'package:foodCourier/providers/type_filter_provider.dart';
import 'package:foodCourier/widgets/filters_screen_widgets/cuisine_filter.dart';
import 'package:foodCourier/widgets/filters_screen_widgets/restrictions_check_list.dart';
import 'package:foodCourier/widgets/filters_screen_widgets/sort_by_radio_list.dart';
import 'package:foodCourier/generated/l10n.dart';

import '../../locator.dart';

GlobalKey _cuisineKey = const GlobalObjectKey('cuisine');
GlobalKey _restrictionKey = const GlobalObjectKey('restriction');
final GlobalKey _showCaseKey = GlobalKey();

final SharedPreferencesClass sharedPreferencesClass =
    locator<SharedPreferencesClass>();

void filterBottomSheet(
    context, Function callbackFun, Function callbackRestriction) {
  sharedPreferencesClass.isFirstTime().then((isFirstTime) => {
        Timer(const Duration(seconds: 1),
            () => ShowCaseWidget.of(context).startShowCase([_showCaseKey]))
      });

  showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(2 * SizeConfig.blockSizeVertical!),
          height: 74 * SizeConfig.blockSizeVertical!,
          alignment: Alignment.center,
          color: whiteColor,
          child: Column(
            children: <Widget>[
              Showcase(
                key: _showCaseKey,
                title: 'Favorite cuisines',
                description: 'click here to set your favorite cuisines',
                child: Container(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    S().filter,
                    //'Filter',
                    style: blackSmallText17,
                  ),
                  GestureDetector(
                    onTap: () async {
                      await Provider.of<TypeFilterProvider>(context,
                              listen: false)
                          .showAll();
                    },
                    child: Text(
                      S().clear,
                      //'Clear',
                      style: oliveSmallText15,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.only(
                    top: 4 * SizeConfig.blockSizeHorizontal!,
                    left: 3 * SizeConfig.blockSizeHorizontal!,
                  ),
                  children: <Widget>[
                    Container(
                      key: _cuisineKey,
                      padding: EdgeInsets.only(
                        bottom: 2 * SizeConfig.blockSizeVertical!,
                      ),
                      child: const CuisineButtonList(),
                    ),
                    Container(
                      key: _restrictionKey,
                      padding: EdgeInsets.only(
                        bottom: 2 * SizeConfig.blockSizeVertical!,
                      ),
                      child: RestrictionsList(callbackRestriction),
                    ),
                    Text(
                      S().sortBy,
                      //'Sort By :',
                      style: blackSmallText17,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 10 * SizeConfig.blockSizeHorizontal!,
                        bottom: 2 * SizeConfig.blockSizeVertical!,
                      ),
                      child: SortByRadioList(callbackFun),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 47 * SizeConfig.blockSizeHorizontal!,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                  child: Text(
                    S().apply,
                    //'Apply',
                    textScaleFactor: 1.0,
                    style: buttonText,
                  ),
                  onPressed: () {
                    //print(Provider.of<AllFiltersProvider>(context).jsonFilters());
                    Navigator.pop(context);
                    //Provider.of<AllFiltersProvider>(context,listen: false).getLabels();
                    //print(Provider.of<AllFiltersProvider>(context,listen: false).jsonFilters());
                    //Navigator.pushNamed(context, 'home');
                  },
                ),
              ),
            ],
          ),
        );
      });
}
