import 'dart:convert';

import 'package:Weather/models/city.dart';
import 'package:flutter/services.dart';


class CityRepository {
  Future<List<City>> fetchCity() async {
    try {
      final data = await rootBundle.loadString('assets/my.json');
      final json = jsonDecode(data) as List;
      final city = json.map((c) => City.fromJson(c)).toList();
      return city;
    } catch (e) {
      return Future.error(e);
    }
  }
}
