import 'package:flutter/cupertino.dart';
import 'package:foodCourier/models/restriction.dart';
import 'package:foodCourier/models/type_filter.dart';

import '../main.dart';
/*
* this notifier is made in order to mark restrictions duo to type filter
* like for example mark on meat if vegetarian filter is chosen or other cases
* */

class TypeFilterProvider extends ChangeNotifier {
  final List<String> _typesPreferred = [
    // set to all by default until user changes to specific type
    'Gluten free', // when user changes to particular type this list will include the preferred type only
    'High protein',
    'Vegetarian',
    'Vegan',
  ];

  List<String> get typesPreferred => _typesPreferred;

  /*static List<TypeFilter> _allFilterStatus = [
    TypeFilter('Normal', true), // All types filter is true => show all
    TypeFilter('Gluten Free', false), //any other filter is set to false until user chose another filter but the All filter
    TypeFilter('High Protein', false),
    TypeFilter('Vegetarian', false),
    TypeFilter('Vegan', false),
  ];*/

  static String labelsListString = FoodCourier().remoteConfigService.labelsList;
  static List<String> labelsList = labelsListString.split(',');

  static String restrictionListString =
      FoodCourier().remoteConfigService.restrictionList;
  static List<String> restrictionList = restrictionListString.split(',');

  static String restrictionListTypeString =
      FoodCourier().remoteConfigService.restrictionListTypes;
  static List<String> restrictionListType =
      restrictionListTypeString.split(',');

  static final List<TypeFilter> _allFilterStatus = [
    for (int i = 0; i < labelsList.length; i++)
      (labelsList[i] == 'Normal')
          ? TypeFilter(labelsList[i], true)
          : TypeFilter(labelsList[i], false)
  ];

  final Map<String, bool> _filterStatus = {
    for (int i = 0; i < labelsList.length && labelsList != null; i++)
      _allFilterStatus[i].type: _allFilterStatus[i].preferred
  };

  /* Map<String,bool>_filterStatus = {
    _allFilterStatus[0].type: _allFilterStatus[0].preferred,
    _allFilterStatus[1].type: _allFilterStatus[1].preferred,
    _allFilterStatus[2].type: _allFilterStatus[2].preferred,
    _allFilterStatus[3].type: _allFilterStatus[3].preferred,
    _allFilterStatus[4].type: _allFilterStatus[4].preferred,

    /*'Normal':true, // All types filter is true => show all
    'Gluten Free':false, //any other filter is set to false until user chose another filter but the All filter
    'High Protein':false,
    'Vegetarian':false,
    'Vegan':false,*/
};*/

  final List<Restriction> restrictionsList = [
    for (int i = 0; i < restrictionList.length; i++)
      Restriction(
          name: restrictionList[i],
          type: restrictionListType[i],
          restricted: false),
  ];

  /*final restrictionsList = [
    Restriction(name: 'wheat' , type: 'Gluten Free'),
    Restriction(name: 'malt' , type: 'Gluten Free'),
    Restriction(name: 'barley' , type: 'Gluten Free'),
    Restriction(name: 'Triticale' , type: 'Gluten Free'),
    Restriction(name: 'rye' , type: 'Gluten Free'),
    Restriction(name: 'bran' , type: 'Gluten Free'),
    Restriction(name: 'bulgur' , type: 'Gluten Free'),
    Restriction(name: 'protein' , type: 'High Protein'),
    Restriction(name: 'protein' , type: 'High Protein'),
    Restriction(name: 'Meat' , type: 'Vegetarian'),
    Restriction(name: 'Poultry' , type: 'Vegetarian'),
    Restriction(name: 'fish' , type: 'Vegetarian'),
    Restriction(name: 'Honey' , type: 'Vegan'),
    Restriction(name: 'Eggs' , type: 'Vegan'),
    Restriction(name: 'Dairy' , type: 'Vegan'),
  ];*/

  bool getRestrictionState(String name) {
    for (Restriction r in restrictionsList) {
      if (r.name == name) return r.restriction;
    }
    return false;
  }

  bool contains(List<String> labels) {
    for (String label in labels) {
      if (_typesPreferred.contains(label)) return true;
    }
    return false;
  }

  Map<String, bool> get filterStatus => _filterStatus;

  String typeOfCurrentFilterApplied = 'Normal';

  String get getTypeOfCurrentFilterApplied => typeOfCurrentFilterApplied;

  void changeFilterState(String key) {
    _filterStatus[typeOfCurrentFilterApplied] = false;
    _filterStatus[key] = true;
    typeOfCurrentFilterApplied = key;
    notifyListeners();
  }

  bool isFirstTime = true;

  // unPrefer all except particular type
  filterBy(String type) {
    isFirstTime = false;
    _typesPreferred.clear();
    _typesPreferred.add(type);
    restrictByType(type);
    notifyListeners();
  }

  filterByRestrict() {
    _typesPreferred.clear();

    isFirstTime = false;

    for (Restriction r in restrictionsList) {
      if (r.restriction) {
        _typesPreferred.add(r.type);
        changeFilterState(r.type);
      }
    }

    if (_typesPreferred.isEmpty) showAll();

    notifyListeners();
  }

  restrictByType(String type) {
    for (Restriction r in restrictionsList) {
      if (r.type == type) {
        r.restrict(); // change restriction state from false to true
      } else if (r.restriction) {
        r.unRestrict(); // unRestrict all other than the chosen type
      }
    }
  }

  showAll() {
    _typesPreferred.clear();
    _typesPreferred.addAll([
      'Gluten Free',
      'High Protein',
      'Vegetarian',
      'Vegan',
    ]);
    changeFilterState('Normal');
    unRestrictAll();
    notifyListeners();
  }

  unRestrictAll() {
    for (Restriction r in restrictionsList) {
      if (r.restriction) r.unRestrict();
    }
  }
}
