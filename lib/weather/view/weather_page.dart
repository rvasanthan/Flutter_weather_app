import 'dart:developer';
import 'dart:convert';
import 'dart:math' hide log;

import 'package:flutter/material.dart';
import 'package:flutter_application_1/weather/view/sun_information_card.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/weather/view/seven_day_forecast.dart';
import 'package:flutter_application_1/weather/view/today_hourly_forecast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/weather/services/call_to_api.dart';
import 'package:flutter_application_1/weather/model/visual_cross_model.dart';
import 'package:flutter_application_1/weather/services/places_api_client.dart';
import 'package:flutter_application_1/weather/constants/apikey.dart';


class WeatherPage extends StatefulWidget {

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  Future<VisualCrossModel> getData(bool isCurrentCity, String cityName) async {
    return await WeatherApi().getWeatherByName(isCurrentCity, cityName);
  }

  Future<List<String>> getPredictions(String searchString) {
    return PlacesApiClient().fetchPredictions(searchString);
  }

  final TextEditingController _searchController = TextEditingController();
  Future<VisualCrossModel>? _myData;
  List<String> _predictions = [];
  Map<String, String> _predictionsLocationKeyMap = {};
  int itemCount = 0;
  String hintText = "Search for a place...";
  String _randomPicFromFuture = '';
  late FocusNode specialFocusNode;
  @override
  void initState() {
    setState(() {
      _myData = getData(true, "");
      //_predictions = getPredictions("");
      _getRandomPic();
    });
    specialFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    //destroys the FocusNode as soon as the page is destroyed
    //because it is a long-lived object
    specialFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: FutureBuilder(
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If error occured
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  '${snapshot.error.toString()} occurred',
                  style: const TextStyle(fontSize: 18),
                ),
              );

