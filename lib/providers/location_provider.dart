import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/saved_jorney.dart';
import '../services/database_helper.dart';

class LocationProvider with ChangeNotifier {
  bool _isTracking = false;
  bool _isLoading = false;
  LatLng? _sourceLocation;
  LatLng? _currentLocation;
  LatLng? _destinationLocation;
  List<LatLng> _routePoints = [];
  DateTime? _startTime;
  double _totalDistance = 0.0;
  List<SavedJourney> _saved_journeys = [];

  bool get isTracking => _isTracking;
  LatLng? get sourceLocation => _sourceLocation;
  LatLng? get destinationLocation => _destinationLocation;
  List<LatLng> get routePoints => _routePoints;
  double get totalDistance => _totalDistance;

  StreamSubscription<Position>? _positionStream;

  LatLng get currentLocation => _currentLocation ?? LatLng(0, 0);
  bool get isLoading => _isLoading;
  List<SavedJourney> get savedJourneys => _saved_journeys;

  // Request location permissions
  Future<void> _requestLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          'Location permissions are permanently denied. Please enable them in settings.');
    }
  }

  Future<void> getCurrentLocation() async {
    _currentLocation = await _getCurrentLatLng();
    log("Current location: $_currentLocation");
    notifyListeners();
  }

  Future<void> startTracking() async {
    _isTracking = false;
    _totalDistance = 0.0;
    _routePoints.clear();
    _sourceLocation = await _getCurrentLatLng();
    _currentLocation = _sourceLocation;
    _startTime = DateTime.now();

    try {
      await _requestLocationPermission();
      _isTracking = true;
      notifyListeners();
    } catch (e) {
      print(e);
    }

    _positionStream = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5, // Trigger every 5 meters
      ),
    ).listen((Position position) {
      LatLng newPosition = LatLng(position.latitude, position.longitude);

      // Calculate distance
      if (_currentLocation != null) {
        _totalDistance += Geolocator.distanceBetween(
          _currentLocation!.latitude,
          _currentLocation!.longitude,
          newPosition.latitude,
          newPosition.longitude,
        );
      }

      _currentLocation = newPosition;
      _routePoints.add(newPosition);
      notifyListeners();
    });
  }

  Future<void> stopTracking() async {
    _isTracking = false;
    _positionStream?.cancel();
    _destinationLocation = _currentLocation;
    saveJourney();
    notifyListeners();
  }

  void saveJourney() async {
    if (_sourceLocation != null && _destinationLocation != null) {
      final journey = {
        'source_lat': _sourceLocation!.latitude,
        'source_lng': _sourceLocation!.longitude,
        'destination_lat': _destinationLocation!.latitude,
        'destination_lng': _destinationLocation!.longitude,
        'distance': _totalDistance,
        'duration': getJourneyDuration().inSeconds,
        'date': DateTime.now().toIso8601String(),
      };

      await DatabaseHelper.instance.insertJourney(journey);
    }
  }

  Future<LatLng> _getCurrentLatLng() async {
    // try {
    await _requestLocationPermission();
    Position position = await Geolocator.getCurrentPosition(
      // desiredAccuracy: LocationAccuracy.high,
      locationSettings: AndroidSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5,
      ),
    );
    return LatLng(position.latitude, position.longitude);
    // } catch (e) {
    //   print(e);
    // }
  }

  Duration getJourneyDuration() {
    if (_startTime != null && _isTracking == false) {
      return DateTime.now().difference(_startTime!);
    }
    return Duration.zero;
  }

  Future<void> fetchAndSetLocation() async {
    _isLoading = true;
    notifyListeners();
    final journeys = await DatabaseHelper.instance.fetchAllJourneys();
    _saved_journeys = journeys;
    _isLoading = false;
    notifyListeners();
  }

  void deleteJourney(int id) async {
    await DatabaseHelper.instance.deleteJourney(id);
    fetchAndSetLocation();
  }

  setSourceLocation(String sourceLat, String sourceLng) {
    _sourceLocation = LatLng(double.parse(sourceLat), double.parse(sourceLng));
    notifyListeners();
  }

  setDestinationLocation(String destinationLat, String destinationLng) {
    _destinationLocation =
        LatLng(double.parse(destinationLat), double.parse(destinationLng));
    notifyListeners();
  }
}
