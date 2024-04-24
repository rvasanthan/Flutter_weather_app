import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class PlacesApiClient {
  Future<List<String>> fetchPredictions(String input) async {
    const apiKey = "AIzaSyCfx8yOCRrSn7TSP1uchs2fO_yos9Pn7oc";
    final endpoint = Uri.parse('https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$apiKey');
    log(endpoint.toString());
    final response = await http.get(endpoint);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      //log(data['predictions'].map((json) => json['description']).toList().cast<String>());
      return data['predictions'].map((json) => json['description']).toList().cast<String>();
    } else {
      throw Exception('Failed to load predictions');
    }
  }
}

