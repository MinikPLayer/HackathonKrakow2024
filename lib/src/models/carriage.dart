import 'package:flutter/material.dart';

class Carriage extends ChangeNotifier {
  final String number;
  final int seats;
  int seatsTaken = 0;

  Carriage({
    required this.number,
    required this.seats,
  });

  void takeSeat() {
    if (seatsTaken < seats) {
      seatsTaken++;
      notifyListeners();
    }
  }

  void freeSeat() {
    if (seatsTaken > 0) {
      seatsTaken--;
      notifyListeners();
    }
  }
}
