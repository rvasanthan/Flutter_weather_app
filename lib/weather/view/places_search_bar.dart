import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/weather/constants/apikey.dart';

class PlaceAutocomplete extends StatefulWidget {
  @override
  _PlaceAutocompleteState createState() => _PlaceAutocompleteState();
}

class _PlaceAutocompleteState extends State<PlaceAutocomplete> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _predictions = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Place Autocomplete Example'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for a place...',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _predictions.clear();
                    });
                  },
                ),
              ),
              onChanged: (value) {
                _fetchPredictions(value);
              },
            ),
          ),
          Flexible(
            fit: FlexFit.loose,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _predictions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_predictions[index]),
                  onTap: () {
                    // Handle selected prediction
                    log(_predictions[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  _fetchPredictions(String input) async {
    const apiKey = googleApiKey;
    final endpoint = Uri.parse('https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$apiKey');
    log(endpoint.toString());
    final response = await http.get(endpoint);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final predictions = data['predictions'];
      log(data.toString());
      setState(() {
        _predictions = predictions.map((json) => json['description']).toList().cast<String>();
        log(_predictions.toString());
      });
    } else {
      throw Exception('Failed to load predictions');
    }
  }
}