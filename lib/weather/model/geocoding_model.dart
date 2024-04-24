import 'dart:ffi';

class GeoCodingModel {
  final String name;
  final String state;
  final String country;
  final Double lat;
  final Double lon;

  GeoCodingModel.fromMap(Map<String, dynamic> json) 
    : name = json[0]['name'].toString(),
      state = json[0]['state'],
      country = json[0]['country'],
      lat = json[0]['lat'],
      lon = json[0]['lon'];
}