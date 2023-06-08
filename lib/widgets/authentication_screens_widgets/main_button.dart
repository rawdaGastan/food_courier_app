import 'package:flutter/material.dart';
import 'package:foodCourier/constants/text_styles.dart';
import 'package:foodCourier/constants/colors.dart';
import 'package:foodCourier/controllers/size_config.dart';

class MainButton extends StatelessWidget {
  final void Function()? action;
  final String label;

  const MainButton({Key? key, this.action, this.label = ''}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90 * SizeConfig.blockSizeHorizontal!,
      height: 8 * SizeConfig.blockSizeVertical!,
      padding:
          EdgeInsets.symmetric(horizontal: 5 * SizeConfig.blockSizeHorizontal!),
      margin: EdgeInsets.only(top: 2 * SizeConfig.blockSizeVertical!),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
        ),
        onPressed: action,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              label,
              style: buttonText,
            ),
          ],
        ),
      ),
    );
  }
}
