import 'package:flutter/material.dart';
import 'package:food_courier/constants/text_styles.dart';
import 'package:food_courier/constants/colors.dart';
import 'package:food_courier/controllers/size_config.dart';
import 'package:food_courier/widgets/authentication_screens_widgets/main_button.dart';

class FinishedOrderScreen extends StatefulWidget {
  const FinishedOrderScreen({Key? key}) : super(key: key);

  @override
  FinishedOrderScreenState createState() => FinishedOrderScreenState();
}

class FinishedOrderScreenState extends State<FinishedOrderScreen> {
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
              horizontal: 3 * SizeConfig.blockSizeVertical!,
              vertical: 2 * SizeConfig.blockSizeVertical!),
          children: [
            SizedBox(height: 10 * SizeConfig.blockSizeVertical!),
            SizedBox(
              width: 30 * SizeConfig.blockSizeHorizontal!,
              height: 30 * SizeConfig.blockSizeVertical!,
              child: const Image(
                image: AssetImage(
                  'assets/icons/balloons.png',
                ),
              ),
            ),
            SizedBox(height: 2 * SizeConfig.blockSizeVertical!),
            const Text(
              'Thank you',
              style: thankYou,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2 * SizeConfig.blockSizeVertical!),
            const Text(
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
