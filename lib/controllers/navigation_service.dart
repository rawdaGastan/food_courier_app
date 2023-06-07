import 'package:flutter/material.dart';

class NavigationService {
  final _navigationKey = GlobalKey<NavigatorState>();

  GlobalKey<NavigatorState> get navigationKey => _navigationKey;

  void pop() {
    return _navigationKey.currentState.pop();
  }

  Future<dynamic> navigateTo(String routeName) {
    return _navigationKey.currentState.pushNamed(routeName);
  }

  Future<dynamic> navigateWithArgsTo(String routeName, String arguments) {
    return _navigationKey.currentState
        .pushNamed(routeName, arguments: arguments);
  }
}
