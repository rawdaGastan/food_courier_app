import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:foodCourier/constants/colors.dart';
import 'package:foodCourier/constants/decorations.dart';
import 'package:foodCourier/constants/text_styles.dart';
import 'package:foodCourier/controllers/size_config.dart';
import 'package:foodCourier/models/meal_value.dart';

class MealReview extends StatefulWidget {
  final ScrollController _controller;
  String mealName;

  MealReview(this._controller, this.mealName, {Key? key}) : super(key: key);

  @override
  MealReviewState createState() => MealReviewState();
}

class MealReviewState extends State<MealReview> {
  int rateByUser = 0;
  List<MealValue> mealValues = [];

  String reviewText = '';
  final inputController = TextEditingController();

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
              'Rate and Review (16)',
              style: mealSubTitles,
            ),
            SizedBox(
              height: 2 * SizeConfig.blockSizeVertical!,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Text('4.5', style: bigRatingText),
                        Text('/5', style: distanceAndRatingText),
                      ],
                    ),
                    SizedBox(
                      height: 1 * SizeConfig.blockSizeVertical!,
                    ),
                    const Text(
                      '30 Reviews',
                      style: mealInfo,
                    ),
                    SizedBox(
                      height: 1 * SizeConfig.blockSizeVertical!,
                    ),
                    const Text(
                      '400 Votes',
                      style: mealInfo,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: orangeColor,
                          size: 15,
                        ),
                        const Icon(
                          Icons.star,
                          color: orangeColor,
                          size: 15,
                        ),
                        const Icon(
                          Icons.star,
                          color: orangeColor,
                          size: 15,
                        ),
                        const Icon(
                          Icons.star,
                          color: orangeColor,
                          size: 15,
                        ),
                        const Icon(
                          Icons.star,
                          color: orangeColor,
                          size: 15,
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              left: 1 * SizeConfig.blockSizeHorizontal!),
                          height: 1 * SizeConfig.blockSizeVertical!,
                          width: 30 * SizeConfig.blockSizeHorizontal!,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                bottomLeft: Radius.circular(10.0)),
                            color: orangeColor,
                          ),
                        ),
                        Container(
                          height: 1 * SizeConfig.blockSizeVertical!,
                          width: 10 * SizeConfig.blockSizeHorizontal!,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10.0),
                                bottomRight: Radius.circular(10.0)),
                            color: lightTextColor,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: orangeColor,
                          size: 15,
                        ),
                        const Icon(
                          Icons.star,
                          color: orangeColor,
                          size: 15,
                        ),
                        const Icon(
                          Icons.star,
                          color: orangeColor,
                          size: 15,
                        ),
                        const Icon(
                          Icons.star,
                          color: orangeColor,
                          size: 15,
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              left: 1 * SizeConfig.blockSizeHorizontal!),
                          height: 1 * SizeConfig.blockSizeVertical!,
                          width: 30 * SizeConfig.blockSizeHorizontal!,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                bottomLeft: Radius.circular(10.0)),
                            color: orangeColor,
                          ),
                        ),
                        Container(
                          height: 1 * SizeConfig.blockSizeVertical!,
                          width: 10 * SizeConfig.blockSizeHorizontal!,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10.0),
                                bottomRight: Radius.circular(10.0)),
                            color: lightTextColor,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: orangeColor,
                          size: 15,
                        ),
                        const Icon(
                          Icons.star,
                          color: orangeColor,
                          size: 15,
                        ),
                        const Icon(
                          Icons.star,
                          color: orangeColor,
                          size: 15,
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              left: 1 * SizeConfig.blockSizeHorizontal!),
                          height: 1 * SizeConfig.blockSizeVertical!,
                          width: 30 * SizeConfig.blockSizeHorizontal!,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                bottomLeft: Radius.circular(10.0)),
                            color: orangeColor,
                          ),
                        ),
                        Container(
                          height: 1 * SizeConfig.blockSizeVertical!,
                          width: 10 * SizeConfig.blockSizeHorizontal!,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10.0),
                                bottomRight: Radius.circular(10.0)),
                            color: lightTextColor,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: orangeColor,
                          size: 15,
                        ),
                        const Icon(
                          Icons.star,
                          color: orangeColor,
                          size: 15,
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              left: 1 * SizeConfig.blockSizeHorizontal!),
                          height: 1 * SizeConfig.blockSizeVertical!,
                          width: 30 * SizeConfig.blockSizeHorizontal!,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                bottomLeft: Radius.circular(10.0)),
                            color: orangeColor,
                          ),
                        ),
                        Container(
                          height: 1 * SizeConfig.blockSizeVertical!,
                          width: 10 * SizeConfig.blockSizeHorizontal!,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10.0),
                                bottomRight: Radius.circular(10.0)),
                            color: lightTextColor,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: orangeColor,
                          size: 15,
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              left: 1 * SizeConfig.blockSizeHorizontal!),
                          height: 1 * SizeConfig.blockSizeVertical!,
                          width: 30 * SizeConfig.blockSizeHorizontal!,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                bottomLeft: Radius.circular(10.0)),
                            color: orangeColor,
                          ),
                        ),
                        Container(
                          height: 1 * SizeConfig.blockSizeVertical!,
                          width: 10 * SizeConfig.blockSizeHorizontal!,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10.0),
                                bottomRight: Radius.circular(10.0)),
                            color: lightTextColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: SizeConfig.blockSizeVertical!),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tap to Rate:',
                  style: mealInfo,
                ),
                Row(
                  children: [
                    IconButton(
                        icon: Icon(
                            rateByUser >= 1 ? Icons.star : Icons.star_border,
                            color: orangeColor),
                        onPressed: () {
                          setState(() {
                            rateByUser = 1;
                          });
                        }),
                    IconButton(
                        icon: Icon(
                            rateByUser >= 2 ? Icons.star : Icons.star_border,
                            color: orangeColor),
                        onPressed: () {
                          setState(() {
                            rateByUser = 2;
                          });
                        }),
                    IconButton(
                        icon: Icon(
                            rateByUser >= 3 ? Icons.star : Icons.star_border,
                            color: orangeColor),
                        onPressed: () {
                          setState(() {
                            rateByUser = 3;
                          });
                        }),
                    IconButton(
                        icon: Icon(
                            rateByUser >= 4 ? Icons.star : Icons.star_border,
                            color: orangeColor),
                        onPressed: () {
                          setState(() {
                            rateByUser = 4;
                          });
                        }),
                    IconButton(
                        icon: Icon(
                            rateByUser == 5 ? Icons.star : Icons.star_border,
                            color: orangeColor),
                        onPressed: () {
                          setState(() {
                            rateByUser = 5;
                          });
                        }),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 1 * SizeConfig.blockSizeVertical!,
            ),
            Row(
              children: [
                const Icon(
                  Icons.add_comment,
                  color: greyTextColor87,
                ),
                SizedBox(width: SizeConfig.blockSizeHorizontal!),
                const Text(
                  'Write a Review',
                  style: mealSubTitles,
                ),
              ],
            ),
            SizedBox(
              height: 1 * SizeConfig.blockSizeVertical!,
            ),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: 3 * SizeConfig.blockSizeHorizontal!),
              color: secondaryColor,
              height: 10 * SizeConfig.blockSizeVertical!,
              margin: EdgeInsets.only(bottom: SizeConfig.blockSizeVertical!),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.all(SizeConfig.blockSizeHorizontal!),
                        child: CircleAvatar(
                          radius: 3 * SizeConfig.blockSizeVertical!,
                          backgroundImage: const AssetImage(
                            'assets/icons/temp.png',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5 * SizeConfig.blockSizeVertical!,
                        width: 60 * SizeConfig.blockSizeHorizontal!,
                        child: TextFormField(
                          cursorColor: whiteColor,
                          controller: inputController,
                          onChanged: (value) {
                            reviewText = value;
                          },
                          style: fillFieldText,
                          decoration: kReviewTextFieldDecoration,
                        ),
                      ),
                    ],
                  ),
                  RichText(
                      text: TextSpan(
                    text: 'Post',
                    style: saveText,
                    recognizer: TapGestureRecognizer()..onTap = () {},
                  )),
                ],
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(bottom: 6 * SizeConfig.blockSizeVertical!),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 3 * SizeConfig.blockSizeHorizontal!),
                    color: secondaryColor,
                    height: 15 * SizeConfig.blockSizeVertical!,
                    margin:
                        EdgeInsets.only(bottom: SizeConfig.blockSizeVertical!),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(
                                      SizeConfig.blockSizeHorizontal!),
                                  child: CircleAvatar(
                                    radius: 3 * SizeConfig.blockSizeVertical!,
                                    backgroundImage: const AssetImage(
                                      'assets/icons/temp.png',
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 1 *
                                              SizeConfig.blockSizeHorizontal!),
                                      child: const AutoSizeText(
                                        'Noor ALshaer',
                                        style: RestaurantDescription,
                                      ),
                                    ),
                                    const Row(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: orangeColor,
                                          size: 15,
                                        ),
                                        Icon(
                                          Icons.star,
                                          color: orangeColor,
                                          size: 15,
                                        ),
                                        Icon(
                                          Icons.star,
                                          color: orangeColor,
                                          size: 15,
                                        ),
                                        Icon(
                                          Icons.star,
                                          color: orangeColor,
                                          size: 15,
                                        ),
                                        Icon(
                                          Icons.star,
                                          color: orangeColor,
                                          size: 15,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const AutoSizeText(
                              '30Dec 2020',
                              style: mealInfo,
                            ),
                          ],
                        ),
                        const AutoSizeText(
                          'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
                          style: RestaurantDescription,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