              // if data has no errors
            } else if (snapshot.hasData) {
              // Extracting data from snapshot object
              final data = snapshot.data as VisualCrossModel;
              Size size = MediaQuery.of(context).size;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(_randomPicFromFuture),
                      fit: BoxFit.fill,
                    ),
                ),
                width: double.infinity,
                height: double.infinity,
                child: SafeArea(
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                         child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: 
                            [
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextField(
                                        cursorColor: Colors.white,
                                        //autofocus: true,
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                        controller: _searchController,
                                        decoration: InputDecoration(
                                          enabledBorder: const OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.white), // change color you want...
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:BorderRadius.circular(15),
                                            borderSide: const BorderSide(color: Colors.white),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:BorderRadius.circular(15),
                                            borderSide: const BorderSide(color: Colors.white),
                                          ),
                                          labelStyle: const TextStyle(
                                            color: Colors.amber,
                                            fontSize: 24.0
                                          ),
                                          hintText: hintText,
                                          hintStyle: const TextStyle( 
                                            color: Color.fromARGB(255, 245, 213, 106)
                                          ),
                                          iconColor: Colors.white,
                                          suffixIcon: IconButton(
                                            icon: const Icon(Icons.clear),
                                            color: Colors.white,
                                            onPressed: () {
                                              _searchController.clear();
                                              setState(() {
                                                _predictions.clear();
                                              });
                                            },
                                          ),
                                        ),
                                        onChanged: (value) {
                                          log(value);
                                          _fetchPredictions(value);
                                        },
                                      ),
                                    ),
                                  ]
                                )
                              ),
                              Flexible(
                                fit: FlexFit.loose,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: _predictions.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      textColor: Colors.white,
                                      title: Text(_predictions[index]),
                                      onTap: () {
                                        // Handle selected prediction
                                        log(_predictions[index]);
                                        setState(() {
                                          _myData = getData(false, _predictions[index]);
                                          log(_predictionsLocationKeyMap[_predictions[index]]!);
                                          _searchController.clear();
                                          _predictions.clear();
                                        });

                                      },
                                    );
                                  },
                                ),
                              ),    
                              Padding(
                                padding: EdgeInsets.only(
                                  top: size.height * 0.03,
                                ),
                                child: Align(
                                  child: Text(
                                    data.city,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.questrial(
                                      color: Colors.white,
                                      fontSize: size.height * 0.025,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  top: size.height * 0.03,
                                ),
                                child: Align(
                                  child: Text(
                                    '${data.temperature}˚C', //curent temperature
                                    style: GoogleFonts.questrial(
                                      color: Colors.white,
                                      fontSize: size.height * 0.13,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: size.width * 0.25),
                                child: const Divider(
                                  //color: isDarkMode ? Colors.white : Colors.black,
                                  color: Colors.white,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  top: size.height * 0.005,
                                ),
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: Text(
                                    data.desc, // weather
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.questrial(
                                      color: Colors.white,
                                          //isDarkMode ? Colors.white54 : Colors.black54,
                                      fontSize: size.height * 0.02,
                                      
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  top: size.height * 0.03,
                                  bottom: size.height * 0.01,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${data.minimumTemp}˚C', // min temperature
                                      style: GoogleFonts.questrial(
                                        color: data.minimumTemp <= 0
                                            ? Colors.white
                                            : data.minimumTemp > 0 && data.minimumTemp <= 15
                                                ? const Color.fromARGB(255, 224, 227, 243)
                                                : data.minimumTemp > 15 && data.minimumTemp < 30
                                                    ? const Color.fromARGB(255, 241, 214, 81)
                                                    : Colors.pink,
                                        fontSize: size.height * 0.03,
                                      ),
                                    ),
                                    Text(
                                      ' / ',
                                      style: GoogleFonts.questrial(
                                        /*color: isDarkMode
                                            ? Colors.white54
                                            : Colors.black54,
                                        fontSize: size.height * 0.03, */
                                        color: Colors.white
                                      ),
                                    ),
                                    Text(
                                      '${data.maximumTemp}˚C', //max temperature
                                      style: GoogleFonts.questrial(
                                        color: data.maximumTemp <= 0
                                            ? Colors.white
                                            : data.maximumTemp > 0 && data.maximumTemp <= 15
                                                ? const Color.fromARGB(255, 228, 230, 242)
                                                : data.maximumTemp > 15 && data.maximumTemp < 30
                                                    ? const Color.fromARGB(255, 241, 214, 81)
                                                    : Colors.pink,
                                        fontSize: size.height * 0.03,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              HourlyForecastCard(data),
                              DaysForecastCard(data, 7),
                              SunInformationCard(data),
                            ],
                         )
                      )
                    ]
                  ),
                ),
              );
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Center(
              child: Text("${snapshot.connectionState} occured"),
            );
          }
          return const Center(
            child: Text("Server timed out!"),
          );
        },
        future: _myData!,
      ),
    );
  }

  _fetchPredictions(String input) async {
    const apiKey = accuweatherApiKey;
    final endpoint = Uri.parse('https://dataservice.accuweather.com/locations/v1/cities/autocomplete?apikey=$apiKey&q=$input');
    log(endpoint.toString());
    final response = await http.get(endpoint);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final predictions = data;
      log(data.toString());
      setState(() {
        _predictions = predictions?.map((json) => json['LocalizedName']+','+ json['AdministrativeArea']['LocalizedName']+','+json['Country']['ID']).toList().cast<String>();
        _predictionsLocationKeyMap = { for (var e in predictions)  e['LocalizedName']+','+e['AdministrativeArea']['LocalizedName']+','+e['Country']['ID'] : e['Key']};
        log(_predictionsLocationKeyMap.toString());
      });
    } else {
      throw Exception('Failed to load predictions');
    }
  }

  _getRandomPic() async {
    var url = 'https://598315541979484:LCLOt5kvys4oTXHaEaim8mwp8kI@api.cloudinary.com/v1_1/abhinithame/resources/image?max_results=300';
    http.Response response = await http.get(
      Uri.parse(url), 
    );

    if(response.statusCode == 200) {
      final data = json.decode(response.body);
      //log(data['resources'].map((json) => json['folder']).toList().toString());
      final reducedData = data['resources'].where((json) => json['folder'] == 'Ramanan/Spring');
      log(reducedData.map((reducedJson) => reducedJson['secure_url']).toList().toString());
      final imageUrls = reducedData.map((reducedJson) => reducedJson['secure_url']).toList();
      setState(() {
        _randomPicFromFuture = imageUrls[Random().nextInt(imageUrls.length)];
        log('Picked Random Pic:$_randomPicFromFuture');
      });
    } else {
      throw Exception("Unable to fetch Pic");
    }
  }
}
