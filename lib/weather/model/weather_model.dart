class WeatherModel {
  final String temperature;
  final String city;
  final String desc;

  WeatherModel.fromMap(Map<String, dynamic> json) 
    : temperature = json['main']['temp'].toString(),
      city = json['name'],
      desc = json['weather'][0]['description'];
}