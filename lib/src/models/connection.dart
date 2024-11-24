import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_krakow_2024/src/models/carriage.dart';
import 'package:hackathon_krakow_2024/src/models/reported_problem.dart';
import 'package:hackathon_krakow_2024/src/models/station.dart';

enum ConnectionType {
  train,
  bus,
}

class Connection extends ChangeNotifier {
  Station from;
  Station to;

  ConnectionType type;
  Decimal price;
  DateTime departureTime;
  DateTime arrivalTime;

  Duration avgDelay = const Duration();
  Duration delay = const Duration();
  List<Carriage> carriages = [];
  List<ReportedProblem> problems = [];

  IconData get icon {
    switch (type) {
      case ConnectionType.train:
        return Icons.train;
      case ConnectionType.bus:
        return Icons.directions_bus;
    }
  }

  void setDelay(Duration delay) {
    this.delay = delay;
    notifyListeners();
  }

  void addProblem(ReportedProblem problem) {
    int existingIndex = -1;
    for (var i = 0; i < problems.length; i++) {
      if (problems[i].problem == problem.problem) {
        existingIndex = i;
        break;
      }
    }

    if (existingIndex == -1) {
      problems.add(problem);
    } else {
      var severityIndex = ProblemsSeverity.values.indexOf(problem.severity);
      var existingSeverityIndex = ProblemsSeverity.values.indexOf(problems[existingIndex].severity);

      if (severityIndex > existingSeverityIndex) {
        problems[existingIndex] = problem;
      }
    }
    notifyListeners();
  }

  Connection({
    required this.from,
    required this.to,
    required this.price,
    required this.departureTime,
    required this.arrivalTime,
    required this.avgDelay,
    required this.type,
    required int carriagesCount,
  }) {
    for (var i = 1; i <= carriagesCount; i++) {
      carriages.add(Carriage(number: i.toString(), seats: 50));
    }
  }
}
