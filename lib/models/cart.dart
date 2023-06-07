class Cart {
  List<dynamic> items = [];
  int supplierID;
  String shippingAddress;
  String paymentMethod;
  String subtotalPrice;
  String taxPercentage;
  String taxTotalPrice;
  String totalPrice;

  Cart(
      {required this.supplierID,
      required this.items,
      required this.paymentMethod,
      required this.shippingAddress,
      required this.subtotalPrice,
      required this.taxPercentage,
      required this.taxTotalPrice,
      required this.totalPrice});
}
