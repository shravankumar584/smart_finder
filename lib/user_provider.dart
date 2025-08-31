import 'package:flutter/material.dart';
import '../models/place_model.dart';
import '../services/places_service.dart';
import '../utils/category_utils.dart';

class UserProvider extends ChangeNotifier {
  String gender = '';
  int age = 0;
  String status = '';
  bool hasKids = false;
  List<Place> places = [];
  String error = '';

  Future<void> fetchRecommendations(double lat, double lon) async {
    try {
      final category = getCategory(age, gender, status, hasKids);
      places = await PlacesService().searchPlaces(category, lat, lon);
      error = '';
    } catch (e) {
      error = 'Error fetching places: $e';
    }
    notifyListeners();
  }

  void updateUser(String g, int a, String s, bool k) {
    gender = g;
    age = a;
    status = s;
    hasKids = k;
    notifyListeners();
  }
}
