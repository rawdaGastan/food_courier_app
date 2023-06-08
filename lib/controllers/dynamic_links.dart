import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:foodCourier/controllers/logger.dart';
import 'package:foodCourier/controllers/remote_config.dart';
import 'package:foodCourier/locator.dart';
import 'package:foodCourier/controllers/navigation_service.dart';
import 'package:foodCourier/providers/authentication_provider.dart';

class DynamicLinkService {
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

  final RemoteConfigService _remoteConfigService =
      locator<RemoteConfigService>();
  final NavigationService _navigationService = locator<NavigationService>();

  Future handleDynamicLinks() async {
    // Get the initial dynamic link if the app is opened with a dynamic link
    final PendingDynamicLinkData? data = await dynamicLinks.getInitialLink();

    // handle link that has been retrieved
    _handleDeepLink(data!);

    // Register a link callback to fire if the app is opened up from the background
    // using a dynamic link.
    dynamicLinks.onLink.listen((dynamicLinkData) {
      _handleDeepLink(dynamicLinkData);
    }).onError((error) {
      logger.e('onLink error: ${error.message}');
    });
  }

  void _handleDeepLink(PendingDynamicLinkData data) async {
    final Uri deepLink = data.link;
    logger.d('_handleDeepLink | deeplink: $deepLink');

    var user = deepLink.pathSegments.contains('signin');
    var confirmEmail = deepLink.pathSegments.contains('confirm-email');
    var confirm = deepLink.pathSegments.contains('confirm');
    if (user) {
      _navigationService.navigateTo('login');
    } else if (confirmEmail) {
      var key = deepLink.queryParameters['key'];
      if (key != null) {
        _navigationService.navigateWithArgsTo('pInfo reg', key);
      } else {
        _navigationService.navigateTo('login');
      }
    } else if (confirm) {
      var key = deepLink.queryParameters['key'];
      if (key != null) {
        var response = await AuthenticationProvider().confirmEmail(key);
        logger.d('confirm email response : $response');

        if (response == 'confirmed') {
          _navigationService.navigateWithArgsTo('pInfo reg', key);
        } else {
          _navigationService.navigateTo('register');
        }
      }
    }

    createConfirmEmailLink('NQ:1lBEq8:Z84cUVDAI2jUFDP42zW3MXM__PQ');
  }

  Future<String> createConfirmEmailLink(String key) async {
    //remote config to change the link
    String changedLink;
    await _remoteConfigService.initialise();
    if (_remoteConfigService.changeConfirmEmailLink != '') {
      changedLink = _remoteConfigService.changeConfirmEmailLink;
      logger.d('changedLink: $changedLink');
    }

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://foodCourier.page.link',
      link: Uri.parse('https://foodCourier.com/confirm?key=$key'),
      androidParameters: const AndroidParameters(
        packageName: 'com.example.foodCourier',
      ),

      // Other things to add as an example. We don't need it now
      /*iosParameters: IosParameters(
        bundleId: 'com.example.ios',
        minimumVersion: '1.0.1',
        appStoreId: '123456789',
      ),
      googleAnalyticsParameters: GoogleAnalyticsParameters(
        campaign: 'example-promo',
        medium: 'social',
        source: 'orkut',
      ),
      itunesConnectAnalyticsParameters: ItunesConnectAnalyticsParameters(
        providerToken: '123456',
        campaignToken: 'example-promo',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: 'Example of a Dynamic Link',
        description: 'This link works whether app is installed or not!',
      ),*/
    );

    final ShortDynamicLink dynamicShortUrl =
        await dynamicLinks.buildShortLink(parameters);
    final Uri dynamicUrl = await dynamicLinks.buildLink(parameters);
    logger.d('dynamicShortUrl: $dynamicShortUrl');
    return dynamicUrl.toString();
  }
}
