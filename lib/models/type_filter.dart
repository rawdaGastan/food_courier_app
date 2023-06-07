class TypeFilter {
  String _type ;
  bool _preferred = true ;

  TypeFilter(this._type, this._preferred); // for types like vegan ...

  /*TypeFilter({String type, bool preferred}){
    this._type = type ;
    this._preferred = preferred;
  }*/

  String get type => this._type ;
  bool get preferred => this._preferred ;

  void togglePreferState(){
    this._preferred = !this._preferred ;
  }

}