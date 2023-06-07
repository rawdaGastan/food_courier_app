import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:foodCourier/constants/text_styles.dart';
import 'package:foodCourier/constants/colors.dart';
import 'package:foodCourier/controllers/size_config.dart';
import 'package:foodCourier/generated/l10n.dart';
import 'package:foodCourier/models/cart.dart';
import 'package:foodCourier/providers/authentication_provider.dart';
import 'package:foodCourier/providers/order_provider.dart';
import 'package:foodCourier/widgets/authentication_screens_widgets/main_button.dart';
import 'package:foodCourier/widgets/order_screen_widgets/items_list.dart';

class OrderCheckout extends StatefulWidget {
  @override
  _OrderCheckoutState createState() => _OrderCheckoutState();
}

class _OrderCheckoutState extends State<OrderCheckout> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  StreamController _streamController;
  Stream _stream;

  @override
  void initState() {
    super.initState();
    _streamController = StreamController.broadcast();
    _stream = _streamController.stream;
    Future.delayed(Duration.zero, this.getCart);
  }

  getCart() async {
    String userToken =
        await Provider.of<AuthenticationProvider>(context, listen: false)
            .userToken;
    if (userToken != null) {
      _streamController.add(
          await Provider.of<OrderProvider>(context, listen: false)
              .viewCart(userToken));
    }
  }

  @override
  Widget build(BuildContext context) {
    List defaults = ModalRoute.of(context).settings.arguments;
    Cart cart;
    if (defaults.length > 0) cart = defaults[0];

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
          'My order',
          style: titleText,
        ),
        actions: [
          cart != null
              ? IconButton(
                  icon: Icon(Icons.delete, color: lightTextColor),
                  onPressed: () {},
                )
              : Container(),
        ],
      ),
      backgroundColor: whiteColor,
      body: SafeArea(
        child: cart != null
            ? ListView(
                children: [
                  SizedBox(
                    height: 2 * SizeConfig.blockSizeVertical,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 2 * SizeConfig.blockSizeVertical),
                    child: Text(
                      'Order',
                      style: buttonText,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: SizeConfig.blockSizeVertical,
                        bottom: SizeConfig.blockSizeVertical,
                        left: 3 * SizeConfig.blockSizeVertical),
                    child: ItemsList(),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 2 * SizeConfig.blockSizeVertical),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.add_circle_outline,
                              color: lightTextColor, size: 20),
                          onPressed: () {},
                        ),
                        Text(
                          'Add new item',
                          style: ItemAddOn,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 2 * SizeConfig.blockSizeVertical),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Promo code',
                          style: buttonText,
                        ),
                        SizedBox(height: SizeConfig.blockSizeVertical),
                        TextFormField(
                          onChanged: (String input) {},
                          textAlign: TextAlign.left,
                          style: fillFieldText,
                          decoration: InputDecoration(
                            hintText: 'Enter promo code',
                            hintStyle: fieldText,
                            enabledBorder: OutlineInputBorder(
                              borderSide: new BorderSide(color: lightTextColor),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: new BorderSide(color: primaryColor),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            contentPadding:
                                EdgeInsets.fromLTRB(10.0, 10.0, 20.0, 10.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 6 * SizeConfig.blockSizeVertical,
                    margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical),
                    padding: EdgeInsets.symmetric(
                        horizontal: 25 * SizeConfig.blockSizeHorizontal),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                      ),
                      child: Text(
                        S().apply,
                        //'Apply',
                        textScaleFactor: 1.0,
                        style: buttonText,
                      ),
                      onPressed: () {},
                    ),
                  ),
                  SizedBox(
                    height: 8 * SizeConfig.blockSizeVertical,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: secondaryColor,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(18.0),
                      ),
                    ),
                    margin: EdgeInsets.only(
                        top: 2 * SizeConfig.blockSizeVertical,
                        left: 3 * SizeConfig.blockSizeVertical,
                        right: 3 * SizeConfig.blockSizeVertical),
                    padding: EdgeInsets.all(2 * SizeConfig.blockSizeVertical),
                    child: StreamBuilder(
                        stream: _stream,
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Summery', style: paymentSummary),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          2 * SizeConfig.blockSizeVertical,
                                      vertical: SizeConfig.blockSizeVertical),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Subtotal',
                                        style: pickUpAndDeliveryTime,
                                      ),
                                      Text(
                                        '${snapshot.data.subtotalPrice} \$',
                                        style: pickUpAndDeliveryTime,
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          2 * SizeConfig.blockSizeVertical),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                      horizontal:
                                          2 * SizeConfig.blockSizeVertical,
                                      vertical: SizeConfig.blockSizeVertical),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Total',
                                        style: buttonText,
                                      ),
                                      Text(
                                        '${snapshot.data.totalPrice} \$',
                                        style: totalPayment,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        }),
                  ),
                  MainButton(
                    label: 'Check out',
                    action: () {
                      Navigator.pushNamed(context, 'order');
                    },
                  ),
                  SizedBox(height: SizeConfig.blockSizeVertical),
                ],
              )
            : ListView(
                padding: EdgeInsets.symmetric(
                    horizontal: 3 * SizeConfig.blockSizeVertical,
                    vertical: 2 * SizeConfig.blockSizeVertical),
                children: [
                  SizedBox(height: 10 * SizeConfig.blockSizeVertical),
                  Container(
                    width: 30 * SizeConfig.blockSizeHorizontal,
                    height: 30 * SizeConfig.blockSizeVertical,
                    child: Image(
                      image: AssetImage(
                        'assets/icons/balloons.png',
                      ),
                    ),
                  ),
                  SizedBox(height: 2 * SizeConfig.blockSizeVertical),
                  Text(
                    'Your cart is Empty',
                    style: greenSmallText17,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 5 * SizeConfig.blockSizeVertical),
                  MainButton(
                    label: 'Continue Browsing ',
                    action: () => Navigator.pushNamed(context, 'home'),
                  ),
                ],
              ),
      ),
    );
  }
}
