import 'package:flutter/cupertino.dart';
import 'package:foodCourier/controllers/ordering_netwrok.dart';
import 'dart:convert';
import 'package:foodCourier/models/cart.dart';

class OrderProvider extends ChangeNotifier {
  Cart _cart;
  Cart get cart => _cart;

  Future<Cart> viewCart(String userToken) async {
    OrderingNetworking net = new OrderingNetworking();
    List<dynamic> response = jsonDecode(await net.viewCart(userToken));

    Map<String, dynamic> cart = response[0];
    _cart = new Cart(
        supplierID: cart['supplier'],
        shippingAddress: cart['shipping_address'],
        paymentMethod: cart['payment_method'],
        subtotalPrice: cart['subtotal'],
        taxPercentage: cart['tax_percentage'],
        taxTotalPrice: cart['tax_total'],
        totalPrice: cart['total'],
        items: cart['items']);
    return _cart;
  }

  Future addToCart(String userToken, int productID, int quantity) async {
    OrderingNetworking net = new OrderingNetworking();
    var response = await net.addToCart(userToken, productID, quantity);
    if (response != null)
      return response;
    else
      return null;
  }

  Future removeFromCart(String userToken, int productID) async {
    OrderingNetworking net = new OrderingNetworking();
    var response = await net.removeFromCart(userToken, productID);
    if (response != null)
      return response;
    else
      return null;
  }

  Future setPaymentMethod(String userToken, String paymentMethod) async {
    OrderingNetworking net = new OrderingNetworking();
    var response = await net.setPayment(userToken, paymentMethod);
    if (response != null)
      return response;
    else
      return null;
  }

  Future createOrder(String userToken) async {
    OrderingNetworking net = new OrderingNetworking();
    var response = await net.createOrder(userToken);
    return response;
  }
}
