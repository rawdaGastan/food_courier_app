import 'package:food_courier/controllers/logger.dart';
import 'package:geolocator/geolocator.dart';

class Location {
  late double _latitude;
  late double _longitude;
  double defaultValue = 30.0;

  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;

  Future<void> getCurrentLocation() async {
    try {
      Position position = await _geolocatorPlatform.getCurrentPosition();

      _latitude = position.latitude;
      _longitude = position.longitude;
    } on Exception catch (e) {
      logger.e(e);
      _latitude = defaultValue;
      _longitude = defaultValue;
    }
  }

  get latitude => _latitude;
  get longitude => _longitude;
}
