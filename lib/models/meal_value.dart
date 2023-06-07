class MealValue {
  String name = '', percentage = '', quantity = '';
  bool isPrimary = true;

  MealValue({
    this.name,
    this.percentage,
    this.quantity,
    this.isPrimary,
  });

  /*String get name => _name;
  String get description => _description;
  String get price => _price;
  String get type => _type;
  bool get isFavorite => _isFavorite;
  List<String> get tags => _tags;*/

  void toggleType() => this.isPrimary = !this.isPrimary;
}
