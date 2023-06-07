import 'package:flutter/material.dart';
import 'package:foodCourier/constants/text_styles.dart';
import 'package:foodCourier/constants/colors.dart';
import 'package:foodCourier/controllers/size_config.dart';

class TrackOrderScreen extends StatefulWidget {
  @override
  _TrackOrderScreenState createState() => _TrackOrderScreenState();
}

class _TrackOrderScreenState extends State<TrackOrderScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
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
        title: Text(
          'Track order',
          style: titleText,
        ),
        actions: [
          TextButton(
            child: Text('Cancel', style: saveText),
            onPressed: () {},
          ),
        ],
      ),
      backgroundColor: whiteColor,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(
              horizontal: 3 * SizeConfig.blockSizeVertical!,
              vertical: 2 * SizeConfig.blockSizeVertical!),
          children: [
            Text('Order number :    3254', style: pickUpAndDeliveryTime),
            Row(
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
            SizedBox(
              height: 2 * SizeConfig.blockSizeVertical!,
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Icon(Icons.brightness_1, size: 30.0, color: primaryColor),
                    Container(
                        alignment: Alignment.center,
                        height: 5 * SizeConfig.blockSizeVertical!,
                        child: VerticalDivider(
                          thickness: 2,
                          color: primaryColor,
                        )),
                    Icon(Icons.brightness_1, size: 30.0, color: primaryColor),
                    Container(
                        alignment: Alignment.center,
                        height: 5 * SizeConfig.blockSizeVertical!,
                        child: VerticalDivider(
                          thickness: 2,
                          color: primaryColor,
                        )),
                    Icon(Icons.brightness_1, size: 30.0, color: orangeColor),
                    Container(
                        alignment: Alignment.center,
                        height: 5 * SizeConfig.blockSizeVertical!,
                        child: VerticalDivider(
                          thickness: 2,
                          color: orangeColor,
                        )),
                    Icon(Icons.brightness_1_outlined, size: 30.0),
                    Container(
                        alignment: Alignment.center,
                        height: 5 * SizeConfig.blockSizeVertical!,
                        child:
                            VerticalDivider(thickness: 2, color: blackColor)),
                    Icon(
                      Icons.brightness_1_outlined,
                      size: 30.0,
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 3 * SizeConfig.blockSizeHorizontal!,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 2 * SizeConfig.blockSizeVertical!,
                    ),
                    Text('Order Placed', style: totalPayment),
                    Text('We have received your order', style: deliveryCost),
                    SizedBox(
                      height: 2 * SizeConfig.blockSizeVertical!,
                    ),
                    Text('Order Confirmed ', style: totalPayment),
                    Text('your order has been confirmed', style: deliveryCost),
                    SizedBox(
                      height: 2 * SizeConfig.blockSizeVertical!,
                    ),
                    Text('Order Processed',
                        style: totalPayment.apply(color: orangeColor)),
                    Text('we are preparing your order',
                        style: deliveryCost.apply(color: orangeColor)),
                    SizedBox(
                      height: 2 * SizeConfig.blockSizeVertical!,
                    ),
                    Text('Order Completed',
                        style: totalPayment.apply(color: blackColor)),
                    Text('your order is on the way',
                        style: deliveryCost.apply(color: blackColor)),
                    SizedBox(
                      height: 2 * SizeConfig.blockSizeVertical!,
                    ),
                    Text('Order Delivered',
                        style: totalPayment.apply(color: blackColor)),
                    Text('Enjoy your food',
                        style: deliveryCost.apply(color: blackColor)),
                    SizedBox(
                      height: 2 * SizeConfig.blockSizeVertical!,
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.error,
                        color: blackColor,
                        size: 5 * SizeConfig.blockSizeHorizontal!,
                      ),
                      SizedBox(
                        width: 2 * SizeConfig.blockSizeHorizontal!,
                      ),
                      Text('Complaint', style: pickUpAndDeliveryTime),
                    ],
                  ),
                ),
                MaterialButton(
                  onPressed: () {},
                  textColor: whiteColor,
                  color: primaryColor,
                  child: Icon(Icons.call),
                  padding: EdgeInsets.all(2 * SizeConfig.blockSizeVertical!),
                  shape: CircleBorder(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
