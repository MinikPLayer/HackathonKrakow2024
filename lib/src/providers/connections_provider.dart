import 'package:flutter/material.dart';
import 'package:hackathon_krakow_2024/src/models/connection.dart';
import 'package:hackathon_krakow_2024/src/models/location.dart';
import 'package:hackathon_krakow_2024/src/models/station.dart';

class ConnectionsProvider extends ChangeNotifier {
  final List<Station> _stations = [];
  final List<Connection> _connections = [];

  List<Connection> get connections => _connections;
  List<Station> get stations => _stations;

  ConnectionsProvider() {
    var krGlowny = Station('Kraków Główny', 'Kraków', Location(50.068, 19.947), StationType.train);
    var krLobzow = Station('Kraków Łobzów', 'Kraków', Location(50.082, 19.916), StationType.train);
    var inna = Station('Inna stacja', 'Innowo', Location(12.345, 67.789), StationType.bus);

    _stations.add(krGlowny);
    _stations.add(krLobzow);
    _stations.add(inna);

    _connections.add(Connection(from: krGlowny, to: krLobzow, lanes: 3));
    _connections.add(Connection(from: krLobzow, to: krGlowny, lanes: 2));
    _connections.add(Connection(from: krGlowny, to: inna, lanes: 1));
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
