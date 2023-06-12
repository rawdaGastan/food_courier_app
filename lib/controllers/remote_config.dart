import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:foodCourier/controllers/logger.dart';

const String _orderingFeature = 'ordering_feature';
const String _paymentFeature = 'payment_feature';
const String _groceryFeature = 'grocery_feature';
const String _restrictionList = 'restriction_list';
const String _restrictionListTypes = 'restriction_list_types';
const String _cuisinesList = 'cuisines_list';
const String _labelsList = 'labels_list';
const String _changeConfirmLink = 'change_confirm_email_link';

class RemoteConfigService {
  final remoteConfig = FirebaseRemoteConfig.instance;
  final defaults = <String, dynamic>{
    _orderingFeature: false,
    _paymentFeature: false,
    _groceryFeature: false,
    _restrictionListTypes: '',
    _restrictionList: '',
    _cuisinesList: '',
    _labelsList: '',
    _changeConfirmLink: ''
  };

  bool get orderingFeature => remoteConfig.getBool(_orderingFeature);
  bool get paymentFeature => remoteConfig.getBool(_paymentFeature);
  bool get groceryFeature => remoteConfig.getBool(_groceryFeature);

  String get restrictionList => remoteConfig.getString(_restrictionList);
  String get cuisinesList => remoteConfig.getString(_cuisinesList);
  String get restrictionListTypes =>
      remoteConfig.getString(_restrictionListTypes);
  String get labelsList => remoteConfig.getString(_labelsList);

  String get changeConfirmEmailLink =>
      remoteConfig.getString(_changeConfirmLink);

  Future initialise() async {
    try {
      await remoteConfig.setDefaults(defaults);
      await remoteConfig.fetchAndActivate();
    } catch (e) {
      logger.e(
          'unable to fetch remote config. Cashed or default values will be used $e');
    }
  }
}
