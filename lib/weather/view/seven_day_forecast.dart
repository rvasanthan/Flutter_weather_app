import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/weather/services/icon_conditions_service.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_application_1/weather/model/visual_cross_model.dart';

class DaysForecastCard extends StatelessWidget {

  final VisualCrossModel model;
  final int numberOfDays;
  const DaysForecastCard (this.model, this.numberOfDays, {super.key});

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isDarkMode = true;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.05,
        vertical: size.height * 0.02,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
          color: Colors.white.withOpacity(0.05),
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(
                  top: size.height * 0.02,
                  left: size.width * 0.03,
                ),
                child: Text(
                  '7-day forecast',
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
            Divider(
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            Padding(
              padding: EdgeInsets.all(size.width * 0.005),
              child: Column(
                children: buildDayForecastCard(model, size),
              ),
            ),
          ],
        ),
      ),
    );
  }

Widget buildSevenDayForecast(String time, String minTemp, String maxTemp,
      IconData? weatherIcon, size, bool isDarkMode) {
    return Padding(
      padding: EdgeInsets.all(
        size.height * 0.005,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.02,
                ),
                child: Text(
                  time,
                  style: GoogleFonts.questrial(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontSize: size.height * 0.025,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.25,
                ),
                child: FaIcon(
                  weatherIcon,
                  color: isDarkMode ? Colors.white : Colors.black,
                  size: size.height * 0.03,
                ),
              ),
              Align(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: size.width * 0.15,
                  ),
                  child: Text(
                    '$minTemp˚C',
                    style: GoogleFonts.questrial(
                      color: isDarkMode ? Color.fromARGB(249, 249, 248, 248) : Colors.black38,
                      fontSize: size.height * 0.025,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.05,
                  ),
                  child: Text(
                    '$maxTemp˚C',
                    style: GoogleFonts.questrial(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontSize: size.height * 0.025,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Divider(
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ],
      ),
    );
  }

  List<Widget> buildDayForecastCard(VisualCrossModel model, Size size) {
    List<Widget> forecastList = [];
    bool isDarkMode = true;
    DateFormat dateFormat = DateFormat("EEE");
    int daysCounter = 0;
    for(final element in model.daysForecast) {
      if(daysCounter == 7) {
        break;
      }
      log(dateFormat.format(DateTime.parse(element['datetime'])));
      forecastList.add(buildSevenDayForecast(dateFormat.format(DateTime.parse(element['datetime'])),
      element['tempmin'].toString(), element['tempmax'].toString(),
        IconsApi().getIconByName(element['icon']), size, isDarkMode));
      daysCounter++;
    }
    return forecastList;
  }  
}
