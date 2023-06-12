import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:food_courier/controllers/size_config.dart';
import 'package:food_courier/constants/colors.dart';
import 'package:food_courier/constants/text_styles.dart';
import 'package:food_courier/models/cart.dart';
import 'package:food_courier/providers/authentication_provider.dart';
import 'package:food_courier/providers/order_provider.dart';
import '../main.dart';

class GoToCartButton extends StatefulWidget {
  const GoToCartButton({Key? key}) : super(key: key);

  @override
  GoToCartButtonState createState() => GoToCartButtonState();
}

class GoToCartButtonState extends State<GoToCartButton> {
  Cart? cart;

  getNumberOfItemsInCart() async {
    String userToken =
        await Provider.of<AuthenticationProvider>(context, listen: false)
            .userToken;
    cart = await Provider.of<OrderProvider>(context, listen: false)
        .viewCart(userToken);

    setState(() {
      cart = cart;
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, getNumberOfItemsInCart);
  }

  @override
  Widget build(BuildContext context) {
    return FoodCourier().remoteConfigService.orderingFeature
        ? Container(
            height: 8 * SizeConfig.blockSizeVertical!,
            padding: EdgeInsets.symmetric(
                horizontal: 5 * SizeConfig.blockSizeHorizontal!),
            margin: EdgeInsets.only(top: 83 * SizeConfig.blockSizeVertical!),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, 'order checkout',
                    arguments: [cart]);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: SizeConfig.blockSizeVertical!,
                  ),
                  Container(
                    height: 5 * SizeConfig.blockSizeVertical!,
                    width: 5 * SizeConfig.blockSizeVertical!,
                    decoration: const BoxDecoration(
                      color: whiteColor,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      cart == null ? '0' : cart!.items.length.toString(),
                      style: buttonText,
                    ),
                  ),
                  const Text(
                    'View cart',
                    style: buttonText,
                  ),
                  Text(
                    cart == null ? '0' : '${cart!.totalPrice} \$',
                    style: buttonText,
                  ),
                  SizedBox(
                    width: SizeConfig.blockSizeVertical!,
                  ),
                ],
              ),
            ),
          )
        : Container();
  }
}
