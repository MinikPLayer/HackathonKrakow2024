import 'dart:math';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_krakow_2024/src/models/connection.dart';
import 'package:hackathon_krakow_2024/src/models/location.dart';
import 'package:hackathon_krakow_2024/src/models/reported_problem.dart';
import 'package:hackathon_krakow_2024/src/models/station.dart';

class ConnectionsProvider extends ChangeNotifier {
  final List<Station> _stations = [];
  final List<Connection> _connections = [];

  List<Connection> get connections => _connections;
  List<Station> get stations => _stations;

  ConnectionsProvider() {
    var krGlowny = Station('Kraków Główny', 'Kraków', Location(50.068, 19.947), StationType.train);
    var krLobzow = Station('Kraków Łobzów', 'Kraków', Location(50.082, 19.916), StationType.train);
    var inna = Station('Kraków Bronowice', 'Kraków', Location(12.345, 67.789), StationType.bus);

    _stations.add(krGlowny);
    _stations.add(krLobzow);
    _stations.add(inna);

    for (var now = DateTime.now();
        now.isBefore(DateTime.now().add(const Duration(days: 7)));
        now = now.add(const Duration(minutes: 15))) {
      var delay = Random().nextInt(100);
      var avgDelay = delay + Random().nextInt(20) - 10;
      var newCon = Connection(
        from: krGlowny,
        to: krLobzow,
        price: Decimal.parse('2.50'),
        departureTime: now,
        arrivalTime: now.add(const Duration(minutes: 10)),
        avgDelay: Duration(minutes: avgDelay),
        type: ConnectionType.train,
        carriagesCount: Random().nextInt(7) + 3,
      );

      for (var c in newCon.carriages) {
        c.seatsTaken = Random().nextInt(c.seats);
      }

      for (var c in Problems.values) {
        if (Random().nextInt(10) > 5) {
          var severity = ProblemsSeverity.values[Random().nextInt(3)];
          newCon.addProblem(ReportedProblem(problem: c, severity: severity));
        }
      }

      newCon.setDelay(Duration(minutes: delay));
      _connections.add(newCon);

      delay = Random().nextInt(30);
      avgDelay = delay + Random().nextInt(20) - 10;
      newCon = Connection(
        from: krLobzow,
        to: krGlowny,
        price: Decimal.parse('2.50'),
        departureTime: now,
        arrivalTime: now.add(const Duration(minutes: 10)),
        avgDelay: Duration(minutes: avgDelay),
        type: ConnectionType.train,
        carriagesCount: Random().nextInt(7) + 3,
      );
      newCon.setDelay(Duration(minutes: delay));
      _connections.add(newCon);

      delay = Random().nextInt(20);
      avgDelay = delay + Random().nextInt(20) - 10;
      newCon = Connection(
        from: krGlowny,
        to: inna,
        price: Decimal.parse('5.00'),
        departureTime: now,
        arrivalTime: now.add(const Duration(minutes: 25)),
        avgDelay: Duration(minutes: avgDelay),
        type: ConnectionType.train,
        carriagesCount: Random().nextInt(7) + 3,
      );
      newCon.setDelay(Duration(minutes: delay));
      _connections.add(newCon);
    }
  }

  (List<Connection> connections, bool isAll) getConnections(
      Station from, Station to, DateTime? departureTime, DateTime? arrivalTime, int limitNumber) {
    var connections = _connections
        .where((element) =>
            element.from == from &&
            element.to == to &&
            (departureTime == null ||
                element.departureTime.millisecondsSinceEpoch > departureTime.millisecondsSinceEpoch) &&
            (arrivalTime == null || element.arrivalTime.millisecondsSinceEpoch > arrivalTime.millisecondsSinceEpoch))
        .toList();
    bool isAll = connections.length <= limitNumber;
    return (isAll ? connections : connections.sublist(0, limitNumber), isAll);
  }

  void addStation(Station station) {
    _stations.add(station);
    notifyListeners();
  }

  void removeStation(Station station) {
    _stations.remove(station);
    notifyListeners();
  }

  void addConnection(Connection connection) {
    _connections.add(connection);
    notifyListeners();
  }

  void removeConnection(Connection connection) {
    _connections.remove(connection);
    notifyListeners();
  }
}
