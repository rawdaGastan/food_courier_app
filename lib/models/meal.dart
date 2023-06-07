import 'package:flutter/cupertino.dart';

class Meal{

  int id;
  String name ='', description='',type;
  int numberOfLikes;
  bool isFavourite = false;
  List<String> ingredients = [];
  String category;
  double price;
  String rating;

  Map<int,String> photos = {};
  List<String> photoUrls = [];

  Map<int,String> labels = {};
  List<String> labelNames = [];

  Map<int,List<dynamic>> supplierPrices = {};

  Meal({
    @required this.id,
    @required this.name,
    this.supplierPrices,
    this.description,
    this.price,
    this.numberOfLikes,
    this.type,
    this.ingredients,
    this.photos,
    this.category,
    this.rating,
    this.labels
  }){
    labels.forEach((_,value)=>labelNames.add(value));
    photos.forEach((_,value)=>photoUrls.add(value));
  }

  /*String get name => _name;
  String get description => _description;
  String get price => _price;
  String get type => _type;
  bool get isFavourite => _isFavourite;
  List<String> get tags => _tags;*/

  void toggleFav()=> this.isFavourite = !this.isFavourite;

}