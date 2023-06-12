import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:food_courier/constants/text_styles.dart';
import 'package:food_courier/controllers/dynamic_links.dart';
import 'package:food_courier/controllers/push_notification.dart';
import 'package:food_courier/controllers/size_config.dart';
import '../locator.dart';
import 'package:food_courier/generated/l10n.dart';
import 'package:food_courier/providers/authentication_provider.dart';
import 'package:food_courier/constants/colors.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  SplashState createState() => SplashState();
}

class SplashState extends State<Splash> {
  final PushNotification _pushNotification = locator<PushNotification>();
  final DynamicLinkService _dynamicLinkService = locator<DynamicLinkService>();

  @override
  initState() {
    super.initState();
    /*Future.delayed(Duration(seconds: 0)).then((_) {
      bottomSheet(context);
    });*/
    goToNextScreen();
  }

  goToNextScreen() async {
    await Future.delayed(const Duration(seconds: 2), () {});
    //Navigator.pop(context);
    //Navigator.pushNamed(context, 'register');
    isLoggedIn();
    //push notification navigation
    await _pushNotification.initialise();
    //dynamic links
    await _dynamicLinkService.handleDynamicLinks();
  }

  isLoggedIn() async {
    dynamic route =
        await Provider.of<AuthenticationProvider>(context, listen: false)
            .isLoggedIn();
    if (route != null) Navigator.pushNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: splashBackground,
        image: DecorationImage(
          image: AssetImage('assets/logos/logo.png'),
          fit: BoxFit.scaleDown,
        ),
      ),
    );
  }

  void bottomSheet(context) {
    SizeConfig().init(context);
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20)),
        ),
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.all(5 * SizeConfig.blockSizeVertical!),
            height: 40 * SizeConfig.blockSizeVertical!,
            decoration: const BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20), topLeft: Radius.circular(20)),
            ),
            alignment: Alignment.center,
            //color: Color(0xFFF0F9F4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  S().splashText,
                  style: splashDescription,
                  maxLines: 4,
                  textAlign: TextAlign.center,
                ),
                Container(
                  height: 7 * SizeConfig.blockSizeVertical!,
                  margin:
                      EdgeInsets.only(top: 3 * SizeConfig.blockSizeVertical!),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, 'login');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          S().signIn,
                          //'Sign in',
                          style: buttonText,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
