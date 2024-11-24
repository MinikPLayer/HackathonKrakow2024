import 'package:flutter/material.dart';
import 'package:hackathon_krakow_2024/src/providers/user_provider.dart';

class MyTicketsPage extends StatelessWidget {
  const MyTicketsPage({super.key, required this.userProvider});

  final UserProvider userProvider;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My tickets'),
      ),
    );
  }
}
