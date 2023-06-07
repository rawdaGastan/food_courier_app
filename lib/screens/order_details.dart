import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:foodCourier/constants/text_styles.dart';
import 'package:foodCourier/constants/colors.dart';
import 'package:foodCourier/controllers/size_config.dart';
import 'package:foodCourier/generated/l10n.dart';
import 'package:foodCourier/widgets/order_screen_widgets/items_list.dart';

class OrderDetailsScreen extends StatefulWidget {
  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  int activeTabIndex = 0;
  int orderRating = 0;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List defaults = ModalRoute.of(context).settings.arguments;
    bool isActiveOrder = defaults[0];

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
          'Order details',
          style: titleText,
        ),
        actions: [
          isActiveOrder
              ? TextButton(
                  child: Text('Cancel', style: saveText),
                  onPressed: () {},
                )
              : IconButton(
                  icon: Icon(Icons.error, color: lightTextColor),
                  onPressed: () {},
                ),
        ],
      ),
      backgroundColor: whiteColor,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(
              horizontal: 3 * SizeConfig.blockSizeVertical,
              vertical: 3 * SizeConfig.blockSizeVertical),
          children: [
            isActiveOrder
                ? Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: secondaryColor,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(18.0),
                          ),
                        ),
                        margin: EdgeInsets.symmetric(
                            horizontal: 2 * SizeConfig.blockSizeHorizontal),
                        padding:
                            EdgeInsets.all(2 * SizeConfig.blockSizeVertical),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.brightness_1,
                                    size: 15 * SizeConfig.blockSizeHorizontal,
                                  ),
                                  color: orangeColor,
                                  onPressed: () => Navigator.pop(context),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: SizeConfig.blockSizeHorizontal,
                                  ),
                                  child: Text('Icon'),
                                ),
                              ],
                            ),
                            Container(
                              width: 60 * SizeConfig.blockSizeHorizontal,
                              padding: EdgeInsets.symmetric(
                                horizontal: 4 * SizeConfig.blockSizeHorizontal,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Order placed',
                                    style: buttonText,
                                  ),
                                  Text(
                                    'We have received your order',
                                    style: deliveryCost,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      DefaultTabController(
                        length: 2,
                        child: Container(
                          color: secondaryColor,
                          height: 8 * SizeConfig.blockSizeVertical,
                          child: TabBar(
                            tabs: [
                              Tab(
                                child: AutoSizeText(
                                  'Modify the order',
                                  maxLines: 1,
                                  style: restaurantBarText,
                                ),
                              ),
                              Tab(
                                child: AutoSizeText(
                                  'Track your order',
                                  maxLines: 1,
                                  style: restaurantBarText,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                            onTap: (index) {
                              setState(() {
                                activeTabIndex = index;
                              });
                              if (index == 1)
                                Navigator.pushNamed(context, 'track order');
                            },
                            isScrollable: false,
                            indicator: BoxDecoration(
                              color: primaryColor,
                            ),
                            indicatorColor: primaryColor,
                            indicatorWeight: 4,
                            labelPadding: EdgeInsets.symmetric(
                                horizontal: 3 * SizeConfig.blockSizeHorizontal),
                          ),
                        ),
                      ),
                      SizedBox(height: SizeConfig.blockSizeVertical),
                      Text(
                        'In this status, You can cancel or modify the order. ',
                        style: mealInfo,
                      ),
                    ],
                  )
                : Column(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'We care about your feedback !',
                        style: rateOrderNotificationDialog,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical,
                      ),
                      AutoSizeText(
                        'Rate this order',
                        style: pickUpTime,
                        textAlign: TextAlign.center,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                              icon: Icon(
                                orderRating >= 1
                                    ? Icons.star
                                    : Icons.star_border,
                                color: orangeColor,
                                size: 10 * SizeConfig.blockSizeHorizontal,
                              ),
                              onPressed: () {
                                setState(() {
                                  orderRating = 1;
                                });
                              }),
                          IconButton(
                              icon: Icon(
                                orderRating >= 2
                                    ? Icons.star
                                    : Icons.star_border,
                                color: orangeColor,
                                size: 10 * SizeConfig.blockSizeHorizontal,
                              ),
                              onPressed: () {
                                setState(() {
                                  orderRating = 2;
                                });
                              }),
                          IconButton(
                              icon: Icon(
                                orderRating >= 3
                                    ? Icons.star
                                    : Icons.star_border,
                                color: orangeColor,
                                size: 10 * SizeConfig.blockSizeHorizontal,
                              ),
                              onPressed: () {
                                setState(() {
                                  orderRating = 3;
                                });
                              }),
                          IconButton(
                              icon: Icon(
                                orderRating >= 4
                                    ? Icons.star
                                    : Icons.star_border,
                                color: orangeColor,
                                size: 10 * SizeConfig.blockSizeHorizontal,
                              ),
                              onPressed: () {
                                setState(() {
                                  orderRating = 4;
                                });
                              }),
                          IconButton(
                              icon: Icon(
                                orderRating == 5
                                    ? Icons.star
                                    : Icons.star_border,
                                color: orangeColor,
                                size: 10 * SizeConfig.blockSizeHorizontal,
                              ),
                              onPressed: () {
                                setState(() {
                                  orderRating = 5;
                                });
                              }),
                        ],
                      ),
                    ],
                  ),
            SizedBox(height: 2 * SizeConfig.blockSizeVertical),
            Text(
              'Order details',
              style: buttonText,
            ),
            SizedBox(height: SizeConfig.blockSizeVertical),
            Container(
              height: 10 * SizeConfig.blockSizeVertical,
              decoration: BoxDecoration(
                border: Border.all(width: 1.0, color: lightTextColor),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        S().delivery,
                        style: mealInfo,
                      ),
                      Text('38 - 48', style: pickUpAndDeliveryTime),
                      Text(
                        'Minutes',
                        style: mealInfo,
                      ),
                    ],
                  ),
                  Container(
                      alignment: Alignment.center,
                      height: 7 * SizeConfig.blockSizeVertical,
                      child: VerticalDivider(
                        thickness: 1,
                        color: lightTextColor,
                      )),
                  Container(
                    width: 60 * SizeConfig.blockSizeHorizontal,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'location',
                          style: mealInfo,
                        ),
                        Text(
                          'Lorem Ipsum is simply dummy text of the printing and typesetting industry',
                          style: pickUpAndDeliveryTime,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: SizeConfig.blockSizeVertical),
            Text(
              'Order',
              style: buttonText,
            ),
            Padding(
              padding: EdgeInsets.only(
                  //top: SizeConfig.blockSizeVertical,
                  bottom: SizeConfig.blockSizeVertical,
                  left: 2 * SizeConfig.blockSizeVertical),
              child: ItemsList(),
            ),
            Container(
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(18.0),
                ),
              ),
              padding: EdgeInsets.all(2 * SizeConfig.blockSizeVertical),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Summery', style: paymentSummary),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 2 * SizeConfig.blockSizeVertical,
                        vertical: SizeConfig.blockSizeVertical),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Subtotal',
                          style: pickUpAndDeliveryTime,
                        ),
                        Text(
                          '15.50 \$',
                          style: pickUpAndDeliveryTime,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 2 * SizeConfig.blockSizeVertical),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Delivery fee',
                          style: pickUpAndDeliveryTime,
                        ),
                        Text(
                          '3.50 \$',
                          style: pickUpAndDeliveryTime,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 2 * SizeConfig.blockSizeVertical,
                        vertical: SizeConfig.blockSizeVertical),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total',
                          style: buttonText,
                        ),
                        Text(
                          '18.50 \$',
                          style: totalPayment,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: SizeConfig.blockSizeVertical),
            Text(
              'Payment',
              style: buttonText,
            ),
            Padding(
              padding: EdgeInsets.only(
                  //top: SizeConfig.blockSizeVertical,
                  bottom: SizeConfig.blockSizeVertical,
                  left: 2 * SizeConfig.blockSizeVertical),
              child: Text(
                'Cash',
                style: pickUpAndDeliveryTime,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
