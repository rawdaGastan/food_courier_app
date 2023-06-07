class Restriction {
  late String _name, _type;
  late bool _restricted = false;

  Restriction(
      {required String name, required String type, required bool restricted}) {
    _name = name;
    _type = type;
    _restricted = restricted;
  }

  String get name => _name;
  String get type => _type;
  bool get restriction => _restricted;

  void toggle() {
    _restricted = !_restricted;
  }

  void restrict() {
    _restricted = true;
  }

  void unRestrict() {
    _restricted = false;
  }
}
