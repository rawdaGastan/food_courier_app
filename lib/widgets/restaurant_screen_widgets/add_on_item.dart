import 'package:flutter/material.dart';
import 'package:foodCourier/constants/colors.dart';
import 'package:foodCourier/controllers/size_config.dart';

final Map<String, String> addOnItemsList = {
  'Lorem Ipsum is simply dummy text 1': '+3.50 \$',
  'Lorem Ipsum is simply dummy text 2': '+3.50 \$',
  'Lorem Ipsum is simply dummy text 3': '+3.50 \$',
  'Lorem Ipsum is simply dummy text 4': '+3.50 \$',
};

class AddOnItemList extends StatefulWidget {
  @override
  _AddOnItemListState createState() => _AddOnItemListState();
}

class _AddOnItemListState extends State<AddOnItemList> {
  bool subItemChecked = false;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: ScrollPhysics(),
      itemBuilder: (_, index) => Row(
        children: <Widget>[
          Checkbox(
              value: subItemChecked,
              checkColor: whiteColor,
              activeColor: blueTextColor,
              onChanged: (_) {
                setState(() {
                  subItemChecked = !subItemChecked;
                });
              }),
          Container(
            width: 40 * SizeConfig.blockSizeHorizontal,
            child: Text(
              addOnItemsList.keys.elementAt(index),
            ),
          ),
          Spacer(),
          Container(
            child: Text(
              addOnItemsList.values.elementAt(index),
            ),
          ),
        ],
      ),
      itemCount: addOnItemsList.length,
      shrinkWrap: true,
    );
  }
}
