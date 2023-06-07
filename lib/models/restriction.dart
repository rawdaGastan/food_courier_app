import 'package:flutter/cupertino.dart';

class Restriction{
  String _name, _type ;
  bool _restricted = false ;

  Restriction({@required String name ,@required String type, bool restricted}){
    this._name = name ;
    this._type = type ;
  }

  String get name => this._name ;
  String get type => this._type ;
  bool get restriction => this._restricted ;

  void toggle(){
    this._restricted = !this._restricted ;
  }

  void restrict(){
    this._restricted = true;
  }

  void unRestrict(){
    this._restricted = false;
  }

}