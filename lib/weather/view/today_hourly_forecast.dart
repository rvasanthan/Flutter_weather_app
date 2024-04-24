import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_application_1/weather/model/visual_cross_model.dart';
import 'package:flutter_application_1/weather/constants/icon_conditions_map.dart';
import 'package:weather_icons/weather_icons.dart';

class HourlyForecastCard extends StatelessWidget {

  final VisualCrossModel model;
  const HourlyForecastCard (this.model, {super.key});

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isDarkMode = true;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.05,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
          color: isDarkMode
              ? Colors.white.withOpacity(0.05)
              : Colors.black.withOpacity(0.05),
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(
                  top: size.height * 0.01,
                  left: size.width * 0.03,
                ),
                child: Text(
                  'Forecast for today',
                  style: GoogleFonts.questrial(
                    color: isDarkMode
                        ? Colors.white
                        : Colors.black,
                    fontSize: size.height * 0.025,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(size.width * 0.005),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: getHourlyForecastCard(model, size),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  

List<Widget> getHourlyForecastCard(VisualCrossModel model, Size size) {

  List<Widget> hourlyList = [];
  final timeFormatter = DateFormat('HH');
  final DateTime now = DateTime.now();
  final String dateAlone = DateFormat('yyyy-MM-dd').format(now);
  final int formattedTime = int.parse(timeFormatter.format(now));
  final Map<String, dynamic> todayForecast = model.daysForecast[0];
  final Map<String, dynamic> nextDayForecast = model.daysForecast[1];
  bool isDarkMode = true;
  int hourCounter = 0;
  for(final element in todayForecast['hours']) {
    if(hourCounter == 12) {
      break;
    }
    final weatherHourNow = '$dateAlone '+element['datetime'];
    DateTime parsedElementTime = DateTime.parse(weatherHourNow);
    if(formattedTime <= int.parse(timeFormatter.format(parsedElementTime))) {
      //og('$formattedTime ${timeFormatter.format(parsedElementTime)}');
      hourCounter++;
      log(element['icon']);
      hourlyList.add(buildForecastToday( '${timeFormatter.format(parsedElementTime)}:00', element['temp'].toString(), element['windspeed'].toString(), element['precipprob'].toString(), 
        getIconByName(element['icon']), size, isDarkMode,));

    }
  }
  if(hourCounter < 12) {
    for(final element in nextDayForecast['hours']) {
      if(hourCounter == 12) {
          break;
      }
      final weatherHourNow = '$dateAlone '+element['datetime'];
      DateTime parsedElementTime = DateTime.parse(weatherHourNow);
      log(element['icon']);
      hourlyList.add(buildForecastToday( '${timeFormatter.format(parsedElementTime)}:00', element['temp'].toString(), element['windspeed'].toString(), element['precipprob'].toString(), 
      getIconByName(element['icon']), size, isDarkMode,));
      hourCounter++;
   }
  }
  return hourlyList;
}

Widget buildForecastToday(String time, String temp, String wind, String rainChance,
      IconData? weatherIcon, size, bool isDarkMode) {
    return Padding(
      padding: EdgeInsets.all(size.width * 0.025),
      child: Column(
        children: [
          Text(
            time,
            style: GoogleFonts.questrial(
              color: isDarkMode ? Colors.white : Colors.black,
              fontSize: size.height * 0.02,
            ),
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: size.height * 0.005,
                ),
                child: FaIcon(
                  weatherIcon,
                  color: isDarkMode ? Colors.white : Colors.black,
                  size: size.height * 0.03,
                ),
              ),
            ],
          ),
          Text(
            '$temp˚C',
            style: GoogleFonts.questrial(
              color: isDarkMode ? Colors.white : Colors.black,
              fontSize: size.height * 0.025,
            ),
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: size.height * 0.01,
                ),
                child: FaIcon(
                  FontAwesomeIcons.wind,
                  color: Color.fromARGB(255, 231, 227, 227),
                  size: size.height * 0.03,
                ),
              ),
            ],
          ),
          Text(
            '$wind km/h',
            style: GoogleFonts.questrial(
              color: Colors.amber[200],
              fontSize: size.height * 0.02,
            ),
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: size.height * 0.01,
                ),
                child: FaIcon(
                  FontAwesomeIcons.umbrella,
                  color: Colors.grey[100],
                  size: size.height * 0.04,
                ),
              ),
            ],
          ),
          Text(
            '$rainChance %',
            style: GoogleFonts.questrial(
              color: Colors.yellow[100],
              fontSize: size.height * 0.02,
            ),
          ),
        ],
      ),
    );
  }

  IconData? getIconByName(String iconName) {
    if(iconConditionsMap[iconName] == null) {
      return WeatherIcons.na;
    } else {
      return iconConditionsMap[iconName];
    }
  }

}
