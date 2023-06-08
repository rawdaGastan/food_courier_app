import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:foodCourier/constants/colors.dart';
import 'package:foodCourier/constants/text_styles.dart';
import 'package:foodCourier/controllers/size_config.dart';
import 'package:foodCourier/providers/authentication_provider.dart';
import 'package:foodCourier/providers/order_provider.dart';
import 'package:foodCourier/models/cart.dart';
import '../../main.dart';

class MealCoverPhoto extends StatefulWidget {
  final String photoUrl;

  const MealCoverPhoto({Key? key, required this.photoUrl}) : super(key: key);

  @override
  MealCoverPhotoState createState() => MealCoverPhotoState();
}

class MealCoverPhotoState extends State<MealCoverPhoto> {
  bool isFavorite = false;
  int myCartLength = 0;
  Cart? cart;

  Future<int> getNumberOfItemsInCart() async {
    String userToken =
        await Provider.of<AuthenticationProvider>(context, listen: false)
            .userToken;
    cart = await Provider.of<OrderProvider>(context, listen: false)
        .viewCart(userToken);
    setState(() {
      myCartLength = cart!.items.length;
    });
    return myCartLength;
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, getNumberOfItemsInCart);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30 * SizeConfig.blockSizeVertical!,
      child: Stack(children: <Widget>[
        Container(
          width: SizeConfig.screenWidth,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: CachedNetworkImageProvider(widget.photoUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.only(
            top: 5 * SizeConfig.blockSizeHorizontal!,
          ),
          child: Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.brightness_1),
                color: whiteColor,
                onPressed: () => Navigator.pop(context),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.blockSizeHorizontal!,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    size: 5 * SizeConfig.blockSizeHorizontal!,
                  ),
                  color: blackColor,
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ),
        Container(
          alignment: Alignment.topRight,
          padding: EdgeInsets.all(5 * SizeConfig.blockSizeHorizontal!),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    backgroundColor: whiteColor,
                    radius: 4 * SizeConfig.blockSizeHorizontal!,
                  ),
                  SizedBox(
                    width: 8 * SizeConfig.blockSizeHorizontal!,
                    height: 8 * SizeConfig.blockSizeHorizontal!,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isFavorite = !isFavorite;
                        });
                      },
                      child: Icon(
                        isFavorite ? Icons.turned_in : Icons.turned_in_not,
                        color: orangeColor,
                      ),
                    ),
                  ),
                ],
              ),
              Stack(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.brightness_1,
                      size: 9 * SizeConfig.blockSizeHorizontal!,
                    ),
                    color: whiteColor,
                    onPressed: () {},
                  ),
                  foodCourier().remoteConfigService.orderingFeature
                      ? GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, 'order checkout');
                          },
                          child: Stack(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.shopping_cart,
                                    color: primaryColor),
                                onPressed: () {
                                  Navigator.pushNamed(context, 'order checkout',
                                      arguments: [cart]);
                                },
                              ),
                              Positioned(
                                bottom: 4 * SizeConfig.blockSizeVertical!,
                                right: 2.5 * SizeConfig.blockSizeHorizontal!,
                                child: Stack(
                                  children: [
                                    Icon(Icons.brightness_1,
                                        size:
                                            3 * SizeConfig.blockSizeHorizontal!,
                                        color: orangeColor),
                                    Positioned(
                                        top: 0.3 *
                                            SizeConfig.blockSizeHorizontal!,
                                        right: 0.3 *
                                            SizeConfig.blockSizeHorizontal!,
                                        child: Center(
                                          child: Text(
                                            myCartLength.toString(),
                                            style: cartLength,
                                            textAlign: TextAlign.center,
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                ],
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
