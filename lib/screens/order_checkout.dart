import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:food_courier/constants/text_styles.dart';
import 'package:food_courier/constants/colors.dart';
import 'package:food_courier/controllers/size_config.dart';
import 'package:food_courier/generated/l10n.dart';
import 'package:food_courier/models/cart.dart';
import 'package:food_courier/providers/authentication_provider.dart';
import 'package:food_courier/providers/order_provider.dart';
import 'package:food_courier/widgets/authentication_screens_widgets/main_button.dart';
import 'package:food_courier/widgets/order_screen_widgets/items_list.dart';

class OrderCheckout extends StatefulWidget {
  const OrderCheckout({Key? key}) : super(key: key);

  @override
  OrderCheckoutState createState() => OrderCheckoutState();
}

class OrderCheckoutState extends State<OrderCheckout> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late StreamController _streamController;
  late Stream _stream;

  @override
  void initState() {
    super.initState();
    _streamController = StreamController.broadcast();
    _stream = _streamController.stream;
    Future.delayed(Duration.zero, getCart);
  }

  getCart() async {
    String userToken =
        await Provider.of<AuthenticationProvider>(context, listen: false)
            .userToken;
    _streamController.add(
        await Provider.of<OrderProvider>(context, listen: false)
            .viewCart(userToken));
  }

  @override
  Widget build(BuildContext context) {
    List defaults = ModalRoute.of(context)!.settings.arguments as List;
    Cart? cart;
    Widget cartWidget = Container();
    if (defaults.isNotEmpty) {
      cart = defaults[0];
      cartWidget = IconButton(
        icon: const Icon(Icons.delete, color: lightTextColor),
        onPressed: () {},
      );
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
            size: 6 * SizeConfig.blockSizeHorizontal!,
          ),
        ),
        centerTitle: true,
        title: const Text(
          'My order',
          style: titleText,
        ),
        actions: [cartWidget],
      ),
      backgroundColor: whiteColor,
      body: SafeArea(
        child: cart == null
            ? ListView(
                children: [
                  SizedBox(
                    height: 2 * SizeConfig.blockSizeVertical!,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 2 * SizeConfig.blockSizeVertical!),
                    child: const Text(
                      'Order',
                      style: buttonText,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: SizeConfig.blockSizeVertical!,
                        bottom: SizeConfig.blockSizeVertical!,
                        left: 3 * SizeConfig.blockSizeVertical!),
                    child: const ItemsList(),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 2 * SizeConfig.blockSizeVertical!),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline,
                              color: lightTextColor, size: 20),
                          onPressed: () {},
                        ),
                        const Text(
                          'Add item',
                          style: itemAddOn,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 2 * SizeConfig.blockSizeVertical!),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Promo code',
                          style: buttonText,
                        ),
                        SizedBox(height: SizeConfig.blockSizeVertical!),
                        TextFormField(
                          onChanged: (String input) {},
                          textAlign: TextAlign.left,
                          style: fillFieldText,
                          decoration: const InputDecoration(
                            hintText: 'Enter promo code',
                            hintStyle: fieldText,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: lightTextColor),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: primaryColor),
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
                    height: 6 * SizeConfig.blockSizeVertical!,
                    margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical!),
                    padding: EdgeInsets.symmetric(
                        horizontal: 25 * SizeConfig.blockSizeHorizontal!),
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
                    height: 8 * SizeConfig.blockSizeVertical!,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: secondaryColor,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(18.0),
                      ),
                    ),
                    margin: EdgeInsets.only(
                        top: 2 * SizeConfig.blockSizeVertical!,
                        left: 3 * SizeConfig.blockSizeVertical!,
                        right: 3 * SizeConfig.blockSizeVertical!),
                    padding: EdgeInsets.all(2 * SizeConfig.blockSizeVertical!),
                    child: StreamBuilder(
                        stream: _stream,
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Summery', style: paymentSummary),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          2 * SizeConfig.blockSizeVertical!,
                                      vertical: SizeConfig.blockSizeVertical!),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
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
                                          2 * SizeConfig.blockSizeVertical!),
                                  child: const Row(
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
                                          2 * SizeConfig.blockSizeVertical!,
                                      vertical: SizeConfig.blockSizeVertical!),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
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
                            return const Center(
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
                  SizedBox(height: SizeConfig.blockSizeVertical!),
                ],
              )
            : ListView(
                padding: EdgeInsets.symmetric(
                    horizontal: 3 * SizeConfig.blockSizeVertical!,
                    vertical: 2 * SizeConfig.blockSizeVertical!),
                children: [
                  SizedBox(height: 10 * SizeConfig.blockSizeVertical!),
                  SizedBox(
                    width: 30 * SizeConfig.blockSizeHorizontal!,
                    height: 30 * SizeConfig.blockSizeVertical!,
                    child: const Image(
                      image: AssetImage(
                        'assets/icons/balloons.png',
                      ),
                    ),
                  ),
                  SizedBox(height: 2 * SizeConfig.blockSizeVertical!),
                  const Text(
                    'Your cart is Empty',
                    style: greenSmallText17,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 5 * SizeConfig.blockSizeVertical!),
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
