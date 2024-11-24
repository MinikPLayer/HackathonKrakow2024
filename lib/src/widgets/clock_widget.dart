import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ClockWidget extends StatelessWidget {
  const ClockWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Stream.periodic(const Duration(seconds: 1)),
      builder: (context, snapshot) {
        var textStyle = Theme.of(context).textTheme.headlineLarge;
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(DateFormat.yMMMd().format(DateTime.now()), style: textStyle),
                Text(DateFormat('hh:mm:ss').format(DateTime.now()), style: textStyle),
              ],
            ),
          ),
        );
      },
    );
  }
}
