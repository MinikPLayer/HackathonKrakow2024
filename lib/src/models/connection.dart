import 'package:hackathon_krakow_2024/src/models/station.dart';

class Connection {
  Station from;
  Station to;

  int lanes;

  Connection({required this.from, required this.to, required this.lanes});
}
