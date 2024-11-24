import 'package:flutter/material.dart';
import 'package:hackathon_krakow_2024/src/models/carriage.dart';

class CarriageWidget extends StatelessWidget {
  const CarriageWidget({super.key, required this.carriage});

  final Carriage carriage;

  Color mix(Color color1, Color color2, double amount) {
    return Color.lerp(color1, color2, amount)!;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListenableBuilder(
        listenable: carriage,
        builder: (context, child) => Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8.0),
            color: mix(Colors.green, Colors.red, carriage.seatsTaken / carriage.seats),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                carriage.number,
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.bold),
              ),
              Text('${carriage.seatsTaken}/${carriage.seats}'),
            ],
          ),
        ),
      ),
    );
  }
}
