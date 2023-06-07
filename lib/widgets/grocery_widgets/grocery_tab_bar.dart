import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:foodCourier/constants/colors.dart';
import 'package:foodCourier/constants/text_styles.dart';
import 'package:foodCourier/controllers/size_config.dart';

class GroceryTabBar extends StatefulWidget {
  @override
  _GroceryTabBarState createState() => _GroceryTabBarState();
}

class _GroceryTabBarState extends State<GroceryTabBar> {
  List<String> categories = [
    'Fruits & Vegetables',
    'Fruits & Vegetables',
    'Fruits & Vegetables',
    'Fruits & Vegetables'
  ];
  bool showMenu = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(
            left: 12 * SizeConfig.blockSizeHorizontal!,
            top: 2 * SizeConfig.blockSizeVertical!,
          ),
          child: DefaultTabController(
            length: categories.length,
            child: Container(
              decoration: BoxDecoration(
                color: whiteColor,
                boxShadow: [
                  BoxShadow(
                    color: secondaryColor,
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 2), // changes position of shadow
                  ),
                ],
              ),
              height: 7 * SizeConfig.blockSizeVertical!,
              child: TabBar(
                tabs: [
                  for (int i = 0; i < categories.length; i++)
                    Tab(
                      child: AutoSizeText(
                        categories[i],
                        maxLines: 1,
                        style: restaurantBarText,
                      ),
                    ),
                ],
                isScrollable: true,
                indicatorColor: primaryColor,
                indicatorWeight: 4,
                labelPadding: EdgeInsets.symmetric(
                    horizontal: 3 * SizeConfig.blockSizeHorizontal!),
              ),
            ),
          ),
        ),
        Container(
          height: 7 * SizeConfig.blockSizeVertical!,
          width: 12 * SizeConfig.blockSizeHorizontal!,
          color: whiteColor,
          margin: EdgeInsets.only(
            top: 2 * SizeConfig.blockSizeVertical!,
          ),
          child: IconButton(
              icon: Icon(Icons.menu, color: primaryColor),
              onPressed: () {
                setState(() {
                  showMenu = !showMenu;
                });
              }),
        ),
        Visibility(
          visible: showMenu,
          child: Container(
            height: 7 * categories.length * SizeConfig.blockSizeVertical!,
            margin: EdgeInsets.only(
              top: 9 * SizeConfig.blockSizeVertical!,
              left: 2 * SizeConfig.blockSizeHorizontal!,
              right: 2 * SizeConfig.blockSizeHorizontal!,
            ),
            child: Expanded(
              child: ListView.builder(
                itemBuilder: (_, index) => GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.only(
                      top: 2 * SizeConfig.blockSizeVertical!,
                      left: 3 * SizeConfig.blockSizeHorizontal!,
                      right: 3 * SizeConfig.blockSizeHorizontal!,
                    ),
                    color: secondaryColor,
                    height: 7 * SizeConfig.blockSizeVertical!,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          categories[index],
                          style: restaurantBarText.copyWith(
                              fontWeight: FontWeight.normal),
                        ),
                        Text(
                          '2 items',
                          style: groceryStoreLocation,
                        ),
                      ],
                    ),
                  ),
                ),
                itemCount: categories.length,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
