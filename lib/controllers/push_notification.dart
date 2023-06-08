import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:foodCourier/controllers/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:foodCourier/constants/colors.dart';
import 'package:foodCourier/constants/text_styles.dart';
import 'package:foodCourier/controllers/size_config.dart';
import 'package:foodCourier/widgets/authentication_screens_widgets/main_button.dart';
import 'dart:io';
import '../locator.dart';
import 'navigation_service.dart';

class PushNotification {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final NavigationService _navigationService = locator<NavigationService>();
  bool onBackground = false;
  //final GlobalKey<NavigatorState> navigatorKey = GlobalKey(debugLabel: "Main Navigator");

  void _tokenRefresh(String newToken) async {
    logger.d('New FCM Token $newToken');
  }

  void _tokenRefreshFailure(error) {
    logger.e('FCM token refresh failed with error $error');
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    SharedPreferences.setMockInitialValues({});
    logger.d('onBackgroundMessage : $message');
    PushNotification().onBackground = true;
    logger.d('onBackground : ${PushNotification().onBackground}');
  }

  void showFlutterNotification(RemoteMessage message) {
    logger.d('onMessage : $message');
    _insideAppNotification(message);
  }

  Future initialise() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen(showFlutterNotification);
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      logger.d('A new onMessageOpenedApp event was published!');
      _serializeAndNavigate(message);
      _insideAppNotification(message);
    });

    if (Platform.isIOS) {
      _firebaseMessaging.requestPermission();
    }

    //handle token of the user registered in FCM
    /* String token = await _firebaseMessaging.getToken();
    var onTokenRefresh = _firebaseMessaging.onTokenRefresh;
    print(token);
    _firebaseMessaging.onTokenRefresh.listen(_tokenRefresh, onError: _tokenRefreshFailure);
        */

    _firebaseMessaging.subscribeToTopic('all');
  }

  void _serializeAndNavigate(RemoteMessage message) {
    var notificationData = message.data;
    var view = notificationData['view'];

    if (view != null) {
      // _navigationService.navigateTo(view);
      _navigationService.navigateTo('home');
    }
  }

  void _insideAppNotification(RemoteMessage message) {
    /*var notification = message['notification'];
    var title = notification['title'];
    var body = notification['body'];*/

    var notificationData = message.data;
    var view = notificationData['view'];

    if (view != null) {
      if (view == 'track order') {
        displayTrackOrderDialog(
            _navigationService.navigationKey.currentState!.overlay!.context);
      }
      if (view == 'rate order') {
        displayRateOrderDialog(
            _navigationService.navigationKey.currentState!.overlay!.context);
      }
    }
  }

  displayTrackOrderDialog(context) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          contentPadding: EdgeInsets.all(0 * SizeConfig.blockSizeVertical!),
          content: SizedBox(
            height: 18 * SizeConfig.blockSizeVertical!,
            child: Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Stack(
                      children: <Widget>[
                        Positioned.fill(
                          child: Container(
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: blackColor),
                            margin: EdgeInsets.all(1.5 *
                                SizeConfig
                                    .blockSizeVertical!), // Modify this till it fills the color properly
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded,
                              color: whiteColor),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ],
                ),
                Center(
                  child: Padding(
                    padding:
                        EdgeInsets.only(top: 4 * SizeConfig.blockSizeVertical!),
                    child: CircleAvatar(
                      radius: 12 * SizeConfig.blockSizeHorizontal!,
                      backgroundColor: backgroundImages,
                      backgroundImage: const AssetImage(
                        'assets/icons/temp.png',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actionsPadding:
              EdgeInsets.only(bottom: 3 * SizeConfig.blockSizeVertical!),
          actions: <Widget>[
            MainButton(
              label: 'Track your order',
              action: () => Navigator.pushNamed(context, 'track order'),
            ),
          ],
        ),
      );

  displayRateOrderDialog(context) {
    int rateByUser = 0;
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.all(0 * SizeConfig.blockSizeVertical!),
        content: SizedBox(
          height: 35 * SizeConfig.blockSizeVertical!,
          child: Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Stack(
                    children: <Widget>[
                      Positioned.fill(
                        child: Container(
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: blackColor),
                          margin: EdgeInsets.all(1.5 *
                              SizeConfig
                                  .blockSizeVertical!), // Modify this till it fills the color properly
                        ),
                      ),
                      IconButton(
                        icon:
                            const Icon(Icons.close_rounded, color: whiteColor),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding:
                    EdgeInsets.only(top: 8 * SizeConfig.blockSizeVertical!),
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'We care about your feedback !',
                      style: rateOrderNotificationDialog,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical!,
                    ),
                    const AutoSizeText(
                      'How was your last order ?',
                      style: pickUpTime,
                      textAlign: TextAlign.center,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            icon: Icon(
                                rateByUser >= 1
                                    ? Icons.star
                                    : Icons.star_border,
                                color: orangeColor),
                            onPressed: () {
                              _navigationService.navigationKey.currentState!
                                  .setState(() {
                                rateByUser = 1;
                              });
                            }),
                        IconButton(
                            icon: Icon(
                                rateByUser >= 2
                                    ? Icons.star
                                    : Icons.star_border,
                                color: orangeColor),
                            onPressed: () {
                              _navigationService.navigationKey.currentState!
                                  .setState(() {
                                rateByUser = 2;
                              });
                            }),
                        IconButton(
                            icon: Icon(
                                rateByUser >= 3
                                    ? Icons.star
                                    : Icons.star_border,
                                color: orangeColor),
                            onPressed: () {
                              _navigationService.navigationKey.currentState!
                                  .setState(() {
                                rateByUser = 3;
                              });
                            }),
                        IconButton(
                            icon: Icon(
                                rateByUser >= 4
                                    ? Icons.star
                                    : Icons.star_border,
                                color: orangeColor),
                            onPressed: () {
                              _navigationService.navigationKey.currentState!
                                  .setState(() {
                                rateByUser = 4;
                              });
                            }),
                        IconButton(
                            icon: Icon(
                                rateByUser == 5
                                    ? Icons.star
                                    : Icons.star_border,
                                color: orangeColor),
                            onPressed: () {
                              _navigationService.navigationKey.currentState!
                                  .setState(() {
                                rateByUser = 5;
                              });
                            }),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
