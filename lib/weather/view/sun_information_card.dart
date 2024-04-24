import 'package:flutter/material.dart';
import 'package:flutter_application_1/weather/model/visual_cross_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_icons/weather_icons.dart';

class  SunInformationCard extends StatelessWidget {

  final VisualCrossModel model;
  const SunInformationCard (this.model, {super.key});

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isDarkMode = true;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.05,
      ),
      child: Column(
        mainAxisAlignment : MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Sunrise / Sunset',
            style: GoogleFonts.questrial(
              color: isDarkMode
                  ? Colors.white
                  : Colors.black,
              fontSize: size.height * 0.03,
              fontWeight: FontWeight.bold,
            ),
          ),
          Card.outlined(
            color: Colors.transparent,
            child: SizedBox(
              width: size.width * 0.9,
              //height: 100,
              child: Center(
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: size.height * 0.05,
                        horizontal: size.width * 0.01,
                      ),

                      child: FaIcon(
                        WeatherIcons.sunrise,
                        color: isDarkMode ? Colors.white : Colors.black,
                        size: size.height * 0.03,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: size.height * 0.05,
                        horizontal: size.width * 0.01,
                      ),
                      child: Text(
                        model.sunrise,
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontSize: size.height * 0.03,
                        ),
                      ),
                    ), 
                    Text(
                      ' / ',
                      style: GoogleFonts.questrial(
                        color: isDarkMode
                            ? Colors.white
                            : Colors.black54,
                        fontSize: size.height * 0.03,   
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: size.height * 0.005,
                        horizontal: size.width * 0.01,
                      ),

                      child: FaIcon(
                        WeatherIcons.sunset,
                        color: isDarkMode ? Colors.white : Colors.black,
                        size: size.height * 0.03,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: size.height * 0.05,
                        horizontal: size.width * 0.01,
                      ),
                      child: Text(
                        model.sunset,
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontSize: size.height * 0.03,
                        ),
                      ),
                    ),
                  ], 
                  
                )
              ),
            )
          ),
        ],
        )
    );
  }
}
