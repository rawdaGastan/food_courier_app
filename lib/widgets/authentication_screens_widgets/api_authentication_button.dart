import 'package:flutter/material.dart';
import 'package:foodCourier/constants/text_styles.dart';
import 'package:foodCourier/constants/colors.dart';
import 'package:foodCourier/controllers/size_config.dart';

class ApiButton extends StatelessWidget {
  final Function action;
  final String label;
  final Widget leading;
  final Color color;

  const ApiButton({Key key, this.action, this.label, this.leading, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 7 * SizeConfig.blockSizeVertical!,
      margin: EdgeInsets.symmetric(
          horizontal: 10 * SizeConfig.blockSizeHorizontal!),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: secondaryColor,
            offset: Offset(5, 5), // changes position of shadow
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: whiteColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
        ),
        onPressed: action,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            leading,
            Text(
              label,
              style: blackSmallText15,
            ),
          ],
        ),
      ),
    );
  }
}
