import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:foodCourier/constants/text_styles.dart';
import 'package:foodCourier/constants/colors.dart';
import 'package:foodCourier/controllers/size_config.dart';
import 'package:foodCourier/widgets/wish_list_widget/meals_wish_list.dart';
import 'package:foodCourier/widgets/wish_list_widget/restaurant_wish_list.dart';
import 'package:foodCourier/widgets/wish_list_widget/stores_wish_list.dart';
import 'package:foodCourier/generated/l10n.dart';

class WishList extends StatefulWidget {
  @override
  _WishListState createState() => _WishListState();
}

class _WishListState extends State<WishList> {
  final ScrollController _controller = ScrollController();
  int selectedIndexOfBottomBar;
  bool gotIndexFromNavigationBar = false;
  Function callbackNavigationBottomBar;

  void _onItemTapped(int index) {
    setState(() {
      selectedIndexOfBottomBar = index;
    });
    Navigator.pop(context);
    Navigator.pop(context);
    callbackNavigationBottomBar(index);
  }

  @override
  Widget build(BuildContext context) {
    List defaults = ModalRoute.of(context).settings.arguments;
    if (!gotIndexFromNavigationBar) {
      selectedIndexOfBottomBar = defaults[0];
      callbackNavigationBottomBar = defaults[1];
      gotIndexFromNavigationBar = !gotIndexFromNavigationBar;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: whiteColor,
        leading: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: blackColor,
            size: 6 * SizeConfig.blockSizeHorizontal,
          ),
        ),
        centerTitle: true,
        title: Text(
          S().wishList,
          style: titleText,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: whiteColor,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            activeIcon: Image.asset(
              'assets/icons/delivery.png',
              width: 8 * SizeConfig.blockSizeHorizontal,
            ),
            icon: Image.asset(
              'assets/icons/delivery.png',
              color: lightTextColor,
              width: 8 * SizeConfig.blockSizeHorizontal,
            ),
            //icon: Icon(Icons.delivery_dining),
            label: S().delivery,
            //'Delivery',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_grocery_store),
            label: S().grocery,
            //'Grocery',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.room_service),
            label: S().dineOut,
            //'Dineout',
          ),
        ],
        currentIndex: selectedIndexOfBottomBar,
        selectedItemColor: primaryColor,
        unselectedItemColor: lightTextColor,
        onTap: _onItemTapped,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _controller,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                //height: 80 * SizeConfig.blockSizeVertical,
                height: 85 * SizeConfig.blockSizeVertical,
                width: double.infinity,
                child: DefaultTabController(
                  length: 3,
                  child: Column(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          color: whiteColor,
                          boxShadow: [
                            BoxShadow(
                              color: shadow,
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 2), // changes position of shadow
                            ),
                          ],
                        ),
                        child: TabBar(
                          tabs: [
                            Tab(
                              child: AutoSizeText(
                                S().restaurant,
                                //'Restaurant',
                                maxLines: 1,
                                style: buttonText,
                              ),
                            ),
                            Tab(
                              child: AutoSizeText(
                                'Stores',
                                //'Meal',
                                maxLines: 1,
                                style: buttonText,
                              ),
                            ),
                            Tab(
                              child: AutoSizeText(
                                S().meal,
                                //'Meal',
                                maxLines: 1,
                                style: buttonText,
                              ),
                            ),
                          ],
                          isScrollable: false,
                          indicatorColor: primaryColor,
                          indicatorWeight: 5,
                          labelPadding: EdgeInsets.symmetric(
                              horizontal: 7 * SizeConfig.blockSizeHorizontal),
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          children: <Widget>[
                            RestaurantWishList(),
                            StoreWishList(),
                            MealsWishList(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}