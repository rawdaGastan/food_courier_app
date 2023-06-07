import 'package:flutter/material.dart';
import 'package:foodCourier/constants/text_styles.dart';
import 'package:foodCourier/constants/colors.dart';
import 'package:foodCourier/controllers/size_config.dart';
import 'package:foodCourier/widgets/authentication_screens_widgets/main_button.dart';

class FinishedOrderScreen extends StatefulWidget {
  @override
  _FinishedOrderScreenState createState() => _FinishedOrderScreenState();
}

class _FinishedOrderScreenState extends State<FinishedOrderScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(
              horizontal: 3 * SizeConfig.blockSizeVertical,
              vertical: 2 * SizeConfig.blockSizeVertical),
          children: [
            SizedBox(height: 10 * SizeConfig.blockSizeVertical),
            Container(
              width: 30 * SizeConfig.blockSizeHorizontal,
              height: 30 * SizeConfig.blockSizeVertical,
              child: Image(
                image: AssetImage(
                  'assets/icons/balloons.png',
                ),
              ),
            ),
            SizedBox(height: 2 * SizeConfig.blockSizeVertical),
            Text(
              'Thank you',
              style: ThankYou,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2 * SizeConfig.blockSizeVertical),
            Text(
              'Lorem Ipsum is simply dummy text of the printing and typesetting industry.'
              ' Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s,',
              style: pickUpAndDeliveryTime,
              textAlign: TextAlign.center,
            ),
            MainButton(
              label: 'Continue Browsing ',
              action: () => Navigator.pushNamed(context, 'home'),
            ),
          ],
        ),
      ),
    );
  }
}
