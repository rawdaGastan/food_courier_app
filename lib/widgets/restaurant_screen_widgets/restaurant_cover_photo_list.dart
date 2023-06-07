import 'package:cached_network_image/cached_network_image.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:foodCourier/constants/colors.dart';
import 'package:foodCourier/constants/text_styles.dart';
import 'package:foodCourier/controllers/size_config.dart';
import 'package:foodCourier/providers/authentication_provider.dart';
import 'package:foodCourier/providers/order_provider.dart';
import '../../main.dart';
import 'package:foodCourier/models/cart.dart';

class CoverPhotoList extends StatefulWidget {
  final List<String> photoUrls;

  CoverPhotoList({this.photoUrls});

  @override
  _CoverPhotoListState createState() => _CoverPhotoListState();
}

class _CoverPhotoListState extends State<CoverPhotoList> {
  int myCartLength = 0;
  Cart cart;
  int _index = 0;
  bool isFavourite = false;

  Future<int> getNumberOfItemsInCart() async {
    String userToken =
        await Provider.of<AuthenticationProvider>(context, listen: false)
            .userToken;
    if (userToken != null) {
      cart = await Provider.of<OrderProvider>(context, listen: false)
          .viewCart(userToken);
      setState(() {
        myCartLength = cart.items.length;
      });
    }
    return myCartLength;
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, this.getNumberOfItemsInCart);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30 * SizeConfig.blockSizeVertical,
      child: Stack(children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: shadow,
          ),
          child: PageView.builder(
              onPageChanged: (int index) => setState(() => _index = index),
              scrollDirection: Axis.horizontal,
              itemCount: widget.photoUrls.length,
              itemBuilder: (_, index) {
                return Container(
                  width: SizeConfig.screenWidth,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                        widget.photoUrls[index],
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              }),
        ),
        Container(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.only(
            top: 5 * SizeConfig.blockSizeHorizontal,
          ),
          child: Stack(
            children: [
              IconButton(
                icon: Icon(Icons.brightness_1),
                color: whiteColor,
                onPressed: () => Navigator.pop(context),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.blockSizeHorizontal,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    size: 5 * SizeConfig.blockSizeHorizontal,
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
          padding: EdgeInsets.all(5 * SizeConfig.blockSizeHorizontal),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Stack(
                children: [
                  Container(
                    child: CircleAvatar(
                      backgroundColor: whiteColor,
                      radius: 4 * SizeConfig.blockSizeHorizontal,
                    ),
                  ),
                  Container(
                    width: 8 * SizeConfig.blockSizeHorizontal,
                    height: 8 * SizeConfig.blockSizeHorizontal,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isFavourite = !isFavourite;
                        });
                      },
                      child: Icon(
                        isFavourite ? Icons.turned_in : Icons.turned_in_not,
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
                      size: 9 * SizeConfig.blockSizeHorizontal,
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
                                icon: Icon(Icons.shopping_cart,
                                    color: primaryColor),
                                onPressed: () {
                                  Navigator.pushNamed(context, 'order checkout',
                                      arguments: [cart]);
                                },
                              ),
                              Positioned(
                                bottom: 4 * SizeConfig.blockSizeVertical,
                                right: 2.5 * SizeConfig.blockSizeHorizontal,
                                child: Stack(
                                  children: [
                                    Icon(Icons.brightness_1,
                                        size:
                                            3 * SizeConfig.blockSizeHorizontal,
                                        color: orangeColor),
                                    Positioned(
                                        top: 0.3 *
                                            SizeConfig.blockSizeHorizontal,
                                        right: 0.3 *
                                            SizeConfig.blockSizeHorizontal,
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
        Container(
          alignment: Alignment.bottomCenter,
          margin: EdgeInsets.only(bottom: 7 * SizeConfig.blockSizeVertical),
          child: DotsIndicator(
            dotsCount: widget.photoUrls.length,
            position: _index,
            decorator: DotsDecorator(
              color: primaryColor, // Inactive color
              activeColor: whiteColor,
            ),
          ),
        ),
      ]),
    );
  }
}
