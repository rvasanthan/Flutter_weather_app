import 'package:flutter/material.dart';
import 'package:flutter_application_1/weather/model/visual_cross_model.dart';

class WeatherInfoCard extends StatelessWidget {
  //const WeatherInfoCard({Key? key}) : super(key: key);
  final VisualCrossModel model; 
  const WeatherInfoCard (this.model, {super.key});
  
  // ignore: empty_constructor_bodies
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      // Define how the card's content should be clipped
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(padding: const EdgeInsets.all(15),
          child: Row(
            children: <Widget>[
              // Add an image widget to display an image
              const Icon(
                Icons.thermostat,
                color: Color.fromARGB(255, 71, 70, 70),
                size: 100.0,
              ),
              Container(width: 20),
                Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(height: 5),
                    // Add a title widget
                    Text(
                      "${model.temperature}°C",
                      style: const TextStyle(
                        color: Colors.black,
                        fontFamily: 'Pacifico',
                        fontSize: 40,
                      ),
                    ),
                    Container(height: 5),
                    // Add a subtitle widget
                    Text(
                      "Feels Like ${model.feelsLike}°C",
                      style: const TextStyle(
                        color: Color.fromARGB(255, 67, 72, 223),
                        fontSize: 25,
                      ),
                    ),
                    Container(height: 5,),
                    Text(
                      "Sub title",
                      style: TextStyle(
                        color: Colors.grey[300],
                      ),
                    ),
                  ],
                ),
              ),
          ],
            ), 
          ),
        ],
      ),
    );
  }
}