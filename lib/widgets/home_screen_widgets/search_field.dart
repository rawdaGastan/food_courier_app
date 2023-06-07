import 'package:flutter/material.dart';
import 'package:foodCourier/constants/text_styles.dart';
import 'package:foodCourier/constants/colors.dart';
import 'package:foodCourier/controllers/size_config.dart';
import 'package:foodCourier/generated/l10n.dart';

class SearchField extends StatelessWidget {
  final Function callbackFun;

  SearchField(this.callbackFun);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 6 * SizeConfig.blockSizeVertical!,
      child: TextField(
        onSubmitted: (input) {
          if (input == '') {
            input = null;
          }
          this.callbackFun(input);
        },
        //onChanged: (input) {this.callbackFun(input);} ,
        style: fillFieldText,
        decoration: InputDecoration(
          fillColor: secondaryColor,
          filled: true,
          border: new OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: const BorderRadius.all(
              const Radius.circular(8.0),
            ),
          ),
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          prefixIcon: Icon(
            Icons.search,
            size: 25.0,
            color: primaryColor,
          ),
          hintText: S().search,
          //'Find restaurant, meal...',
          hintStyle: fieldText,
        ),
      ),
    );
  }
}
