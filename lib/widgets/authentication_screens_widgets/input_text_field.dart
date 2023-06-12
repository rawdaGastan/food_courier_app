import 'package:flutter/material.dart';
import 'package:food_courier/constants/text_styles.dart';
import 'package:food_courier/constants/colors.dart';
import 'package:food_courier/controllers/size_config.dart';
import 'package:form_field_validator/form_field_validator.dart';

class InputField extends StatelessWidget {
  final bool isObscure;
  final TextInputType? type;
  final String? label;
  final Widget? prefix;
  final Function onChanged;
  final MultiValidator? validator;
  final TextEditingController? controller;
  final double? width;
  final Widget? suffix;

  const InputField(
      {Key? key,
      this.isObscure = false,
      this.type,
      this.label,
      this.prefix,
      this.suffix,
      required this.onChanged,
      this.validator,
      this.controller,
      this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 9 * SizeConfig.blockSizeVertical!,
      padding:
          EdgeInsets.symmetric(horizontal: 5 * SizeConfig.blockSizeHorizontal!),
      margin: EdgeInsets.only(
        //top: SizeConfig.blockSizeVertical!,
        bottom: SizeConfig.blockSizeVertical!,
      ),
      child: TextFormField(
        onChanged: (String input) {
          onChanged(input);
        },
        validator: validator!,
        controller: controller,
        obscureText: isObscure,
        textAlign: TextAlign.left,
        style: fillFieldText,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: type ?? TextInputType.text,
        decoration: InputDecoration(
          hintText: label,
          hintStyle: fieldText,
          prefix: prefix,
          suffix: suffix,
          enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: lightTextColor)),
          focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: primaryColor)),
          contentPadding: const EdgeInsets.fromLTRB(10.0, 10.0, 20.0, 10.0),
        ),
      ),
    );
  }
}
