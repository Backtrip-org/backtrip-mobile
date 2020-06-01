import 'dart:convert';
import 'dart:io';
import 'package:backtrip/model/place/place.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class PlacesService {
  static const String apiURL = "https://photon.komoot.de/api";

  static Future<List<Place>> getSuggestions(String query) async {
    var uri = '$apiURL/?q=$query&lang=fr&limit=5';
    final response = await http.get(uri);

    if (response.statusCode == HttpStatus.ok) {
      return compute(parsePlaces, utf8.decode(response.body.runes.toList()));
    } else {
      throw Exception('Failed to load places');
    }
  }

  static List<Place> parsePlaces(String responseBody) {
    Iterable data = json.decode(responseBody)['features'];
    return data.map((model) => Place.fromJson(model)).toList();
  }
}
