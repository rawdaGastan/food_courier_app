import 'package:get_it/get_it.dart';
import 'package:foodCourier/controllers/sharedPreferences.dart';

import 'controllers/analytics.dart';
import 'controllers/dynamic_links.dart';
import 'controllers/navigation_service.dart';
import 'controllers/push_notification.dart';
import 'controllers/facebook_analytics.dart';
import 'controllers/remote_config.dart';

GetIt locator = GetIt.instance;

Future setupLocator() async {
  locator.registerLazySingleton(() => PushNotification());
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => DynamicLinkService());
  locator.registerLazySingleton(() => AnalyticsService());
  locator.registerLazySingleton(() => FacebookAnalyticsService());
  locator.registerLazySingleton(() => SharedPreferencesClass());
  locator.registerLazySingleton(() => RemoteConfigService());
}
