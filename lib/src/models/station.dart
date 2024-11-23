import 'package:hackathon_krakow_2024/src/models/location.dart';

enum StationType {
  train,
  bus,
}

class Station {
  String name;
  String city;
  Location location;
  StationType type;

  Station(
    this.name,
    this.city,
    this.location,
    this.type,
  );
}
