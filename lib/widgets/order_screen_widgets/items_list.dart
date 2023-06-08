import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:foodCourier/constants/colors.dart';
import 'package:foodCourier/constants/text_styles.dart';
import 'package:foodCourier/controllers/size_config.dart';
import 'package:foodCourier/providers/authentication_provider.dart';
import 'package:foodCourier/providers/order_provider.dart';

class ItemsList extends StatefulWidget {
  const ItemsList({Key? key}) : super(key: key);

  @override
  ItemsListState createState() => ItemsListState();
}

class ItemsListState extends State<ItemsList> {
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

  addItemTOCart(context, int productID, int quantity) async {
    String userToken =
        await Provider.of<AuthenticationProvider>(context, listen: false)
            .userToken;
    await Provider.of<OrderProvider>(context, listen: false)
        .addToCart(userToken, productID, quantity);
  }

  removeItem(int itemID) async {
    String userToken =
        await Provider.of<AuthenticationProvider>(context, listen: false)
            .userToken;
    await Provider.of<OrderProvider>(context, listen: false)
        .removeFromCart(userToken, itemID);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                SizedBox(
                  height: snapshot.data.items.length *
                      6 *
                      SizeConfig.blockSizeVertical!,
                  child: ListView.builder(
                    itemBuilder: (_, index) => GestureDetector(
                      onTap: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                snapshot.data.items[index]['quantity']
                                    .toString(),
                                style: ItemAddOn,
                              ),
                              const Text(
                                ' x ',
                                style: ItemAddOn,
                              ),
                              SizedBox(
                                width: 15 * SizeConfig.blockSizeHorizontal!,
                                child: Text(
                                  snapshot
                                      .data
                                      .items[index]['item']['product']
                                          ['product_name']
                                      .toString(),
                                  style: ItemAddOn,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline,
                                    color: lightTextColor, size: 20),
                                onPressed: () => setState(() =>
                                    snapshot.data.items[index]['quantity']++),
                              ),
                              Text(
                                snapshot.data.items[index]['quantity']
                                    .toString(),
                                style: mealPrice,
                              ),
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline,
                                    color: lightTextColor, size: 20),
                                onPressed: () => setState(() =>
                                    snapshot.data.items[index]['quantity'] > 0
                                        ? snapshot.data.items[index]
                                            ['quantity']--
                                        : snapshot.data.items[index]
                                            ['quantity']),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                '${snapshot.data.items[index]['line_item_total']} \$',
                                style: mealPrice,
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete,
                                    color: lightTextColor),
                                onPressed: () => removeItem(57),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    itemCount: snapshot.data.items.length,
                  ),
                ),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
