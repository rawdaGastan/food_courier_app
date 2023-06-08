class Meal {
  int id;
  String name = '', description = '', type;
  int numberOfLikes = 0;
  bool isFavorite = false;
  List<String> ingredients = [];
  String category = '';
  double price = 0.0;
  String rating = '';

  Map<int, String> photos = {};
  List<String> photoUrls = [];

  Map<int, String> labels = {};
  List<String> labelNames = [];

  Map<int, List<dynamic>> supplierPrices = {};

  Meal(
      {required this.id,
      required this.name,
      this.supplierPrices = const {},
      required this.description,
      required this.price,
      this.numberOfLikes = 0,
      required this.type,
      this.ingredients = const [],
      this.photos = const {},
      this.category = '',
      this.rating = '',
      required this.labels}) {
    labels.forEach((_, value) => labelNames.add(value));
    photos.forEach((_, value) => photoUrls.add(value));
  }

  void toggleFav() => isFavorite = !isFavorite;
}
