import 'package:flutter/material.dart';
import 'package:hackathon_krakow_2024/src/models/ticket.dart';
import 'package:hackathon_krakow_2024/src/models/user.dart';

class UserProvider with ChangeNotifier {
  UserProvider({
    required this.user,
  });

  User user;
  final List<Ticket> _tickets = [];
  List<Ticket> get tickets => _tickets;

  void updateUser(User newUser) {
    user = newUser;
    notifyListeners();
  }

  void addTicket(Ticket ticket) {
    _tickets.add(ticket);
    notifyListeners();
  }
}
