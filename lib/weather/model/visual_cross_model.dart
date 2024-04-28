class VisualCrossModel {
  final String temperature;
  String city;
  final String desc;
  final String feelsLike;
  final String conditions;
  // ignore: prefer_typing_uninitialized_variables
  var minimumTemp;
  // ignore: prefer_typing_uninitialized_variables
  var maximumTemp;
  List<dynamic> hourlyForecast;
  List<dynamic> daysForecast;
  String latitude;
  String longitude;
  String sunrise;
  String sunset;

  VisualCrossModel.fromMap(Map<String, dynamic> weatherInfo) 
    : temperature = weatherInfo['currentConditions']['temp'].toString(),
      city = weatherInfo['address'],
      desc = weatherInfo['description'],
      feelsLike = weatherInfo['currentConditions']['feelslike'].toString(),
      conditions = weatherInfo['currentConditions']['conditions'].toString(),
      minimumTemp = weatherInfo['days'][0]['tempmin'],
      maximumTemp = weatherInfo['days'][0]['tempmax'],
      hourlyForecast = weatherInfo['days'][0]['hours'],
      daysForecast = weatherInfo['days'],
      latitude = weatherInfo['latitude'].toString(),
      longitude = weatherInfo['longitude'].toString(),
      sunrise = weatherInfo['currentConditions']['sunrise'].toString(),
      sunset = weatherInfo['currentConditions']['sunset'].toString()
      ;
}