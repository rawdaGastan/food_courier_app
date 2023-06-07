import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:foodCourier/constants/text_styles.dart';
import 'package:foodCourier/controllers/dynamic_links.dart';
import 'package:foodCourier/controllers/push_notification.dart';
import 'package:foodCourier/controllers/size_config.dart';
import '../locator.dart';
import 'package:foodCourier/generated/l10n.dart';
import 'package:foodCourier/providers/authentication_provider.dart';
import 'package:foodCourier/constants/colors.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
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
      decoration: BoxDecoration(
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20)),
        ),
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.all(5 * SizeConfig.blockSizeVertical),
            height: 40 * SizeConfig.blockSizeVertical,
            decoration: BoxDecoration(
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
                  height: 7 * SizeConfig.blockSizeVertical,
                  margin:
                      EdgeInsets.only(top: 3 * SizeConfig.blockSizeVertical),
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
