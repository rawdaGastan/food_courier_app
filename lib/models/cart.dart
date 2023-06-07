
class Cart{
  List<dynamic> items = [];
  int supplierID;
  String shippingAddress;
  String paymentMethod;
  String subtotalPrice;
  String taxPercentage;
  String taxTotalPrice;
  String totalPrice;

  Cart({
    this.supplierID,
    this.items,
    this.paymentMethod,
    this.shippingAddress,
    this.subtotalPrice,
    this.taxPercentage,
    this.taxTotalPrice,
    this.totalPrice
  });
}