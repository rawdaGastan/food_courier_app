class TypeFilter {
  String _type;
  bool _preferred = true;

  TypeFilter(this._type, this._preferred); // for types like vegan ...

  /*TypeFilter({String type, bool preferred}){
    this._type = type ;
    this._preferred = preferred;
  }*/

  String get type => _type;
  bool get preferred => _preferred;

  void togglePreferState() {
    _preferred = !_preferred;
  }
}
