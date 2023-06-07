import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:foodCourier/constants/colors.dart';
import 'package:foodCourier/constants/text_styles.dart';
import 'package:foodCourier/controllers/size_config.dart';
import 'package:foodCourier/providers/authentication_provider.dart';
import 'package:foodCourier/providers/order_provider.dart';

import '../../main.dart';

class CheckOut extends StatefulWidget {
  @override
  _CheckOutState createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  int paymentIndex = 0;
  @override
  void initState() {
    super.initState();
  }

  setPayment(String paymentMethod) async {
    String userToken =
        await Provider.of<AuthenticationProvider>(context, listen: false)
            .userToken;
    if (userToken != null) {
      await Provider.of<OrderProvider>(context, listen: false)
          .setPaymentMethod(userToken, paymentMethod);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: 2 * SizeConfig.blockSizeVertical,
          right: 3 * SizeConfig.blockSizeVertical),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Check out',
            style: buttonText,
          ),
          Padding(
            padding: EdgeInsets.only(
              top: SizeConfig.blockSizeVertical,
              left: 3 * SizeConfig.blockSizeVertical,
            ),
            child: Text(
              "Payment Method",
              style: pickUpAndDeliveryTime,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 0.5 * SizeConfig.blockSizeVertical,
              bottom: SizeConfig.blockSizeVertical,
              left: SizeConfig.blockSizeVertical,
            ),
            child: DefaultTabController(
              length: foodCourier().remoteConfigService.paymentFeature ? 2 : 1,
              child: Container(
                decoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
                height: 6 * SizeConfig.blockSizeVertical,
                child: TabBar(
                  tabs: foodCourier().remoteConfigService.paymentFeature
                      ? [
                          Tab(
                            child: AutoSizeText(
                              'Credit card',
                              maxLines: 1,
                              style: restaurantBarText,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Tab(
                            child: AutoSizeText(
                              'Cash',
                              maxLines: 1,
                              style: restaurantBarText,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ]
                      : [
                          Tab(
                            child: AutoSizeText(
                              'Cash',
                              maxLines: 1,
                              style: restaurantBarText,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                  onTap: (index) {
                    setState(() {
                      foodCourier().remoteConfigService.paymentFeature
                          ? (index == 0)
                              ? setPayment('Credit card')
                              : setPayment('Cash')
                          : setPayment('Cash');
                      paymentIndex = index;
                    });
                  },
                  isScrollable: false,
                  indicator: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  ),
                  indicatorColor: primaryColor,
                  indicatorWeight: 4,
                  labelPadding: EdgeInsets.symmetric(
                      horizontal: 3 * SizeConfig.blockSizeHorizontal),
                ),
              ),
            ),
          ),
          foodCourier().remoteConfigService.paymentFeature
              ? (paymentIndex == 0)
                  ? Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2 * SizeConfig.blockSizeVertical),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Card number',
                                style: pickUpAndDeliveryTime,
                              ),
                              SizedBox(height: SizeConfig.blockSizeVertical),
                              TextFormField(
                                onChanged: (String input) {},
                                textAlign: TextAlign.left,
                                style: fillFieldText,
                                decoration: InputDecoration(
                                  hintText: '.... ..... .....',
                                  hintStyle: fieldText,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        new BorderSide(color: lightTextColor),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        new BorderSide(color: primaryColor),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  contentPadding: EdgeInsets.fromLTRB(
                                      10.0, 10.0, 20.0, 10.0),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              width: 25 * SizeConfig.blockSizeHorizontal,
                              padding: EdgeInsets.symmetric(
                                  vertical: SizeConfig.blockSizeVertical,
                                  horizontal: 2 * SizeConfig.blockSizeVertical),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Exp',
                                    style: pickUpAndDeliveryTime,
                                  ),
                                  SizedBox(
                                      height: SizeConfig.blockSizeVertical),
                                  TextFormField(
                                    onChanged: (String input) {},
                                    textAlign: TextAlign.left,
                                    style: fillFieldText,
                                    decoration: InputDecoration(
                                      hintText: 'mm',
                                      hintStyle: fieldText,
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: new BorderSide(
                                            color: lightTextColor),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            new BorderSide(color: primaryColor),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      contentPadding: EdgeInsets.fromLTRB(
                                          10.0, 10.0, 20.0, 10.0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: 4 * SizeConfig.blockSizeVertical),
                              child: Text(
                                '/',
                                style: pickUpAndDeliveryTime,
                              ),
                            ),
                            Container(
                              width: 25 * SizeConfig.blockSizeHorizontal,
                              margin: EdgeInsets.only(
                                  top: 4 * SizeConfig.blockSizeVertical),
                              padding: EdgeInsets.symmetric(
                                  vertical: SizeConfig.blockSizeVertical,
                                  horizontal: 2 * SizeConfig.blockSizeVertical),
                              child: TextFormField(
                                onChanged: (String input) {},
                                textAlign: TextAlign.left,
                                style: fillFieldText,
                                decoration: InputDecoration(
                                  hintText: 'yy',
                                  hintStyle: fieldText,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        new BorderSide(color: lightTextColor),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        new BorderSide(color: primaryColor),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  contentPadding: EdgeInsets.fromLTRB(
                                      10.0, 10.0, 20.0, 10.0),
                                ),
                              ),
                            ),
                            Container(
                              width: 30 * SizeConfig.blockSizeHorizontal,
                              padding: EdgeInsets.symmetric(
                                  vertical: SizeConfig.blockSizeVertical,
                                  horizontal: 2 * SizeConfig.blockSizeVertical),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'CVC',
                                    style: pickUpAndDeliveryTime,
                                  ),
                                  SizedBox(
                                      height: SizeConfig.blockSizeVertical),
                                  TextFormField(
                                    onChanged: (String input) {},
                                    textAlign: TextAlign.left,
                                    style: fillFieldText,
                                    decoration: InputDecoration(
                                      hintText: '...',
                                      hintStyle: fieldText,
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: new BorderSide(
                                            color: lightTextColor),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            new BorderSide(color: primaryColor),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      contentPadding: EdgeInsets.fromLTRB(
                                          10.0, 10.0, 20.0, 10.0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : Container()
              : Container()
        ],
      ),
    );
  }
}
