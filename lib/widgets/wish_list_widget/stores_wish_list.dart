import 'package:flutter/material.dart';
import 'package:food_courier/constants/colors.dart';
import 'package:food_courier/controllers/size_config.dart';
import 'package:food_courier/models/restaurant.dart';
import 'package:food_courier/widgets/grocery_widgets/stores_all_card.dart';

// ignore: must_be_immutable
class StoreWishList extends StatelessWidget {
  final bool isFavorite = true;
  String duration = '';
  final List<Restaurant> temp = [
    Restaurant(
      name: 'Store',
      type: 'GRCR',
      city: 'Cairo',
      town: '5th-settlement',
      email: '',
      isDelivery: true,
      phone: '',
      id: 1,
      rating: '5',
      logoUrl: '',
      latitude: '1.5',
      longitude: '1.5',
      rangePrice: 1,
      isDineOut: false,
      addressLines: [],
      labels: {},
      photos: {
        119:
            'https://scontent-hbe1-1.xx.fbcdn.net/v/t1.0-9/151086294_732019560832468_3507742128333123628_n.jpg'
      },
    ),
    Restaurant(
      name: 'Store',
      type: 'GRCR',
      city: 'Cairo',
      town: '5th-settlement',
      email: '',
      isDelivery: true,
      phone: '',
      id: 1,
      rating: '5',
      logoUrl: '',
      latitude: '1.5',
      longitude: '1.5',
      rangePrice: 1,
      isDineOut: false,
      addressLines: [],
      labels: {},
      photos: {
        119:
            'https://scontent-hbe1-1.xx.fbcdn.net/v/t1.0-9/151086294_732019560832468_3507742128333123628_n.jpg'
      },
    ),
    Restaurant(
      name: 'Store',
      type: 'GRCR',
      city: 'Cairo',
      town: '5th-settlement',
      email: '',
      isDelivery: true,
      phone: '',
      id: 1,
      rating: '5',
      logoUrl: '',
      latitude: '1.5',
      longitude: '1.5',
      rangePrice: 1,
      isDineOut: false,
      addressLines: [],
      labels: {},
      photos: {
        119:
            'https://scontent-hbe1-1.xx.fbcdn.net/v/t1.0-9/151086294_732019560832468_3507742128333123628_n.jpg'
      },
    ),
    Restaurant(
      name: 'Store',
      type: 'GRCR',
      city: 'Cairo',
      town: '5th-settlement',
      email: '',
      isDelivery: true,
      phone: '',
      id: 1,
      rating: '5',
      logoUrl: '',
      latitude: '1.5',
      longitude: '1.5',
      rangePrice: 1,
      isDineOut: false,
      addressLines: [],
      labels: {},
      photos: {
        119:
            'https://scontent-hbe1-1.xx.fbcdn.net/v/t1.0-9/151086294_732019560832468_3507742128333123628_n.jpg'
      },
    ),
  ];

  StoreWishList({Key? key}) : super(key: key);

  callBackDistance(double dis, String? dur) {
    if (dur != null) {
      duration = dur;
      /* setState(() {
      duration = dur;
    });*/
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (_, index) => GestureDetector(
        onTap: () => {},
        child: Stack(
          children: [
            AllStoresCard(
              restaurant: temp[index],
              isDelivery: temp[index].isDelivery,
              callbackFun: callBackDistance,
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 4 * SizeConfig.blockSizeVertical!,
                left: 85 * SizeConfig.blockSizeHorizontal!,
              ),
              child: Stack(
                children: [
                  CircleAvatar(
                    backgroundColor: whiteColor,
                    radius: 4 * SizeConfig.blockSizeHorizontal!,
                  ),
                  SizedBox(
                    width: 8 * SizeConfig.blockSizeHorizontal!,
                    height: 8 * SizeConfig.blockSizeHorizontal!,
                    child: Icon(
                      isFavorite ? Icons.turned_in : Icons.turned_in_not,
                      color: orangeColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      itemCount: temp.length,
    );
  }
}
