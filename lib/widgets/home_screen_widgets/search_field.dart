import 'package:flutter/material.dart';
import 'package:foodCourier/constants/text_styles.dart';
import 'package:foodCourier/constants/colors.dart';
import 'package:foodCourier/controllers/size_config.dart';
import 'package:foodCourier/generated/l10n.dart';

class SearchField extends StatelessWidget {
  final Function callbackFun;

  const SearchField(this.callbackFun, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 6 * SizeConfig.blockSizeVertical!,
      child: TextField(
        onSubmitted: (String? input) {
          if (input == '') {
            input = null;
          }
          callbackFun(input);
        },
        //onChanged: (input) {this.callbackFun(input);} ,
        style: fillFieldText,
        decoration: InputDecoration(
          fillColor: secondaryColor,
          filled: true,
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
          ),
          contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          prefixIcon: const Icon(
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
