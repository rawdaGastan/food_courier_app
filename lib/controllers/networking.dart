import 'dart:convert';

import 'package:food_courier/controllers/logger.dart';
import 'package:http/http.dart' as http;

class Networking {
  Networking();

  //String url = 'https://alexosama.pythonanywhere.com/api/suppliers/query/';
  String apiUrl = 'https://foodCouriereg.pythonanywhere.com/';
  String version = 'v1/';

  String url = '';

  Future<String> register(String email, String password1, String password2,
      String invitation) async {
    var jsonBody = jsonEncode({
      'email': email,
      'password1': password1,
      'password2': password2,
      'customer': true,
      'invitation': invitation,
    });

    var response = await http.post(
        Uri.parse('${apiUrl}dj-rest-auth/registration/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonBody);
    if (response.statusCode == 200) {
      logger.d('success');
      return response.body;
    } else {
      logger.d('Request failed with status: ${response.statusCode}.');
      return response.body;
    }
  }

  Future<String> login(String email, String password) async {
    var response = await http.post(Uri.parse('${apiUrl}dj-rest-auth/login/'),
        body: {'email': email, 'password': password});
    logger.d(response.body);
    if (response.statusCode == 200) {
      logger.d('success');
      return response.body;
    } else {
      logger.e('Request failed with status: ${response.statusCode}.');
      return response.body;
    }
  }

  Future<String> refreshToken(String refresh) async {
    var response = await http
        .post(Uri.parse('${apiUrl}dj-rest-auth/token/refresh/'), body: {
      'refresh': refresh,
    });
    if (response.statusCode == 200) {
      logger.d('success');
      return response.body;
    } else {
      logger.e('Request failed with status: ${response.statusCode}.');
      return response.body;
    }
  }

  Future<String> confirmEmail(String key) async {
    var response = await http.post(
        Uri.parse('${apiUrl}users/dj-rest-auth/registration/verify-email/'),
        body: {'key': key});
    if (response.statusCode == 200) {
      logger.d('success');
      return response.body;
    } else {
      logger.e('Request failed with status: ${response.statusCode}.');
      return response.body;
    }
  }

  Future<String> resetPassWithEmail(String email) async {
    var response = await http
        .post(Uri.parse('${apiUrl}dj-rest-auth/password/reset/'), body: {
      'email': email,
    });
    if (response.statusCode == 200) {
      logger.d('success');
      return response.body;
    } else {
      logger.e('Request failed with status: ${response.statusCode}.');
      return response.body;
    }
  }

  Future<String> changePass(
      String password, String password2, String uid, String token) async {
    var response = await http.post(
        Uri.parse('${apiUrl}dj-rest-auth/password/reset/confirm/'),
        body: {
          'new_password1': password,
          'new_password2': password2,
          'uid': uid,
          'token': token,
        });
    if (response.statusCode == 200) {
      logger.d('success');
      return response.body;
    } else {
      logger.e('Request failed with status: ${response.statusCode}.');
      return response.body;
    }
  }

  Future getUser(String token) async {
    url = '${apiUrl}api/users/me/';
    var response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      logger.d('success');
      return response.body;
    } else {
      logger.e('Request failed with status: ${response.statusCode}.');
    }
    return;
  }

  Future updateUserData(
      String token, firstName, lastName, dateOfBirth, durationOfDiet) async {
    url = '$apiUrl${version}api/profile/update';
    var response = await http.post(Uri.parse(url), headers: {
      'Authorization': 'Bearer $token',
    }, body: {
      'first_name': firstName,
      'last_name': lastName,
      'date_of_birth': dateOfBirth,
      'duration_of_diet': durationOfDiet,
    });
    if (response.statusCode == 200) {
      logger.d('success');
      return response.body;
    } else {
      logger.e('Request failed with status: ${response.statusCode}.');
    }
    return;
  }

  Future getProfile(String token) async {
    url = '$apiUrl${version}api/profile/view';
    var response = await http.get(Uri.parse(url), headers: {
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      logger.d('success');
      return response.body;
    } else {
      logger.e('Request failed with status: ${response.statusCode}.');
    }
    return;
  }

  Future getSuppliers(
      int pageIndex, String token, String restaurantType) async {
    url =
        '$apiUrl${version}api/branches/query?$restaurantType=true&page=$pageIndex';

    var response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      logger.d('success');
      return response.body;
    } else {
      logger.e('Request failed with status: ${response.statusCode}.');
    }
    return;
  }

  Future searchForRestaurant(String searchInput, int pageIndex, String token,
      String restaurantType) async {
    url =
        '$apiUrl${version}api/branches/query?$restaurantType=true&search_term=$searchInput&page=$pageIndex';
    var response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      logger.d('success');
      return response.body;
    } else {
      logger.e('Request failed with status: ${response.statusCode}.');
    }
    return;
  }

  Future sortRestaurantBy(
      int pageIndex, String sortBy, String token, String restaurantType) async {
    url =
        '$apiUrl${version}api/branches/query?$restaurantType=true&ordering=$sortBy&page=$pageIndex';
    var response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      logger.d('success');
      return response.body;
    } else {
      logger.e('Request failed with status: ${response.statusCode}.');
    }
    return;
  }

  Future sortRestaurantByDistance(int pageIndex, latitude, longitude,
      String token, String restaurantType) async {
    url =
        '$apiUrl${version}api/branches/query?$restaurantType=true&nearest_to=$latitude,$longitude&page=$pageIndex';
    var response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      logger.d('success');
      return response.body;
    } else {
      logger.e('Request failed with status: ${response.statusCode}.');
    }
    return;
  }

  Future showSuppliersByLocation(int pageIndex, String token, String location,
      String type, String restaurantType) async {
    url =
        '$apiUrl${version}api/branches/query?$restaurantType=true&$type=$location&page=$pageIndex';
    var response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      logger.d('success');
      return response.body;
    } else {
      logger.e('Request failed with status: ${response.statusCode}.');
    }
    return;
  }

  Future getMealsData(
      String restaurantName, int pageIndex, String token) async {
    url =
        '$apiUrl${version}api/products/query?supplier=$restaurantName&page=$pageIndex';
    var response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      logger.d('success');
      return response.body;
    } else {
      logger.e('Request failed with status: ${response.statusCode}.');
    }
    return;
  }

  Future getSpecificMeal(int id, String token) async {
    url = '$apiUrl${version}api/products/id/$id';
    var response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      logger.d('success');
      return response.body;
    } else {
      logger.e('Request failed with status: ${response.statusCode}.');
    }
    return;
  }
}
