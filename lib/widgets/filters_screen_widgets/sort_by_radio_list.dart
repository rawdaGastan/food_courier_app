import 'package:flutter/material.dart';
import 'package:foodCourier/constants/text_styles.dart';
import 'package:foodCourier/constants/colors.dart';
import 'package:foodCourier/controllers/size_config.dart';

final sortByList = [
  'Rating',
  'Price',
  'Distance',
];

class SortByRadioList extends StatefulWidget {
  final Function callbackFun;

  const SortByRadioList(this.callbackFun, {Key? key}) : super(key: key);

  @override
  SortByRadioListState createState() => SortByRadioListState();
}

class SortByRadioListState extends State<SortByRadioList> {
  int selectedRadioTile = 0;

  // Changes the selected value on 'onChanged' click on each radio button
  setSelectedRadioTile(int val) {
    setState(() {
      selectedRadioTile = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: sortByList.length,
      itemBuilder: (context, index) => SizedBox(
        height: 6 * SizeConfig.blockSizeVertical!,
        child: RadioListTile(
          value: index,
          groupValue: selectedRadioTile,
          title: Text(sortByList[index],
              textScaleFactor: 1.0, style: sortFiltersText),
          onChanged: (val) {
            setSelectedRadioTile(val as int);
            if (val == 0) {
              widget.callbackFun('-rating');
            } else if (val == 1) {
              widget.callbackFun('price_range');
            } else if (val == 2) {
              widget.callbackFun('distance');
            }
          },
          activeColor: orangeColor,
        ),
      ),
    );
  }
}
