import 'package:flutter/material.dart';
import 'package:food_courier/constants/colors.dart';
import 'package:food_courier/constants/text_styles.dart';
import 'package:food_courier/controllers/size_config.dart';
import 'package:food_courier/models/meal_value.dart';

class MealDescription extends StatefulWidget {
  final ScrollController _controller;
  final String mealName;
  const MealDescription(this._controller, this.mealName, {Key? key})
      : super(key: key);

  @override
  MealDescriptionState createState() => MealDescriptionState();
}

class MealDescriptionState extends State<MealDescription> {
  List<MealValue> mealValues = [];

  dummyMealValues() {
    mealValues.add(MealValue(
        name: 'Protein', percentage: '10%', quantity: '12g', isPrimary: true));
    mealValues.add(MealValue(
        name: 'Total carbs',
        percentage: '10%',
        quantity: '12g',
        isPrimary: true));
    mealValues.add(MealValue(
        name: 'Total sugars',
        percentage: '10%',
        quantity: '10g',
        isPrimary: true));
    mealValues.add(MealValue(
        name: 'Dietary fiber',
        percentage: '10%',
        quantity: '6g',
        isPrimary: true));
    mealValues.add(MealValue(
        name: 'Sodium',
        percentage: '10%',
        quantity: '112mg',
        isPrimary: false));
    mealValues.add(MealValue(
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
            const Text(
              'macronutrients',
              style: mealSubTitles,
            ),
            SizedBox(
              height: SizeConfig.blockSizeVertical!,
            ),
            Row(
              children: [
                Container(
                  height: 2 * SizeConfig.blockSizeVertical!,
                  width: 30 * SizeConfig.blockSizeHorizontal!,
                  color: orangeColor,
                ),
                Container(
                  height: 2 * SizeConfig.blockSizeVertical!,
                  width: 30 * SizeConfig.blockSizeHorizontal!,
                  color: greyTextColor,
                ),
                Container(
                  height: 2 * SizeConfig.blockSizeVertical!,
                  width: 32 * SizeConfig.blockSizeHorizontal!,
                  color: primaryColor,
                ),
              ],
            ),
            SizedBox(height: SizeConfig.blockSizeVertical!),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      height: 2 * SizeConfig.blockSizeHorizontal!,
                      width: 2 * SizeConfig.blockSizeHorizontal!,
                      decoration: const BoxDecoration(
                        color: orangeColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const Text(
                      ' Carb ',
                      style: mealInfo,
                    ),
                    const Text(
                      '0.3g',
                      style: mealPrice,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      height: 2 * SizeConfig.blockSizeHorizontal!,
                      width: 2 * SizeConfig.blockSizeHorizontal!,
                      decoration: const BoxDecoration(
                        color: greyTextColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const Text(
                      ' Fat ',
                      style: mealInfo,
                    ),
                    const Text(
                      '0.3g',
                      style: mealPrice,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      height: 2 * SizeConfig.blockSizeHorizontal!,
                      width: 2 * SizeConfig.blockSizeHorizontal!,
                      decoration: const BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const Text(
                      ' Protein ',
                      style: mealInfo,
                    ),
                    const Text(
                      '0.3g',
                      style: mealPrice,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.blockSizeVertical!,
            ),
            const Row(
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
            const Text(
              'Nutritional Info',
              style: mealSubTitles,
            ),
            SizedBox(
              height: SizeConfig.blockSizeVertical!,
            ),
            Container(
              height: 8 * SizeConfig.blockSizeVertical!,
              padding: EdgeInsets.symmetric(
                  horizontal: 3 * SizeConfig.blockSizeHorizontal!),
              decoration: const BoxDecoration(
                color: secondaryColor,
                border: Border(
                  top: BorderSide(color: blackColor, width: 1.0),
                  left: BorderSide(color: blackColor, width: 1.0),
                  right: BorderSide(color: blackColor, width: 1.0),
                ),
              ),
              child: const Row(
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
              height: 6 * SizeConfig.blockSizeVertical!,
              padding: EdgeInsets.symmetric(
                  horizontal: 3 * SizeConfig.blockSizeHorizontal!),
              decoration: const BoxDecoration(
                color: secondaryColor,
                border: Border(
                  top: BorderSide(color: blackColor, width: 3.0),
                  left: BorderSide(color: blackColor, width: 1.0),
                  right: BorderSide(color: blackColor, width: 1.0),
                ),
              ),
              child: const Column(
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
                  horizontal: 3 * SizeConfig.blockSizeHorizontal!),
              decoration: const BoxDecoration(
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
                  return SizedBox(
                    height: 6 * SizeConfig.blockSizeVertical!,
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
                              const Icon(Icons.keyboard_arrow_up),
                            ],
                          ),
                        ),
                        const Align(
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
              height: 10 * SizeConfig.blockSizeVertical!,
              padding: EdgeInsets.symmetric(
                  horizontal: 3 * SizeConfig.blockSizeHorizontal!),
              decoration: const BoxDecoration(
                color: secondaryColor,
                border: Border(
                  bottom: BorderSide(color: blackColor, width: 1.0),
                  left: BorderSide(color: blackColor, width: 1.0),
                  right: BorderSide(color: blackColor, width: 1.0),
                ),
              ),
              child: const Row(
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
