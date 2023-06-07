import 'package:flutter/material.dart';
import 'package:foodCourier/constants/text_styles.dart';
import 'package:foodCourier/constants/colors.dart';
import 'package:foodCourier/controllers/size_config.dart';

class AllOrdersScreen extends StatefulWidget {
  const AllOrdersScreen({Key? key}) : super(key: key);

  @override
  AllOrdersScreenState createState() => AllOrdersScreenState();
}

class AllOrdersScreenState extends State<AllOrdersScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool combined = false;

  @override
  void initState() {
    super.initState();
  }

  Widget showCombinedOrderWidget(String nameOfRestaurant, int numberOfItems,
      double price, String restaurantIconUrl) {
    Widget combinedOrderWidget = GestureDetector(
      //true means current order
      onTap: () =>
          Navigator.pushNamed(context, 'order details', arguments: [true]),
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(
              top: 2 * SizeConfig.blockSizeVertical!,
              bottom: 2 * SizeConfig.blockSizeVertical!,
              left: 3 * SizeConfig.blockSizeHorizontal!,
            ),
            padding:
                EdgeInsets.only(left: 10 * SizeConfig.blockSizeHorizontal!),
            decoration: BoxDecoration(
              color: secondaryColor,
              boxShadow: [
                BoxShadow(
                  color: shadow,
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  nameOfRestaurant,
                  style: restaurantName,
                ),
                Row(
                  children: [
                    Text('$numberOfItems x ', style: ItemAddOn),
                    Text('$price \$', style: deliveryCost),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.keyboard_arrow_down,
                      color: lightTextColor),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 2 * SizeConfig.blockSizeVertical!),
            child: CircleAvatar(
              radius: 3 * SizeConfig.blockSizeVertical!,
              backgroundImage: AssetImage(
                restaurantIconUrl,
              ),
            ),
          ),
        ],
      ),
    );
    return combinedOrderWidget;
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
          'My orders',
          style: titleText,
        ),
      ),
      backgroundColor: whiteColor,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(
              horizontal: 3 * SizeConfig.blockSizeVertical!,
              vertical: 2 * SizeConfig.blockSizeVertical!),
          children: [
            const Text('Current order', style: pickUpAndDeliveryTime),
            !combined
                ? GestureDetector(
                    //true means current order
                    onTap: () => Navigator.pushNamed(context, 'order details',
                        arguments: [true]),
                    child: Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            top: 2 * SizeConfig.blockSizeVertical!,
                            bottom: 2 * SizeConfig.blockSizeVertical!,
                            left: 8 * SizeConfig.blockSizeHorizontal!,
                          ),
                          padding: EdgeInsets.only(
                              left: 10 * SizeConfig.blockSizeHorizontal!),
                          decoration: BoxDecoration(
                            color: whiteColor,
                            boxShadow: [
                              BoxShadow(
                                color: shadow,
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(
                                    0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Restaurant name',
                                    style: restaurantName,
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: lightTextColor),
                                    onPressed: () {},
                                  ),
                                ],
                              ),
                              const Text(
                                'Lorem Ipsum is simply dummy text',
                                style: RestaurantDescription,
                              ),
                              const Row(
                                children: [
                                  Text('3x ', style: ItemAddOn),
                                  Text('18.50 \$', style: deliveryCost),
                                ],
                              ),
                              SizedBox(height: SizeConfig.blockSizeVertical)
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 4.5 * SizeConfig.blockSizeVertical!),
                          child: CircleAvatar(
                            radius: 4 * SizeConfig.blockSizeVertical!,
                            backgroundImage: const AssetImage(
                              'assets/icons/temp.png',
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 2 * SizeConfig.blockSizeHorizontal!,
                            ),
                            child: const Text('Combined order',
                                style: combinedOrder),
                          ),
                          IconButton(
                            icon:
                                const Icon(Icons.delete, color: lightTextColor),
                            onPressed: () {},
                          ),
                        ],
                      ),
                      showCombinedOrderWidget(
                          'Restaurant name', 3, 18.5, 'assets/icons/temp.png'),
                      showCombinedOrderWidget(
                          'Restaurant name', 3, 18.5, 'assets/icons/temp.png'),
                    ],
                  ),
            const Text('Past orders', style: pastOrders),
            SizedBox(height: SizeConfig.blockSizeVertical),
            SizedBox(
              height: 4 * 15 * SizeConfig.blockSizeVertical!,
              child: ListView.builder(
                itemBuilder: (_, index) => GestureDetector(
                  //false means pastOrder
                  onTap: () => Navigator.pushNamed(context, 'order details',
                      arguments: [false]),
                  child: Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          top: 2 * SizeConfig.blockSizeVertical!,
                          bottom: 2 * SizeConfig.blockSizeVertical!,
                          left: 8 * SizeConfig.blockSizeHorizontal!,
                        ),
                        padding: EdgeInsets.only(
                            left: 10 * SizeConfig.blockSizeHorizontal!),
                        decoration: BoxDecoration(
                          color: secondaryColor,
                          boxShadow: [
                            BoxShadow(
                              color: shadow,
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Restaurant name',
                                  style: restaurantName,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: lightTextColor),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                            const Text(
                              'Lorem Ipsum is simply dummy text',
                              style: RestaurantDescription,
                            ),
                            const Row(
                              children: [
                                Text('3x ', style: ItemAddOn),
                                Text('18.50 \$', style: deliveryCost),
                              ],
                            ),
                            SizedBox(height: SizeConfig.blockSizeVertical)
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 4.5 * SizeConfig.blockSizeVertical!),
                        child: CircleAvatar(
                          radius: 4 * SizeConfig.blockSizeVertical!,
                          backgroundImage: const AssetImage(
                            'assets/icons/temp.png',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                itemCount: 4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
