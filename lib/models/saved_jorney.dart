class SavedJourney {
  final int? id;
  final String sourceLat;
  final String sourceLng;
  final String destinationLat;
  final String destinationLng;
  final double distance; // in meters
  final int duration;
  final String date; // JSON string of List<LatLng>

  SavedJourney({
    this.id,
    required this.sourceLat,
    required this.sourceLng,
    required this.destinationLat,
    required this.destinationLng,
    required this.distance,
    required this.duration,
    required this.date,
  });

  // Convert a Journey object to a Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'source_lat': sourceLat,
      'source_lng': sourceLng,
      'destination_lat': destinationLat,
      'destination_lng': destinationLng,
      'distance': distance,
      'duration': duration,
      'date': date,
    };
  }

  // Convert a Map from SQLite to a Journey object
  factory SavedJourney.fromMap(Map<String, dynamic> map) {
    return SavedJourney(
      id: map['id'],
      sourceLat: map['source_lat'],
      sourceLng: map['source_lng'],
      destinationLat: map['destination_lat'],
      destinationLng: map['destination_lng'],
      distance: map['distance'],
      duration: map['duration'],
      date: map['date'],
    );
  }
}
