import 'dart:convert';

import 'package:foodCourier/controllers/logger.dart';
import 'package:http/http.dart' as http;

class OrderingNetworking {
  OrderingNetworking();

  String apiUrl = 'https://foodCouriereg.pythonanywhere.com/';
  String version = 'v1/';

  String url = '';

  Future viewCart(String token) async {
    url = '$apiUrl${version}api/cart/view';
    var response = await http.get(Uri.parse(url), headers: {
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 201) {
      logger.d('success');
      return response.body;
    } else {
      logger.e('Request failed with status: ${response.statusCode}.');
    }
    return;
  }

  Future addToCart(String token, int productID, int quantity) async {
    url = '$apiUrl${version}api/cart/add/';

    var jsonBody = jsonEncode({'product': productID, 'quantity': quantity});

    var response = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonBody);
    if (response.statusCode == 201) {
      logger.d('success');
      return response.body;
    } else {
      logger.e('Request failed with status: ${response.statusCode}.');
    }
    return;
  }

  Future removeFromCart(String token, int productID) async {
    url = '$apiUrl${version}api/cart/remove/';

    var jsonBody = jsonEncode({
      'item': productID,
    });

    var response = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonBody);
    if (response.statusCode == 201) {
      logger.d('success');
      return response.body;
    } else {
      logger.e('Request failed with status: ${response.statusCode}.');
    }
    return;
  }

  Future setPayment(String token, String paymentMethod) async {
    url = '$apiUrl${version}api/cart/payment_method/set/';

    var jsonBody = jsonEncode({'payment_method': paymentMethod});

    var response = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonBody);
    if (response.statusCode == 201) {
      logger.d('success');
      return response.body;
    } else {
      logger.e('Request failed with status: ${response.statusCode}.');
    }
    return;
  }

  Future createOrder(String token) async {
    url = '$apiUrl${version}api/cart/order';

    var response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 201) {
      logger.d('success');
      return response.body;
    } else {
      logger.e('Request failed with status: ${response.statusCode}.');
    }
    return;
  }
}
