import 'package:flutter/material.dart';
import 'package:tot_app/models/dog_model.dart';
import 'package:tot_app/services/api_service.dart';

import '../services/database_helper.dart';

class DogProvider with ChangeNotifier {
  final ApiService _apiService = ApiService('https://freetestapi.com/api/v1');
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  List<Dog> _dogs = [];
  List<Dog> _favoriteDogs = [];
  List<Dog> _filteredDogs = [];
  String _query = '';

  bool _isLoading = false;
  String? _error;

  List<Dog> get dogs => _dogs;
  List<Dog> get favoriteDogs => _favoriteDogs;
  List<Dog> get filteredDogs => _filteredDogs;
  String get query => _query;

  set query(String value) {
    _query = value;
    searchDogs(value);
  }

  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  String? get error => _error;

  Future<void> fetchDogs() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _dogs = await _apiService.fetchDogs();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadFavorites() async {
    _favoriteDogs = await _databaseHelper.getFavoriteDogs();
    notifyListeners();
  }

  Future<void> saveToFavorites(Dog post) async {
    await _databaseHelper.insertDog(post);
    await loadFavorites();
  }

  Future<void> removeFromFavorites(int id) async {
    await _databaseHelper.deleteDog(id);
    await loadFavorites();
  }

  searchDogs(String query) {
    _filteredDogs = _dogs
        .where((dog) =>
            dog.name!.toLowerCase().contains(query.toLowerCase()) ||
            dog.breedGroup!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    notifyListeners();
  }

  toggleFavorite(Dog dog) {
    if (_favoriteDogs.any((favDog) => favDog.id == dog.id)) {
      removeFromFavorites(dog.id!);
    } else {
      saveToFavorites(dog);
    }
    notifyListeners();
  }
}
