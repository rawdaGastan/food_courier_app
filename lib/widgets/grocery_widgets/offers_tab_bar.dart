import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:foodCourier/constants/colors.dart';
import 'package:foodCourier/constants/text_styles.dart';
import 'package:foodCourier/controllers/size_config.dart';

class OffersTabBar extends StatefulWidget {
  const OffersTabBar({Key? key}) : super(key: key);

  @override
  TabBarState createState() => TabBarState();
}

class TabBarState extends State<OffersTabBar> {
  List<String> offers = [
    'Up 50% off',
    'Up 20% off',
    'New Price',
    'Free Delivery'
  ];
  bool showOffersMenu = false;

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
            length: offers.length,
            child: Container(
              decoration: const BoxDecoration(
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
                  for (int i = 0; i < offers.length; i++)
                    Tab(
                      child: AutoSizeText(
                        offers[i],
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
              icon: const Icon(Icons.menu, color: primaryColor),
              onPressed: () {
                setState(() {
                  showOffersMenu = !showOffersMenu;
                });
              }),
        ),
        Visibility(
          visible: showOffersMenu,
          child: Container(
            height: 7 * offers.length * SizeConfig.blockSizeVertical!,
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
                          offers[index],
                          style: restaurantBarText.copyWith(
                              fontWeight: FontWeight.normal),
                        ),
                        const Text(
                          '2 items',
                          style: groceryStoreLocation,
                        ),
                      ],
                    ),
                  ),
                ),
                itemCount: offers.length,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
