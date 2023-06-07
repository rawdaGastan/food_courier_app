class MealValue {
  String name = '', percentage = '', quantity = '';
  bool isPrimary = true;

  MealValue({
    required this.name,
    required this.percentage,
    required this.quantity,
    required this.isPrimary,
  });

  /*String get name => _name;
  String get description => _description;
  String get price => _price;
  String get type => _type;
  bool get isFavorite => _isFavorite;
  List<String> get tags => _tags;*/

  void toggleType() => isPrimary = !isPrimary;
}
