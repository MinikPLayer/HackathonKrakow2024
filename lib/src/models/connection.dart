import 'package:decimal/decimal.dart';
import 'package:hackathon_krakow_2024/src/models/station.dart';

class Connection {
  Station from;
  Station to;

  Decimal price;
  DateTime departureTime;
  DateTime arrivalTime;

  Connection({
    required this.from,
    required this.to,
    required this.price,
    required this.departureTime,
    required this.arrivalTime,
  });
}
