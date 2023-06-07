import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:foodCourier/providers/filters_api_provider.dart';
import 'package:foodCourier/screens/forgot_pass.dart';
import 'package:foodCourier/screens/home.dart';
import 'package:foodCourier/screens/meal.dart';
import 'package:foodCourier/screens/login.dart';
import 'package:foodCourier/screens/p_info_registration.dart';
import 'package:foodCourier/screens/preferences_registration.dart';
import 'package:foodCourier/screens/profile.dart';
import 'package:foodCourier/screens/register.dart';
import 'package:foodCourier/screens/reset_password.dart';
import 'package:foodCourier/screens/restaurant.dart';
import 'controllers/analytics.dart';
import 'controllers/navigation_service.dart';
import 'controllers/remote_config.dart';
import 'screens/feedback.dart';
import 'package:foodCourier/screens/verification_code.dart';
import 'package:foodCourier/screens/wish_list.dart';
import 'package:foodCourier/providers/type_filter_provider.dart';
import 'screens/splash.dart';
import 'package:foodCourier/locator.dart';
import 'package:foodCourier/screens/languages.dart';
import 'package:foodCourier/providers/meals_provider.dart';
import 'package:foodCourier/generated/l10n.dart';
import 'package:foodCourier/providers/authentication_provider.dart';
import 'package:foodCourier/screens/order.dart';
import 'package:foodCourier/screens/all_orders.dart';
import 'package:foodCourier/screens/track_order.dart';
import 'package:foodCourier/screens/finished_order.dart';
import 'package:foodCourier/screens/order_details.dart';
import 'package:foodCourier/screens/order_checkout.dart';
import 'package:foodCourier/providers/user_provider.dart';
import 'package:foodCourier/providers/order_provider.dart';
import 'package:foodCourier/screens/grocery_see_all.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  //crashLytics
  await Firebase.initializeApp();
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  runApp(foodCourier());
}

class foodCourier extends StatefulWidget {
  final RemoteConfigService remoteConfigService =
      locator<RemoteConfigService>();

  _foodCourierState createState() => _foodCourierState();
  static _foodCourierState of(BuildContext context) =>
      context.findAncestorStateOfType<_foodCourierState>();
}

class _foodCourierState extends State<foodCourier> {
  Locale _locale;

  void setLocale(Locale value) async {
    await S.load(value);
    setState(() {
      _locale = value;
      print(_locale);
    });
  }

  startRemoteConfig() async {
    await widget.remoteConfigService.initialise();
  }

  @override
  void initState() {
    startRemoteConfig();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //uxcam
    /*FlutterUxcam.optIntoSchematicRecordings();
    FlutterUxcam.startWithKey(UXCamKey);*/

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TypeFilterProvider>(
          create: (_) => TypeFilterProvider(),
        ),
        ChangeNotifierProvider<AllFiltersProvider>(
          create: (_) => AllFiltersProvider(),
        ),
        ChangeNotifierProvider<MealsProvider>(
          create: (_) => MealsProvider(),
        ),
        ChangeNotifierProvider<AuthenticationProvider>(
          create: (_) => AuthenticationProvider(),
        ),
        ChangeNotifierProvider<UserProvider>(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider<OrderProvider>(
          create: (_) => OrderProvider(),
        ),
      ],
      child: MaterialApp(
        locale: _locale,
        localizationsDelegates: const [
          //AppLocalizationDelegate(),
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const <Locale>[
          Locale('en', ''),
          Locale('ar', ''),
          Locale('de', ''),
          Locale('fr', ''),
        ],
        navigatorObservers: [
          locator<AnalyticsService>().getAnalyticsObserver(),
        ],
        navigatorKey: locator<NavigationService>().navigationKey,
        initialRoute: '/',
        routes: {
          '/': (context) => Splash(), //Splash(),
          'home': (context) => Home(),
          'restaurant': (context) => RestaurantScreen(),
          'register': (context) => Registration(),
          'login': (context) => LoginScreen(),
          'forgot pass': (context) => ForgotPass(),
          'verify': (context) => VerificationCodeScreen(),
          'pInfo reg': (context) => PersonalInfoRegistration(),
          'preferences reg': (context) => PreferencesRegistration(),
          'reset pass': (context) => ResetPassword(),
          'feedback': (context) => FeedBack(),
          'profile': (context) => Profile(),
          'wish list': (context) => WishList(),
          'languages': (context) => Languages(),
          'meal': (context) => MealScreen(),
          'order': (context) => Order(),
          'order checkout': (context) => OrderCheckout(),
          'all orders': (context) => AllOrdersScreen(),
          'track order': (context) => TrackOrderScreen(),
          'finish order': (context) => FinishedOrderScreen(),
          'order details': (context) => OrderDetailsScreen(),
          'grocery see all': (context) => GrocerySeeAll(),
        },
        builder: (context, _) {
          return MediaQuery(
            child: _,
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          );
        },
      ),
    );
  }
}
