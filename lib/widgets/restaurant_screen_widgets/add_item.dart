import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:food_courier/constants/colors.dart';
import 'package:food_courier/constants/text_styles.dart';
import 'package:food_courier/controllers/size_config.dart';
import 'package:food_courier/models/meal.dart';
import 'package:food_courier/providers/authentication_provider.dart';
import 'package:food_courier/providers/order_provider.dart';
import 'package:food_courier/widgets/restaurant_screen_widgets/add_on_item.dart';

showIngredients(list) {
  var concatenate = StringBuffer();

  list.forEach((item) {
    concatenate.write('$item, ');
  });
  return concatenate.toString().substring(0, concatenate.toString().length - 2);
}

addItemTOCart(context, int productID, int quantity) async {
  String userToken =
      await Provider.of<AuthenticationProvider>(context, listen: false)
          .userToken;
  var response = await Provider.of<OrderProvider>(context, listen: false)
      .addToCart(userToken, productID, quantity);
  if (response != null) Navigator.pop(context);
}

void addItemBottomSheet(context, Meal meal, int productID) {
  int itemQuantity = 0;
  showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(40), topLeft: Radius.circular(40)),
      ),
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (BuildContext context, setState) {
          return Container(
            padding:
                EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeVertical!),
            height: 90 * SizeConfig.blockSizeVertical!,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(40), topLeft: Radius.circular(40)),
            ),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: SizeConfig.blockSizeVertical!,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () => Navigator.pop(context),
                      ),
                      IconButton(
                        icon: const Icon(Icons.error_outline),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.blockSizeVertical!),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SizedBox(
                        width: 70 * SizeConfig.blockSizeHorizontal!,
                        child: AutoSizeText(
                          meal.name,
                          style: orderMealName,
                        ),
                      ),
                      Text(
                        meal.price.toString(),
                        style: orderMealPrice,
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.all(
                    SizeConfig.blockSizeVertical!,
                  ),
                  child: AutoSizeText(
                    showIngredients(meal.ingredients),
                    style: mealIngredientsStyle,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(
                    SizeConfig.blockSizeVertical!,
                  ),
                  height: 25 * SizeConfig.blockSizeVertical!,
                  width: SizeConfig.screenWidth,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(meal.photoUrls[0]),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      Padding(
                        padding:
                            EdgeInsets.all(3 * SizeConfig.blockSizeHorizontal!),
                        child: const Text(
                          'lorem ipsec',
                          style: itemAddOn,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: 2 * SizeConfig.blockSizeVertical!,
                        ),
                        child: const AddOnItemList(),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.all(3 * SizeConfig.blockSizeHorizontal!),
                        child: const Text(
                          'Preferences',
                          style: itemAddOn,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 3 * SizeConfig.blockSizeHorizontal!),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Extra instructions',
                              style: mealSubTitles,
                            ),
                            Text(
                              'List any special requests',
                              style: mealSubTitles,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical!,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 5 * SizeConfig.blockSizeHorizontal!),
                        margin: EdgeInsets.only(
                          //top: SizeConfig.blockSizeVertical!,
                          bottom: SizeConfig.blockSizeVertical!,
                        ),
                        child: TextFormField(
                          textAlign: TextAlign.left,
                          style: fillFieldText,
                          decoration: const InputDecoration(
                            hintText: 'e.g. extra spicy,etc.',
                            hintStyle: fieldText,
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: lightTextColor)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: primaryColor)),
                            contentPadding:
                                EdgeInsets.fromLTRB(10.0, 10.0, 20.0, 10.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 47 * SizeConfig.blockSizeHorizontal!,
                      height: 8 * SizeConfig.blockSizeVertical!,
                      padding: EdgeInsets.symmetric(
                          horizontal: 5 * SizeConfig.blockSizeHorizontal!),
                      margin: EdgeInsets.only(
                          left: SizeConfig.blockSizeHorizontal!),
                      color: secondaryColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline,
                                color: lightTextColor, size: 30),
                            onPressed: () => setState(() => itemQuantity > 0
                                ? itemQuantity--
                                : itemQuantity),
                          ),
                          Text(
                            itemQuantity.toString(),
                            style: mealPrice,
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline,
                                color: lightTextColor, size: 30),
                            onPressed: () => setState(() => itemQuantity++),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 48 * SizeConfig.blockSizeHorizontal!,
                      height: 8 * SizeConfig.blockSizeVertical!,
                      //padding: EdgeInsets.only(right: SizeConfig.blockSizeHorizontal!),
                      margin: EdgeInsets.symmetric(
                          vertical: SizeConfig.blockSizeVertical!),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                          ),
                        ),
                        onPressed: () =>
                            addItemTOCart(context, productID, itemQuantity),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Add to cart',
                              style: buttonText,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
      });
}
