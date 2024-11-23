class Location {
  final double latitude;
  final double longitude;

  Location(this.latitude, this.longitude);

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      json['latitude'],
      json['longitude'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
