class Meal {
  int id;
  String name = '', description = '', type;
  int numberOfLikes;
  bool isFavorite = false;
  List<String> ingredients = [];
  String category;
  double price;
  String rating;

  Map<int, String> photos = {};
  List<String> photoUrls = [];

  Map<int, String> labels = {};
  List<String> labelNames = [];

  Map<int, List<dynamic>> supplierPrices = {};

  Meal(
      {required this.id,
      required this.name,
      required this.supplierPrices,
      required this.description,
      required this.price,
      required this.numberOfLikes,
      required this.type,
      required this.ingredients,
      required this.photos,
      required this.category,
      required this.rating,
      required this.labels}) {
    labels.forEach((_, value) => labelNames.add(value));
    photos.forEach((_, value) => photoUrls.add(value));
  }

  void toggleFav() => isFavorite = !isFavorite;
}
