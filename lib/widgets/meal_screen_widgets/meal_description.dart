import 'package:flutter/material.dart';
import 'package:foodCourier/constants/colors.dart';
import 'package:foodCourier/constants/text_styles.dart';
import 'package:foodCourier/controllers/size_config.dart';
import 'package:foodCourier/models/meal_value.dart';

class MealDescription extends StatefulWidget {
  final ScrollController _controller;
  final String mealName;
  MealDescription(this._controller, this.mealName);

  @override
  _MealDescriptionState createState() => _MealDescriptionState();
}

class _MealDescriptionState extends State<MealDescription> {
  List<MealValue> mealValues = [];

  dummyMealValues() {
    mealValues.add(new MealValue(
        name: 'Protien', percentage: '10%', quantity: '12g', isPrimary: true));
    mealValues.add(new MealValue(
        name: 'Total carbs',
        percentage: '10%',
        quantity: '12g',
        isPrimary: true));
    mealValues.add(new MealValue(
        name: 'Total sugars',
        percentage: '10%',
        quantity: '10g',
        isPrimary: true));
    mealValues.add(new MealValue(
        name: 'Dietary fiber',
        percentage: '10%',
        quantity: '6g',
        isPrimary: true));
    mealValues.add(new MealValue(
        name: 'Sodium',
        percentage: '10%',
        quantity: '112mg',
        isPrimary: false));
    mealValues.add(new MealValue(
        name: 'Cholestrol',
        percentage: '10%',
        quantity: '70mg',
        isPrimary: false));
  }

  @override
  void initState() {
    super.initState();
    dummyMealValues();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView(
          controller: widget._controller,
          children: [
            Text(
              'macronutrients',
              style: mealSubTitles,
            ),
            SizedBox(
              height: SizeConfig.blockSizeVertical,
            ),
            Row(
              children: [
                Container(
                  height: 2 * SizeConfig.blockSizeVertical,
                  width: 30 * SizeConfig.blockSizeHorizontal,
                  color: orangeColor,
                ),
                Container(
                  height: 2 * SizeConfig.blockSizeVertical,
                  width: 30 * SizeConfig.blockSizeHorizontal,
                  color: greyTextColor,
                ),
                Container(
                  height: 2 * SizeConfig.blockSizeVertical,
                  width: 32 * SizeConfig.blockSizeHorizontal,
                  color: primaryColor,
                ),
              ],
            ),
            SizedBox(height: SizeConfig.blockSizeVertical),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      height: 2 * SizeConfig.blockSizeHorizontal,
                      width: 2 * SizeConfig.blockSizeHorizontal,
                      decoration: new BoxDecoration(
                        color: orangeColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Text(
                      ' Carb ',
                      style: mealInfo,
                    ),
                    Text(
                      '0.3g',
                      style: mealPrice,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      height: 2 * SizeConfig.blockSizeHorizontal,
                      width: 2 * SizeConfig.blockSizeHorizontal,
                      decoration: new BoxDecoration(
                        color: greyTextColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Text(
                      ' Fat ',
                      style: mealInfo,
                    ),
                    Text(
                      '0.3g',
                      style: mealPrice,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      height: 2 * SizeConfig.blockSizeHorizontal,
                      width: 2 * SizeConfig.blockSizeHorizontal,
                      decoration: new BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Text(
                      ' Protien ',
                      style: mealInfo,
                    ),
                    Text(
                      '0.3g',
                      style: mealPrice,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.blockSizeVertical,
            ),
            Row(
              children: [
                Icon(
                  Icons.error_outline,
                  color: lightTextColor,
                ),
                Text(
                  '  Lorem Ipsum is simply dummy text.',
                  style: mealInfo,
                ),
              ],
            ),
            Text(
              'Nutritional Info',
              style: mealSubTitles,
            ),
            SizedBox(
              height: SizeConfig.blockSizeVertical,
            ),
            Container(
              height: 8 * SizeConfig.blockSizeVertical,
              padding: EdgeInsets.symmetric(
                  horizontal: 3 * SizeConfig.blockSizeHorizontal),
              decoration: BoxDecoration(
                color: secondaryColor,
                border: Border(
                  top: BorderSide(color: blackColor, width: 1.0),
                  left: BorderSide(color: blackColor, width: 1.0),
                  right: BorderSide(color: blackColor, width: 1.0),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    'Calories         ',
                    style: caloriesTitle,
                  ),
                  Text(
                    '250',
                    style: caloriesTitle,
                  ),
                ],
              ),
            ),
            Container(
              height: 6 * SizeConfig.blockSizeVertical,
              padding: EdgeInsets.symmetric(
                  horizontal: 3 * SizeConfig.blockSizeHorizontal),
              decoration: BoxDecoration(
                color: secondaryColor,
                border: Border(
                  top: BorderSide(color: blackColor, width: 3.0),
                  left: BorderSide(color: blackColor, width: 1.0),
                  right: BorderSide(color: blackColor, width: 1.0),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '% Daily values ',
                    style: subTitleText,
                  ),
                  Divider(),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: 3 * SizeConfig.blockSizeHorizontal),
              decoration: BoxDecoration(
                color: secondaryColor,
                border: Border(
                  left: BorderSide(color: blackColor, width: 1.0),
                  right: BorderSide(color: blackColor, width: 1.0),
                ),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: mealValues.length,
                itemBuilder: (context, index) {
                  return Container(
                    height: 6 * SizeConfig.blockSizeVertical,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            mealValues[index].name,
                            style: mealValuesInfo,
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            mealValues[index].quantity,
                            style: mealValuesInfo,
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                mealValues[index].percentage,
                                style: mealValuesInfo,
                              ),
                              Icon(Icons.keyboard_arrow_up),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Divider(),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Container(
              height: 10 * SizeConfig.blockSizeVertical,
              padding: EdgeInsets.symmetric(
                  horizontal: 3 * SizeConfig.blockSizeHorizontal),
              decoration: BoxDecoration(
                color: secondaryColor,
                border: Border(
                  bottom: BorderSide(color: blackColor, width: 1.0),
                  left: BorderSide(color: blackColor, width: 1.0),
                  right: BorderSide(color: blackColor, width: 1.0),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: lightTextColor),
                  Text(
                    '  Lorem Ipsum is simply dummy text.',
                    style: mealInfo,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
