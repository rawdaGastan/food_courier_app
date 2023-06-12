import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesClass {
  late SharedPreferences prefs;

  Future<bool> isFirstTime() async {
    prefs = await SharedPreferences.getInstance();
    var isFirstTime = prefs.getBool('first_time');
    if (isFirstTime != null && !isFirstTime) {
      prefs.setBool('first_time', false);
      return false;
    } else {
      prefs.setBool('first_time', false);
      return true;
    }
  }

  setBackgroundNotification(bool value) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setBool('show_notification', value);
  }

  Future<bool?> showBackgroundNotification() async {
    prefs = await SharedPreferences.getInstance();
    bool? showNotification = prefs.getBool('show_notification');
    setBackgroundNotification(false);
    return showNotification;
  }
}
