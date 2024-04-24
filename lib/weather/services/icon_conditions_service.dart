import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:flutter_application_1/weather/constants/icon_conditions_map.dart';

class IconsApi {
  IconData? getIconByName(String iconName) {
    if(iconConditionsMap[iconName] == null) {
      return WeatherIcons.na;
    } else {
      return iconConditionsMap[iconName];
    }
  }
}