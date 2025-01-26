class Journey {
  final int? id;
  final String startLocation;
  final String destination;
  final double totalDistance; // in meters
  final String trackedLocations; // JSON string of List<LatLng>

  Journey({
    this.id,
    required this.startLocation,
    required this.destination,
    required this.totalDistance,
    required this.trackedLocations,
  });

  // Convert a Journey object to a Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'source': startLocation,
      'destination': destination,
      'totalDistance': totalDistance,
      'trackedLocations': trackedLocations,
    };
  }

  // Convert a Map from SQLite to a Journey object
  factory Journey.fromMap(Map<String, dynamic> map) {
    return Journey(
      id: map['id'],
      startLocation: map['startLocation'],
      destination: map['destination'],
      totalDistance: map['totalDistance'],
      trackedLocations: map['trackedLocations'],
    );
  }
}
