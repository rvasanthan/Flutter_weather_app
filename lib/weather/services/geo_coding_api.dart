import 'dart:developer';
import 'dart:convert';

import 'package:flutter_application_1/weather/model/geocoding_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/weather/constants/apikey.dart';

class GeoCodingApi {
  Future<GeoCodingModel> getLocationByCoordinates(bool current, String latitude, String longitude) async {
    try {
      if (current) {
        Position currentPosition = await getCurrentPosition();
        latitude = currentPosition.latitude as String;
        longitude = currentPosition.longitude as String;
      } 
      var openWeatherUrl = Uri.https('api.openweathermap.org', '/geo/1.0/reverse',
          {"lat": latitude, "lon": longitude, "limit": 100, "appid" : geoCodingApiKey});
      
      log(openWeatherUrl.toString());
      final http.Response response = await http.get(openWeatherUrl);
      //log(response.body.toString());
      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedJson = json.decode(response.body);
        return GeoCodingModel.fromMap(decodedJson);
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch(e) {
      log(e.toString());
      throw Exception('Unable to fetch weather data');
    }
  }

  Future<GeoCodingModel> getCoordinatesByLocation(String searchString) async {
    try {
      var openWeatherUrl = Uri.https('api.openweathermap.org', '/geo/1.0/direct',
            {"q": searchString, "limit": 5, "appid" : geoCodingApiKey});
      log(openWeatherUrl.toString());
      final http.Response response = await http.get(openWeatherUrl);
        //log(response.body.toString());
        if (response.statusCode == 200) {
          final Map<String, dynamic> decodedJson = json.decode(response.body);
          log(decodedJson.toString());
          return GeoCodingModel.fromMap(decodedJson);
        } else {
          throw Exception('Failed to load weather data');
        }
      } catch(e) {
        log(e.toString());
        throw Exception('Unable to fetch weather data');
      }
  }

  Future<Position> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if(!serviceEnabled) {
      return Future.error("Location Services are disabled");    
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {

        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
  }

}