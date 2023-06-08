import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:foodCourier/constants/colors.dart';
import 'package:foodCourier/constants/text_styles.dart';
import 'package:foodCourier/controllers/size_config.dart';
import 'package:foodCourier/generated/l10n.dart';
import 'package:foodCourier/widgets/order_screen_widgets/address_container.dart';
import 'package:foodCourier/widgets/order_screen_widgets/edit_pickup_time.dart';

class OrderInfo extends StatefulWidget {
  @override
  _OrderInfoState createState() => _OrderInfoState();
}

class _OrderInfoState extends State<OrderInfo> {
  int focusedDayIndex = 0;
  int deliveryOrPick = 0;
  int addressIndex = 0;

  displayDialog(context) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Container(
              height: 31 * SizeConfig.blockSizeVertical!,
              padding: EdgeInsets.symmetric(
                  horizontal: 3 * SizeConfig.blockSizeHorizontal!),
              child: Column(
                children: [
                  Text(
                    'when will you be there ?',
                    style: textBold16,
                    textAlign: TextAlign.center,
                  ),
                  Divider(),
                  EditPickUpTime(),
                ],
              )),
        ),
      );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DefaultTabController(
          length: 2,
          child: Container(
            decoration: BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
            ),
            height: 6 * SizeConfig.blockSizeVertical!,
            child: TabBar(
              tabs: [
                Tab(
                  child: AutoSizeText(
                    S().delivery,
                    maxLines: 1,
                    style: restaurantBarText,
                  ),
                ),
                Tab(
                  child: AutoSizeText(
                    'Pick up',
                    maxLines: 1,
                    style: restaurantBarText,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
              onTap: (index) {
                setState(() {
                  deliveryOrPick = index;
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
                  horizontal: 3 * SizeConfig.blockSizeHorizontal!),
            ),
          ),
        ),
        SizedBox(
          height: 2 * SizeConfig.blockSizeVertical!,
        ),
        (deliveryOrPick == 0)
            ? Container(
                height: 10 * SizeConfig.blockSizeVertical!,
                decoration: BoxDecoration(
                  border: Border.all(width: 1.0, color: lightTextColor),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('\$ 0,00', style: deliveryCost),
                        Text('Delivery fee on \$15+', style: mealInfo),
                      ],
                    ),
                    Container(
                        alignment: Alignment.center,
                        height: 7 * SizeConfig.blockSizeVertical!,
                        child: VerticalDivider(
                          thickness: 1,
                          color: lightTextColor,
                        )),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('38 - 48', style: pickUpAndDeliveryTime),
                        Text(
                          'Minutes',
                          style: mealInfo,
                        ),
                      ],
                    ),
                  ],
                ),
              )
            : Container(
                height: 10 * SizeConfig.blockSizeVertical!,
                decoration: BoxDecoration(
                  border: Border.all(width: 1.0, color: lightTextColor),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.5 * SizeConfig.blockSizeHorizontal!),
                      child: Text('6 Pm', style: pickUpAndDeliveryTime),
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: 10 * SizeConfig.blockSizeVertical!,
                      padding: EdgeInsets.symmetric(
                          horizontal: 3 * SizeConfig.blockSizeHorizontal!),
                      width: 60 * SizeConfig.blockSizeHorizontal!,
                      color: secondaryColor,
                      child: AutoSizeText(
                        'This is a Pickup order Today at 6pm You\'ll need to go to Mid Atlantic Seafood to pick up this order: 6500 New Hampshire Avenue',
                        style: mealInfo,
                      ),
                    ),
                    Container(
                      width: 12 * SizeConfig.blockSizeHorizontal!,
                      height: 10 * SizeConfig.blockSizeVertical!,
                      color: primaryColor,
                      child: IconButton(
                          icon: Icon(
                            Icons.mode_edit,
                            color: whiteColor,
                          ),
                          onPressed: () {
                            displayDialog(context);
                          }),
                    ),
                  ],
                ),
              ),
        SizedBox(
          height: 2 * SizeConfig.blockSizeVertical!,
        ),
        DefaultTabController(
          length: 3,
          child: Container(
            decoration: BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
            ),
            height: 6 * SizeConfig.blockSizeVertical!,
            child: TabBar(
              tabs: [
                Tab(
                  child: AutoSizeText(
                    'Home',
                    maxLines: 1,
                    style: restaurantBarText,
                  ),
                ),
                Tab(
                  child: AutoSizeText(
                    'Work',
                    maxLines: 1,
                    style: restaurantBarText,
                    textAlign: TextAlign.center,
                  ),
                ),
                Tab(
                  child: AutoSizeText(
                    'New Address',
                    maxLines: 2,
                    style: restaurantBarText,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
              onTap: (index) {
                setState(() {
                  addressIndex = index;
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
                  horizontal: 3 * SizeConfig.blockSizeHorizontal!),
            ),
          ),
        ),
        SizedBox(
          height: 2 * SizeConfig.blockSizeVertical!,
        ),
        (addressIndex == 0)
            ? AddressContainer(
                address:
                    'Lorem Ipsum is simply dummy text of the printing and typesetting industry',
                controller: TextEditingController())
            : (addressIndex == 1)
                ? AddressContainer(
                    address:
                        'Lorem Ipsum is simply dummy text of the printing and typesetting industry',
                    controller: TextEditingController())
                : AddressContainer(
                    address:
                        'Lorem Ipsum is simply dummy text of the printing and typesetting industry',
                    controller: TextEditingController()),
        SizedBox(
          height: 2 * SizeConfig.blockSizeVertical!,
        ),
      ],
    );
  }
}
