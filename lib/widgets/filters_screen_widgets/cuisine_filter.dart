import 'package:flutter/material.dart';
import 'package:foodCourier/models/type_filter.dart';

import '../../main.dart';
import 'cuisine_filter_button.dart';

String cuisineListString = FoodCourier().remoteConfigService.cuisinesList;
List<String> cuisineList = cuisineListString.split(',');

final List<TypeFilter> restrictByList = [
  for (int i = 0; i < cuisineList.length; i++)
    TypeFilter(cuisineList[i], false),
];

class CuisineButtonList extends StatelessWidget {
  const CuisineButtonList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const ScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: MediaQuery.of(context).size.width /
            (MediaQuery.of(context).size.height / 5),
      ),
      itemBuilder: (_, index) => Row(
        children: <Widget>[
          CuisineFilterButton(
            typeFilter: restrictByList[index],
          ),
        ],
      ),
      itemCount: restrictByList.length,
      shrinkWrap: true,
    );
  }
}
