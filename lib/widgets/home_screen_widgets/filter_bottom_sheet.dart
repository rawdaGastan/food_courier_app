import 'dart:async';

import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:provider/provider.dart';
import 'package:foodCourier/constants/text_styles.dart';
import 'package:foodCourier/constants/colors.dart';
import 'package:foodCourier/controllers/sharedPreferences.dart';
import 'package:foodCourier/controllers/size_config.dart';
import 'package:foodCourier/providers/type_filter_provider.dart';
import 'package:foodCourier/widgets/filters_screen_widgets/cuisine_filter.dart';
import 'package:foodCourier/widgets/filters_screen_widgets/restrictions_check_list.dart';
import 'package:foodCourier/widgets/filters_screen_widgets/sort_by_radio_list.dart';
import 'package:foodCourier/generated/l10n.dart';

import '../../locator.dart';

GlobalKey _cuisineKey = GlobalObjectKey("cuisine");
GlobalKey _restrictionKey = GlobalObjectKey("restriction");
final SharedPreferencesClass sharedPreferencesClass =
    locator<SharedPreferencesClass>();

void showCoachMarkFAB() async {
  CoachMark coachMarkFAB = CoachMark();
  RenderBox target = _cuisineKey.currentContext.findRenderObject();
  Rect markRect = target.localToGlobal(Offset.zero) & target.size;
  markRect = markRect.inflate(5.0);

  await sharedPreferencesClass.isFirstTime().then((isFirstTime) => {
        (isFirstTime)
            ? coachMarkFAB.show(
                targetContext: _cuisineKey.currentContext,
                markRect: markRect,
                markShape: BoxShape.rectangle,
                children: [
                  Positioned(
                      top: markRect.top - (10 * SizeConfig.blockSizeVertical!),
                      right: 5 * SizeConfig.blockSizeHorizontal!,
                      left: 5 * SizeConfig.blockSizeHorizontal!,
                      child: Text(
                        "click here to set your favourite cuisines",
                        style: const TextStyle(
                          fontSize: 24.0,
                          color: whiteColor,
                        ),
                        textAlign: TextAlign.center,
                      ))
                ],
                duration: null,
                onClose: () {
                  Timer(Duration(seconds: 3), () => showCoachMarkTile());
                })
            : null
      });
}

void showCoachMarkTile() {
  CoachMark coachMarkTile = CoachMark();
  RenderBox target = _restrictionKey.currentContext.findRenderObject();

  Rect markRect = target.localToGlobal(Offset.zero) & target.size;
  markRect = markRect.inflate(5.0);

  coachMarkTile.show(
    targetContext: _restrictionKey.currentContext,
    markRect: markRect,
    markShape: BoxShape.rectangle,
    children: [
      Positioned(
          top: markRect.bottom + 15.0,
          right: 2 * SizeConfig.blockSizeHorizontal!,
          left: 2 * SizeConfig.blockSizeHorizontal!,
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

void filterBottomSheet(
    context, Function callbackFun, Function callbackRestriction) {
  Timer(Duration(seconds: 1), () => showCoachMarkFAB());
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    S().filter,
                    //'Filter',
                    style: blackSmallText17,
                  ),
                  new GestureDetector(
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
                      child: CuisineButtonList(),
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
              Container(
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
