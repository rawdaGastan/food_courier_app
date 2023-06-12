import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:food_courier/providers/filters_api_provider.dart';
import 'package:food_courier/screens/forgot_pass.dart';
import 'package:food_courier/screens/home.dart';
import 'package:food_courier/screens/meal.dart';
import 'package:food_courier/screens/login.dart';
import 'package:food_courier/screens/p_info_registration.dart';
import 'package:food_courier/screens/preferences_registration.dart';
import 'package:food_courier/screens/profile.dart';
import 'package:food_courier/screens/register.dart';
import 'package:food_courier/screens/reset_password.dart';
import 'package:food_courier/screens/restaurant.dart';
import 'controllers/analytics.dart';
import 'controllers/navigation_service.dart';
import 'controllers/remote_config.dart';
import 'screens/feedback.dart';
import 'package:food_courier/screens/verification_code.dart';
import 'package:food_courier/screens/wish_list.dart';
import 'package:food_courier/providers/type_filter_provider.dart';
import 'screens/splash.dart';
import 'package:food_courier/locator.dart';
import 'package:food_courier/screens/languages.dart';
import 'package:food_courier/providers/meals_provider.dart';
import 'package:food_courier/generated/l10n.dart';
import 'package:food_courier/providers/authentication_provider.dart';
import 'package:food_courier/screens/order.dart';
import 'package:food_courier/screens/all_orders.dart';
import 'package:food_courier/screens/track_order.dart';
import 'package:food_courier/screens/finished_order.dart';
import 'package:food_courier/screens/order_details.dart';
import 'package:food_courier/screens/order_checkout.dart';
import 'package:food_courier/providers/user_provider.dart';
import 'package:food_courier/providers/order_provider.dart';
import 'package:food_courier/screens/grocery_see_all.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  //crashLytics
  await Firebase.initializeApp();
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  runApp(FoodCourier());
}

class FoodCourier extends StatefulWidget {
  final RemoteConfigService remoteConfigService =
      locator<RemoteConfigService>();

  FoodCourier({Key? key}) : super(key: key);

  @override
  FoodCourierState createState() => FoodCourierState();

  static FoodCourierState? of(BuildContext context) =>
      context.findAncestorStateOfType<FoodCourierState>();
}

class FoodCourierState extends State<FoodCourier> {
  late Locale _locale;

  void setLocale(Locale value) async {
    await S.load(value);
    setState(() {
      _locale = value;
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
    FlutterUxcam.startWithKey(uxCamKey);*/

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
          '/': (context) => const Splash(), //Splash(),
          'home': (context) => const Home(),
          'restaurant': (context) => const RestaurantScreen(),
          'register': (context) => const Registration(),
          'login': (context) => LoginScreen(),
          'forgot pass': (context) => const ForgotPass(),
          'verify': (context) => const VerificationCodeScreen(),
          'pInfo reg': (context) => const PersonalInfoRegistration(),
          'preferences reg': (context) => const PreferencesRegistration(),
          'reset pass': (context) => const ResetPassword(),
          'feedback': (context) => const FeedBack(),
          'profile': (context) => const Profile(),
          'wish list': (context) => const WishList(),
          'languages': (context) => Languages(),
          'meal': (context) => const MealScreen(),
          'order': (context) => const Order(),
          'order checkout': (context) => const OrderCheckout(),
          'all orders': (context) => const AllOrdersScreen(),
          'track order': (context) => const TrackOrderScreen(),
          'finish order': (context) => const FinishedOrderScreen(),
          'order details': (context) => const OrderDetailsScreen(),
          'grocery see all': (context) => const GrocerySeeAll(),
        },
        builder: (context, _) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: const SizedBox(),
          );
        },
      ),
    );
  }
}
