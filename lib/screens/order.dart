import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:food_courier/constants/text_styles.dart';
import 'package:food_courier/constants/colors.dart';
import 'package:food_courier/controllers/size_config.dart';
import 'package:food_courier/providers/authentication_provider.dart';
import 'package:food_courier/providers/order_provider.dart';
import 'package:food_courier/widgets/authentication_screens_widgets/main_button.dart';
import 'package:food_courier/widgets/order_screen_widgets/check_out.dart';
import 'package:food_courier/widgets/order_screen_widgets/order_info.dart';

class Order extends StatefulWidget {
  const Order({Key? key}) : super(key: key);

  @override
  OrderState createState() => OrderState();
}

class OrderState extends State<Order> {
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

  createOrder() async {
    String userToken =
        await Provider.of<AuthenticationProvider>(context, listen: false)
            .userToken;
    var response = await Provider.of<OrderProvider>(context, listen: false)
        .createOrder(userToken);
    if (response != null) Navigator.pushNamed(context, 'finish order');
  }

  @override
  Widget build(BuildContext context) {
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
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: lightTextColor),
            onPressed: () {},
          ),
        ],
      ),
      backgroundColor: whiteColor,
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 3 * SizeConfig.blockSizeVertical!,
                  vertical: 2 * SizeConfig.blockSizeVertical!),
              child: const OrderInfo(),
            ),
            SizedBox(
              height: 2 * SizeConfig.blockSizeVertical!,
            ),
            const CheckOut(),
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
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Summery', style: paymentSummary),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2 * SizeConfig.blockSizeVertical!,
                                vertical: SizeConfig.blockSizeVertical!),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                horizontal: 2 * SizeConfig.blockSizeVertical!),
                            child: const Row(
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
                                horizontal: 2 * SizeConfig.blockSizeVertical!,
                                vertical: SizeConfig.blockSizeVertical!),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              label: 'Place order',
              action: () => createOrder(),
            ),
            SizedBox(height: SizeConfig.blockSizeVertical!),
          ],
        ),
      ),
    );
  }
}
