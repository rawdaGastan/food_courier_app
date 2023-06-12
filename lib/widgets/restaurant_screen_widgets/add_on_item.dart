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
  const AddOnItemList({Key? key}) : super(key: key);

  @override
  AddOnItemListState createState() => AddOnItemListState();
}

class AddOnItemListState extends State<AddOnItemList> {
  bool subItemChecked = false;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const ScrollPhysics(),
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
          SizedBox(
            width: 40 * SizeConfig.blockSizeHorizontal!,
            child: Text(
              addOnItemsList.keys.elementAt(index),
            ),
          ),
          const Spacer(),
          Text(
            addOnItemsList.values.elementAt(index),
          ),
        ],
      ),
      itemCount: addOnItemsList.length,
      shrinkWrap: true,
    );
  }
}
