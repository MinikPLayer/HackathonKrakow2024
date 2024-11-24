import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_krakow_2024/src/models/carriage.dart';
import 'package:hackathon_krakow_2024/src/models/reported_problem.dart';
import 'package:hackathon_krakow_2024/src/models/station.dart';

class Connection extends ChangeNotifier {
  Station from;
  Station to;

  Decimal price;
  DateTime departureTime;
  DateTime arrivalTime;

  Duration delay = const Duration();
  List<Carriage> carriages = [];
  List<ReportedProblem> problems = [];

  void setDelay(Duration delay) {
    this.delay = delay;
    notifyListeners();
  }

  void addProblem(ReportedProblem problem) {
    problems.add(problem);
    notifyListeners();
  }

  Connection({
    required this.from,
    required this.to,
    required this.price,
    required this.departureTime,
    required this.arrivalTime,
    required int carriagesCount,
  }) {
    for (var i = 0; i < carriagesCount; i++) {
      carriages.add(Carriage(number: i.toString(), seats: 50));
    }
  }
}
