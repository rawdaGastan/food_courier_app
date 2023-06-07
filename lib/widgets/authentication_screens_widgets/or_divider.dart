import 'package:flutter/material.dart';
import 'package:foodCourier/constants/text_styles.dart';
import 'package:foodCourier/constants/colors.dart';
import 'package:foodCourier/controllers/size_config.dart';

class OrDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Expanded(
        child: Container(
            margin: EdgeInsets.only(
              top: 4 * SizeConfig.blockSizeVertical,
              bottom: 2 * SizeConfig.blockSizeVertical,
              left: 10 * SizeConfig.blockSizeHorizontal,
              right: 5 * SizeConfig.blockSizeHorizontal,
            ),
            //margin: const EdgeInsets.only(left: 10.0, right: 20.0),
            child: Divider(
              color: lightTextColor,
              thickness: 1,
            )),
      ),
      Padding(
        padding: EdgeInsets.only(
          top: 4 * SizeConfig.blockSizeVertical,
          bottom: 2 * SizeConfig.blockSizeVertical,
        ),
        child: Text("OR", style: fieldText),
      ),
      Expanded(
        child: Container(
            margin: EdgeInsets.only(
              top: 4 * SizeConfig.blockSizeVertical,
              bottom: 2 * SizeConfig.blockSizeVertical,
              right: 10 * SizeConfig.blockSizeHorizontal,
              left: 5 * SizeConfig.blockSizeHorizontal,
            ),
            //margin: const EdgeInsets.only(left: 20.0, right: 10.0),
            child: Divider(
              color: lightTextColor,
              thickness: 1,
            )),
      ),
    ]);
  }
}
