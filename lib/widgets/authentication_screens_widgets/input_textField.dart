import 'package:flutter/material.dart';
import 'package:foodCourier/constants/text_styles.dart';
import 'package:foodCourier/constants/colors.dart';
import 'package:foodCourier/controllers/size_config.dart';
import 'package:form_field_validator/form_field_validator.dart';

class InputField extends StatelessWidget {
  final bool isObscure;
  final TextInputType type;
  final String label;
  final Widget prefix;
  final Function onChanged;
  final MultiValidator validator;
  final TextEditingController controller;
  final double width;
  final Widget suffix;

  InputField(
      {Key key,
      this.isObscure,
      this.type,
      this.label,
      this.prefix,
      this.suffix,
      this.onChanged,
      this.validator,
      this.controller,
      this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: validator == null
          ? 7 * SizeConfig.blockSizeVertical
          : 9 * SizeConfig.blockSizeVertical,
      padding:
          EdgeInsets.symmetric(horizontal: 5 * SizeConfig.blockSizeHorizontal),
      margin: EdgeInsets.only(
        //top: SizeConfig.blockSizeVertical,
        bottom: SizeConfig.blockSizeVertical,
      ),
      child: TextFormField(
        onChanged: (String input) {
          onChanged(input);
        },
        validator: validator,
        controller: controller,
        obscureText: isObscure,
        textAlign: TextAlign.left,
        style: fillFieldText,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: type == null ? TextInputType.text : type,
        decoration: InputDecoration(
          hintText: label,
          hintStyle: fieldText,
          prefix: prefix,
          suffix: suffix,
          enabledBorder: new UnderlineInputBorder(
              borderSide: new BorderSide(color: lightTextColor)),
          focusedBorder: new UnderlineInputBorder(
              borderSide: new BorderSide(color: primaryColor)),
          contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 20.0, 10.0),
        ),
      ),
    );
  }
}
