import 'package:flutter/material.dart';
import 'package:hackathon_krakow_2024/src/providers/connections_provider.dart';
import 'package:hackathon_krakow_2024/src/providers/user_provider.dart';
import 'package:hackathon_krakow_2024/src/widgets/search_connections_widget.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key, required this.connectionsProvider, required this.userProvider});

  static const String routeName = '/landing';
  final ConnectionsProvider connectionsProvider;
  final UserProvider userProvider;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search connections'),
      ),
      body: Column(
        children: [
          SearchConnectionsWidget(
            connectionsProvider: connectionsProvider,
            userProvider: userProvider,
          ),
        ],
      ),
    );
  }
}
