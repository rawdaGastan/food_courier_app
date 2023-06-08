import 'package:flutter/cupertino.dart';
import 'package:foodCourier/controllers/networking.dart';
import 'dart:convert';
import 'package:foodCourier/models/user.dart';

class UserProvider extends ChangeNotifier {
  final User _user = User('', '', '', '', '', '');
  User get user => _user;

  getUserData(String userToken) async {
    Networking net = Networking();
    Map<String, dynamic> response = jsonDecode(await net.getUser(userToken));

    _user.setEmail = response['email'];
    _user.setPhone = response['phone_number'];
  }

  Future updateUserData(String userToken, firstName, lastName, dateOfBirth,
      durationOfDiet) async {
    Networking net = Networking();
    var response = await net.updateUserData(
        userToken, firstName, lastName, dateOfBirth, durationOfDiet);

    if (response != null) {
      _user.setFirstName = firstName;
      _user.setLastName = lastName;
      _user.setDateOfBirth = dateOfBirth;
      _user.setDurationOfDiet = durationOfDiet;
      return response;
    }
    return response;
  }

  Future getProfile(String userToken) async {
    Networking net = Networking();
    var response = await net.getProfile(userToken);

    if (response != null) {
      _user.setFirstName = response['first_name'];
      _user.setLastName = response['last_name'];
      _user.setDateOfBirth = response['date_of_birth'];
      _user.setDurationOfDiet = response['duration_of_diet'];
      return response;
    }
    return response;
  }
}
