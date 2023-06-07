import 'package:flutter/material.dart';
import 'package:foodCourier/constants/text_styles.dart';
import 'package:foodCourier/constants/colors.dart';
import 'package:foodCourier/controllers/size_config.dart';
import 'package:foodCourier/generated/l10n.dart';

class FeedbackReview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: secondaryColor,
      width: SizeConfig.screenWidth,
      height: 18 * SizeConfig.blockSizeVertical!,
      margin: EdgeInsets.all(2 * SizeConfig.blockSizeVertical!),
      padding: EdgeInsets.only(
          left: SizeConfig.blockSizeHorizontal!,
          top: 2 * SizeConfig.blockSizeVertical!,
          //bottom: 2 * SizeConfig.blockSizeVertical!,
          right: SizeConfig.blockSizeHorizontal!),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            S().satisfied,
            //'How satisfied are you with the service?',
            style: feedbackSatisfiedStyle,
          ),
          Container(
            height: 3 * SizeConfig.blockSizeVertical!,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                radius: 7 * SizeConfig.blockSizeHorizontal!,
                backgroundColor: backgroundImages,
                backgroundImage: AssetImage(
                  'assets/icons/horrible.png',
                ),
              ),
              CircleAvatar(
                radius: 7 * SizeConfig.blockSizeHorizontal!,
                backgroundColor: backgroundImages,
                backgroundImage: AssetImage(
                  'assets/icons/bad.png',
                ),
              ),
              CircleAvatar(
                radius: 7 * SizeConfig.blockSizeHorizontal!,
                backgroundColor: backgroundImages,
                backgroundImage: AssetImage(
                  'assets/icons/normal.png',
                ),
              ),
              CircleAvatar(
                radius: 7 * SizeConfig.blockSizeHorizontal!,
                backgroundColor: backgroundImages,
                backgroundImage: AssetImage(
                  'assets/icons/good.png',
                ),
              ),
              CircleAvatar(
                radius: 7 * SizeConfig.blockSizeHorizontal!,
                backgroundColor: backgroundImages,
                backgroundImage: AssetImage(
                  'assets/icons/excellent.png',
                ),
              ),
            ],
          ),
          /*EmojiFeedback(
            key: _fabKey,
            onChange: (index) {
              print(index);
            },
          ),*/
        ],
      ),
    );
  }
}
