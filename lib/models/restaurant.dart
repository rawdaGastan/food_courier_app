class Restaurant {
  int id;
  String name, phone = '', city = '', town = '', type = '', email = '';
  bool isDelivery = false;
  List<String> addressLines = [];
  Map<int, String> labels = {}; // id : name
  List<String> labelNames = [];
  String rating;
  Map<int, String> photos = {};
  List<String> photoUrls = [];
  String logoUrl;
  bool isDineOut = false;
  String longitude;
  String latitude;
  int rangePrice;

  Restaurant(
      {required this.id,
      required this.name,
      required this.city,
      required this.town,
      required this.phone,
      required this.type,
      required this.email,
      required this.isDelivery,
      required this.addressLines,
      required this.labels,
      required this.rating,
      required this.photos,
      required this.logoUrl,
      required this.isDineOut,
      required this.longitude,
      required this.latitude,
      required this.rangePrice}) {
    labels.forEach((_, value) => labelNames.add(value));
    photos.forEach((_, value) => photoUrls.add(value));
  }
}
