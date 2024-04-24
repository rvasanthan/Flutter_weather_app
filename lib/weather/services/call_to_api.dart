import 'dart:developer';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/weather/constants/apikey.dart';
import 'package:flutter_application_1/weather/model/visual_cross_model.dart';

class WeatherApi {
  Future<VisualCrossModel> getWeatherByName(bool current, String locationName) async {
    try {

      Position currentPosition = await getCurrentPosition();
      String location;
      String city = locationName;
      if (current) {
        List<Placemark> placemarks = await placemarkFromCoordinates(
            currentPosition.latitude, currentPosition.longitude);
        Placemark place = placemarks[0];
        log(place.locality.toString());
        log(place.administrativeArea.toString());
        location = '${currentPosition.latitude},${currentPosition.longitude}';
        city = '${place.locality},${place.administrativeArea}';
        log(city);
      } else {
        location = locationName;
      }
      log("LocationName:$locationName");
      var visualCrossUrl = Uri.https('weather.visualcrossing.com', '/VisualCrossingWebServices/rest/services/timeline/$location',
          {"unitGroup": "metric", "key": visualCrossApiKey, "contentType": "json"});
      VisualCrossModel model = VisualCrossModel();
      log(visualCrossUrl.toString());
      final http.Response response = await http.get(visualCrossUrl);
      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedJson = json.decode(response.body);
        var pollenApiUrl = Uri.https('pollen.googleapis.com', '/v1/forecast:lookup',
            {"key":"AIzaSyCfx8yOCRrSn7TSP1uchs2fO_yos9Pn7oc",  "location.longitude":decodedJson['latitude'].toString(), "location.latitude":decodedJson['latitude'].toString(), "days":"5"});
          log(pollenApiUrl.toString());
        final http.Response pollenResponse = await http.get(pollenApiUrl);
        if(response.statusCode == 200) {
          final Map<String, dynamic> decodedPollenJson = json.decode(pollenResponse.body);
          model = VisualCrossModel.fromMap(decodedJson, decodedPollenJson);
        }
        if(current) {
          model.city = city;
        }
        return model;
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