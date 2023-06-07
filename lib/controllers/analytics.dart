import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  FirebaseAnalyticsObserver getAnalyticsObserver() =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  Future setUserProperties(
      {required String userId, required String userRole}) async {
    await _analytics.setUserId(id: userId);
    await _analytics.setUserProperty(name: 'user_role', value: userRole);
  }

  Future logLogin() async {
    await _analytics.logLogin(loginMethod: 'email');
  }

  Future logSignUp() async {
    await _analytics.logSignUp(signUpMethod: 'email');
  }

  Future logAnalyticsEvent() async {
    await _analytics.logEvent(
      name: 'test_event',
      parameters: <String, dynamic>{
        'string': 'string',
        'int': 42,
        'long': 12345678910,
        'double': 42.0,
        'bool': true,
      },
    );
    setMessage('logEvent succeeded');
  }

  void setMessage(String message) {
    /*setState(() {
      _message = message;
    });*/
  }

  Future<void> _testSetCurrentScreen() async {
    await _analytics.setCurrentScreen(
      screenName: 'Analytics Demo',
      screenClassOverride: 'AnalyticsDemo',
    );
    setMessage('setCurrentScreen succeeded');
  }

  Future<void> _testSetAnalyticsCollectionEnabled() async {
    await _analytics.setAnalyticsCollectionEnabled(false);
    await _analytics.setAnalyticsCollectionEnabled(true);
    setMessage('setAnalyticsCollectionEnabled succeeded');
  }

  Future<void> _testSetSessionTimeoutDuration() async {
    await _analytics.android?.setSessionTimeoutDuration(2000000);
    setMessage('setSessionTimeoutDuration succeeded');
  }
}
