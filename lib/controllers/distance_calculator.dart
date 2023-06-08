import 'dart:math';

import 'dart:convert';
import 'package:vector_math/vector_math.dart';
import 'package:foodCourier/config/config.dart';
import 'package:http/http.dart' as http;

double calculateDistance(latitude1, longitude1, latitude2, longitude2) {
  double radiusOfEarth = 6373.0;

  double lat1 = radians(latitude1);
  double lon1 = radians(longitude1);
  double lat2 = radians(latitude2);
  double lon2 = radians(longitude2);

  double differenceLat = lat2 - lat1;
  double differenceLon = lon2 - lon1;

  double a = pow(sin(differenceLat / 2), 2) +
      cos(lat1) * cos(lat2) * pow(sin(differenceLon / 2), 2);
  double c = 2 * atan2(sqrt(a), sqrt(1 - a));

  double distance = (radiusOfEarth * c);

  double distanceRounded = double.parse(distance.toStringAsFixed(2));

  print("Result: $distanceRounded");

  return distanceRounded;
}

calculateDistanceBetweenLocations(
    latitude1, longitude1, latitude2, longitude2) async {
  final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=$latitude1,$longitude1&destinations=$latitude2,$longitude2&key=$theApiKey');

  var response = await http.get(url);

  if (response.statusCode == 200) {
    print('success');
    String distance = parseResponse(response.body);
    //return response.body;
    return distance;
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
}

String parseResponse(String responseBody) {
  Map<String, dynamic> distanceResponse = jsonDecode(responseBody);
  Map<String, dynamic> rows = distanceResponse["rows"][0];
  Map<String, dynamic> elements = rows["elements"][0];
  Map<String, dynamic> distance = elements["distance"];
  String distanceMiles = distance['text']
      .toString()
      .substring(0, distance['text'].toString().indexOf(' '));
  String distanceInKm =
      (1.60934 * double.parse(distanceMiles)).toStringAsExponential(2);
  String distanceInKm_2Digits =
      distanceInKm.substring(0, distanceInKm.indexOf('e'));

  return distanceInKm_2Digits;
}

Future<String?> calculateTimeBetweenLocations(
    latitude1, longitude1, latitude2, longitude2) async {
  final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=$latitude1,$longitude1&destinations=$latitude2,$longitude2&key=$theApiKey');

  var response = await http.get(url);

  if (response.statusCode == 200) {
    print('success');
    String duration = parseTime(response.body);
    return duration;
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
}

String parseTime(String responseBody) {
  Map<String, dynamic> distanceResponse = jsonDecode(responseBody);
  Map<String, dynamic> rows = distanceResponse["rows"][0];
  Map<String, dynamic> elements = rows["elements"][0];
  Map<String, dynamic> duration = elements["duration"];

  String timeDistance = duration['text'].toString();
  return timeDistance;
}
