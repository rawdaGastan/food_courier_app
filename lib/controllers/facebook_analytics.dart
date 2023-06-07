import 'package:facebook_app_events/facebook_app_events.dart';

class FacebookAnalyticsService {
  final facebookAppEvents = FacebookAppEvents();

  Future logEvent() async {
    await facebookAppEvents.logEvent(
      name: "test_event",
      parameters: {"value": 10, "subname": "exampleStringValue"},
    );
  }
}
