import 'package:cached_network_image/cached_network_image.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:food_courier/constants/colors.dart';
import 'package:food_courier/constants/text_styles.dart';
import 'package:food_courier/controllers/size_config.dart';
import 'package:food_courier/providers/authentication_provider.dart';
import 'package:food_courier/providers/order_provider.dart';
import '../../main.dart';
import 'package:food_courier/models/cart.dart';

class CoverPhotoList extends StatefulWidget {
  final List<String> photoUrls;

  const CoverPhotoList({Key? key, required this.photoUrls}) : super(key: key);

  @override
  CoverPhotoListState createState() => CoverPhotoListState();
}

class CoverPhotoListState extends State<CoverPhotoList> {
  int myCartLength = 0;
  late Cart cart;
  int _index = 0;
  bool isFavorite = false;

  Future<int> getNumberOfItemsInCart() async {
    String userToken =
        await Provider.of<AuthenticationProvider>(context, listen: false)
            .userToken;
    cart = await Provider.of<OrderProvider>(context, listen: false)
        .viewCart(userToken);
    setState(() {
      myCartLength = cart.items.length;
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
                  FoodCourier().remoteConfigService.orderingFeature
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
        Container(
          alignment: Alignment.bottomCenter,
          margin: EdgeInsets.only(bottom: 7 * SizeConfig.blockSizeVertical!),
          child: DotsIndicator(
            dotsCount: widget.photoUrls.length,
            position: _index,
            decorator: const DotsDecorator(
              color: primaryColor, // Inactive color
              activeColor: whiteColor,
            ),
          ),
        ),
      ]),
    );
  }
}
