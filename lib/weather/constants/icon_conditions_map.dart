import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:weather_icons/weather_icons.dart';

const Map<String, IconData> iconConditionsMap = {
  "clear-day" : WeatherIcons.day_sunny,
  "clear-night" : WeatherIcons.night_clear,
  "partly-cloudy-night" : WeatherIcons.night_alt_cloudy,
  "partly-cloudy-day" : WeatherIcons.day_cloudy,
  "cloudy" : WeatherIcons.cloudy,
  "rain" : WeatherIcons.rain,
  "snow" : WeatherIcons.snow,
  "fog" : WeatherIcons.fog,
  "Tree": CupertinoIcons.tree,
  "Grass": IconData(0xf7be, fontFamily: 'MaterialIcons')
};