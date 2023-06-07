import 'package:flutter/cupertino.dart';
import 'package:foodCourier/controllers/ordering_network.dart';
import 'dart:convert';
import 'package:foodCourier/models/cart.dart';

class OrderProvider extends ChangeNotifier {
  late Cart _cart;
  Cart get cart => _cart;

  Future<Cart> viewCart(String userToken) async {
    OrderingNetworking net = OrderingNetworking();
    List<dynamic> response = jsonDecode(await net.viewCart(userToken));

    Map<String, dynamic> cart = response[0];
    _cart = Cart(
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
    OrderingNetworking net = OrderingNetworking();
    var response = await net.addToCart(userToken, productID, quantity);
    return response;
  }

  Future removeFromCart(String userToken, int productID) async {
    OrderingNetworking net = OrderingNetworking();
    var response = await net.removeFromCart(userToken, productID);
    return response;
  }

  Future setPaymentMethod(String userToken, String paymentMethod) async {
    OrderingNetworking net = OrderingNetworking();
    var response = await net.setPayment(userToken, paymentMethod);
    return response;
  }

  Future createOrder(String userToken) async {
    OrderingNetworking net = OrderingNetworking();
    var response = await net.createOrder(userToken);
    return response;
  }
}
