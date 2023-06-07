import 'package:flutter/cupertino.dart';

class Restaurant{
  int id;
  String name, phone ='', city='', town='', type='', email='' ;
  bool isDelivery = false;
  List<String> addressLines= [];
  Map<int,String> labels= {}; // id : name
  List<String> labelNames= [];
  String rating;
  Map<int,String> photos = {};
  List<String> photoUrls = [];
  String logoUrl;
  bool isDineOut = false;
  String longitude;
  String latitude;
  int rangePrice;

  Restaurant({
   @required this.id,
   @required this.name,
    this.city,
    this.town,
    this.phone,
    this.type,
    this.email,
    this.isDelivery,
   @required this.addressLines,
   @required this.labels,
    this.rating,
    this.photos,
    this.logoUrl,
    this.isDineOut,
    this.longitude,
    this.latitude,
    this.rangePrice
}){
    labels.forEach((_,value)=>labelNames.add(value));
    photos.forEach((_,value)=>photoUrls.add(value));
  }
}